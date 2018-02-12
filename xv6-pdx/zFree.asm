
_zFree:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#ifdef CS333_P3P4
#include "types.h"
#include "user.h"

int main(void) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	81 ec a4 01 00 00    	sub    $0x1a4,%esp
    int pid[100];
    int ppid = getpid();
  14:	e8 98 04 00 00       	call   4b1 <getpid>
  19:	89 45 ec             	mov    %eax,-0x14(%ebp)

    int i = 0;
  1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (i < 100) {
  23:	eb 43                	jmp    68 <main+0x68>
        pid[i] = fork();
  25:	e8 ff 03 00 00       	call   429 <fork>
  2a:	89 c2                	mov    %eax,%edx
  2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2f:	89 94 85 5c fe ff ff 	mov    %edx,-0x1a4(%ebp,%eax,4)
        if (ppid != getpid()) {
  36:	e8 76 04 00 00       	call   4b1 <getpid>
  3b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  3e:	74 15                	je     55 <main+0x55>
            //for(int x = 0; x < 1000000000; ++x); // cycle runnable and ready
            sleep(4000); // put to sleep
  40:	83 ec 0c             	sub    $0xc,%esp
  43:	68 a0 0f 00 00       	push   $0xfa0
  48:	e8 74 04 00 00       	call   4c1 <sleep>
  4d:	83 c4 10             	add    $0x10,%esp
            exit();
  50:	e8 dc 03 00 00       	call   431 <exit>
        }
        if (pid[i] == -1) {
  55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  58:	8b 84 85 5c fe ff ff 	mov    -0x1a4(%ebp,%eax,4),%eax
  5f:	83 f8 ff             	cmp    $0xffffffff,%eax
  62:	74 0c                	je     70 <main+0x70>
            break;
        }
        ++i;
  64:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
int main(void) {
    int pid[100];
    int ppid = getpid();

    int i = 0;
    while (i < 100) {
  68:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  6c:	7e b7                	jle    25 <main+0x25>
  6e:	eb 01                	jmp    71 <main+0x71>
            //for(int x = 0; x < 1000000000; ++x); // cycle runnable and ready
            sleep(4000); // put to sleep
            exit();
        }
        if (pid[i] == -1) {
            break;
  70:	90                   	nop
        }
        ++i;
    }

    if (ppid == getpid()) {
  71:	e8 3b 04 00 00       	call   4b1 <getpid>
  76:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  79:	0f 85 83 00 00 00    	jne    102 <main+0x102>
        printf(1, "Kill.\n");
  7f:	83 ec 08             	sub    $0x8,%esp
  82:	68 9e 09 00 00       	push   $0x99e
  87:	6a 01                	push   $0x1
  89:	e8 5a 05 00 00       	call   5e8 <printf>
  8e:	83 c4 10             	add    $0x10,%esp
        sleep(4000);
  91:	83 ec 0c             	sub    $0xc,%esp
  94:	68 a0 0f 00 00       	push   $0xfa0
  99:	e8 23 04 00 00       	call   4c1 <sleep>
  9e:	83 c4 10             	add    $0x10,%esp
        int j = 0;
  a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        while (j < 64) {
  a8:	eb 52                	jmp    fc <main+0xfc>
            kill(pid[j]);
  aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  ad:	8b 84 85 5c fe ff ff 	mov    -0x1a4(%ebp,%eax,4),%eax
  b4:	83 ec 0c             	sub    $0xc,%esp
  b7:	50                   	push   %eax
  b8:	e8 a4 03 00 00       	call   461 <kill>
  bd:	83 c4 10             	add    $0x10,%esp
            sleep(4000);
  c0:	83 ec 0c             	sub    $0xc,%esp
  c3:	68 a0 0f 00 00       	push   $0xfa0
  c8:	e8 f4 03 00 00       	call   4c1 <sleep>
  cd:	83 c4 10             	add    $0x10,%esp
            while (wait() == -1) {}
  d0:	90                   	nop
  d1:	e8 63 03 00 00       	call   439 <wait>
  d6:	83 f8 ff             	cmp    $0xffffffff,%eax
  d9:	74 f6                	je     d1 <main+0xd1>
            printf(1, "Reaped %d\n", pid[j]);
  db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  de:	8b 84 85 5c fe ff ff 	mov    -0x1a4(%ebp,%eax,4),%eax
  e5:	83 ec 04             	sub    $0x4,%esp
  e8:	50                   	push   %eax
  e9:	68 a5 09 00 00       	push   $0x9a5
  ee:	6a 01                	push   $0x1
  f0:	e8 f3 04 00 00       	call   5e8 <printf>
  f5:	83 c4 10             	add    $0x10,%esp
            ++j;
  f8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)

    if (ppid == getpid()) {
        printf(1, "Kill.\n");
        sleep(4000);
        int j = 0;
        while (j < 64) {
  fc:	83 7d f0 3f          	cmpl   $0x3f,-0x10(%ebp)
 100:	7e a8                	jle    aa <main+0xaa>
            while (wait() == -1) {}
            printf(1, "Reaped %d\n", pid[j]);
            ++j;
        }
    }
    exit();
 102:	e8 2a 03 00 00       	call   431 <exit>

00000107 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 107:	55                   	push   %ebp
 108:	89 e5                	mov    %esp,%ebp
 10a:	57                   	push   %edi
 10b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 10c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 10f:	8b 55 10             	mov    0x10(%ebp),%edx
 112:	8b 45 0c             	mov    0xc(%ebp),%eax
 115:	89 cb                	mov    %ecx,%ebx
 117:	89 df                	mov    %ebx,%edi
 119:	89 d1                	mov    %edx,%ecx
 11b:	fc                   	cld    
 11c:	f3 aa                	rep stos %al,%es:(%edi)
 11e:	89 ca                	mov    %ecx,%edx
 120:	89 fb                	mov    %edi,%ebx
 122:	89 5d 08             	mov    %ebx,0x8(%ebp)
 125:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 128:	90                   	nop
 129:	5b                   	pop    %ebx
 12a:	5f                   	pop    %edi
 12b:	5d                   	pop    %ebp
 12c:	c3                   	ret    

0000012d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 12d:	55                   	push   %ebp
 12e:	89 e5                	mov    %esp,%ebp
 130:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 133:	8b 45 08             	mov    0x8(%ebp),%eax
 136:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 139:	90                   	nop
 13a:	8b 45 08             	mov    0x8(%ebp),%eax
 13d:	8d 50 01             	lea    0x1(%eax),%edx
 140:	89 55 08             	mov    %edx,0x8(%ebp)
 143:	8b 55 0c             	mov    0xc(%ebp),%edx
 146:	8d 4a 01             	lea    0x1(%edx),%ecx
 149:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 14c:	0f b6 12             	movzbl (%edx),%edx
 14f:	88 10                	mov    %dl,(%eax)
 151:	0f b6 00             	movzbl (%eax),%eax
 154:	84 c0                	test   %al,%al
 156:	75 e2                	jne    13a <strcpy+0xd>
    ;
  return os;
 158:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 15b:	c9                   	leave  
 15c:	c3                   	ret    

0000015d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 15d:	55                   	push   %ebp
 15e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 160:	eb 08                	jmp    16a <strcmp+0xd>
    p++, q++;
 162:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 166:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 16a:	8b 45 08             	mov    0x8(%ebp),%eax
 16d:	0f b6 00             	movzbl (%eax),%eax
 170:	84 c0                	test   %al,%al
 172:	74 10                	je     184 <strcmp+0x27>
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	0f b6 10             	movzbl (%eax),%edx
 17a:	8b 45 0c             	mov    0xc(%ebp),%eax
 17d:	0f b6 00             	movzbl (%eax),%eax
 180:	38 c2                	cmp    %al,%dl
 182:	74 de                	je     162 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 184:	8b 45 08             	mov    0x8(%ebp),%eax
 187:	0f b6 00             	movzbl (%eax),%eax
 18a:	0f b6 d0             	movzbl %al,%edx
 18d:	8b 45 0c             	mov    0xc(%ebp),%eax
 190:	0f b6 00             	movzbl (%eax),%eax
 193:	0f b6 c0             	movzbl %al,%eax
 196:	29 c2                	sub    %eax,%edx
 198:	89 d0                	mov    %edx,%eax
}
 19a:	5d                   	pop    %ebp
 19b:	c3                   	ret    

0000019c <strlen>:

uint
strlen(char *s)
{
 19c:	55                   	push   %ebp
 19d:	89 e5                	mov    %esp,%ebp
 19f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1a2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1a9:	eb 04                	jmp    1af <strlen+0x13>
 1ab:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1af:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1b2:	8b 45 08             	mov    0x8(%ebp),%eax
 1b5:	01 d0                	add    %edx,%eax
 1b7:	0f b6 00             	movzbl (%eax),%eax
 1ba:	84 c0                	test   %al,%al
 1bc:	75 ed                	jne    1ab <strlen+0xf>
    ;
  return n;
 1be:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c1:	c9                   	leave  
 1c2:	c3                   	ret    

000001c3 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c3:	55                   	push   %ebp
 1c4:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1c6:	8b 45 10             	mov    0x10(%ebp),%eax
 1c9:	50                   	push   %eax
 1ca:	ff 75 0c             	pushl  0xc(%ebp)
 1cd:	ff 75 08             	pushl  0x8(%ebp)
 1d0:	e8 32 ff ff ff       	call   107 <stosb>
 1d5:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1db:	c9                   	leave  
 1dc:	c3                   	ret    

000001dd <strchr>:

char*
strchr(const char *s, char c)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	83 ec 04             	sub    $0x4,%esp
 1e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e6:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1e9:	eb 14                	jmp    1ff <strchr+0x22>
    if(*s == c)
 1eb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ee:	0f b6 00             	movzbl (%eax),%eax
 1f1:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1f4:	75 05                	jne    1fb <strchr+0x1e>
      return (char*)s;
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
 1f9:	eb 13                	jmp    20e <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1fb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1ff:	8b 45 08             	mov    0x8(%ebp),%eax
 202:	0f b6 00             	movzbl (%eax),%eax
 205:	84 c0                	test   %al,%al
 207:	75 e2                	jne    1eb <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 209:	b8 00 00 00 00       	mov    $0x0,%eax
}
 20e:	c9                   	leave  
 20f:	c3                   	ret    

00000210 <gets>:

char*
gets(char *buf, int max)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 216:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 21d:	eb 42                	jmp    261 <gets+0x51>
    cc = read(0, &c, 1);
 21f:	83 ec 04             	sub    $0x4,%esp
 222:	6a 01                	push   $0x1
 224:	8d 45 ef             	lea    -0x11(%ebp),%eax
 227:	50                   	push   %eax
 228:	6a 00                	push   $0x0
 22a:	e8 1a 02 00 00       	call   449 <read>
 22f:	83 c4 10             	add    $0x10,%esp
 232:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 235:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 239:	7e 33                	jle    26e <gets+0x5e>
      break;
    buf[i++] = c;
 23b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 23e:	8d 50 01             	lea    0x1(%eax),%edx
 241:	89 55 f4             	mov    %edx,-0xc(%ebp)
 244:	89 c2                	mov    %eax,%edx
 246:	8b 45 08             	mov    0x8(%ebp),%eax
 249:	01 c2                	add    %eax,%edx
 24b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24f:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 251:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 255:	3c 0a                	cmp    $0xa,%al
 257:	74 16                	je     26f <gets+0x5f>
 259:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 25d:	3c 0d                	cmp    $0xd,%al
 25f:	74 0e                	je     26f <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 261:	8b 45 f4             	mov    -0xc(%ebp),%eax
 264:	83 c0 01             	add    $0x1,%eax
 267:	3b 45 0c             	cmp    0xc(%ebp),%eax
 26a:	7c b3                	jl     21f <gets+0xf>
 26c:	eb 01                	jmp    26f <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 26e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 26f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	01 d0                	add    %edx,%eax
 277:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 27d:	c9                   	leave  
 27e:	c3                   	ret    

0000027f <stat>:

int
stat(char *n, struct stat *st)
{
 27f:	55                   	push   %ebp
 280:	89 e5                	mov    %esp,%ebp
 282:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 285:	83 ec 08             	sub    $0x8,%esp
 288:	6a 00                	push   $0x0
 28a:	ff 75 08             	pushl  0x8(%ebp)
 28d:	e8 df 01 00 00       	call   471 <open>
 292:	83 c4 10             	add    $0x10,%esp
 295:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 298:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 29c:	79 07                	jns    2a5 <stat+0x26>
    return -1;
 29e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2a3:	eb 25                	jmp    2ca <stat+0x4b>
  r = fstat(fd, st);
 2a5:	83 ec 08             	sub    $0x8,%esp
 2a8:	ff 75 0c             	pushl  0xc(%ebp)
 2ab:	ff 75 f4             	pushl  -0xc(%ebp)
 2ae:	e8 d6 01 00 00       	call   489 <fstat>
 2b3:	83 c4 10             	add    $0x10,%esp
 2b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2b9:	83 ec 0c             	sub    $0xc,%esp
 2bc:	ff 75 f4             	pushl  -0xc(%ebp)
 2bf:	e8 95 01 00 00       	call   459 <close>
 2c4:	83 c4 10             	add    $0x10,%esp
  return r;
 2c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2ca:	c9                   	leave  
 2cb:	c3                   	ret    

000002cc <atoi>:

int
atoi(const char *s)
{
 2cc:	55                   	push   %ebp
 2cd:	89 e5                	mov    %esp,%ebp
 2cf:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2d9:	eb 04                	jmp    2df <atoi+0x13>
 2db:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2df:	8b 45 08             	mov    0x8(%ebp),%eax
 2e2:	0f b6 00             	movzbl (%eax),%eax
 2e5:	3c 20                	cmp    $0x20,%al
 2e7:	74 f2                	je     2db <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 2e9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ec:	0f b6 00             	movzbl (%eax),%eax
 2ef:	3c 2d                	cmp    $0x2d,%al
 2f1:	75 07                	jne    2fa <atoi+0x2e>
 2f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2f8:	eb 05                	jmp    2ff <atoi+0x33>
 2fa:	b8 01 00 00 00       	mov    $0x1,%eax
 2ff:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 302:	8b 45 08             	mov    0x8(%ebp),%eax
 305:	0f b6 00             	movzbl (%eax),%eax
 308:	3c 2b                	cmp    $0x2b,%al
 30a:	74 0a                	je     316 <atoi+0x4a>
 30c:	8b 45 08             	mov    0x8(%ebp),%eax
 30f:	0f b6 00             	movzbl (%eax),%eax
 312:	3c 2d                	cmp    $0x2d,%al
 314:	75 2b                	jne    341 <atoi+0x75>
    s++;
 316:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 31a:	eb 25                	jmp    341 <atoi+0x75>
    n = n*10 + *s++ - '0';
 31c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 31f:	89 d0                	mov    %edx,%eax
 321:	c1 e0 02             	shl    $0x2,%eax
 324:	01 d0                	add    %edx,%eax
 326:	01 c0                	add    %eax,%eax
 328:	89 c1                	mov    %eax,%ecx
 32a:	8b 45 08             	mov    0x8(%ebp),%eax
 32d:	8d 50 01             	lea    0x1(%eax),%edx
 330:	89 55 08             	mov    %edx,0x8(%ebp)
 333:	0f b6 00             	movzbl (%eax),%eax
 336:	0f be c0             	movsbl %al,%eax
 339:	01 c8                	add    %ecx,%eax
 33b:	83 e8 30             	sub    $0x30,%eax
 33e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 341:	8b 45 08             	mov    0x8(%ebp),%eax
 344:	0f b6 00             	movzbl (%eax),%eax
 347:	3c 2f                	cmp    $0x2f,%al
 349:	7e 0a                	jle    355 <atoi+0x89>
 34b:	8b 45 08             	mov    0x8(%ebp),%eax
 34e:	0f b6 00             	movzbl (%eax),%eax
 351:	3c 39                	cmp    $0x39,%al
 353:	7e c7                	jle    31c <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 355:	8b 45 f8             	mov    -0x8(%ebp),%eax
 358:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 35c:	c9                   	leave  
 35d:	c3                   	ret    

0000035e <atoo>:

int
atoo(const char *s)
{
 35e:	55                   	push   %ebp
 35f:	89 e5                	mov    %esp,%ebp
 361:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 364:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 36b:	eb 04                	jmp    371 <atoo+0x13>
 36d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 371:	8b 45 08             	mov    0x8(%ebp),%eax
 374:	0f b6 00             	movzbl (%eax),%eax
 377:	3c 20                	cmp    $0x20,%al
 379:	74 f2                	je     36d <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 37b:	8b 45 08             	mov    0x8(%ebp),%eax
 37e:	0f b6 00             	movzbl (%eax),%eax
 381:	3c 2d                	cmp    $0x2d,%al
 383:	75 07                	jne    38c <atoo+0x2e>
 385:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 38a:	eb 05                	jmp    391 <atoo+0x33>
 38c:	b8 01 00 00 00       	mov    $0x1,%eax
 391:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 394:	8b 45 08             	mov    0x8(%ebp),%eax
 397:	0f b6 00             	movzbl (%eax),%eax
 39a:	3c 2b                	cmp    $0x2b,%al
 39c:	74 0a                	je     3a8 <atoo+0x4a>
 39e:	8b 45 08             	mov    0x8(%ebp),%eax
 3a1:	0f b6 00             	movzbl (%eax),%eax
 3a4:	3c 2d                	cmp    $0x2d,%al
 3a6:	75 27                	jne    3cf <atoo+0x71>
    s++;
 3a8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 3ac:	eb 21                	jmp    3cf <atoo+0x71>
    n = n*8 + *s++ - '0';
 3ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3b1:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 3b8:	8b 45 08             	mov    0x8(%ebp),%eax
 3bb:	8d 50 01             	lea    0x1(%eax),%edx
 3be:	89 55 08             	mov    %edx,0x8(%ebp)
 3c1:	0f b6 00             	movzbl (%eax),%eax
 3c4:	0f be c0             	movsbl %al,%eax
 3c7:	01 c8                	add    %ecx,%eax
 3c9:	83 e8 30             	sub    $0x30,%eax
 3cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 3cf:	8b 45 08             	mov    0x8(%ebp),%eax
 3d2:	0f b6 00             	movzbl (%eax),%eax
 3d5:	3c 2f                	cmp    $0x2f,%al
 3d7:	7e 0a                	jle    3e3 <atoo+0x85>
 3d9:	8b 45 08             	mov    0x8(%ebp),%eax
 3dc:	0f b6 00             	movzbl (%eax),%eax
 3df:	3c 37                	cmp    $0x37,%al
 3e1:	7e cb                	jle    3ae <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 3e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3e6:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3ea:	c9                   	leave  
 3eb:	c3                   	ret    

000003ec <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 3ec:	55                   	push   %ebp
 3ed:	89 e5                	mov    %esp,%ebp
 3ef:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3f2:	8b 45 08             	mov    0x8(%ebp),%eax
 3f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3fe:	eb 17                	jmp    417 <memmove+0x2b>
    *dst++ = *src++;
 400:	8b 45 fc             	mov    -0x4(%ebp),%eax
 403:	8d 50 01             	lea    0x1(%eax),%edx
 406:	89 55 fc             	mov    %edx,-0x4(%ebp)
 409:	8b 55 f8             	mov    -0x8(%ebp),%edx
 40c:	8d 4a 01             	lea    0x1(%edx),%ecx
 40f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 412:	0f b6 12             	movzbl (%edx),%edx
 415:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 417:	8b 45 10             	mov    0x10(%ebp),%eax
 41a:	8d 50 ff             	lea    -0x1(%eax),%edx
 41d:	89 55 10             	mov    %edx,0x10(%ebp)
 420:	85 c0                	test   %eax,%eax
 422:	7f dc                	jg     400 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 424:	8b 45 08             	mov    0x8(%ebp),%eax
}
 427:	c9                   	leave  
 428:	c3                   	ret    

00000429 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 429:	b8 01 00 00 00       	mov    $0x1,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <exit>:
SYSCALL(exit)
 431:	b8 02 00 00 00       	mov    $0x2,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <wait>:
SYSCALL(wait)
 439:	b8 03 00 00 00       	mov    $0x3,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <pipe>:
SYSCALL(pipe)
 441:	b8 04 00 00 00       	mov    $0x4,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <read>:
SYSCALL(read)
 449:	b8 05 00 00 00       	mov    $0x5,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <write>:
SYSCALL(write)
 451:	b8 10 00 00 00       	mov    $0x10,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <close>:
SYSCALL(close)
 459:	b8 15 00 00 00       	mov    $0x15,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <kill>:
SYSCALL(kill)
 461:	b8 06 00 00 00       	mov    $0x6,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <exec>:
SYSCALL(exec)
 469:	b8 07 00 00 00       	mov    $0x7,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <open>:
SYSCALL(open)
 471:	b8 0f 00 00 00       	mov    $0xf,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <mknod>:
SYSCALL(mknod)
 479:	b8 11 00 00 00       	mov    $0x11,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <unlink>:
SYSCALL(unlink)
 481:	b8 12 00 00 00       	mov    $0x12,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <fstat>:
SYSCALL(fstat)
 489:	b8 08 00 00 00       	mov    $0x8,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <link>:
SYSCALL(link)
 491:	b8 13 00 00 00       	mov    $0x13,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <mkdir>:
SYSCALL(mkdir)
 499:	b8 14 00 00 00       	mov    $0x14,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <chdir>:
SYSCALL(chdir)
 4a1:	b8 09 00 00 00       	mov    $0x9,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <dup>:
SYSCALL(dup)
 4a9:	b8 0a 00 00 00       	mov    $0xa,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <getpid>:
SYSCALL(getpid)
 4b1:	b8 0b 00 00 00       	mov    $0xb,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <sbrk>:
SYSCALL(sbrk)
 4b9:	b8 0c 00 00 00       	mov    $0xc,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <sleep>:
SYSCALL(sleep)
 4c1:	b8 0d 00 00 00       	mov    $0xd,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <uptime>:
SYSCALL(uptime)
 4c9:	b8 0e 00 00 00       	mov    $0xe,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <halt>:
SYSCALL(halt)
 4d1:	b8 16 00 00 00       	mov    $0x16,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <date>:
SYSCALL(date)
 4d9:	b8 17 00 00 00       	mov    $0x17,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <getuid>:
SYSCALL(getuid)
 4e1:	b8 18 00 00 00       	mov    $0x18,%eax
 4e6:	cd 40                	int    $0x40
 4e8:	c3                   	ret    

000004e9 <getgid>:
SYSCALL(getgid)
 4e9:	b8 19 00 00 00       	mov    $0x19,%eax
 4ee:	cd 40                	int    $0x40
 4f0:	c3                   	ret    

000004f1 <getppid>:
SYSCALL(getppid)
 4f1:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4f6:	cd 40                	int    $0x40
 4f8:	c3                   	ret    

000004f9 <setuid>:
SYSCALL(setuid)
 4f9:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4fe:	cd 40                	int    $0x40
 500:	c3                   	ret    

00000501 <setgid>:
SYSCALL(setgid)
 501:	b8 1c 00 00 00       	mov    $0x1c,%eax
 506:	cd 40                	int    $0x40
 508:	c3                   	ret    

00000509 <getprocs>:
SYSCALL(getprocs)
 509:	b8 1d 00 00 00       	mov    $0x1d,%eax
 50e:	cd 40                	int    $0x40
 510:	c3                   	ret    

00000511 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 511:	55                   	push   %ebp
 512:	89 e5                	mov    %esp,%ebp
 514:	83 ec 18             	sub    $0x18,%esp
 517:	8b 45 0c             	mov    0xc(%ebp),%eax
 51a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 51d:	83 ec 04             	sub    $0x4,%esp
 520:	6a 01                	push   $0x1
 522:	8d 45 f4             	lea    -0xc(%ebp),%eax
 525:	50                   	push   %eax
 526:	ff 75 08             	pushl  0x8(%ebp)
 529:	e8 23 ff ff ff       	call   451 <write>
 52e:	83 c4 10             	add    $0x10,%esp
}
 531:	90                   	nop
 532:	c9                   	leave  
 533:	c3                   	ret    

00000534 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 534:	55                   	push   %ebp
 535:	89 e5                	mov    %esp,%ebp
 537:	53                   	push   %ebx
 538:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 53b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 542:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 546:	74 17                	je     55f <printint+0x2b>
 548:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 54c:	79 11                	jns    55f <printint+0x2b>
    neg = 1;
 54e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 555:	8b 45 0c             	mov    0xc(%ebp),%eax
 558:	f7 d8                	neg    %eax
 55a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 55d:	eb 06                	jmp    565 <printint+0x31>
  } else {
    x = xx;
 55f:	8b 45 0c             	mov    0xc(%ebp),%eax
 562:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 565:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 56c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 56f:	8d 41 01             	lea    0x1(%ecx),%eax
 572:	89 45 f4             	mov    %eax,-0xc(%ebp)
 575:	8b 5d 10             	mov    0x10(%ebp),%ebx
 578:	8b 45 ec             	mov    -0x14(%ebp),%eax
 57b:	ba 00 00 00 00       	mov    $0x0,%edx
 580:	f7 f3                	div    %ebx
 582:	89 d0                	mov    %edx,%eax
 584:	0f b6 80 20 0c 00 00 	movzbl 0xc20(%eax),%eax
 58b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 58f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 592:	8b 45 ec             	mov    -0x14(%ebp),%eax
 595:	ba 00 00 00 00       	mov    $0x0,%edx
 59a:	f7 f3                	div    %ebx
 59c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 59f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5a3:	75 c7                	jne    56c <printint+0x38>
  if(neg)
 5a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5a9:	74 2d                	je     5d8 <printint+0xa4>
    buf[i++] = '-';
 5ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ae:	8d 50 01             	lea    0x1(%eax),%edx
 5b1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5b4:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5b9:	eb 1d                	jmp    5d8 <printint+0xa4>
    putc(fd, buf[i]);
 5bb:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5c1:	01 d0                	add    %edx,%eax
 5c3:	0f b6 00             	movzbl (%eax),%eax
 5c6:	0f be c0             	movsbl %al,%eax
 5c9:	83 ec 08             	sub    $0x8,%esp
 5cc:	50                   	push   %eax
 5cd:	ff 75 08             	pushl  0x8(%ebp)
 5d0:	e8 3c ff ff ff       	call   511 <putc>
 5d5:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5d8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5e0:	79 d9                	jns    5bb <printint+0x87>
    putc(fd, buf[i]);
}
 5e2:	90                   	nop
 5e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5e6:	c9                   	leave  
 5e7:	c3                   	ret    

000005e8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5e8:	55                   	push   %ebp
 5e9:	89 e5                	mov    %esp,%ebp
 5eb:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5f5:	8d 45 0c             	lea    0xc(%ebp),%eax
 5f8:	83 c0 04             	add    $0x4,%eax
 5fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 605:	e9 59 01 00 00       	jmp    763 <printf+0x17b>
    c = fmt[i] & 0xff;
 60a:	8b 55 0c             	mov    0xc(%ebp),%edx
 60d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 610:	01 d0                	add    %edx,%eax
 612:	0f b6 00             	movzbl (%eax),%eax
 615:	0f be c0             	movsbl %al,%eax
 618:	25 ff 00 00 00       	and    $0xff,%eax
 61d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 620:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 624:	75 2c                	jne    652 <printf+0x6a>
      if(c == '%'){
 626:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 62a:	75 0c                	jne    638 <printf+0x50>
        state = '%';
 62c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 633:	e9 27 01 00 00       	jmp    75f <printf+0x177>
      } else {
        putc(fd, c);
 638:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 63b:	0f be c0             	movsbl %al,%eax
 63e:	83 ec 08             	sub    $0x8,%esp
 641:	50                   	push   %eax
 642:	ff 75 08             	pushl  0x8(%ebp)
 645:	e8 c7 fe ff ff       	call   511 <putc>
 64a:	83 c4 10             	add    $0x10,%esp
 64d:	e9 0d 01 00 00       	jmp    75f <printf+0x177>
      }
    } else if(state == '%'){
 652:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 656:	0f 85 03 01 00 00    	jne    75f <printf+0x177>
      if(c == 'd'){
 65c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 660:	75 1e                	jne    680 <printf+0x98>
        printint(fd, *ap, 10, 1);
 662:	8b 45 e8             	mov    -0x18(%ebp),%eax
 665:	8b 00                	mov    (%eax),%eax
 667:	6a 01                	push   $0x1
 669:	6a 0a                	push   $0xa
 66b:	50                   	push   %eax
 66c:	ff 75 08             	pushl  0x8(%ebp)
 66f:	e8 c0 fe ff ff       	call   534 <printint>
 674:	83 c4 10             	add    $0x10,%esp
        ap++;
 677:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 67b:	e9 d8 00 00 00       	jmp    758 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 680:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 684:	74 06                	je     68c <printf+0xa4>
 686:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 68a:	75 1e                	jne    6aa <printf+0xc2>
        printint(fd, *ap, 16, 0);
 68c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68f:	8b 00                	mov    (%eax),%eax
 691:	6a 00                	push   $0x0
 693:	6a 10                	push   $0x10
 695:	50                   	push   %eax
 696:	ff 75 08             	pushl  0x8(%ebp)
 699:	e8 96 fe ff ff       	call   534 <printint>
 69e:	83 c4 10             	add    $0x10,%esp
        ap++;
 6a1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a5:	e9 ae 00 00 00       	jmp    758 <printf+0x170>
      } else if(c == 's'){
 6aa:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6ae:	75 43                	jne    6f3 <printf+0x10b>
        s = (char*)*ap;
 6b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b3:	8b 00                	mov    (%eax),%eax
 6b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6c0:	75 25                	jne    6e7 <printf+0xff>
          s = "(null)";
 6c2:	c7 45 f4 b0 09 00 00 	movl   $0x9b0,-0xc(%ebp)
        while(*s != 0){
 6c9:	eb 1c                	jmp    6e7 <printf+0xff>
          putc(fd, *s);
 6cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ce:	0f b6 00             	movzbl (%eax),%eax
 6d1:	0f be c0             	movsbl %al,%eax
 6d4:	83 ec 08             	sub    $0x8,%esp
 6d7:	50                   	push   %eax
 6d8:	ff 75 08             	pushl  0x8(%ebp)
 6db:	e8 31 fe ff ff       	call   511 <putc>
 6e0:	83 c4 10             	add    $0x10,%esp
          s++;
 6e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ea:	0f b6 00             	movzbl (%eax),%eax
 6ed:	84 c0                	test   %al,%al
 6ef:	75 da                	jne    6cb <printf+0xe3>
 6f1:	eb 65                	jmp    758 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6f3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6f7:	75 1d                	jne    716 <printf+0x12e>
        putc(fd, *ap);
 6f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6fc:	8b 00                	mov    (%eax),%eax
 6fe:	0f be c0             	movsbl %al,%eax
 701:	83 ec 08             	sub    $0x8,%esp
 704:	50                   	push   %eax
 705:	ff 75 08             	pushl  0x8(%ebp)
 708:	e8 04 fe ff ff       	call   511 <putc>
 70d:	83 c4 10             	add    $0x10,%esp
        ap++;
 710:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 714:	eb 42                	jmp    758 <printf+0x170>
      } else if(c == '%'){
 716:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 71a:	75 17                	jne    733 <printf+0x14b>
        putc(fd, c);
 71c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 71f:	0f be c0             	movsbl %al,%eax
 722:	83 ec 08             	sub    $0x8,%esp
 725:	50                   	push   %eax
 726:	ff 75 08             	pushl  0x8(%ebp)
 729:	e8 e3 fd ff ff       	call   511 <putc>
 72e:	83 c4 10             	add    $0x10,%esp
 731:	eb 25                	jmp    758 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 733:	83 ec 08             	sub    $0x8,%esp
 736:	6a 25                	push   $0x25
 738:	ff 75 08             	pushl  0x8(%ebp)
 73b:	e8 d1 fd ff ff       	call   511 <putc>
 740:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 743:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 746:	0f be c0             	movsbl %al,%eax
 749:	83 ec 08             	sub    $0x8,%esp
 74c:	50                   	push   %eax
 74d:	ff 75 08             	pushl  0x8(%ebp)
 750:	e8 bc fd ff ff       	call   511 <putc>
 755:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 758:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 75f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 763:	8b 55 0c             	mov    0xc(%ebp),%edx
 766:	8b 45 f0             	mov    -0x10(%ebp),%eax
 769:	01 d0                	add    %edx,%eax
 76b:	0f b6 00             	movzbl (%eax),%eax
 76e:	84 c0                	test   %al,%al
 770:	0f 85 94 fe ff ff    	jne    60a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 776:	90                   	nop
 777:	c9                   	leave  
 778:	c3                   	ret    

00000779 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 779:	55                   	push   %ebp
 77a:	89 e5                	mov    %esp,%ebp
 77c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 77f:	8b 45 08             	mov    0x8(%ebp),%eax
 782:	83 e8 08             	sub    $0x8,%eax
 785:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 788:	a1 3c 0c 00 00       	mov    0xc3c,%eax
 78d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 790:	eb 24                	jmp    7b6 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 792:	8b 45 fc             	mov    -0x4(%ebp),%eax
 795:	8b 00                	mov    (%eax),%eax
 797:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 79a:	77 12                	ja     7ae <free+0x35>
 79c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a2:	77 24                	ja     7c8 <free+0x4f>
 7a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a7:	8b 00                	mov    (%eax),%eax
 7a9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7ac:	77 1a                	ja     7c8 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b1:	8b 00                	mov    (%eax),%eax
 7b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7bc:	76 d4                	jbe    792 <free+0x19>
 7be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c1:	8b 00                	mov    (%eax),%eax
 7c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7c6:	76 ca                	jbe    792 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cb:	8b 40 04             	mov    0x4(%eax),%eax
 7ce:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d8:	01 c2                	add    %eax,%edx
 7da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dd:	8b 00                	mov    (%eax),%eax
 7df:	39 c2                	cmp    %eax,%edx
 7e1:	75 24                	jne    807 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e6:	8b 50 04             	mov    0x4(%eax),%edx
 7e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ec:	8b 00                	mov    (%eax),%eax
 7ee:	8b 40 04             	mov    0x4(%eax),%eax
 7f1:	01 c2                	add    %eax,%edx
 7f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fc:	8b 00                	mov    (%eax),%eax
 7fe:	8b 10                	mov    (%eax),%edx
 800:	8b 45 f8             	mov    -0x8(%ebp),%eax
 803:	89 10                	mov    %edx,(%eax)
 805:	eb 0a                	jmp    811 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 807:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80a:	8b 10                	mov    (%eax),%edx
 80c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 811:	8b 45 fc             	mov    -0x4(%ebp),%eax
 814:	8b 40 04             	mov    0x4(%eax),%eax
 817:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 81e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 821:	01 d0                	add    %edx,%eax
 823:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 826:	75 20                	jne    848 <free+0xcf>
    p->s.size += bp->s.size;
 828:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82b:	8b 50 04             	mov    0x4(%eax),%edx
 82e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 831:	8b 40 04             	mov    0x4(%eax),%eax
 834:	01 c2                	add    %eax,%edx
 836:	8b 45 fc             	mov    -0x4(%ebp),%eax
 839:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 83c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83f:	8b 10                	mov    (%eax),%edx
 841:	8b 45 fc             	mov    -0x4(%ebp),%eax
 844:	89 10                	mov    %edx,(%eax)
 846:	eb 08                	jmp    850 <free+0xd7>
  } else
    p->s.ptr = bp;
 848:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 84e:	89 10                	mov    %edx,(%eax)
  freep = p;
 850:	8b 45 fc             	mov    -0x4(%ebp),%eax
 853:	a3 3c 0c 00 00       	mov    %eax,0xc3c
}
 858:	90                   	nop
 859:	c9                   	leave  
 85a:	c3                   	ret    

0000085b <morecore>:

static Header*
morecore(uint nu)
{
 85b:	55                   	push   %ebp
 85c:	89 e5                	mov    %esp,%ebp
 85e:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 861:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 868:	77 07                	ja     871 <morecore+0x16>
    nu = 4096;
 86a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 871:	8b 45 08             	mov    0x8(%ebp),%eax
 874:	c1 e0 03             	shl    $0x3,%eax
 877:	83 ec 0c             	sub    $0xc,%esp
 87a:	50                   	push   %eax
 87b:	e8 39 fc ff ff       	call   4b9 <sbrk>
 880:	83 c4 10             	add    $0x10,%esp
 883:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 886:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 88a:	75 07                	jne    893 <morecore+0x38>
    return 0;
 88c:	b8 00 00 00 00       	mov    $0x0,%eax
 891:	eb 26                	jmp    8b9 <morecore+0x5e>
  hp = (Header*)p;
 893:	8b 45 f4             	mov    -0xc(%ebp),%eax
 896:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 899:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89c:	8b 55 08             	mov    0x8(%ebp),%edx
 89f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a5:	83 c0 08             	add    $0x8,%eax
 8a8:	83 ec 0c             	sub    $0xc,%esp
 8ab:	50                   	push   %eax
 8ac:	e8 c8 fe ff ff       	call   779 <free>
 8b1:	83 c4 10             	add    $0x10,%esp
  return freep;
 8b4:	a1 3c 0c 00 00       	mov    0xc3c,%eax
}
 8b9:	c9                   	leave  
 8ba:	c3                   	ret    

000008bb <malloc>:

void*
malloc(uint nbytes)
{
 8bb:	55                   	push   %ebp
 8bc:	89 e5                	mov    %esp,%ebp
 8be:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c1:	8b 45 08             	mov    0x8(%ebp),%eax
 8c4:	83 c0 07             	add    $0x7,%eax
 8c7:	c1 e8 03             	shr    $0x3,%eax
 8ca:	83 c0 01             	add    $0x1,%eax
 8cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8d0:	a1 3c 0c 00 00       	mov    0xc3c,%eax
 8d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8dc:	75 23                	jne    901 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8de:	c7 45 f0 34 0c 00 00 	movl   $0xc34,-0x10(%ebp)
 8e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e8:	a3 3c 0c 00 00       	mov    %eax,0xc3c
 8ed:	a1 3c 0c 00 00       	mov    0xc3c,%eax
 8f2:	a3 34 0c 00 00       	mov    %eax,0xc34
    base.s.size = 0;
 8f7:	c7 05 38 0c 00 00 00 	movl   $0x0,0xc38
 8fe:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 901:	8b 45 f0             	mov    -0x10(%ebp),%eax
 904:	8b 00                	mov    (%eax),%eax
 906:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 909:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90c:	8b 40 04             	mov    0x4(%eax),%eax
 90f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 912:	72 4d                	jb     961 <malloc+0xa6>
      if(p->s.size == nunits)
 914:	8b 45 f4             	mov    -0xc(%ebp),%eax
 917:	8b 40 04             	mov    0x4(%eax),%eax
 91a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 91d:	75 0c                	jne    92b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 91f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 922:	8b 10                	mov    (%eax),%edx
 924:	8b 45 f0             	mov    -0x10(%ebp),%eax
 927:	89 10                	mov    %edx,(%eax)
 929:	eb 26                	jmp    951 <malloc+0x96>
      else {
        p->s.size -= nunits;
 92b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92e:	8b 40 04             	mov    0x4(%eax),%eax
 931:	2b 45 ec             	sub    -0x14(%ebp),%eax
 934:	89 c2                	mov    %eax,%edx
 936:	8b 45 f4             	mov    -0xc(%ebp),%eax
 939:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 93c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93f:	8b 40 04             	mov    0x4(%eax),%eax
 942:	c1 e0 03             	shl    $0x3,%eax
 945:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 948:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 94e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 951:	8b 45 f0             	mov    -0x10(%ebp),%eax
 954:	a3 3c 0c 00 00       	mov    %eax,0xc3c
      return (void*)(p + 1);
 959:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95c:	83 c0 08             	add    $0x8,%eax
 95f:	eb 3b                	jmp    99c <malloc+0xe1>
    }
    if(p == freep)
 961:	a1 3c 0c 00 00       	mov    0xc3c,%eax
 966:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 969:	75 1e                	jne    989 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 96b:	83 ec 0c             	sub    $0xc,%esp
 96e:	ff 75 ec             	pushl  -0x14(%ebp)
 971:	e8 e5 fe ff ff       	call   85b <morecore>
 976:	83 c4 10             	add    $0x10,%esp
 979:	89 45 f4             	mov    %eax,-0xc(%ebp)
 97c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 980:	75 07                	jne    989 <malloc+0xce>
        return 0;
 982:	b8 00 00 00 00       	mov    $0x0,%eax
 987:	eb 13                	jmp    99c <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 989:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 98f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 992:	8b 00                	mov    (%eax),%eax
 994:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 997:	e9 6d ff ff ff       	jmp    909 <malloc+0x4e>
}
 99c:	c9                   	leave  
 99d:	c3                   	ret    
