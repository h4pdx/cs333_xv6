
_tPrio:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

#include "types.h"
#include "user.h"

int
main(void) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
    int pid, prio;
    int rc;
    pid = getpid();
  11:	e8 b6 05 00 00       	call   5cc <getpid>
  16:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(1, "Setting priority to 1 (Expected: PASS).\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 c4 0a 00 00       	push   $0xac4
  21:	6a 01                	push   $0x1
  23:	e8 e3 06 00 00       	call   70b <printf>
  28:	83 c4 10             	add    $0x10,%esp
    prio = 1;
  2b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    rc = setpriority(pid, prio);
  32:	83 ec 08             	sub    $0x8,%esp
  35:	ff 75 f0             	pushl  -0x10(%ebp)
  38:	ff 75 f4             	pushl  -0xc(%ebp)
  3b:	e8 ec 05 00 00       	call   62c <setpriority>
  40:	83 c4 10             	add    $0x10,%esp
  43:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (!rc) {
  46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  4a:	75 17                	jne    63 <main+0x63>
        printf(1, "Priority for process %d set to: %d.\n", pid, prio);
  4c:	ff 75 f0             	pushl  -0x10(%ebp)
  4f:	ff 75 f4             	pushl  -0xc(%ebp)
  52:	68 f0 0a 00 00       	push   $0xaf0
  57:	6a 01                	push   $0x1
  59:	e8 ad 06 00 00       	call   70b <printf>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	eb 15                	jmp    78 <main+0x78>
    } else {
        printf(1, "setpriority failed. PID: %d, Priority: %d.\n", pid, prio);
  63:	ff 75 f0             	pushl  -0x10(%ebp)
  66:	ff 75 f4             	pushl  -0xc(%ebp)
  69:	68 18 0b 00 00       	push   $0xb18
  6e:	6a 01                	push   $0x1
  70:	e8 96 06 00 00       	call   70b <printf>
  75:	83 c4 10             	add    $0x10,%esp
    }
    printf(1, "Sleeping.\n");
  78:	83 ec 08             	sub    $0x8,%esp
  7b:	68 44 0b 00 00       	push   $0xb44
  80:	6a 01                	push   $0x1
  82:	e8 84 06 00 00       	call   70b <printf>
  87:	83 c4 10             	add    $0x10,%esp
    sleep(5000);
  8a:	83 ec 0c             	sub    $0xc,%esp
  8d:	68 88 13 00 00       	push   $0x1388
  92:	e8 45 05 00 00       	call   5dc <sleep>
  97:	83 c4 10             	add    $0x10,%esp

    printf(1, "Setting priority to 3 (Expected: PASS).\n");
  9a:	83 ec 08             	sub    $0x8,%esp
  9d:	68 50 0b 00 00       	push   $0xb50
  a2:	6a 01                	push   $0x1
  a4:	e8 62 06 00 00       	call   70b <printf>
  a9:	83 c4 10             	add    $0x10,%esp
    prio = 3;
  ac:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
    rc = setpriority(pid, prio);
  b3:	83 ec 08             	sub    $0x8,%esp
  b6:	ff 75 f0             	pushl  -0x10(%ebp)
  b9:	ff 75 f4             	pushl  -0xc(%ebp)
  bc:	e8 6b 05 00 00       	call   62c <setpriority>
  c1:	83 c4 10             	add    $0x10,%esp
  c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (!rc) {
  c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  cb:	75 17                	jne    e4 <main+0xe4>
        printf(1, "Priority for process %d set to: %d.\n", pid, prio);
  cd:	ff 75 f0             	pushl  -0x10(%ebp)
  d0:	ff 75 f4             	pushl  -0xc(%ebp)
  d3:	68 f0 0a 00 00       	push   $0xaf0
  d8:	6a 01                	push   $0x1
  da:	e8 2c 06 00 00       	call   70b <printf>
  df:	83 c4 10             	add    $0x10,%esp
  e2:	eb 15                	jmp    f9 <main+0xf9>
    } else {
        printf(1, "setpriority failed. PID: %d, Priority: %d.\n", pid, prio);
  e4:	ff 75 f0             	pushl  -0x10(%ebp)
  e7:	ff 75 f4             	pushl  -0xc(%ebp)
  ea:	68 18 0b 00 00       	push   $0xb18
  ef:	6a 01                	push   $0x1
  f1:	e8 15 06 00 00       	call   70b <printf>
  f6:	83 c4 10             	add    $0x10,%esp
    }
    printf(1, "Sleeping.\n");
  f9:	83 ec 08             	sub    $0x8,%esp
  fc:	68 44 0b 00 00       	push   $0xb44
 101:	6a 01                	push   $0x1
 103:	e8 03 06 00 00       	call   70b <printf>
 108:	83 c4 10             	add    $0x10,%esp
    sleep(5000);
 10b:	83 ec 0c             	sub    $0xc,%esp
 10e:	68 88 13 00 00       	push   $0x1388
 113:	e8 c4 04 00 00       	call   5dc <sleep>
 118:	83 c4 10             	add    $0x10,%esp

    printf(1, "Setting priority to 100 (Expected: FAIL).\n");
 11b:	83 ec 08             	sub    $0x8,%esp
 11e:	68 7c 0b 00 00       	push   $0xb7c
 123:	6a 01                	push   $0x1
 125:	e8 e1 05 00 00       	call   70b <printf>
 12a:	83 c4 10             	add    $0x10,%esp
    prio = 100;
 12d:	c7 45 f0 64 00 00 00 	movl   $0x64,-0x10(%ebp)
    rc = setpriority(pid, prio);
 134:	83 ec 08             	sub    $0x8,%esp
 137:	ff 75 f0             	pushl  -0x10(%ebp)
 13a:	ff 75 f4             	pushl  -0xc(%ebp)
 13d:	e8 ea 04 00 00       	call   62c <setpriority>
 142:	83 c4 10             	add    $0x10,%esp
 145:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (!rc) {
 148:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 14c:	75 17                	jne    165 <main+0x165>
        printf(1, "Priority for process %d set to: %d.\n", pid, prio);
 14e:	ff 75 f0             	pushl  -0x10(%ebp)
 151:	ff 75 f4             	pushl  -0xc(%ebp)
 154:	68 f0 0a 00 00       	push   $0xaf0
 159:	6a 01                	push   $0x1
 15b:	e8 ab 05 00 00       	call   70b <printf>
 160:	83 c4 10             	add    $0x10,%esp
 163:	eb 15                	jmp    17a <main+0x17a>
    } else {
        printf(1, "setpriority failed. PID: %d, Priority: %d.\n", pid, prio);
 165:	ff 75 f0             	pushl  -0x10(%ebp)
 168:	ff 75 f4             	pushl  -0xc(%ebp)
 16b:	68 18 0b 00 00       	push   $0xb18
 170:	6a 01                	push   $0x1
 172:	e8 94 05 00 00       	call   70b <printf>
 177:	83 c4 10             	add    $0x10,%esp
    }
    printf(1, "Sleeping.\n");
 17a:	83 ec 08             	sub    $0x8,%esp
 17d:	68 44 0b 00 00       	push   $0xb44
 182:	6a 01                	push   $0x1
 184:	e8 82 05 00 00       	call   70b <printf>
 189:	83 c4 10             	add    $0x10,%esp
    sleep(5000);
 18c:	83 ec 0c             	sub    $0xc,%esp
 18f:	68 88 13 00 00       	push   $0x1388
 194:	e8 43 04 00 00       	call   5dc <sleep>
 199:	83 c4 10             	add    $0x10,%esp

    printf(1, "Setting priority to -10 (Expected: FAIL).\n");
 19c:	83 ec 08             	sub    $0x8,%esp
 19f:	68 a8 0b 00 00       	push   $0xba8
 1a4:	6a 01                	push   $0x1
 1a6:	e8 60 05 00 00       	call   70b <printf>
 1ab:	83 c4 10             	add    $0x10,%esp
    prio = (-10);
 1ae:	c7 45 f0 f6 ff ff ff 	movl   $0xfffffff6,-0x10(%ebp)
    rc = setpriority(pid, prio);
 1b5:	83 ec 08             	sub    $0x8,%esp
 1b8:	ff 75 f0             	pushl  -0x10(%ebp)
 1bb:	ff 75 f4             	pushl  -0xc(%ebp)
 1be:	e8 69 04 00 00       	call   62c <setpriority>
 1c3:	83 c4 10             	add    $0x10,%esp
 1c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (!rc) {
 1c9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 1cd:	75 17                	jne    1e6 <main+0x1e6>
        printf(1, "Priority for process %d set to: %d.\n", pid, prio);
 1cf:	ff 75 f0             	pushl  -0x10(%ebp)
 1d2:	ff 75 f4             	pushl  -0xc(%ebp)
 1d5:	68 f0 0a 00 00       	push   $0xaf0
 1da:	6a 01                	push   $0x1
 1dc:	e8 2a 05 00 00       	call   70b <printf>
 1e1:	83 c4 10             	add    $0x10,%esp
 1e4:	eb 15                	jmp    1fb <main+0x1fb>
    } else {
        printf(1, "setpriority failed. PID: %d, Priority: %d.\n", pid, prio);
 1e6:	ff 75 f0             	pushl  -0x10(%ebp)
 1e9:	ff 75 f4             	pushl  -0xc(%ebp)
 1ec:	68 18 0b 00 00       	push   $0xb18
 1f1:	6a 01                	push   $0x1
 1f3:	e8 13 05 00 00       	call   70b <printf>
 1f8:	83 c4 10             	add    $0x10,%esp
    }
    printf(1, "Sleeping.\n");
 1fb:	83 ec 08             	sub    $0x8,%esp
 1fe:	68 44 0b 00 00       	push   $0xb44
 203:	6a 01                	push   $0x1
 205:	e8 01 05 00 00       	call   70b <printf>
 20a:	83 c4 10             	add    $0x10,%esp
    sleep(5000);
 20d:	83 ec 0c             	sub    $0xc,%esp
 210:	68 88 13 00 00       	push   $0x1388
 215:	e8 c2 03 00 00       	call   5dc <sleep>
 21a:	83 c4 10             	add    $0x10,%esp


    


    exit();
 21d:	e8 2a 03 00 00       	call   54c <exit>

00000222 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 222:	55                   	push   %ebp
 223:	89 e5                	mov    %esp,%ebp
 225:	57                   	push   %edi
 226:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 227:	8b 4d 08             	mov    0x8(%ebp),%ecx
 22a:	8b 55 10             	mov    0x10(%ebp),%edx
 22d:	8b 45 0c             	mov    0xc(%ebp),%eax
 230:	89 cb                	mov    %ecx,%ebx
 232:	89 df                	mov    %ebx,%edi
 234:	89 d1                	mov    %edx,%ecx
 236:	fc                   	cld    
 237:	f3 aa                	rep stos %al,%es:(%edi)
 239:	89 ca                	mov    %ecx,%edx
 23b:	89 fb                	mov    %edi,%ebx
 23d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 240:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 243:	90                   	nop
 244:	5b                   	pop    %ebx
 245:	5f                   	pop    %edi
 246:	5d                   	pop    %ebp
 247:	c3                   	ret    

00000248 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 248:	55                   	push   %ebp
 249:	89 e5                	mov    %esp,%ebp
 24b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 254:	90                   	nop
 255:	8b 45 08             	mov    0x8(%ebp),%eax
 258:	8d 50 01             	lea    0x1(%eax),%edx
 25b:	89 55 08             	mov    %edx,0x8(%ebp)
 25e:	8b 55 0c             	mov    0xc(%ebp),%edx
 261:	8d 4a 01             	lea    0x1(%edx),%ecx
 264:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 267:	0f b6 12             	movzbl (%edx),%edx
 26a:	88 10                	mov    %dl,(%eax)
 26c:	0f b6 00             	movzbl (%eax),%eax
 26f:	84 c0                	test   %al,%al
 271:	75 e2                	jne    255 <strcpy+0xd>
    ;
  return os;
 273:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 276:	c9                   	leave  
 277:	c3                   	ret    

00000278 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 278:	55                   	push   %ebp
 279:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 27b:	eb 08                	jmp    285 <strcmp+0xd>
    p++, q++;
 27d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 281:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 285:	8b 45 08             	mov    0x8(%ebp),%eax
 288:	0f b6 00             	movzbl (%eax),%eax
 28b:	84 c0                	test   %al,%al
 28d:	74 10                	je     29f <strcmp+0x27>
 28f:	8b 45 08             	mov    0x8(%ebp),%eax
 292:	0f b6 10             	movzbl (%eax),%edx
 295:	8b 45 0c             	mov    0xc(%ebp),%eax
 298:	0f b6 00             	movzbl (%eax),%eax
 29b:	38 c2                	cmp    %al,%dl
 29d:	74 de                	je     27d <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	0f b6 00             	movzbl (%eax),%eax
 2a5:	0f b6 d0             	movzbl %al,%edx
 2a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ab:	0f b6 00             	movzbl (%eax),%eax
 2ae:	0f b6 c0             	movzbl %al,%eax
 2b1:	29 c2                	sub    %eax,%edx
 2b3:	89 d0                	mov    %edx,%eax
}
 2b5:	5d                   	pop    %ebp
 2b6:	c3                   	ret    

