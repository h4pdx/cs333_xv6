
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
  16:	68 9b 09 00 00       	push   $0x99b
  1b:	e8 4b 04 00 00       	call   46b <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	79 26                	jns    4d <main+0x4d>
    mknod("console", 1, 1);
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	6a 01                	push   $0x1
  2c:	6a 01                	push   $0x1
  2e:	68 9b 09 00 00       	push   $0x99b
  33:	e8 3b 04 00 00       	call   473 <mknod>
  38:	83 c4 10             	add    $0x10,%esp
    open("console", O_RDWR);
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	6a 02                	push   $0x2
  40:	68 9b 09 00 00       	push   $0x99b
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
  6a:	68 a3 09 00 00       	push   $0x9a3
  6f:	6a 01                	push   $0x1
  71:	e8 6c 05 00 00       	call   5e2 <printf>
  76:	83 c4 10             	add    $0x10,%esp
    pid = fork();
  79:	e8 a5 03 00 00       	call   423 <fork>
  7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(pid < 0){
  81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  85:	79 17                	jns    9e <main+0x9e>
      printf(1, "init: fork failed\n");
  87:	83 ec 08             	sub    $0x8,%esp
  8a:	68 b6 09 00 00       	push   $0x9b6
  8f:	6a 01                	push   $0x1
  91:	e8 4c 05 00 00       	call   5e2 <printf>
  96:	83 c4 10             	add    $0x10,%esp
      exit();
  99:	e8 8d 03 00 00       	call   42b <exit>
    }
    if(pid == 0){
  9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a2:	75 3e                	jne    e2 <main+0xe2>
      exec("sh", argv);
  a4:	83 ec 08             	sub    $0x8,%esp
  a7:	68 58 0c 00 00       	push   $0xc58
  ac:	68 98 09 00 00       	push   $0x998
  b1:	e8 ad 03 00 00       	call   463 <exec>
  b6:	83 c4 10             	add    $0x10,%esp
      printf(1, "init: exec sh failed\n");
  b9:	83 ec 08             	sub    $0x8,%esp
  bc:	68 c9 09 00 00       	push   $0x9c9
  c1:	6a 01                	push   $0x1
  c3:	e8 1a 05 00 00       	call   5e2 <printf>
  c8:	83 c4 10             	add    $0x10,%esp
      exit();
  cb:	e8 5b 03 00 00       	call   42b <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  d0:	83 ec 08             	sub    $0x8,%esp
  d3:	68 df 09 00 00       	push   $0x9df
  d8:	6a 01                	push   $0x1
  da:	e8 03 05 00 00       	call   5e2 <printf>
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

0000050b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 50b:	55                   	push   %ebp
 50c:	89 e5                	mov    %esp,%ebp
 50e:	83 ec 18             	sub    $0x18,%esp
 511:	8b 45 0c             	mov    0xc(%ebp),%eax
 514:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 517:	83 ec 04             	sub    $0x4,%esp
 51a:	6a 01                	push   $0x1
 51c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 51f:	50                   	push   %eax
 520:	ff 75 08             	pushl  0x8(%ebp)
 523:	e8 23 ff ff ff       	call   44b <write>
 528:	83 c4 10             	add    $0x10,%esp
}
 52b:	90                   	nop
 52c:	c9                   	leave  
 52d:	c3                   	ret    

