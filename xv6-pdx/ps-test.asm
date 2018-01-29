
_ps-test:     file format elf32-i386


Disassembly of section .text:

00000000 <forktest>:
#include "types.h"
#include "user.h"

void
forktest(int N)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n, pid;

  printf(1, "starting fork test\n");
   6:	83 ec 08             	sub    $0x8,%esp
   9:	68 c0 09 00 00       	push   $0x9c0
   e:	6a 01                	push   $0x1
  10:	e8 f5 05 00 00       	call   60a <printf>
  15:	83 c4 10             	add    $0x10,%esp

  for(n=0; n<N; n++){
  18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1f:	eb 2d                	jmp    4e <forktest+0x4e>
    pid = fork();
  21:	e8 25 04 00 00       	call   44b <fork>
  26:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
  29:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  2d:	78 29                	js     58 <forktest+0x58>
      break;
    if(pid == 0) {
  2f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  33:	75 15                	jne    4a <forktest+0x4a>
      sleep(10*TPS);
  35:	83 ec 0c             	sub    $0xc,%esp
  38:	68 10 27 00 00       	push   $0x2710
  3d:	e8 a1 04 00 00       	call   4e3 <sleep>
  42:	83 c4 10             	add    $0x10,%esp
      exit();
  45:	e8 09 04 00 00       	call   453 <exit>
{
  int n, pid;

  printf(1, "starting fork test\n");

  for(n=0; n<N; n++){
  4a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  51:	3b 45 08             	cmp    0x8(%ebp),%eax
  54:	7c cb                	jl     21 <forktest+0x21>
  56:	eb 01                	jmp    59 <forktest+0x59>
    pid = fork();
    if(pid < 0)
      break;
  58:	90                   	nop
      sleep(10*TPS);
      exit();
    }
  }

  printf(2, "checking for %d child processes.\n", n);
  59:	83 ec 04             	sub    $0x4,%esp
  5c:	ff 75 f4             	pushl  -0xc(%ebp)
  5f:	68 d4 09 00 00       	push   $0x9d4
  64:	6a 02                	push   $0x2
  66:	e8 9f 05 00 00       	call   60a <printf>
  6b:	83 c4 10             	add    $0x10,%esp

  for(; n > 0; n--){
  6e:	eb 24                	jmp    94 <forktest+0x94>
    if(wait() < 0){
  70:	e8 e6 03 00 00       	call   45b <wait>
  75:	85 c0                	test   %eax,%eax
  77:	79 17                	jns    90 <forktest+0x90>
      printf(2, "wait stopped early\n");
  79:	83 ec 08             	sub    $0x8,%esp
  7c:	68 f6 09 00 00       	push   $0x9f6
  81:	6a 02                	push   $0x2
  83:	e8 82 05 00 00       	call   60a <printf>
  88:	83 c4 10             	add    $0x10,%esp
      exit();
  8b:	e8 c3 03 00 00       	call   453 <exit>
    }
  }

  printf(2, "checking for %d child processes.\n", n);

  for(; n > 0; n--){
  90:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  98:	7f d6                	jg     70 <forktest+0x70>
      printf(2, "wait stopped early\n");
      exit();
    }
  }

  if(wait() != -1){
  9a:	e8 bc 03 00 00       	call   45b <wait>
  9f:	83 f8 ff             	cmp    $0xffffffff,%eax
  a2:	74 17                	je     bb <forktest+0xbb>
    printf(2, "wait got too many\n");
  a4:	83 ec 08             	sub    $0x8,%esp
  a7:	68 0a 0a 00 00       	push   $0xa0a
  ac:	6a 02                	push   $0x2
  ae:	e8 57 05 00 00       	call   60a <printf>
  b3:	83 c4 10             	add    $0x10,%esp
    exit();
  b6:	e8 98 03 00 00       	call   453 <exit>
  }

  printf(1, "fork test OK\n");
  bb:	83 ec 08             	sub    $0x8,%esp
  be:	68 1d 0a 00 00       	push   $0xa1d
  c3:	6a 01                	push   $0x1
  c5:	e8 40 05 00 00       	call   60a <printf>
  ca:	83 c4 10             	add    $0x10,%esp
}
  cd:	90                   	nop
  ce:	c9                   	leave  
  cf:	c3                   	ret    

000000d0 <main>:

int
main(int argc, char **argv)
{
  d0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  d4:	83 e4 f0             	and    $0xfffffff0,%esp
  d7:	ff 71 fc             	pushl  -0x4(%ecx)
  da:	55                   	push   %ebp
  db:	89 e5                	mov    %esp,%ebp
  dd:	51                   	push   %ecx
  de:	83 ec 14             	sub    $0x14,%esp
  e1:	89 c8                	mov    %ecx,%eax
  int N;

  if (argc == 1) {
  e3:	83 38 01             	cmpl   $0x1,(%eax)
  e6:	75 17                	jne    ff <main+0x2f>
    printf(2, "Enter number of processes to create\n");
  e8:	83 ec 08             	sub    $0x8,%esp
  eb:	68 2c 0a 00 00       	push   $0xa2c
  f0:	6a 02                	push   $0x2
  f2:	e8 13 05 00 00       	call   60a <printf>
  f7:	83 c4 10             	add    $0x10,%esp
    exit();
  fa:	e8 54 03 00 00       	call   453 <exit>
  }

  N = atoi(argv[1]);
  ff:	8b 40 04             	mov    0x4(%eax),%eax
 102:	83 c0 04             	add    $0x4,%eax
 105:	8b 00                	mov    (%eax),%eax
 107:	83 ec 0c             	sub    $0xc,%esp
 10a:	50                   	push   %eax
 10b:	e8 de 01 00 00       	call   2ee <atoi>
 110:	83 c4 10             	add    $0x10,%esp
 113:	89 45 f4             	mov    %eax,-0xc(%ebp)
  forktest(N);
 116:	83 ec 0c             	sub    $0xc,%esp
 119:	ff 75 f4             	pushl  -0xc(%ebp)
 11c:	e8 df fe ff ff       	call   0 <forktest>
 121:	83 c4 10             	add    $0x10,%esp
  exit();
 124:	e8 2a 03 00 00       	call   453 <exit>

00000129 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 129:	55                   	push   %ebp
 12a:	89 e5                	mov    %esp,%ebp
 12c:	57                   	push   %edi
 12d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 12e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 131:	8b 55 10             	mov    0x10(%ebp),%edx
 134:	8b 45 0c             	mov    0xc(%ebp),%eax
 137:	89 cb                	mov    %ecx,%ebx
 139:	89 df                	mov    %ebx,%edi
 13b:	89 d1                	mov    %edx,%ecx
 13d:	fc                   	cld    
 13e:	f3 aa                	rep stos %al,%es:(%edi)
 140:	89 ca                	mov    %ecx,%edx
 142:	89 fb                	mov    %edi,%ebx
 144:	89 5d 08             	mov    %ebx,0x8(%ebp)
 147:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 14a:	90                   	nop
 14b:	5b                   	pop    %ebx
 14c:	5f                   	pop    %edi
 14d:	5d                   	pop    %ebp
 14e:	c3                   	ret    

0000014f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 14f:	55                   	push   %ebp
 150:	89 e5                	mov    %esp,%ebp
 152:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 155:	8b 45 08             	mov    0x8(%ebp),%eax
 158:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 15b:	90                   	nop
 15c:	8b 45 08             	mov    0x8(%ebp),%eax
 15f:	8d 50 01             	lea    0x1(%eax),%edx
 162:	89 55 08             	mov    %edx,0x8(%ebp)
 165:	8b 55 0c             	mov    0xc(%ebp),%edx
 168:	8d 4a 01             	lea    0x1(%edx),%ecx
 16b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 16e:	0f b6 12             	movzbl (%edx),%edx
 171:	88 10                	mov    %dl,(%eax)
 173:	0f b6 00             	movzbl (%eax),%eax
 176:	84 c0                	test   %al,%al
 178:	75 e2                	jne    15c <strcpy+0xd>
    ;
  return os;
 17a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 17d:	c9                   	leave  
 17e:	c3                   	ret    

0000017f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 17f:	55                   	push   %ebp
 180:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 182:	eb 08                	jmp    18c <strcmp+0xd>
    p++, q++;
 184:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 188:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	0f b6 00             	movzbl (%eax),%eax
 192:	84 c0                	test   %al,%al
 194:	74 10                	je     1a6 <strcmp+0x27>
 196:	8b 45 08             	mov    0x8(%ebp),%eax
 199:	0f b6 10             	movzbl (%eax),%edx
 19c:	8b 45 0c             	mov    0xc(%ebp),%eax
 19f:	0f b6 00             	movzbl (%eax),%eax
 1a2:	38 c2                	cmp    %al,%dl
 1a4:	74 de                	je     184 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
 1a9:	0f b6 00             	movzbl (%eax),%eax
 1ac:	0f b6 d0             	movzbl %al,%edx
 1af:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b2:	0f b6 00             	movzbl (%eax),%eax
 1b5:	0f b6 c0             	movzbl %al,%eax
 1b8:	29 c2                	sub    %eax,%edx
 1ba:	89 d0                	mov    %edx,%eax
}
 1bc:	5d                   	pop    %ebp
 1bd:	c3                   	ret    

000001be <strlen>:

uint
strlen(char *s)
{
 1be:	55                   	push   %ebp
 1bf:	89 e5                	mov    %esp,%ebp
 1c1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1cb:	eb 04                	jmp    1d1 <strlen+0x13>
 1cd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1d4:	8b 45 08             	mov    0x8(%ebp),%eax
 1d7:	01 d0                	add    %edx,%eax
 1d9:	0f b6 00             	movzbl (%eax),%eax
 1dc:	84 c0                	test   %al,%al
 1de:	75 ed                	jne    1cd <strlen+0xf>
    ;
  return n;
 1e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1e3:	c9                   	leave  
 1e4:	c3                   	ret    

000001e5 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e5:	55                   	push   %ebp
 1e6:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1e8:	8b 45 10             	mov    0x10(%ebp),%eax
 1eb:	50                   	push   %eax
 1ec:	ff 75 0c             	pushl  0xc(%ebp)
 1ef:	ff 75 08             	pushl  0x8(%ebp)
 1f2:	e8 32 ff ff ff       	call   129 <stosb>
 1f7:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1fd:	c9                   	leave  
 1fe:	c3                   	ret    

000001ff <strchr>:

char*
strchr(const char *s, char c)
{
 1ff:	55                   	push   %ebp
 200:	89 e5                	mov    %esp,%ebp
 202:	83 ec 04             	sub    $0x4,%esp
 205:	8b 45 0c             	mov    0xc(%ebp),%eax
 208:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 20b:	eb 14                	jmp    221 <strchr+0x22>
    if(*s == c)
 20d:	8b 45 08             	mov    0x8(%ebp),%eax
 210:	0f b6 00             	movzbl (%eax),%eax
 213:	3a 45 fc             	cmp    -0x4(%ebp),%al
 216:	75 05                	jne    21d <strchr+0x1e>
      return (char*)s;
 218:	8b 45 08             	mov    0x8(%ebp),%eax
 21b:	eb 13                	jmp    230 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 21d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 221:	8b 45 08             	mov    0x8(%ebp),%eax
 224:	0f b6 00             	movzbl (%eax),%eax
 227:	84 c0                	test   %al,%al
 229:	75 e2                	jne    20d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 22b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 230:	c9                   	leave  
 231:	c3                   	ret    

00000232 <gets>:

char*
gets(char *buf, int max)
{
 232:	55                   	push   %ebp
 233:	89 e5                	mov    %esp,%ebp
 235:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 238:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 23f:	eb 42                	jmp    283 <gets+0x51>
    cc = read(0, &c, 1);
 241:	83 ec 04             	sub    $0x4,%esp
 244:	6a 01                	push   $0x1
 246:	8d 45 ef             	lea    -0x11(%ebp),%eax
 249:	50                   	push   %eax
 24a:	6a 00                	push   $0x0
 24c:	e8 1a 02 00 00       	call   46b <read>
 251:	83 c4 10             	add    $0x10,%esp
 254:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 257:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 25b:	7e 33                	jle    290 <gets+0x5e>
      break;
    buf[i++] = c;
 25d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 260:	8d 50 01             	lea    0x1(%eax),%edx
 263:	89 55 f4             	mov    %edx,-0xc(%ebp)
 266:	89 c2                	mov    %eax,%edx
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	01 c2                	add    %eax,%edx
 26d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 271:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 273:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 277:	3c 0a                	cmp    $0xa,%al
 279:	74 16                	je     291 <gets+0x5f>
 27b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27f:	3c 0d                	cmp    $0xd,%al
 281:	74 0e                	je     291 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 283:	8b 45 f4             	mov    -0xc(%ebp),%eax
 286:	83 c0 01             	add    $0x1,%eax
 289:	3b 45 0c             	cmp    0xc(%ebp),%eax
 28c:	7c b3                	jl     241 <gets+0xf>
 28e:	eb 01                	jmp    291 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 290:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 291:	8b 55 f4             	mov    -0xc(%ebp),%edx
 294:	8b 45 08             	mov    0x8(%ebp),%eax
 297:	01 d0                	add    %edx,%eax
 299:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 29f:	c9                   	leave  
 2a0:	c3                   	ret    

000002a1 <stat>:

int
stat(char *n, struct stat *st)
{
 2a1:	55                   	push   %ebp
 2a2:	89 e5                	mov    %esp,%ebp
 2a4:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a7:	83 ec 08             	sub    $0x8,%esp
 2aa:	6a 00                	push   $0x0
 2ac:	ff 75 08             	pushl  0x8(%ebp)
 2af:	e8 df 01 00 00       	call   493 <open>
 2b4:	83 c4 10             	add    $0x10,%esp
 2b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2be:	79 07                	jns    2c7 <stat+0x26>
    return -1;
 2c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c5:	eb 25                	jmp    2ec <stat+0x4b>
  r = fstat(fd, st);
 2c7:	83 ec 08             	sub    $0x8,%esp
 2ca:	ff 75 0c             	pushl  0xc(%ebp)
 2cd:	ff 75 f4             	pushl  -0xc(%ebp)
 2d0:	e8 d6 01 00 00       	call   4ab <fstat>
 2d5:	83 c4 10             	add    $0x10,%esp
 2d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2db:	83 ec 0c             	sub    $0xc,%esp
 2de:	ff 75 f4             	pushl  -0xc(%ebp)
 2e1:	e8 95 01 00 00       	call   47b <close>
 2e6:	83 c4 10             	add    $0x10,%esp
  return r;
 2e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2ec:	c9                   	leave  
 2ed:	c3                   	ret    

000002ee <atoi>:

int
atoi(const char *s)
{
 2ee:	55                   	push   %ebp
 2ef:	89 e5                	mov    %esp,%ebp
 2f1:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2fb:	eb 04                	jmp    301 <atoi+0x13>
 2fd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 301:	8b 45 08             	mov    0x8(%ebp),%eax
 304:	0f b6 00             	movzbl (%eax),%eax
 307:	3c 20                	cmp    $0x20,%al
 309:	74 f2                	je     2fd <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 30b:	8b 45 08             	mov    0x8(%ebp),%eax
 30e:	0f b6 00             	movzbl (%eax),%eax
 311:	3c 2d                	cmp    $0x2d,%al
 313:	75 07                	jne    31c <atoi+0x2e>
 315:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 31a:	eb 05                	jmp    321 <atoi+0x33>
 31c:	b8 01 00 00 00       	mov    $0x1,%eax
 321:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 324:	8b 45 08             	mov    0x8(%ebp),%eax
 327:	0f b6 00             	movzbl (%eax),%eax
 32a:	3c 2b                	cmp    $0x2b,%al
 32c:	74 0a                	je     338 <atoi+0x4a>
 32e:	8b 45 08             	mov    0x8(%ebp),%eax
 331:	0f b6 00             	movzbl (%eax),%eax
 334:	3c 2d                	cmp    $0x2d,%al
 336:	75 2b                	jne    363 <atoi+0x75>
    s++;
 338:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 33c:	eb 25                	jmp    363 <atoi+0x75>
    n = n*10 + *s++ - '0';
 33e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 341:	89 d0                	mov    %edx,%eax
 343:	c1 e0 02             	shl    $0x2,%eax
 346:	01 d0                	add    %edx,%eax
 348:	01 c0                	add    %eax,%eax
 34a:	89 c1                	mov    %eax,%ecx
 34c:	8b 45 08             	mov    0x8(%ebp),%eax
 34f:	8d 50 01             	lea    0x1(%eax),%edx
 352:	89 55 08             	mov    %edx,0x8(%ebp)
 355:	0f b6 00             	movzbl (%eax),%eax
 358:	0f be c0             	movsbl %al,%eax
 35b:	01 c8                	add    %ecx,%eax
 35d:	83 e8 30             	sub    $0x30,%eax
 360:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 363:	8b 45 08             	mov    0x8(%ebp),%eax
 366:	0f b6 00             	movzbl (%eax),%eax
 369:	3c 2f                	cmp    $0x2f,%al
 36b:	7e 0a                	jle    377 <atoi+0x89>
 36d:	8b 45 08             	mov    0x8(%ebp),%eax
 370:	0f b6 00             	movzbl (%eax),%eax
 373:	3c 39                	cmp    $0x39,%al
 375:	7e c7                	jle    33e <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 377:	8b 45 f8             	mov    -0x8(%ebp),%eax
 37a:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 37e:	c9                   	leave  
 37f:	c3                   	ret    

00000380 <atoo>:

int
atoo(const char *s)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 386:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 38d:	eb 04                	jmp    393 <atoo+0x13>
 38f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 393:	8b 45 08             	mov    0x8(%ebp),%eax
 396:	0f b6 00             	movzbl (%eax),%eax
 399:	3c 20                	cmp    $0x20,%al
 39b:	74 f2                	je     38f <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 39d:	8b 45 08             	mov    0x8(%ebp),%eax
 3a0:	0f b6 00             	movzbl (%eax),%eax
 3a3:	3c 2d                	cmp    $0x2d,%al
 3a5:	75 07                	jne    3ae <atoo+0x2e>
 3a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3ac:	eb 05                	jmp    3b3 <atoo+0x33>
 3ae:	b8 01 00 00 00       	mov    $0x1,%eax
 3b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3b6:	8b 45 08             	mov    0x8(%ebp),%eax
 3b9:	0f b6 00             	movzbl (%eax),%eax
 3bc:	3c 2b                	cmp    $0x2b,%al
 3be:	74 0a                	je     3ca <atoo+0x4a>
 3c0:	8b 45 08             	mov    0x8(%ebp),%eax
 3c3:	0f b6 00             	movzbl (%eax),%eax
 3c6:	3c 2d                	cmp    $0x2d,%al
 3c8:	75 27                	jne    3f1 <atoo+0x71>
    s++;
 3ca:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 3ce:	eb 21                	jmp    3f1 <atoo+0x71>
    n = n*8 + *s++ - '0';
 3d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3d3:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 3da:	8b 45 08             	mov    0x8(%ebp),%eax
 3dd:	8d 50 01             	lea    0x1(%eax),%edx
 3e0:	89 55 08             	mov    %edx,0x8(%ebp)
 3e3:	0f b6 00             	movzbl (%eax),%eax
 3e6:	0f be c0             	movsbl %al,%eax
 3e9:	01 c8                	add    %ecx,%eax
 3eb:	83 e8 30             	sub    $0x30,%eax
 3ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 3f1:	8b 45 08             	mov    0x8(%ebp),%eax
 3f4:	0f b6 00             	movzbl (%eax),%eax
 3f7:	3c 2f                	cmp    $0x2f,%al
 3f9:	7e 0a                	jle    405 <atoo+0x85>
 3fb:	8b 45 08             	mov    0x8(%ebp),%eax
 3fe:	0f b6 00             	movzbl (%eax),%eax
 401:	3c 37                	cmp    $0x37,%al
 403:	7e cb                	jle    3d0 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 405:	8b 45 f8             	mov    -0x8(%ebp),%eax
 408:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 40c:	c9                   	leave  
 40d:	c3                   	ret    

0000040e <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 40e:	55                   	push   %ebp
 40f:	89 e5                	mov    %esp,%ebp
 411:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 414:	8b 45 08             	mov    0x8(%ebp),%eax
 417:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 41a:	8b 45 0c             	mov    0xc(%ebp),%eax
 41d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 420:	eb 17                	jmp    439 <memmove+0x2b>
    *dst++ = *src++;
 422:	8b 45 fc             	mov    -0x4(%ebp),%eax
 425:	8d 50 01             	lea    0x1(%eax),%edx
 428:	89 55 fc             	mov    %edx,-0x4(%ebp)
 42b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 42e:	8d 4a 01             	lea    0x1(%edx),%ecx
 431:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 434:	0f b6 12             	movzbl (%edx),%edx
 437:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 439:	8b 45 10             	mov    0x10(%ebp),%eax
 43c:	8d 50 ff             	lea    -0x1(%eax),%edx
 43f:	89 55 10             	mov    %edx,0x10(%ebp)
 442:	85 c0                	test   %eax,%eax
 444:	7f dc                	jg     422 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 446:	8b 45 08             	mov    0x8(%ebp),%eax
}
 449:	c9                   	leave  
 44a:	c3                   	ret    

0000044b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 44b:	b8 01 00 00 00       	mov    $0x1,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <exit>:
SYSCALL(exit)
 453:	b8 02 00 00 00       	mov    $0x2,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <wait>:
SYSCALL(wait)
 45b:	b8 03 00 00 00       	mov    $0x3,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <pipe>:
SYSCALL(pipe)
 463:	b8 04 00 00 00       	mov    $0x4,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <read>:
SYSCALL(read)
 46b:	b8 05 00 00 00       	mov    $0x5,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <write>:
SYSCALL(write)
 473:	b8 10 00 00 00       	mov    $0x10,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <close>:
SYSCALL(close)
 47b:	b8 15 00 00 00       	mov    $0x15,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <kill>:
SYSCALL(kill)
 483:	b8 06 00 00 00       	mov    $0x6,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <exec>:
SYSCALL(exec)
 48b:	b8 07 00 00 00       	mov    $0x7,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <open>:
SYSCALL(open)
 493:	b8 0f 00 00 00       	mov    $0xf,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <mknod>:
SYSCALL(mknod)
 49b:	b8 11 00 00 00       	mov    $0x11,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <unlink>:
SYSCALL(unlink)
 4a3:	b8 12 00 00 00       	mov    $0x12,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <fstat>:
SYSCALL(fstat)
 4ab:	b8 08 00 00 00       	mov    $0x8,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <link>:
SYSCALL(link)
 4b3:	b8 13 00 00 00       	mov    $0x13,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <mkdir>:
SYSCALL(mkdir)
 4bb:	b8 14 00 00 00       	mov    $0x14,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <chdir>:
SYSCALL(chdir)
 4c3:	b8 09 00 00 00       	mov    $0x9,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <dup>:
SYSCALL(dup)
 4cb:	b8 0a 00 00 00       	mov    $0xa,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <getpid>:
SYSCALL(getpid)
 4d3:	b8 0b 00 00 00       	mov    $0xb,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <sbrk>:
SYSCALL(sbrk)
 4db:	b8 0c 00 00 00       	mov    $0xc,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <sleep>:
SYSCALL(sleep)
 4e3:	b8 0d 00 00 00       	mov    $0xd,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <uptime>:
SYSCALL(uptime)
 4eb:	b8 0e 00 00 00       	mov    $0xe,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <halt>:
SYSCALL(halt)
 4f3:	b8 16 00 00 00       	mov    $0x16,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <date>:
SYSCALL(date)
 4fb:	b8 17 00 00 00       	mov    $0x17,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <getuid>:
SYSCALL(getuid)
 503:	b8 18 00 00 00       	mov    $0x18,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <getgid>:
SYSCALL(getgid)
 50b:	b8 19 00 00 00       	mov    $0x19,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <getppid>:
SYSCALL(getppid)
 513:	b8 1a 00 00 00       	mov    $0x1a,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <setuid>:
SYSCALL(setuid)
 51b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <setgid>:
SYSCALL(setgid)
 523:	b8 1c 00 00 00       	mov    $0x1c,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <getprocs>:
SYSCALL(getprocs)
 52b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 533:	55                   	push   %ebp
 534:	89 e5                	mov    %esp,%ebp
 536:	83 ec 18             	sub    $0x18,%esp
 539:	8b 45 0c             	mov    0xc(%ebp),%eax
 53c:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 53f:	83 ec 04             	sub    $0x4,%esp
 542:	6a 01                	push   $0x1
 544:	8d 45 f4             	lea    -0xc(%ebp),%eax
 547:	50                   	push   %eax
 548:	ff 75 08             	pushl  0x8(%ebp)
 54b:	e8 23 ff ff ff       	call   473 <write>
 550:	83 c4 10             	add    $0x10,%esp
}
 553:	90                   	nop
 554:	c9                   	leave  
 555:	c3                   	ret    

00000556 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 556:	55                   	push   %ebp
 557:	89 e5                	mov    %esp,%ebp
 559:	53                   	push   %ebx
 55a:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 55d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 564:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 568:	74 17                	je     581 <printint+0x2b>
 56a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 56e:	79 11                	jns    581 <printint+0x2b>
    neg = 1;
 570:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 577:	8b 45 0c             	mov    0xc(%ebp),%eax
 57a:	f7 d8                	neg    %eax
 57c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 57f:	eb 06                	jmp    587 <printint+0x31>
  } else {
    x = xx;
 581:	8b 45 0c             	mov    0xc(%ebp),%eax
 584:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 587:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 58e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 591:	8d 41 01             	lea    0x1(%ecx),%eax
 594:	89 45 f4             	mov    %eax,-0xc(%ebp)
 597:	8b 5d 10             	mov    0x10(%ebp),%ebx
 59a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 59d:	ba 00 00 00 00       	mov    $0x0,%edx
 5a2:	f7 f3                	div    %ebx
 5a4:	89 d0                	mov    %edx,%eax
 5a6:	0f b6 80 e0 0c 00 00 	movzbl 0xce0(%eax),%eax
 5ad:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5b7:	ba 00 00 00 00       	mov    $0x0,%edx
 5bc:	f7 f3                	div    %ebx
 5be:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5c1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5c5:	75 c7                	jne    58e <printint+0x38>
  if(neg)
 5c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5cb:	74 2d                	je     5fa <printint+0xa4>
    buf[i++] = '-';
 5cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5d0:	8d 50 01             	lea    0x1(%eax),%edx
 5d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5d6:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5db:	eb 1d                	jmp    5fa <printint+0xa4>
    putc(fd, buf[i]);
 5dd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e3:	01 d0                	add    %edx,%eax
 5e5:	0f b6 00             	movzbl (%eax),%eax
 5e8:	0f be c0             	movsbl %al,%eax
 5eb:	83 ec 08             	sub    $0x8,%esp
 5ee:	50                   	push   %eax
 5ef:	ff 75 08             	pushl  0x8(%ebp)
 5f2:	e8 3c ff ff ff       	call   533 <putc>
 5f7:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5fa:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 602:	79 d9                	jns    5dd <printint+0x87>
    putc(fd, buf[i]);
}
 604:	90                   	nop
 605:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 608:	c9                   	leave  
 609:	c3                   	ret    

0000060a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 60a:	55                   	push   %ebp
 60b:	89 e5                	mov    %esp,%ebp
 60d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 610:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 617:	8d 45 0c             	lea    0xc(%ebp),%eax
 61a:	83 c0 04             	add    $0x4,%eax
 61d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 620:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 627:	e9 59 01 00 00       	jmp    785 <printf+0x17b>
    c = fmt[i] & 0xff;
 62c:	8b 55 0c             	mov    0xc(%ebp),%edx
 62f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 632:	01 d0                	add    %edx,%eax
 634:	0f b6 00             	movzbl (%eax),%eax
 637:	0f be c0             	movsbl %al,%eax
 63a:	25 ff 00 00 00       	and    $0xff,%eax
 63f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 642:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 646:	75 2c                	jne    674 <printf+0x6a>
      if(c == '%'){
 648:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 64c:	75 0c                	jne    65a <printf+0x50>
        state = '%';
 64e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 655:	e9 27 01 00 00       	jmp    781 <printf+0x177>
      } else {
        putc(fd, c);
 65a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 65d:	0f be c0             	movsbl %al,%eax
 660:	83 ec 08             	sub    $0x8,%esp
 663:	50                   	push   %eax
 664:	ff 75 08             	pushl  0x8(%ebp)
 667:	e8 c7 fe ff ff       	call   533 <putc>
 66c:	83 c4 10             	add    $0x10,%esp
 66f:	e9 0d 01 00 00       	jmp    781 <printf+0x177>
      }
    } else if(state == '%'){
 674:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 678:	0f 85 03 01 00 00    	jne    781 <printf+0x177>
      if(c == 'd'){
 67e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 682:	75 1e                	jne    6a2 <printf+0x98>
        printint(fd, *ap, 10, 1);
 684:	8b 45 e8             	mov    -0x18(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	6a 01                	push   $0x1
 68b:	6a 0a                	push   $0xa
 68d:	50                   	push   %eax
 68e:	ff 75 08             	pushl  0x8(%ebp)
 691:	e8 c0 fe ff ff       	call   556 <printint>
 696:	83 c4 10             	add    $0x10,%esp
        ap++;
 699:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 69d:	e9 d8 00 00 00       	jmp    77a <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6a2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6a6:	74 06                	je     6ae <printf+0xa4>
 6a8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6ac:	75 1e                	jne    6cc <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b1:	8b 00                	mov    (%eax),%eax
 6b3:	6a 00                	push   $0x0
 6b5:	6a 10                	push   $0x10
 6b7:	50                   	push   %eax
 6b8:	ff 75 08             	pushl  0x8(%ebp)
 6bb:	e8 96 fe ff ff       	call   556 <printint>
 6c0:	83 c4 10             	add    $0x10,%esp
        ap++;
 6c3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6c7:	e9 ae 00 00 00       	jmp    77a <printf+0x170>
      } else if(c == 's'){
 6cc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6d0:	75 43                	jne    715 <printf+0x10b>
        s = (char*)*ap;
 6d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d5:	8b 00                	mov    (%eax),%eax
 6d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6da:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6e2:	75 25                	jne    709 <printf+0xff>
          s = "(null)";
 6e4:	c7 45 f4 51 0a 00 00 	movl   $0xa51,-0xc(%ebp)
        while(*s != 0){
 6eb:	eb 1c                	jmp    709 <printf+0xff>
          putc(fd, *s);
 6ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f0:	0f b6 00             	movzbl (%eax),%eax
 6f3:	0f be c0             	movsbl %al,%eax
 6f6:	83 ec 08             	sub    $0x8,%esp
 6f9:	50                   	push   %eax
 6fa:	ff 75 08             	pushl  0x8(%ebp)
 6fd:	e8 31 fe ff ff       	call   533 <putc>
 702:	83 c4 10             	add    $0x10,%esp
          s++;
 705:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 709:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70c:	0f b6 00             	movzbl (%eax),%eax
 70f:	84 c0                	test   %al,%al
 711:	75 da                	jne    6ed <printf+0xe3>
 713:	eb 65                	jmp    77a <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 715:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 719:	75 1d                	jne    738 <printf+0x12e>
        putc(fd, *ap);
 71b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 71e:	8b 00                	mov    (%eax),%eax
 720:	0f be c0             	movsbl %al,%eax
 723:	83 ec 08             	sub    $0x8,%esp
 726:	50                   	push   %eax
 727:	ff 75 08             	pushl  0x8(%ebp)
 72a:	e8 04 fe ff ff       	call   533 <putc>
 72f:	83 c4 10             	add    $0x10,%esp
        ap++;
 732:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 736:	eb 42                	jmp    77a <printf+0x170>
      } else if(c == '%'){
 738:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 73c:	75 17                	jne    755 <printf+0x14b>
        putc(fd, c);
 73e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 741:	0f be c0             	movsbl %al,%eax
 744:	83 ec 08             	sub    $0x8,%esp
 747:	50                   	push   %eax
 748:	ff 75 08             	pushl  0x8(%ebp)
 74b:	e8 e3 fd ff ff       	call   533 <putc>
 750:	83 c4 10             	add    $0x10,%esp
 753:	eb 25                	jmp    77a <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 755:	83 ec 08             	sub    $0x8,%esp
 758:	6a 25                	push   $0x25
 75a:	ff 75 08             	pushl  0x8(%ebp)
 75d:	e8 d1 fd ff ff       	call   533 <putc>
 762:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 765:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 768:	0f be c0             	movsbl %al,%eax
 76b:	83 ec 08             	sub    $0x8,%esp
 76e:	50                   	push   %eax
 76f:	ff 75 08             	pushl  0x8(%ebp)
 772:	e8 bc fd ff ff       	call   533 <putc>
 777:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 77a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 781:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 785:	8b 55 0c             	mov    0xc(%ebp),%edx
 788:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78b:	01 d0                	add    %edx,%eax
 78d:	0f b6 00             	movzbl (%eax),%eax
 790:	84 c0                	test   %al,%al
 792:	0f 85 94 fe ff ff    	jne    62c <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 798:	90                   	nop
 799:	c9                   	leave  
 79a:	c3                   	ret    

0000079b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 79b:	55                   	push   %ebp
 79c:	89 e5                	mov    %esp,%ebp
 79e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7a1:	8b 45 08             	mov    0x8(%ebp),%eax
 7a4:	83 e8 08             	sub    $0x8,%eax
 7a7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7aa:	a1 fc 0c 00 00       	mov    0xcfc,%eax
 7af:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7b2:	eb 24                	jmp    7d8 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b7:	8b 00                	mov    (%eax),%eax
 7b9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7bc:	77 12                	ja     7d0 <free+0x35>
 7be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c4:	77 24                	ja     7ea <free+0x4f>
 7c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c9:	8b 00                	mov    (%eax),%eax
 7cb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7ce:	77 1a                	ja     7ea <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d3:	8b 00                	mov    (%eax),%eax
 7d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7de:	76 d4                	jbe    7b4 <free+0x19>
 7e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e3:	8b 00                	mov    (%eax),%eax
 7e5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e8:	76 ca                	jbe    7b4 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ed:	8b 40 04             	mov    0x4(%eax),%eax
 7f0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fa:	01 c2                	add    %eax,%edx
 7fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ff:	8b 00                	mov    (%eax),%eax
 801:	39 c2                	cmp    %eax,%edx
 803:	75 24                	jne    829 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 805:	8b 45 f8             	mov    -0x8(%ebp),%eax
 808:	8b 50 04             	mov    0x4(%eax),%edx
 80b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80e:	8b 00                	mov    (%eax),%eax
 810:	8b 40 04             	mov    0x4(%eax),%eax
 813:	01 c2                	add    %eax,%edx
 815:	8b 45 f8             	mov    -0x8(%ebp),%eax
 818:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 81b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81e:	8b 00                	mov    (%eax),%eax
 820:	8b 10                	mov    (%eax),%edx
 822:	8b 45 f8             	mov    -0x8(%ebp),%eax
 825:	89 10                	mov    %edx,(%eax)
 827:	eb 0a                	jmp    833 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 829:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82c:	8b 10                	mov    (%eax),%edx
 82e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 831:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 833:	8b 45 fc             	mov    -0x4(%ebp),%eax
 836:	8b 40 04             	mov    0x4(%eax),%eax
 839:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 840:	8b 45 fc             	mov    -0x4(%ebp),%eax
 843:	01 d0                	add    %edx,%eax
 845:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 848:	75 20                	jne    86a <free+0xcf>
    p->s.size += bp->s.size;
 84a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84d:	8b 50 04             	mov    0x4(%eax),%edx
 850:	8b 45 f8             	mov    -0x8(%ebp),%eax
 853:	8b 40 04             	mov    0x4(%eax),%eax
 856:	01 c2                	add    %eax,%edx
 858:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 85e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 861:	8b 10                	mov    (%eax),%edx
 863:	8b 45 fc             	mov    -0x4(%ebp),%eax
 866:	89 10                	mov    %edx,(%eax)
 868:	eb 08                	jmp    872 <free+0xd7>
  } else
    p->s.ptr = bp;
 86a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 870:	89 10                	mov    %edx,(%eax)
  freep = p;
 872:	8b 45 fc             	mov    -0x4(%ebp),%eax
 875:	a3 fc 0c 00 00       	mov    %eax,0xcfc
}
 87a:	90                   	nop
 87b:	c9                   	leave  
 87c:	c3                   	ret    

0000087d <morecore>:

static Header*
morecore(uint nu)
{
 87d:	55                   	push   %ebp
 87e:	89 e5                	mov    %esp,%ebp
 880:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 883:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 88a:	77 07                	ja     893 <morecore+0x16>
    nu = 4096;
 88c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 893:	8b 45 08             	mov    0x8(%ebp),%eax
 896:	c1 e0 03             	shl    $0x3,%eax
 899:	83 ec 0c             	sub    $0xc,%esp
 89c:	50                   	push   %eax
 89d:	e8 39 fc ff ff       	call   4db <sbrk>
 8a2:	83 c4 10             	add    $0x10,%esp
 8a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8a8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8ac:	75 07                	jne    8b5 <morecore+0x38>
    return 0;
 8ae:	b8 00 00 00 00       	mov    $0x0,%eax
 8b3:	eb 26                	jmp    8db <morecore+0x5e>
  hp = (Header*)p;
 8b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8be:	8b 55 08             	mov    0x8(%ebp),%edx
 8c1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c7:	83 c0 08             	add    $0x8,%eax
 8ca:	83 ec 0c             	sub    $0xc,%esp
 8cd:	50                   	push   %eax
 8ce:	e8 c8 fe ff ff       	call   79b <free>
 8d3:	83 c4 10             	add    $0x10,%esp
  return freep;
 8d6:	a1 fc 0c 00 00       	mov    0xcfc,%eax
}
 8db:	c9                   	leave  
 8dc:	c3                   	ret    

000008dd <malloc>:

void*
malloc(uint nbytes)
{
 8dd:	55                   	push   %ebp
 8de:	89 e5                	mov    %esp,%ebp
 8e0:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8e3:	8b 45 08             	mov    0x8(%ebp),%eax
 8e6:	83 c0 07             	add    $0x7,%eax
 8e9:	c1 e8 03             	shr    $0x3,%eax
 8ec:	83 c0 01             	add    $0x1,%eax
 8ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8f2:	a1 fc 0c 00 00       	mov    0xcfc,%eax
 8f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8fe:	75 23                	jne    923 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 900:	c7 45 f0 f4 0c 00 00 	movl   $0xcf4,-0x10(%ebp)
 907:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90a:	a3 fc 0c 00 00       	mov    %eax,0xcfc
 90f:	a1 fc 0c 00 00       	mov    0xcfc,%eax
 914:	a3 f4 0c 00 00       	mov    %eax,0xcf4
    base.s.size = 0;
 919:	c7 05 f8 0c 00 00 00 	movl   $0x0,0xcf8
 920:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 923:	8b 45 f0             	mov    -0x10(%ebp),%eax
 926:	8b 00                	mov    (%eax),%eax
 928:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 92b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92e:	8b 40 04             	mov    0x4(%eax),%eax
 931:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 934:	72 4d                	jb     983 <malloc+0xa6>
      if(p->s.size == nunits)
 936:	8b 45 f4             	mov    -0xc(%ebp),%eax
 939:	8b 40 04             	mov    0x4(%eax),%eax
 93c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 93f:	75 0c                	jne    94d <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 941:	8b 45 f4             	mov    -0xc(%ebp),%eax
 944:	8b 10                	mov    (%eax),%edx
 946:	8b 45 f0             	mov    -0x10(%ebp),%eax
 949:	89 10                	mov    %edx,(%eax)
 94b:	eb 26                	jmp    973 <malloc+0x96>
      else {
        p->s.size -= nunits;
 94d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 950:	8b 40 04             	mov    0x4(%eax),%eax
 953:	2b 45 ec             	sub    -0x14(%ebp),%eax
 956:	89 c2                	mov    %eax,%edx
 958:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95b:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 95e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 961:	8b 40 04             	mov    0x4(%eax),%eax
 964:	c1 e0 03             	shl    $0x3,%eax
 967:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 96a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96d:	8b 55 ec             	mov    -0x14(%ebp),%edx
 970:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 973:	8b 45 f0             	mov    -0x10(%ebp),%eax
 976:	a3 fc 0c 00 00       	mov    %eax,0xcfc
      return (void*)(p + 1);
 97b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97e:	83 c0 08             	add    $0x8,%eax
 981:	eb 3b                	jmp    9be <malloc+0xe1>
    }
    if(p == freep)
 983:	a1 fc 0c 00 00       	mov    0xcfc,%eax
 988:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 98b:	75 1e                	jne    9ab <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 98d:	83 ec 0c             	sub    $0xc,%esp
 990:	ff 75 ec             	pushl  -0x14(%ebp)
 993:	e8 e5 fe ff ff       	call   87d <morecore>
 998:	83 c4 10             	add    $0x10,%esp
 99b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 99e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9a2:	75 07                	jne    9ab <malloc+0xce>
        return 0;
 9a4:	b8 00 00 00 00       	mov    $0x0,%eax
 9a9:	eb 13                	jmp    9be <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b4:	8b 00                	mov    (%eax),%eax
 9b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9b9:	e9 6d ff ff ff       	jmp    92b <malloc+0x4e>
}
 9be:	c9                   	leave  
 9bf:	c3                   	ret    