000002b7 <strlen>:

uint
strlen(char *s)
{
 2b7:	55                   	push   %ebp
 2b8:	89 e5                	mov    %esp,%ebp
 2ba:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2c4:	eb 04                	jmp    2ca <strlen+0x13>
 2c6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
 2d0:	01 d0                	add    %edx,%eax
 2d2:	0f b6 00             	movzbl (%eax),%eax
 2d5:	84 c0                	test   %al,%al
 2d7:	75 ed                	jne    2c6 <strlen+0xf>
    ;
  return n;
 2d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2dc:	c9                   	leave  
 2dd:	c3                   	ret    

000002de <memset>:

void*
memset(void *dst, int c, uint n)
{
 2de:	55                   	push   %ebp
 2df:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 2e1:	8b 45 10             	mov    0x10(%ebp),%eax
 2e4:	50                   	push   %eax
 2e5:	ff 75 0c             	pushl  0xc(%ebp)
 2e8:	ff 75 08             	pushl  0x8(%ebp)
 2eb:	e8 32 ff ff ff       	call   222 <stosb>
 2f0:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f6:	c9                   	leave  
 2f7:	c3                   	ret    

000002f8 <strchr>:

char*
strchr(const char *s, char c)
{
 2f8:	55                   	push   %ebp
 2f9:	89 e5                	mov    %esp,%ebp
 2fb:	83 ec 04             	sub    $0x4,%esp
 2fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 301:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 304:	eb 14                	jmp    31a <strchr+0x22>
    if(*s == c)
 306:	8b 45 08             	mov    0x8(%ebp),%eax
 309:	0f b6 00             	movzbl (%eax),%eax
 30c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 30f:	75 05                	jne    316 <strchr+0x1e>
      return (char*)s;
 311:	8b 45 08             	mov    0x8(%ebp),%eax
 314:	eb 13                	jmp    329 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 316:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 31a:	8b 45 08             	mov    0x8(%ebp),%eax
 31d:	0f b6 00             	movzbl (%eax),%eax
 320:	84 c0                	test   %al,%al
 322:	75 e2                	jne    306 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 324:	b8 00 00 00 00       	mov    $0x0,%eax
}
 329:	c9                   	leave  
 32a:	c3                   	ret    

0000032b <gets>:

char*
gets(char *buf, int max)
{
 32b:	55                   	push   %ebp
 32c:	89 e5                	mov    %esp,%ebp
 32e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 331:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 338:	eb 42                	jmp    37c <gets+0x51>
    cc = read(0, &c, 1);
 33a:	83 ec 04             	sub    $0x4,%esp
 33d:	6a 01                	push   $0x1
 33f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 342:	50                   	push   %eax
 343:	6a 00                	push   $0x0
 345:	e8 1a 02 00 00       	call   564 <read>
 34a:	83 c4 10             	add    $0x10,%esp
 34d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 350:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 354:	7e 33                	jle    389 <gets+0x5e>
      break;
    buf[i++] = c;
 356:	8b 45 f4             	mov    -0xc(%ebp),%eax
 359:	8d 50 01             	lea    0x1(%eax),%edx
 35c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 35f:	89 c2                	mov    %eax,%edx
 361:	8b 45 08             	mov    0x8(%ebp),%eax
 364:	01 c2                	add    %eax,%edx
 366:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 36a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 36c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 370:	3c 0a                	cmp    $0xa,%al
 372:	74 16                	je     38a <gets+0x5f>
 374:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 378:	3c 0d                	cmp    $0xd,%al
 37a:	74 0e                	je     38a <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 37c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 37f:	83 c0 01             	add    $0x1,%eax
 382:	3b 45 0c             	cmp    0xc(%ebp),%eax
 385:	7c b3                	jl     33a <gets+0xf>
 387:	eb 01                	jmp    38a <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 389:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 38a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 38d:	8b 45 08             	mov    0x8(%ebp),%eax
 390:	01 d0                	add    %edx,%eax
 392:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 395:	8b 45 08             	mov    0x8(%ebp),%eax
}
 398:	c9                   	leave  
 399:	c3                   	ret    

0000039a <stat>:

int
stat(char *n, struct stat *st)
{
 39a:	55                   	push   %ebp
 39b:	89 e5                	mov    %esp,%ebp
 39d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3a0:	83 ec 08             	sub    $0x8,%esp
 3a3:	6a 00                	push   $0x0
 3a5:	ff 75 08             	pushl  0x8(%ebp)
 3a8:	e8 df 01 00 00       	call   58c <open>
 3ad:	83 c4 10             	add    $0x10,%esp
 3b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 3b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3b7:	79 07                	jns    3c0 <stat+0x26>
    return -1;
 3b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3be:	eb 25                	jmp    3e5 <stat+0x4b>
  r = fstat(fd, st);
 3c0:	83 ec 08             	sub    $0x8,%esp
 3c3:	ff 75 0c             	pushl  0xc(%ebp)
 3c6:	ff 75 f4             	pushl  -0xc(%ebp)
 3c9:	e8 d6 01 00 00       	call   5a4 <fstat>
 3ce:	83 c4 10             	add    $0x10,%esp
 3d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3d4:	83 ec 0c             	sub    $0xc,%esp
 3d7:	ff 75 f4             	pushl  -0xc(%ebp)
 3da:	e8 95 01 00 00       	call   574 <close>
 3df:	83 c4 10             	add    $0x10,%esp
  return r;
 3e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3e5:	c9                   	leave  
 3e6:	c3                   	ret    

000003e7 <atoi>:

int
atoi(const char *s)
{
 3e7:	55                   	push   %ebp
 3e8:	89 e5                	mov    %esp,%ebp
 3ea:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 3f4:	eb 04                	jmp    3fa <atoi+0x13>
 3f6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3fa:	8b 45 08             	mov    0x8(%ebp),%eax
 3fd:	0f b6 00             	movzbl (%eax),%eax
 400:	3c 20                	cmp    $0x20,%al
 402:	74 f2                	je     3f6 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 404:	8b 45 08             	mov    0x8(%ebp),%eax
 407:	0f b6 00             	movzbl (%eax),%eax
 40a:	3c 2d                	cmp    $0x2d,%al
 40c:	75 07                	jne    415 <atoi+0x2e>
 40e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 413:	eb 05                	jmp    41a <atoi+0x33>
 415:	b8 01 00 00 00       	mov    $0x1,%eax
 41a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 41d:	8b 45 08             	mov    0x8(%ebp),%eax
 420:	0f b6 00             	movzbl (%eax),%eax
 423:	3c 2b                	cmp    $0x2b,%al
 425:	74 0a                	je     431 <atoi+0x4a>
 427:	8b 45 08             	mov    0x8(%ebp),%eax
 42a:	0f b6 00             	movzbl (%eax),%eax
 42d:	3c 2d                	cmp    $0x2d,%al
 42f:	75 2b                	jne    45c <atoi+0x75>
    s++;
 431:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 435:	eb 25                	jmp    45c <atoi+0x75>
    n = n*10 + *s++ - '0';
 437:	8b 55 fc             	mov    -0x4(%ebp),%edx
 43a:	89 d0                	mov    %edx,%eax
 43c:	c1 e0 02             	shl    $0x2,%eax
 43f:	01 d0                	add    %edx,%eax
 441:	01 c0                	add    %eax,%eax
 443:	89 c1                	mov    %eax,%ecx
 445:	8b 45 08             	mov    0x8(%ebp),%eax
 448:	8d 50 01             	lea    0x1(%eax),%edx
 44b:	89 55 08             	mov    %edx,0x8(%ebp)
 44e:	0f b6 00             	movzbl (%eax),%eax
 451:	0f be c0             	movsbl %al,%eax
 454:	01 c8                	add    %ecx,%eax
 456:	83 e8 30             	sub    $0x30,%eax
 459:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 45c:	8b 45 08             	mov    0x8(%ebp),%eax
 45f:	0f b6 00             	movzbl (%eax),%eax
 462:	3c 2f                	cmp    $0x2f,%al
 464:	7e 0a                	jle    470 <atoi+0x89>
 466:	8b 45 08             	mov    0x8(%ebp),%eax
 469:	0f b6 00             	movzbl (%eax),%eax
 46c:	3c 39                	cmp    $0x39,%al
 46e:	7e c7                	jle    437 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 470:	8b 45 f8             	mov    -0x8(%ebp),%eax
 473:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 477:	c9                   	leave  
 478:	c3                   	ret    

00000479 <atoo>:

int
atoo(const char *s)
{
 479:	55                   	push   %ebp
 47a:	89 e5                	mov    %esp,%ebp
 47c:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 47f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 486:	eb 04                	jmp    48c <atoo+0x13>
 488:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 48c:	8b 45 08             	mov    0x8(%ebp),%eax
 48f:	0f b6 00             	movzbl (%eax),%eax
 492:	3c 20                	cmp    $0x20,%al
 494:	74 f2                	je     488 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 496:	8b 45 08             	mov    0x8(%ebp),%eax
 499:	0f b6 00             	movzbl (%eax),%eax
 49c:	3c 2d                	cmp    $0x2d,%al
 49e:	75 07                	jne    4a7 <atoo+0x2e>
 4a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4a5:	eb 05                	jmp    4ac <atoo+0x33>
 4a7:	b8 01 00 00 00       	mov    $0x1,%eax
 4ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 4af:	8b 45 08             	mov    0x8(%ebp),%eax
 4b2:	0f b6 00             	movzbl (%eax),%eax
 4b5:	3c 2b                	cmp    $0x2b,%al
 4b7:	74 0a                	je     4c3 <atoo+0x4a>
 4b9:	8b 45 08             	mov    0x8(%ebp),%eax
 4bc:	0f b6 00             	movzbl (%eax),%eax
 4bf:	3c 2d                	cmp    $0x2d,%al
 4c1:	75 27                	jne    4ea <atoo+0x71>
    s++;
 4c3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 4c7:	eb 21                	jmp    4ea <atoo+0x71>
    n = n*8 + *s++ - '0';
 4c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4cc:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 4d3:	8b 45 08             	mov    0x8(%ebp),%eax
 4d6:	8d 50 01             	lea    0x1(%eax),%edx
 4d9:	89 55 08             	mov    %edx,0x8(%ebp)
 4dc:	0f b6 00             	movzbl (%eax),%eax
 4df:	0f be c0             	movsbl %al,%eax
 4e2:	01 c8                	add    %ecx,%eax
 4e4:	83 e8 30             	sub    $0x30,%eax
 4e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 4ea:	8b 45 08             	mov    0x8(%ebp),%eax
 4ed:	0f b6 00             	movzbl (%eax),%eax
 4f0:	3c 2f                	cmp    $0x2f,%al
 4f2:	7e 0a                	jle    4fe <atoo+0x85>
 4f4:	8b 45 08             	mov    0x8(%ebp),%eax
 4f7:	0f b6 00             	movzbl (%eax),%eax
 4fa:	3c 37                	cmp    $0x37,%al
 4fc:	7e cb                	jle    4c9 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 4fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 501:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 505:	c9                   	leave  
 506:	c3                   	ret    

00000507 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 507:	55                   	push   %ebp
 508:	89 e5                	mov    %esp,%ebp
 50a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 50d:	8b 45 08             	mov    0x8(%ebp),%eax
 510:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 513:	8b 45 0c             	mov    0xc(%ebp),%eax
 516:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 519:	eb 17                	jmp    532 <memmove+0x2b>
    *dst++ = *src++;
 51b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 51e:	8d 50 01             	lea    0x1(%eax),%edx
 521:	89 55 fc             	mov    %edx,-0x4(%ebp)
 524:	8b 55 f8             	mov    -0x8(%ebp),%edx
 527:	8d 4a 01             	lea    0x1(%edx),%ecx
 52a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 52d:	0f b6 12             	movzbl (%edx),%edx
 530:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 532:	8b 45 10             	mov    0x10(%ebp),%eax
 535:	8d 50 ff             	lea    -0x1(%eax),%edx
 538:	89 55 10             	mov    %edx,0x10(%ebp)
 53b:	85 c0                	test   %eax,%eax
 53d:	7f dc                	jg     51b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 53f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 542:	c9                   	leave  
 543:	c3                   	ret    

00000544 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 544:	b8 01 00 00 00       	mov    $0x1,%eax
 549:	cd 40                	int    $0x40
 54b:	c3                   	ret    

0000054c <exit>:
SYSCALL(exit)
 54c:	b8 02 00 00 00       	mov    $0x2,%eax
 551:	cd 40                	int    $0x40
 553:	c3                   	ret    

00000554 <wait>:
SYSCALL(wait)
 554:	b8 03 00 00 00       	mov    $0x3,%eax
 559:	cd 40                	int    $0x40
 55b:	c3                   	ret    

0000055c <pipe>:
SYSCALL(pipe)
 55c:	b8 04 00 00 00       	mov    $0x4,%eax
 561:	cd 40                	int    $0x40
 563:	c3                   	ret    

00000564 <read>:
SYSCALL(read)
 564:	b8 05 00 00 00       	mov    $0x5,%eax
 569:	cd 40                	int    $0x40
 56b:	c3                   	ret    

0000056c <write>:
SYSCALL(write)
 56c:	b8 10 00 00 00       	mov    $0x10,%eax
 571:	cd 40                	int    $0x40
 573:	c3                   	ret    

00000574 <close>:
SYSCALL(close)
 574:	b8 15 00 00 00       	mov    $0x15,%eax
 579:	cd 40                	int    $0x40
 57b:	c3                   	ret    

0000057c <kill>:
SYSCALL(kill)
 57c:	b8 06 00 00 00       	mov    $0x6,%eax
 581:	cd 40                	int    $0x40
 583:	c3                   	ret    

00000584 <exec>:
SYSCALL(exec)
 584:	b8 07 00 00 00       	mov    $0x7,%eax
 589:	cd 40                	int    $0x40
 58b:	c3                   	ret    

0000058c <open>:
SYSCALL(open)
 58c:	b8 0f 00 00 00       	mov    $0xf,%eax
 591:	cd 40                	int    $0x40
 593:	c3                   	ret    

00000594 <mknod>:
SYSCALL(mknod)
 594:	b8 11 00 00 00       	mov    $0x11,%eax
 599:	cd 40                	int    $0x40
 59b:	c3                   	ret    

0000059c <unlink>:
SYSCALL(unlink)
 59c:	b8 12 00 00 00       	mov    $0x12,%eax
 5a1:	cd 40                	int    $0x40
 5a3:	c3                   	ret    

000005a4 <fstat>:
SYSCALL(fstat)
 5a4:	b8 08 00 00 00       	mov    $0x8,%eax
 5a9:	cd 40                	int    $0x40
 5ab:	c3                   	ret    

000005ac <link>:
SYSCALL(link)
 5ac:	b8 13 00 00 00       	mov    $0x13,%eax
 5b1:	cd 40                	int    $0x40
 5b3:	c3                   	ret    

000005b4 <mkdir>:
SYSCALL(mkdir)
 5b4:	b8 14 00 00 00       	mov    $0x14,%eax
 5b9:	cd 40                	int    $0x40
 5bb:	c3                   	ret    

000005bc <chdir>:
SYSCALL(chdir)
 5bc:	b8 09 00 00 00       	mov    $0x9,%eax
 5c1:	cd 40                	int    $0x40
 5c3:	c3                   	ret    

000005c4 <dup>:
SYSCALL(dup)
 5c4:	b8 0a 00 00 00       	mov    $0xa,%eax
 5c9:	cd 40                	int    $0x40
 5cb:	c3                   	ret    

000005cc <getpid>:
SYSCALL(getpid)
 5cc:	b8 0b 00 00 00       	mov    $0xb,%eax
 5d1:	cd 40                	int    $0x40
 5d3:	c3                   	ret    

000005d4 <sbrk>:
SYSCALL(sbrk)
 5d4:	b8 0c 00 00 00       	mov    $0xc,%eax
 5d9:	cd 40                	int    $0x40
 5db:	c3                   	ret    

000005dc <sleep>:
SYSCALL(sleep)
 5dc:	b8 0d 00 00 00       	mov    $0xd,%eax
 5e1:	cd 40                	int    $0x40
 5e3:	c3                   	ret    

000005e4 <uptime>:
SYSCALL(uptime)
 5e4:	b8 0e 00 00 00       	mov    $0xe,%eax
 5e9:	cd 40                	int    $0x40
 5eb:	c3                   	ret    

000005ec <halt>:
SYSCALL(halt)
 5ec:	b8 16 00 00 00       	mov    $0x16,%eax
 5f1:	cd 40                	int    $0x40
 5f3:	c3                   	ret    

000005f4 <date>:
SYSCALL(date)
 5f4:	b8 17 00 00 00       	mov    $0x17,%eax
 5f9:	cd 40                	int    $0x40
 5fb:	c3                   	ret    

000005fc <getuid>:
SYSCALL(getuid)
 5fc:	b8 18 00 00 00       	mov    $0x18,%eax
 601:	cd 40                	int    $0x40
 603:	c3                   	ret    

00000604 <getgid>:
SYSCALL(getgid)
 604:	b8 19 00 00 00       	mov    $0x19,%eax
 609:	cd 40                	int    $0x40
 60b:	c3                   	ret    

0000060c <getppid>:
SYSCALL(getppid)
 60c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 611:	cd 40                	int    $0x40
 613:	c3                   	ret    

00000614 <setuid>:
SYSCALL(setuid)
 614:	b8 1b 00 00 00       	mov    $0x1b,%eax
 619:	cd 40                	int    $0x40
 61b:	c3                   	ret    

0000061c <setgid>:
SYSCALL(setgid)
 61c:	b8 1c 00 00 00       	mov    $0x1c,%eax
 621:	cd 40                	int    $0x40
 623:	c3                   	ret    

00000624 <getprocs>:
SYSCALL(getprocs)
 624:	b8 1d 00 00 00       	mov    $0x1d,%eax
 629:	cd 40                	int    $0x40
 62b:	c3                   	ret    

0000062c <setpriority>:
SYSCALL(setpriority)
 62c:	b8 1e 00 00 00       	mov    $0x1e,%eax
 631:	cd 40                	int    $0x40
 633:	c3                   	ret    

00000634 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 634:	55                   	push   %ebp
 635:	89 e5                	mov    %esp,%ebp
 637:	83 ec 18             	sub    $0x18,%esp
 63a:	8b 45 0c             	mov    0xc(%ebp),%eax
 63d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 640:	83 ec 04             	sub    $0x4,%esp
 643:	6a 01                	push   $0x1
 645:	8d 45 f4             	lea    -0xc(%ebp),%eax
 648:	50                   	push   %eax
 649:	ff 75 08             	pushl  0x8(%ebp)
 64c:	e8 1b ff ff ff       	call   56c <write>
 651:	83 c4 10             	add    $0x10,%esp
}
 654:	90                   	nop
 655:	c9                   	leave  
 656:	c3                   	ret    

00000657 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 657:	55                   	push   %ebp
 658:	89 e5                	mov    %esp,%ebp
 65a:	53                   	push   %ebx
 65b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 65e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 665:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 669:	74 17                	je     682 <printint+0x2b>
 66b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 66f:	79 11                	jns    682 <printint+0x2b>
    neg = 1;
 671:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 678:	8b 45 0c             	mov    0xc(%ebp),%eax
 67b:	f7 d8                	neg    %eax
 67d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 680:	eb 06                	jmp    688 <printint+0x31>
  } else {
    x = xx;
 682:	8b 45 0c             	mov    0xc(%ebp),%eax
 685:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 688:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 68f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 692:	8d 41 01             	lea    0x1(%ecx),%eax
 695:	89 45 f4             	mov    %eax,-0xc(%ebp)
 698:	8b 5d 10             	mov    0x10(%ebp),%ebx
 69b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 69e:	ba 00 00 00 00       	mov    $0x0,%edx
 6a3:	f7 f3                	div    %ebx
 6a5:	89 d0                	mov    %edx,%eax
 6a7:	0f b6 80 44 0e 00 00 	movzbl 0xe44(%eax),%eax
 6ae:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 6b2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 6b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6b8:	ba 00 00 00 00       	mov    $0x0,%edx
 6bd:	f7 f3                	div    %ebx
 6bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6c6:	75 c7                	jne    68f <printint+0x38>
  if(neg)
 6c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6cc:	74 2d                	je     6fb <printint+0xa4>
    buf[i++] = '-';
 6ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d1:	8d 50 01             	lea    0x1(%eax),%edx
 6d4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6d7:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6dc:	eb 1d                	jmp    6fb <printint+0xa4>
    putc(fd, buf[i]);
 6de:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e4:	01 d0                	add    %edx,%eax
 6e6:	0f b6 00             	movzbl (%eax),%eax
 6e9:	0f be c0             	movsbl %al,%eax
 6ec:	83 ec 08             	sub    $0x8,%esp
 6ef:	50                   	push   %eax
 6f0:	ff 75 08             	pushl  0x8(%ebp)
 6f3:	e8 3c ff ff ff       	call   634 <putc>
 6f8:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6fb:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 703:	79 d9                	jns    6de <printint+0x87>
    putc(fd, buf[i]);
}
 705:	90                   	nop
 706:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 709:	c9                   	leave  
 70a:	c3                   	ret    

0000070b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 70b:	55                   	push   %ebp
 70c:	89 e5                	mov    %esp,%ebp
 70e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 711:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 718:	8d 45 0c             	lea    0xc(%ebp),%eax
 71b:	83 c0 04             	add    $0x4,%eax
 71e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 721:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 728:	e9 59 01 00 00       	jmp    886 <printf+0x17b>
    c = fmt[i] & 0xff;
 72d:	8b 55 0c             	mov    0xc(%ebp),%edx
 730:	8b 45 f0             	mov    -0x10(%ebp),%eax
 733:	01 d0                	add    %edx,%eax
 735:	0f b6 00             	movzbl (%eax),%eax
 738:	0f be c0             	movsbl %al,%eax
 73b:	25 ff 00 00 00       	and    $0xff,%eax
 740:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 743:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 747:	75 2c                	jne    775 <printf+0x6a>
      if(c == '%'){
 749:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 74d:	75 0c                	jne    75b <printf+0x50>
        state = '%';
 74f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 756:	e9 27 01 00 00       	jmp    882 <printf+0x177>
      } else {
        putc(fd, c);
 75b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 75e:	0f be c0             	movsbl %al,%eax
 761:	83 ec 08             	sub    $0x8,%esp
 764:	50                   	push   %eax
 765:	ff 75 08             	pushl  0x8(%ebp)
 768:	e8 c7 fe ff ff       	call   634 <putc>
 76d:	83 c4 10             	add    $0x10,%esp
 770:	e9 0d 01 00 00       	jmp    882 <printf+0x177>
      }
    } else if(state == '%'){
 775:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 779:	0f 85 03 01 00 00    	jne    882 <printf+0x177>
      if(c == 'd'){
 77f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 783:	75 1e                	jne    7a3 <printf+0x98>
        printint(fd, *ap, 10, 1);
 785:	8b 45 e8             	mov    -0x18(%ebp),%eax
 788:	8b 00                	mov    (%eax),%eax
 78a:	6a 01                	push   $0x1
 78c:	6a 0a                	push   $0xa
 78e:	50                   	push   %eax
 78f:	ff 75 08             	pushl  0x8(%ebp)
 792:	e8 c0 fe ff ff       	call   657 <printint>
 797:	83 c4 10             	add    $0x10,%esp
        ap++;
 79a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 79e:	e9 d8 00 00 00       	jmp    87b <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7a3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7a7:	74 06                	je     7af <printf+0xa4>
 7a9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7ad:	75 1e                	jne    7cd <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7af:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7b2:	8b 00                	mov    (%eax),%eax
 7b4:	6a 00                	push   $0x0
 7b6:	6a 10                	push   $0x10
 7b8:	50                   	push   %eax
 7b9:	ff 75 08             	pushl  0x8(%ebp)
 7bc:	e8 96 fe ff ff       	call   657 <printint>
 7c1:	83 c4 10             	add    $0x10,%esp
        ap++;
 7c4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7c8:	e9 ae 00 00 00       	jmp    87b <printf+0x170>
      } else if(c == 's'){
 7cd:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7d1:	75 43                	jne    816 <printf+0x10b>
        s = (char*)*ap;
 7d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7d6:	8b 00                	mov    (%eax),%eax
 7d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7db:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7e3:	75 25                	jne    80a <printf+0xff>
          s = "(null)";
 7e5:	c7 45 f4 d3 0b 00 00 	movl   $0xbd3,-0xc(%ebp)
        while(*s != 0){
 7ec:	eb 1c                	jmp    80a <printf+0xff>
          putc(fd, *s);
 7ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f1:	0f b6 00             	movzbl (%eax),%eax
 7f4:	0f be c0             	movsbl %al,%eax
 7f7:	83 ec 08             	sub    $0x8,%esp
 7fa:	50                   	push   %eax
 7fb:	ff 75 08             	pushl  0x8(%ebp)
 7fe:	e8 31 fe ff ff       	call   634 <putc>
 803:	83 c4 10             	add    $0x10,%esp
          s++;
 806:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 80a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80d:	0f b6 00             	movzbl (%eax),%eax
 810:	84 c0                	test   %al,%al
 812:	75 da                	jne    7ee <printf+0xe3>
 814:	eb 65                	jmp    87b <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 816:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 81a:	75 1d                	jne    839 <printf+0x12e>
        putc(fd, *ap);
 81c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 81f:	8b 00                	mov    (%eax),%eax
 821:	0f be c0             	movsbl %al,%eax
 824:	83 ec 08             	sub    $0x8,%esp
 827:	50                   	push   %eax
 828:	ff 75 08             	pushl  0x8(%ebp)
 82b:	e8 04 fe ff ff       	call   634 <putc>
 830:	83 c4 10             	add    $0x10,%esp
        ap++;
 833:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 837:	eb 42                	jmp    87b <printf+0x170>
      } else if(c == '%'){
 839:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 83d:	75 17                	jne    856 <printf+0x14b>
        putc(fd, c);
 83f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 842:	0f be c0             	movsbl %al,%eax
 845:	83 ec 08             	sub    $0x8,%esp
 848:	50                   	push   %eax
 849:	ff 75 08             	pushl  0x8(%ebp)
 84c:	e8 e3 fd ff ff       	call   634 <putc>
 851:	83 c4 10             	add    $0x10,%esp
 854:	eb 25                	jmp    87b <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 856:	83 ec 08             	sub    $0x8,%esp
 859:	6a 25                	push   $0x25
 85b:	ff 75 08             	pushl  0x8(%ebp)
 85e:	e8 d1 fd ff ff       	call   634 <putc>
 863:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 866:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 869:	0f be c0             	movsbl %al,%eax
 86c:	83 ec 08             	sub    $0x8,%esp
 86f:	50                   	push   %eax
 870:	ff 75 08             	pushl  0x8(%ebp)
 873:	e8 bc fd ff ff       	call   634 <putc>
 878:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 87b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 882:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 886:	8b 55 0c             	mov    0xc(%ebp),%edx
 889:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88c:	01 d0                	add    %edx,%eax
 88e:	0f b6 00             	movzbl (%eax),%eax
 891:	84 c0                	test   %al,%al
 893:	0f 85 94 fe ff ff    	jne    72d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 899:	90                   	nop
 89a:	c9                   	leave  
 89b:	c3                   	ret    

0000089c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 89c:	55                   	push   %ebp
 89d:	89 e5                	mov    %esp,%ebp
 89f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8a2:	8b 45 08             	mov    0x8(%ebp),%eax
 8a5:	83 e8 08             	sub    $0x8,%eax
 8a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ab:	a1 60 0e 00 00       	mov    0xe60,%eax
 8b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8b3:	eb 24                	jmp    8d9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b8:	8b 00                	mov    (%eax),%eax
 8ba:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8bd:	77 12                	ja     8d1 <free+0x35>
 8bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8c5:	77 24                	ja     8eb <free+0x4f>
 8c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ca:	8b 00                	mov    (%eax),%eax
 8cc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8cf:	77 1a                	ja     8eb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d4:	8b 00                	mov    (%eax),%eax
 8d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8dc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8df:	76 d4                	jbe    8b5 <free+0x19>
 8e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e4:	8b 00                	mov    (%eax),%eax
 8e6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8e9:	76 ca                	jbe    8b5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ee:	8b 40 04             	mov    0x4(%eax),%eax
 8f1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fb:	01 c2                	add    %eax,%edx
 8fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 900:	8b 00                	mov    (%eax),%eax
 902:	39 c2                	cmp    %eax,%edx
 904:	75 24                	jne    92a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 906:	8b 45 f8             	mov    -0x8(%ebp),%eax
 909:	8b 50 04             	mov    0x4(%eax),%edx
 90c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90f:	8b 00                	mov    (%eax),%eax
 911:	8b 40 04             	mov    0x4(%eax),%eax
 914:	01 c2                	add    %eax,%edx
 916:	8b 45 f8             	mov    -0x8(%ebp),%eax
 919:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 91c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91f:	8b 00                	mov    (%eax),%eax
 921:	8b 10                	mov    (%eax),%edx
 923:	8b 45 f8             	mov    -0x8(%ebp),%eax
 926:	89 10                	mov    %edx,(%eax)
 928:	eb 0a                	jmp    934 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 92a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92d:	8b 10                	mov    (%eax),%edx
 92f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 932:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 934:	8b 45 fc             	mov    -0x4(%ebp),%eax
 937:	8b 40 04             	mov    0x4(%eax),%eax
 93a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 941:	8b 45 fc             	mov    -0x4(%ebp),%eax
 944:	01 d0                	add    %edx,%eax
 946:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 949:	75 20                	jne    96b <free+0xcf>
    p->s.size += bp->s.size;
 94b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94e:	8b 50 04             	mov    0x4(%eax),%edx
 951:	8b 45 f8             	mov    -0x8(%ebp),%eax
 954:	8b 40 04             	mov    0x4(%eax),%eax
 957:	01 c2                	add    %eax,%edx
 959:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 95f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 962:	8b 10                	mov    (%eax),%edx
 964:	8b 45 fc             	mov    -0x4(%ebp),%eax
 967:	89 10                	mov    %edx,(%eax)
 969:	eb 08                	jmp    973 <free+0xd7>
  } else
    p->s.ptr = bp;
 96b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 971:	89 10                	mov    %edx,(%eax)
  freep = p;
 973:	8b 45 fc             	mov    -0x4(%ebp),%eax
 976:	a3 60 0e 00 00       	mov    %eax,0xe60
}
 97b:	90                   	nop
 97c:	c9                   	leave  
 97d:	c3                   	ret    

0000097e <morecore>:

static Header*
morecore(uint nu)
{
 97e:	55                   	push   %ebp
 97f:	89 e5                	mov    %esp,%ebp
 981:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 984:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 98b:	77 07                	ja     994 <morecore+0x16>
    nu = 4096;
 98d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 994:	8b 45 08             	mov    0x8(%ebp),%eax
 997:	c1 e0 03             	shl    $0x3,%eax
 99a:	83 ec 0c             	sub    $0xc,%esp
 99d:	50                   	push   %eax
 99e:	e8 31 fc ff ff       	call   5d4 <sbrk>
 9a3:	83 c4 10             	add    $0x10,%esp
 9a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9a9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9ad:	75 07                	jne    9b6 <morecore+0x38>
    return 0;
 9af:	b8 00 00 00 00       	mov    $0x0,%eax
 9b4:	eb 26                	jmp    9dc <morecore+0x5e>
  hp = (Header*)p;
 9b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9bf:	8b 55 08             	mov    0x8(%ebp),%edx
 9c2:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c8:	83 c0 08             	add    $0x8,%eax
 9cb:	83 ec 0c             	sub    $0xc,%esp
 9ce:	50                   	push   %eax
 9cf:	e8 c8 fe ff ff       	call   89c <free>
 9d4:	83 c4 10             	add    $0x10,%esp
  return freep;
 9d7:	a1 60 0e 00 00       	mov    0xe60,%eax
}
 9dc:	c9                   	leave  
 9dd:	c3                   	ret    

000009de <malloc>:

void*
malloc(uint nbytes)
{
 9de:	55                   	push   %ebp
 9df:	89 e5                	mov    %esp,%ebp
 9e1:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e4:	8b 45 08             	mov    0x8(%ebp),%eax
 9e7:	83 c0 07             	add    $0x7,%eax
 9ea:	c1 e8 03             	shr    $0x3,%eax
 9ed:	83 c0 01             	add    $0x1,%eax
 9f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9f3:	a1 60 0e 00 00       	mov    0xe60,%eax
 9f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9ff:	75 23                	jne    a24 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a01:	c7 45 f0 58 0e 00 00 	movl   $0xe58,-0x10(%ebp)
 a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a0b:	a3 60 0e 00 00       	mov    %eax,0xe60
 a10:	a1 60 0e 00 00       	mov    0xe60,%eax
 a15:	a3 58 0e 00 00       	mov    %eax,0xe58
    base.s.size = 0;
 a1a:	c7 05 5c 0e 00 00 00 	movl   $0x0,0xe5c
 a21:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a27:	8b 00                	mov    (%eax),%eax
 a29:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2f:	8b 40 04             	mov    0x4(%eax),%eax
 a32:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a35:	72 4d                	jb     a84 <malloc+0xa6>
      if(p->s.size == nunits)
 a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3a:	8b 40 04             	mov    0x4(%eax),%eax
 a3d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a40:	75 0c                	jne    a4e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a45:	8b 10                	mov    (%eax),%edx
 a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a4a:	89 10                	mov    %edx,(%eax)
 a4c:	eb 26                	jmp    a74 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a51:	8b 40 04             	mov    0x4(%eax),%eax
 a54:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a57:	89 c2                	mov    %eax,%edx
 a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a62:	8b 40 04             	mov    0x4(%eax),%eax
 a65:	c1 e0 03             	shl    $0x3,%eax
 a68:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a71:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a74:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a77:	a3 60 0e 00 00       	mov    %eax,0xe60
      return (void*)(p + 1);
 a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7f:	83 c0 08             	add    $0x8,%eax
 a82:	eb 3b                	jmp    abf <malloc+0xe1>
    }
    if(p == freep)
 a84:	a1 60 0e 00 00       	mov    0xe60,%eax
 a89:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a8c:	75 1e                	jne    aac <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a8e:	83 ec 0c             	sub    $0xc,%esp
 a91:	ff 75 ec             	pushl  -0x14(%ebp)
 a94:	e8 e5 fe ff ff       	call   97e <morecore>
 a99:	83 c4 10             	add    $0x10,%esp
 a9c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 aa3:	75 07                	jne    aac <malloc+0xce>
        return 0;
 aa5:	b8 00 00 00 00       	mov    $0x0,%eax
 aaa:	eb 13                	jmp    abf <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aaf:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab5:	8b 00                	mov    (%eax),%eax
 ab7:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 aba:	e9 6d ff ff ff       	jmp    a2c <malloc+0x4e>
}
 abf:	c9                   	leave  
 ac0:	c3                   	ret    