0000052e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 52e:	55                   	push   %ebp
 52f:	89 e5                	mov    %esp,%ebp
 531:	53                   	push   %ebx
 532:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 535:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 53c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 540:	74 17                	je     559 <printint+0x2b>
 542:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 546:	79 11                	jns    559 <printint+0x2b>
    neg = 1;
 548:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 54f:	8b 45 0c             	mov    0xc(%ebp),%eax
 552:	f7 d8                	neg    %eax
 554:	89 45 ec             	mov    %eax,-0x14(%ebp)
 557:	eb 06                	jmp    55f <printint+0x31>
  } else {
    x = xx;
 559:	8b 45 0c             	mov    0xc(%ebp),%eax
 55c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 55f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 566:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 569:	8d 41 01             	lea    0x1(%ecx),%eax
 56c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 56f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 572:	8b 45 ec             	mov    -0x14(%ebp),%eax
 575:	ba 00 00 00 00       	mov    $0x0,%edx
 57a:	f7 f3                	div    %ebx
 57c:	89 d0                	mov    %edx,%eax
 57e:	0f b6 80 60 0c 00 00 	movzbl 0xc60(%eax),%eax
 585:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 589:	8b 5d 10             	mov    0x10(%ebp),%ebx
 58c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 58f:	ba 00 00 00 00       	mov    $0x0,%edx
 594:	f7 f3                	div    %ebx
 596:	89 45 ec             	mov    %eax,-0x14(%ebp)
 599:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 59d:	75 c7                	jne    566 <printint+0x38>
  if(neg)
 59f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5a3:	74 2d                	je     5d2 <printint+0xa4>
    buf[i++] = '-';
 5a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a8:	8d 50 01             	lea    0x1(%eax),%edx
 5ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5ae:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5b3:	eb 1d                	jmp    5d2 <printint+0xa4>
    putc(fd, buf[i]);
 5b5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5bb:	01 d0                	add    %edx,%eax
 5bd:	0f b6 00             	movzbl (%eax),%eax
 5c0:	0f be c0             	movsbl %al,%eax
 5c3:	83 ec 08             	sub    $0x8,%esp
 5c6:	50                   	push   %eax
 5c7:	ff 75 08             	pushl  0x8(%ebp)
 5ca:	e8 3c ff ff ff       	call   50b <putc>
 5cf:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5d2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5da:	79 d9                	jns    5b5 <printint+0x87>
    putc(fd, buf[i]);
}
 5dc:	90                   	nop
 5dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5e0:	c9                   	leave  
 5e1:	c3                   	ret    

000005e2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5e2:	55                   	push   %ebp
 5e3:	89 e5                	mov    %esp,%ebp
 5e5:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5e8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5ef:	8d 45 0c             	lea    0xc(%ebp),%eax
 5f2:	83 c0 04             	add    $0x4,%eax
 5f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5f8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5ff:	e9 59 01 00 00       	jmp    75d <printf+0x17b>
    c = fmt[i] & 0xff;
 604:	8b 55 0c             	mov    0xc(%ebp),%edx
 607:	8b 45 f0             	mov    -0x10(%ebp),%eax
 60a:	01 d0                	add    %edx,%eax
 60c:	0f b6 00             	movzbl (%eax),%eax
 60f:	0f be c0             	movsbl %al,%eax
 612:	25 ff 00 00 00       	and    $0xff,%eax
 617:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 61a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 61e:	75 2c                	jne    64c <printf+0x6a>
      if(c == '%'){
 620:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 624:	75 0c                	jne    632 <printf+0x50>
        state = '%';
 626:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 62d:	e9 27 01 00 00       	jmp    759 <printf+0x177>
      } else {
        putc(fd, c);
 632:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 635:	0f be c0             	movsbl %al,%eax
 638:	83 ec 08             	sub    $0x8,%esp
 63b:	50                   	push   %eax
 63c:	ff 75 08             	pushl  0x8(%ebp)
 63f:	e8 c7 fe ff ff       	call   50b <putc>
 644:	83 c4 10             	add    $0x10,%esp
 647:	e9 0d 01 00 00       	jmp    759 <printf+0x177>
      }
    } else if(state == '%'){
 64c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 650:	0f 85 03 01 00 00    	jne    759 <printf+0x177>
      if(c == 'd'){
 656:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 65a:	75 1e                	jne    67a <printf+0x98>
        printint(fd, *ap, 10, 1);
 65c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65f:	8b 00                	mov    (%eax),%eax
 661:	6a 01                	push   $0x1
 663:	6a 0a                	push   $0xa
 665:	50                   	push   %eax
 666:	ff 75 08             	pushl  0x8(%ebp)
 669:	e8 c0 fe ff ff       	call   52e <printint>
 66e:	83 c4 10             	add    $0x10,%esp
        ap++;
 671:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 675:	e9 d8 00 00 00       	jmp    752 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 67a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 67e:	74 06                	je     686 <printf+0xa4>
 680:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 684:	75 1e                	jne    6a4 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 686:	8b 45 e8             	mov    -0x18(%ebp),%eax
 689:	8b 00                	mov    (%eax),%eax
 68b:	6a 00                	push   $0x0
 68d:	6a 10                	push   $0x10
 68f:	50                   	push   %eax
 690:	ff 75 08             	pushl  0x8(%ebp)
 693:	e8 96 fe ff ff       	call   52e <printint>
 698:	83 c4 10             	add    $0x10,%esp
        ap++;
 69b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 69f:	e9 ae 00 00 00       	jmp    752 <printf+0x170>
      } else if(c == 's'){
 6a4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6a8:	75 43                	jne    6ed <printf+0x10b>
        s = (char*)*ap;
 6aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ad:	8b 00                	mov    (%eax),%eax
 6af:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6b2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6ba:	75 25                	jne    6e1 <printf+0xff>
          s = "(null)";
 6bc:	c7 45 f4 e8 09 00 00 	movl   $0x9e8,-0xc(%ebp)
        while(*s != 0){
 6c3:	eb 1c                	jmp    6e1 <printf+0xff>
          putc(fd, *s);
 6c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c8:	0f b6 00             	movzbl (%eax),%eax
 6cb:	0f be c0             	movsbl %al,%eax
 6ce:	83 ec 08             	sub    $0x8,%esp
 6d1:	50                   	push   %eax
 6d2:	ff 75 08             	pushl  0x8(%ebp)
 6d5:	e8 31 fe ff ff       	call   50b <putc>
 6da:	83 c4 10             	add    $0x10,%esp
          s++;
 6dd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e4:	0f b6 00             	movzbl (%eax),%eax
 6e7:	84 c0                	test   %al,%al
 6e9:	75 da                	jne    6c5 <printf+0xe3>
 6eb:	eb 65                	jmp    752 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6ed:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6f1:	75 1d                	jne    710 <printf+0x12e>
        putc(fd, *ap);
 6f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6f6:	8b 00                	mov    (%eax),%eax
 6f8:	0f be c0             	movsbl %al,%eax
 6fb:	83 ec 08             	sub    $0x8,%esp
 6fe:	50                   	push   %eax
 6ff:	ff 75 08             	pushl  0x8(%ebp)
 702:	e8 04 fe ff ff       	call   50b <putc>
 707:	83 c4 10             	add    $0x10,%esp
        ap++;
 70a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 70e:	eb 42                	jmp    752 <printf+0x170>
      } else if(c == '%'){
 710:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 714:	75 17                	jne    72d <printf+0x14b>
        putc(fd, c);
 716:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 719:	0f be c0             	movsbl %al,%eax
 71c:	83 ec 08             	sub    $0x8,%esp
 71f:	50                   	push   %eax
 720:	ff 75 08             	pushl  0x8(%ebp)
 723:	e8 e3 fd ff ff       	call   50b <putc>
 728:	83 c4 10             	add    $0x10,%esp
 72b:	eb 25                	jmp    752 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 72d:	83 ec 08             	sub    $0x8,%esp
 730:	6a 25                	push   $0x25
 732:	ff 75 08             	pushl  0x8(%ebp)
 735:	e8 d1 fd ff ff       	call   50b <putc>
 73a:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 73d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 740:	0f be c0             	movsbl %al,%eax
 743:	83 ec 08             	sub    $0x8,%esp
 746:	50                   	push   %eax
 747:	ff 75 08             	pushl  0x8(%ebp)
 74a:	e8 bc fd ff ff       	call   50b <putc>
 74f:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 752:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 759:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 75d:	8b 55 0c             	mov    0xc(%ebp),%edx
 760:	8b 45 f0             	mov    -0x10(%ebp),%eax
 763:	01 d0                	add    %edx,%eax
 765:	0f b6 00             	movzbl (%eax),%eax
 768:	84 c0                	test   %al,%al
 76a:	0f 85 94 fe ff ff    	jne    604 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 770:	90                   	nop
 771:	c9                   	leave  
 772:	c3                   	ret    

00000773 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 773:	55                   	push   %ebp
 774:	89 e5                	mov    %esp,%ebp
 776:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 779:	8b 45 08             	mov    0x8(%ebp),%eax
 77c:	83 e8 08             	sub    $0x8,%eax
 77f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 782:	a1 7c 0c 00 00       	mov    0xc7c,%eax
 787:	89 45 fc             	mov    %eax,-0x4(%ebp)
 78a:	eb 24                	jmp    7b0 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78f:	8b 00                	mov    (%eax),%eax
 791:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 794:	77 12                	ja     7a8 <free+0x35>
 796:	8b 45 f8             	mov    -0x8(%ebp),%eax
 799:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 79c:	77 24                	ja     7c2 <free+0x4f>
 79e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a1:	8b 00                	mov    (%eax),%eax
 7a3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a6:	77 1a                	ja     7c2 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ab:	8b 00                	mov    (%eax),%eax
 7ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7b6:	76 d4                	jbe    78c <free+0x19>
 7b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bb:	8b 00                	mov    (%eax),%eax
 7bd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7c0:	76 ca                	jbe    78c <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c5:	8b 40 04             	mov    0x4(%eax),%eax
 7c8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d2:	01 c2                	add    %eax,%edx
 7d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d7:	8b 00                	mov    (%eax),%eax
 7d9:	39 c2                	cmp    %eax,%edx
 7db:	75 24                	jne    801 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e0:	8b 50 04             	mov    0x4(%eax),%edx
 7e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e6:	8b 00                	mov    (%eax),%eax
 7e8:	8b 40 04             	mov    0x4(%eax),%eax
 7eb:	01 c2                	add    %eax,%edx
 7ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f0:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f6:	8b 00                	mov    (%eax),%eax
 7f8:	8b 10                	mov    (%eax),%edx
 7fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fd:	89 10                	mov    %edx,(%eax)
 7ff:	eb 0a                	jmp    80b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 801:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804:	8b 10                	mov    (%eax),%edx
 806:	8b 45 f8             	mov    -0x8(%ebp),%eax
 809:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 80b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80e:	8b 40 04             	mov    0x4(%eax),%eax
 811:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 818:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81b:	01 d0                	add    %edx,%eax
 81d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 820:	75 20                	jne    842 <free+0xcf>
    p->s.size += bp->s.size;
 822:	8b 45 fc             	mov    -0x4(%ebp),%eax
 825:	8b 50 04             	mov    0x4(%eax),%edx
 828:	8b 45 f8             	mov    -0x8(%ebp),%eax
 82b:	8b 40 04             	mov    0x4(%eax),%eax
 82e:	01 c2                	add    %eax,%edx
 830:	8b 45 fc             	mov    -0x4(%ebp),%eax
 833:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 836:	8b 45 f8             	mov    -0x8(%ebp),%eax
 839:	8b 10                	mov    (%eax),%edx
 83b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83e:	89 10                	mov    %edx,(%eax)
 840:	eb 08                	jmp    84a <free+0xd7>
  } else
    p->s.ptr = bp;
 842:	8b 45 fc             	mov    -0x4(%ebp),%eax
 845:	8b 55 f8             	mov    -0x8(%ebp),%edx
 848:	89 10                	mov    %edx,(%eax)
  freep = p;
 84a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84d:	a3 7c 0c 00 00       	mov    %eax,0xc7c
}
 852:	90                   	nop
 853:	c9                   	leave  
 854:	c3                   	ret    

00000855 <morecore>:

static Header*
morecore(uint nu)
{
 855:	55                   	push   %ebp
 856:	89 e5                	mov    %esp,%ebp
 858:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 85b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 862:	77 07                	ja     86b <morecore+0x16>
    nu = 4096;
 864:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 86b:	8b 45 08             	mov    0x8(%ebp),%eax
 86e:	c1 e0 03             	shl    $0x3,%eax
 871:	83 ec 0c             	sub    $0xc,%esp
 874:	50                   	push   %eax
 875:	e8 39 fc ff ff       	call   4b3 <sbrk>
 87a:	83 c4 10             	add    $0x10,%esp
 87d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 880:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 884:	75 07                	jne    88d <morecore+0x38>
    return 0;
 886:	b8 00 00 00 00       	mov    $0x0,%eax
 88b:	eb 26                	jmp    8b3 <morecore+0x5e>
  hp = (Header*)p;
 88d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 890:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 893:	8b 45 f0             	mov    -0x10(%ebp),%eax
 896:	8b 55 08             	mov    0x8(%ebp),%edx
 899:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 89c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89f:	83 c0 08             	add    $0x8,%eax
 8a2:	83 ec 0c             	sub    $0xc,%esp
 8a5:	50                   	push   %eax
 8a6:	e8 c8 fe ff ff       	call   773 <free>
 8ab:	83 c4 10             	add    $0x10,%esp
  return freep;
 8ae:	a1 7c 0c 00 00       	mov    0xc7c,%eax
}
 8b3:	c9                   	leave  
 8b4:	c3                   	ret    

000008b5 <malloc>:

void*
malloc(uint nbytes)
{
 8b5:	55                   	push   %ebp
 8b6:	89 e5                	mov    %esp,%ebp
 8b8:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8bb:	8b 45 08             	mov    0x8(%ebp),%eax
 8be:	83 c0 07             	add    $0x7,%eax
 8c1:	c1 e8 03             	shr    $0x3,%eax
 8c4:	83 c0 01             	add    $0x1,%eax
 8c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8ca:	a1 7c 0c 00 00       	mov    0xc7c,%eax
 8cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8d6:	75 23                	jne    8fb <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8d8:	c7 45 f0 74 0c 00 00 	movl   $0xc74,-0x10(%ebp)
 8df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e2:	a3 7c 0c 00 00       	mov    %eax,0xc7c
 8e7:	a1 7c 0c 00 00       	mov    0xc7c,%eax
 8ec:	a3 74 0c 00 00       	mov    %eax,0xc74
    base.s.size = 0;
 8f1:	c7 05 78 0c 00 00 00 	movl   $0x0,0xc78
 8f8:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fe:	8b 00                	mov    (%eax),%eax
 900:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 903:	8b 45 f4             	mov    -0xc(%ebp),%eax
 906:	8b 40 04             	mov    0x4(%eax),%eax
 909:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 90c:	72 4d                	jb     95b <malloc+0xa6>
      if(p->s.size == nunits)
 90e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 911:	8b 40 04             	mov    0x4(%eax),%eax
 914:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 917:	75 0c                	jne    925 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 919:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91c:	8b 10                	mov    (%eax),%edx
 91e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 921:	89 10                	mov    %edx,(%eax)
 923:	eb 26                	jmp    94b <malloc+0x96>
      else {
        p->s.size -= nunits;
 925:	8b 45 f4             	mov    -0xc(%ebp),%eax
 928:	8b 40 04             	mov    0x4(%eax),%eax
 92b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 92e:	89 c2                	mov    %eax,%edx
 930:	8b 45 f4             	mov    -0xc(%ebp),%eax
 933:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 936:	8b 45 f4             	mov    -0xc(%ebp),%eax
 939:	8b 40 04             	mov    0x4(%eax),%eax
 93c:	c1 e0 03             	shl    $0x3,%eax
 93f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 942:	8b 45 f4             	mov    -0xc(%ebp),%eax
 945:	8b 55 ec             	mov    -0x14(%ebp),%edx
 948:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 94b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94e:	a3 7c 0c 00 00       	mov    %eax,0xc7c
      return (void*)(p + 1);
 953:	8b 45 f4             	mov    -0xc(%ebp),%eax
 956:	83 c0 08             	add    $0x8,%eax
 959:	eb 3b                	jmp    996 <malloc+0xe1>
    }
    if(p == freep)
 95b:	a1 7c 0c 00 00       	mov    0xc7c,%eax
 960:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 963:	75 1e                	jne    983 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 965:	83 ec 0c             	sub    $0xc,%esp
 968:	ff 75 ec             	pushl  -0x14(%ebp)
 96b:	e8 e5 fe ff ff       	call   855 <morecore>
 970:	83 c4 10             	add    $0x10,%esp
 973:	89 45 f4             	mov    %eax,-0xc(%ebp)
 976:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 97a:	75 07                	jne    983 <malloc+0xce>
        return 0;
 97c:	b8 00 00 00 00       	mov    $0x0,%eax
 981:	eb 13                	jmp    996 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 983:	8b 45 f4             	mov    -0xc(%ebp),%eax
 986:	89 45 f0             	mov    %eax,-0x10(%ebp)
 989:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98c:	8b 00                	mov    (%eax),%eax
 98e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 991:	e9 6d ff ff ff       	jmp    903 <malloc+0x4e>
}
 996:	c9                   	leave  
 997:	c3                   	ret    
