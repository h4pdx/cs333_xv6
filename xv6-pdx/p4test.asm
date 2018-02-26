
_p4test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#ifdef CS333_P3P4
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
   e:	83 ec 24             	sub    $0x24,%esp

// fork a bunch of infinite loops
    int pid[5];
    int ppid = getpid();
  11:	e8 9d 04 00 00       	call   4b3 <getpid>
  16:	89 45 ec             	mov    %eax,-0x14(%ebp)
    int i = 0;
  19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    //int rc;
    while (i < 100) {
  20:	eb 52                	jmp    74 <main+0x74>
        pid[i] = fork();
  22:	e8 04 04 00 00       	call   42b <fork>
  27:	89 c2                	mov    %eax,%edx
  29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2c:	89 54 85 d8          	mov    %edx,-0x28(%ebp,%eax,4)
        setpriority(pid[i], 2);
  30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  33:	8b 44 85 d8          	mov    -0x28(%ebp,%eax,4),%eax
  37:	83 ec 08             	sub    $0x8,%esp
  3a:	6a 02                	push   $0x2
  3c:	50                   	push   %eax
  3d:	e8 d1 04 00 00       	call   513 <setpriority>
  42:	83 c4 10             	add    $0x10,%esp
        if (ppid != getpid()) {
  45:	e8 69 04 00 00       	call   4b3 <getpid>
  4a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  4d:	74 15                	je     64 <main+0x64>
            //for(int x = 0; x < 100000000000; x++); // cycle runnable and ready
            sleep(10000); // put to sleep
  4f:	83 ec 0c             	sub    $0xc,%esp
  52:	68 10 27 00 00       	push   $0x2710
  57:	e8 67 04 00 00       	call   4c3 <sleep>
  5c:	83 c4 10             	add    $0x10,%esp
                else {
                    printf(1, "Prio not set.\n");
                }
            }
            */
            exit();
  5f:	e8 cf 03 00 00       	call   433 <exit>
        }
        if (pid[i] == -1) {
  64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  67:	8b 44 85 d8          	mov    -0x28(%ebp,%eax,4),%eax
  6b:	83 f8 ff             	cmp    $0xffffffff,%eax
  6e:	74 0c                	je     7c <main+0x7c>
            break;
        }
        i++;
  70:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
// fork a bunch of infinite loops
    int pid[5];
    int ppid = getpid();
    int i = 0;
    //int rc;
    while (i < 100) {
  74:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  78:	7e a8                	jle    22 <main+0x22>
  7a:	eb 01                	jmp    7d <main+0x7d>
            }
            */
            exit();
        }
        if (pid[i] == -1) {
            break;
  7c:	90                   	nop
        }
        i++;
    }

    if (ppid == getpid()) {
  7d:	e8 31 04 00 00       	call   4b3 <getpid>
  82:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  85:	75 7d                	jne    104 <main+0x104>
            if (!rc) {
                sleep(2500);
            }
        }
        */
        printf(1, "Killed.\n");
  87:	83 ec 08             	sub    $0x8,%esp
  8a:	68 a8 09 00 00       	push   $0x9a8
  8f:	6a 01                	push   $0x1
  91:	e8 5c 05 00 00       	call   5f2 <printf>
  96:	83 c4 10             	add    $0x10,%esp
        sleep(10000);
  99:	83 ec 0c             	sub    $0xc,%esp
  9c:	68 10 27 00 00       	push   $0x2710
  a1:	e8 1d 04 00 00       	call   4c3 <sleep>
  a6:	83 c4 10             	add    $0x10,%esp
        int j = 0;
  a9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
        while (j < 64) {
  b0:	eb 4c                	jmp    fe <main+0xfe>
            kill(pid[j]);
  b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  b5:	8b 44 85 d8          	mov    -0x28(%ebp,%eax,4),%eax
  b9:	83 ec 0c             	sub    $0xc,%esp
  bc:	50                   	push   %eax
  bd:	e8 a1 03 00 00       	call   463 <kill>
  c2:	83 c4 10             	add    $0x10,%esp
            sleep(2000);
  c5:	83 ec 0c             	sub    $0xc,%esp
  c8:	68 d0 07 00 00       	push   $0x7d0
  cd:	e8 f1 03 00 00       	call   4c3 <sleep>
  d2:	83 c4 10             	add    $0x10,%esp
            while (wait() == -1) {}
  d5:	90                   	nop
  d6:	e8 60 03 00 00       	call   43b <wait>
  db:	83 f8 ff             	cmp    $0xffffffff,%eax
  de:	74 f6                	je     d6 <main+0xd6>
            printf(1, "Reaped %d.\n", pid[j]);
  e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  e3:	8b 44 85 d8          	mov    -0x28(%ebp,%eax,4),%eax
  e7:	83 ec 04             	sub    $0x4,%esp
  ea:	50                   	push   %eax
  eb:	68 b1 09 00 00       	push   $0x9b1
  f0:	6a 01                	push   $0x1
  f2:	e8 fb 04 00 00       	call   5f2 <printf>
  f7:	83 c4 10             	add    $0x10,%esp
            j++;
  fa:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
        }
        */
        printf(1, "Killed.\n");
        sleep(10000);
        int j = 0;
        while (j < 64) {
  fe:	83 7d f0 3f          	cmpl   $0x3f,-0x10(%ebp)
 102:	7e ae                	jle    b2 <main+0xb2>
            while (wait() == -1) {}
            printf(1, "Reaped %d.\n", pid[j]);
            j++;
        }
    }
    exit();
 104:	e8 2a 03 00 00       	call   433 <exit>

00000109 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	57                   	push   %edi
 10d:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 10e:	8b 4d 08             	mov    0x8(%ebp),%ecx
 111:	8b 55 10             	mov    0x10(%ebp),%edx
 114:	8b 45 0c             	mov    0xc(%ebp),%eax
 117:	89 cb                	mov    %ecx,%ebx
 119:	89 df                	mov    %ebx,%edi
 11b:	89 d1                	mov    %edx,%ecx
 11d:	fc                   	cld    
 11e:	f3 aa                	rep stos %al,%es:(%edi)
 120:	89 ca                	mov    %ecx,%edx
 122:	89 fb                	mov    %edi,%ebx
 124:	89 5d 08             	mov    %ebx,0x8(%ebp)
 127:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 12a:	90                   	nop
 12b:	5b                   	pop    %ebx
 12c:	5f                   	pop    %edi
 12d:	5d                   	pop    %ebp
 12e:	c3                   	ret    

0000012f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 12f:	55                   	push   %ebp
 130:	89 e5                	mov    %esp,%ebp
 132:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 135:	8b 45 08             	mov    0x8(%ebp),%eax
 138:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 13b:	90                   	nop
 13c:	8b 45 08             	mov    0x8(%ebp),%eax
 13f:	8d 50 01             	lea    0x1(%eax),%edx
 142:	89 55 08             	mov    %edx,0x8(%ebp)
 145:	8b 55 0c             	mov    0xc(%ebp),%edx
 148:	8d 4a 01             	lea    0x1(%edx),%ecx
 14b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 14e:	0f b6 12             	movzbl (%edx),%edx
 151:	88 10                	mov    %dl,(%eax)
 153:	0f b6 00             	movzbl (%eax),%eax
 156:	84 c0                	test   %al,%al
 158:	75 e2                	jne    13c <strcpy+0xd>
    ;
  return os;
 15a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 15d:	c9                   	leave  
 15e:	c3                   	ret    

0000015f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 15f:	55                   	push   %ebp
 160:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 162:	eb 08                	jmp    16c <strcmp+0xd>
    p++, q++;
 164:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 168:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	84 c0                	test   %al,%al
 174:	74 10                	je     186 <strcmp+0x27>
 176:	8b 45 08             	mov    0x8(%ebp),%eax
 179:	0f b6 10             	movzbl (%eax),%edx
 17c:	8b 45 0c             	mov    0xc(%ebp),%eax
 17f:	0f b6 00             	movzbl (%eax),%eax
 182:	38 c2                	cmp    %al,%dl
 184:	74 de                	je     164 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 186:	8b 45 08             	mov    0x8(%ebp),%eax
 189:	0f b6 00             	movzbl (%eax),%eax
 18c:	0f b6 d0             	movzbl %al,%edx
 18f:	8b 45 0c             	mov    0xc(%ebp),%eax
 192:	0f b6 00             	movzbl (%eax),%eax
 195:	0f b6 c0             	movzbl %al,%eax
 198:	29 c2                	sub    %eax,%edx
 19a:	89 d0                	mov    %edx,%eax
}
 19c:	5d                   	pop    %ebp
 19d:	c3                   	ret    

0000019e <strlen>:

uint
strlen(char *s)
{
 19e:	55                   	push   %ebp
 19f:	89 e5                	mov    %esp,%ebp
 1a1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1ab:	eb 04                	jmp    1b1 <strlen+0x13>
 1ad:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
 1b7:	01 d0                	add    %edx,%eax
 1b9:	0f b6 00             	movzbl (%eax),%eax
 1bc:	84 c0                	test   %al,%al
 1be:	75 ed                	jne    1ad <strlen+0xf>
    ;
  return n;
 1c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c3:	c9                   	leave  
 1c4:	c3                   	ret    

000001c5 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1c5:	55                   	push   %ebp
 1c6:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1c8:	8b 45 10             	mov    0x10(%ebp),%eax
 1cb:	50                   	push   %eax
 1cc:	ff 75 0c             	pushl  0xc(%ebp)
 1cf:	ff 75 08             	pushl  0x8(%ebp)
 1d2:	e8 32 ff ff ff       	call   109 <stosb>
 1d7:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1da:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1dd:	c9                   	leave  
 1de:	c3                   	ret    

000001df <strchr>:

char*
strchr(const char *s, char c)
{
 1df:	55                   	push   %ebp
 1e0:	89 e5                	mov    %esp,%ebp
 1e2:	83 ec 04             	sub    $0x4,%esp
 1e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e8:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1eb:	eb 14                	jmp    201 <strchr+0x22>
    if(*s == c)
 1ed:	8b 45 08             	mov    0x8(%ebp),%eax
 1f0:	0f b6 00             	movzbl (%eax),%eax
 1f3:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1f6:	75 05                	jne    1fd <strchr+0x1e>
      return (char*)s;
 1f8:	8b 45 08             	mov    0x8(%ebp),%eax
 1fb:	eb 13                	jmp    210 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1fd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 201:	8b 45 08             	mov    0x8(%ebp),%eax
 204:	0f b6 00             	movzbl (%eax),%eax
 207:	84 c0                	test   %al,%al
 209:	75 e2                	jne    1ed <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 20b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 210:	c9                   	leave  
 211:	c3                   	ret    

00000212 <gets>:

char*
gets(char *buf, int max)
{
 212:	55                   	push   %ebp
 213:	89 e5                	mov    %esp,%ebp
 215:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 218:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 21f:	eb 42                	jmp    263 <gets+0x51>
    cc = read(0, &c, 1);
 221:	83 ec 04             	sub    $0x4,%esp
 224:	6a 01                	push   $0x1
 226:	8d 45 ef             	lea    -0x11(%ebp),%eax
 229:	50                   	push   %eax
 22a:	6a 00                	push   $0x0
 22c:	e8 1a 02 00 00       	call   44b <read>
 231:	83 c4 10             	add    $0x10,%esp
 234:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 237:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 23b:	7e 33                	jle    270 <gets+0x5e>
      break;
    buf[i++] = c;
 23d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 240:	8d 50 01             	lea    0x1(%eax),%edx
 243:	89 55 f4             	mov    %edx,-0xc(%ebp)
 246:	89 c2                	mov    %eax,%edx
 248:	8b 45 08             	mov    0x8(%ebp),%eax
 24b:	01 c2                	add    %eax,%edx
 24d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 251:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 253:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 257:	3c 0a                	cmp    $0xa,%al
 259:	74 16                	je     271 <gets+0x5f>
 25b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 25f:	3c 0d                	cmp    $0xd,%al
 261:	74 0e                	je     271 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 263:	8b 45 f4             	mov    -0xc(%ebp),%eax
 266:	83 c0 01             	add    $0x1,%eax
 269:	3b 45 0c             	cmp    0xc(%ebp),%eax
 26c:	7c b3                	jl     221 <gets+0xf>
 26e:	eb 01                	jmp    271 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 270:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 271:	8b 55 f4             	mov    -0xc(%ebp),%edx
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	01 d0                	add    %edx,%eax
 279:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 27f:	c9                   	leave  
 280:	c3                   	ret    

00000281 <stat>:

int
stat(char *n, struct stat *st)
{
 281:	55                   	push   %ebp
 282:	89 e5                	mov    %esp,%ebp
 284:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 287:	83 ec 08             	sub    $0x8,%esp
 28a:	6a 00                	push   $0x0
 28c:	ff 75 08             	pushl  0x8(%ebp)
 28f:	e8 df 01 00 00       	call   473 <open>
 294:	83 c4 10             	add    $0x10,%esp
 297:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 29a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 29e:	79 07                	jns    2a7 <stat+0x26>
    return -1;
 2a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2a5:	eb 25                	jmp    2cc <stat+0x4b>
  r = fstat(fd, st);
 2a7:	83 ec 08             	sub    $0x8,%esp
 2aa:	ff 75 0c             	pushl  0xc(%ebp)
 2ad:	ff 75 f4             	pushl  -0xc(%ebp)
 2b0:	e8 d6 01 00 00       	call   48b <fstat>
 2b5:	83 c4 10             	add    $0x10,%esp
 2b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2bb:	83 ec 0c             	sub    $0xc,%esp
 2be:	ff 75 f4             	pushl  -0xc(%ebp)
 2c1:	e8 95 01 00 00       	call   45b <close>
 2c6:	83 c4 10             	add    $0x10,%esp
  return r;
 2c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2cc:	c9                   	leave  
 2cd:	c3                   	ret    

000002ce <atoi>:

int
atoi(const char *s)
{
 2ce:	55                   	push   %ebp
 2cf:	89 e5                	mov    %esp,%ebp
 2d1:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2db:	eb 04                	jmp    2e1 <atoi+0x13>
 2dd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2e1:	8b 45 08             	mov    0x8(%ebp),%eax
 2e4:	0f b6 00             	movzbl (%eax),%eax
 2e7:	3c 20                	cmp    $0x20,%al
 2e9:	74 f2                	je     2dd <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 2eb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ee:	0f b6 00             	movzbl (%eax),%eax
 2f1:	3c 2d                	cmp    $0x2d,%al
 2f3:	75 07                	jne    2fc <atoi+0x2e>
 2f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2fa:	eb 05                	jmp    301 <atoi+0x33>
 2fc:	b8 01 00 00 00       	mov    $0x1,%eax
 301:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	0f b6 00             	movzbl (%eax),%eax
 30a:	3c 2b                	cmp    $0x2b,%al
 30c:	74 0a                	je     318 <atoi+0x4a>
 30e:	8b 45 08             	mov    0x8(%ebp),%eax
 311:	0f b6 00             	movzbl (%eax),%eax
 314:	3c 2d                	cmp    $0x2d,%al
 316:	75 2b                	jne    343 <atoi+0x75>
    s++;
 318:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 31c:	eb 25                	jmp    343 <atoi+0x75>
    n = n*10 + *s++ - '0';
 31e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 321:	89 d0                	mov    %edx,%eax
 323:	c1 e0 02             	shl    $0x2,%eax
 326:	01 d0                	add    %edx,%eax
 328:	01 c0                	add    %eax,%eax
 32a:	89 c1                	mov    %eax,%ecx
 32c:	8b 45 08             	mov    0x8(%ebp),%eax
 32f:	8d 50 01             	lea    0x1(%eax),%edx
 332:	89 55 08             	mov    %edx,0x8(%ebp)
 335:	0f b6 00             	movzbl (%eax),%eax
 338:	0f be c0             	movsbl %al,%eax
 33b:	01 c8                	add    %ecx,%eax
 33d:	83 e8 30             	sub    $0x30,%eax
 340:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 343:	8b 45 08             	mov    0x8(%ebp),%eax
 346:	0f b6 00             	movzbl (%eax),%eax
 349:	3c 2f                	cmp    $0x2f,%al
 34b:	7e 0a                	jle    357 <atoi+0x89>
 34d:	8b 45 08             	mov    0x8(%ebp),%eax
 350:	0f b6 00             	movzbl (%eax),%eax
 353:	3c 39                	cmp    $0x39,%al
 355:	7e c7                	jle    31e <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 357:	8b 45 f8             	mov    -0x8(%ebp),%eax
 35a:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 35e:	c9                   	leave  
 35f:	c3                   	ret    

00000360 <atoo>:

int
atoo(const char *s)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 366:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 36d:	eb 04                	jmp    373 <atoo+0x13>
 36f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	0f b6 00             	movzbl (%eax),%eax
 379:	3c 20                	cmp    $0x20,%al
 37b:	74 f2                	je     36f <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 37d:	8b 45 08             	mov    0x8(%ebp),%eax
 380:	0f b6 00             	movzbl (%eax),%eax
 383:	3c 2d                	cmp    $0x2d,%al
 385:	75 07                	jne    38e <atoo+0x2e>
 387:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 38c:	eb 05                	jmp    393 <atoo+0x33>
 38e:	b8 01 00 00 00       	mov    $0x1,%eax
 393:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 396:	8b 45 08             	mov    0x8(%ebp),%eax
 399:	0f b6 00             	movzbl (%eax),%eax
 39c:	3c 2b                	cmp    $0x2b,%al
 39e:	74 0a                	je     3aa <atoo+0x4a>
 3a0:	8b 45 08             	mov    0x8(%ebp),%eax
 3a3:	0f b6 00             	movzbl (%eax),%eax
 3a6:	3c 2d                	cmp    $0x2d,%al
 3a8:	75 27                	jne    3d1 <atoo+0x71>
    s++;
 3aa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 3ae:	eb 21                	jmp    3d1 <atoo+0x71>
    n = n*8 + *s++ - '0';
 3b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3b3:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 3ba:	8b 45 08             	mov    0x8(%ebp),%eax
 3bd:	8d 50 01             	lea    0x1(%eax),%edx
 3c0:	89 55 08             	mov    %edx,0x8(%ebp)
 3c3:	0f b6 00             	movzbl (%eax),%eax
 3c6:	0f be c0             	movsbl %al,%eax
 3c9:	01 c8                	add    %ecx,%eax
 3cb:	83 e8 30             	sub    $0x30,%eax
 3ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 3d1:	8b 45 08             	mov    0x8(%ebp),%eax
 3d4:	0f b6 00             	movzbl (%eax),%eax
 3d7:	3c 2f                	cmp    $0x2f,%al
 3d9:	7e 0a                	jle    3e5 <atoo+0x85>
 3db:	8b 45 08             	mov    0x8(%ebp),%eax
 3de:	0f b6 00             	movzbl (%eax),%eax
 3e1:	3c 37                	cmp    $0x37,%al
 3e3:	7e cb                	jle    3b0 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 3e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3e8:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3ec:	c9                   	leave  
 3ed:	c3                   	ret    

000003ee <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 3ee:	55                   	push   %ebp
 3ef:	89 e5                	mov    %esp,%ebp
 3f1:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3f4:	8b 45 08             	mov    0x8(%ebp),%eax
 3f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 400:	eb 17                	jmp    419 <memmove+0x2b>
    *dst++ = *src++;
 402:	8b 45 fc             	mov    -0x4(%ebp),%eax
 405:	8d 50 01             	lea    0x1(%eax),%edx
 408:	89 55 fc             	mov    %edx,-0x4(%ebp)
 40b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 40e:	8d 4a 01             	lea    0x1(%edx),%ecx
 411:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 414:	0f b6 12             	movzbl (%edx),%edx
 417:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 419:	8b 45 10             	mov    0x10(%ebp),%eax
 41c:	8d 50 ff             	lea    -0x1(%eax),%edx
 41f:	89 55 10             	mov    %edx,0x10(%ebp)
 422:	85 c0                	test   %eax,%eax
 424:	7f dc                	jg     402 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 426:	8b 45 08             	mov    0x8(%ebp),%eax
}
 429:	c9                   	leave  
 42a:	c3                   	ret    

0000042b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 42b:	b8 01 00 00 00       	mov    $0x1,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <exit>:
SYSCALL(exit)
 433:	b8 02 00 00 00       	mov    $0x2,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <wait>:
SYSCALL(wait)
 43b:	b8 03 00 00 00       	mov    $0x3,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <pipe>:
SYSCALL(pipe)
 443:	b8 04 00 00 00       	mov    $0x4,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <read>:
SYSCALL(read)
 44b:	b8 05 00 00 00       	mov    $0x5,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <write>:
SYSCALL(write)
 453:	b8 10 00 00 00       	mov    $0x10,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <close>:
SYSCALL(close)
 45b:	b8 15 00 00 00       	mov    $0x15,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <kill>:
SYSCALL(kill)
 463:	b8 06 00 00 00       	mov    $0x6,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <exec>:
SYSCALL(exec)
 46b:	b8 07 00 00 00       	mov    $0x7,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <open>:
SYSCALL(open)
 473:	b8 0f 00 00 00       	mov    $0xf,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <mknod>:
SYSCALL(mknod)
 47b:	b8 11 00 00 00       	mov    $0x11,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <unlink>:
SYSCALL(unlink)
 483:	b8 12 00 00 00       	mov    $0x12,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <fstat>:
SYSCALL(fstat)
 48b:	b8 08 00 00 00       	mov    $0x8,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <link>:
SYSCALL(link)
 493:	b8 13 00 00 00       	mov    $0x13,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <mkdir>:
SYSCALL(mkdir)
 49b:	b8 14 00 00 00       	mov    $0x14,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <chdir>:
SYSCALL(chdir)
 4a3:	b8 09 00 00 00       	mov    $0x9,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <dup>:
SYSCALL(dup)
 4ab:	b8 0a 00 00 00       	mov    $0xa,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <getpid>:
SYSCALL(getpid)
 4b3:	b8 0b 00 00 00       	mov    $0xb,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <sbrk>:
SYSCALL(sbrk)
 4bb:	b8 0c 00 00 00       	mov    $0xc,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <sleep>:
SYSCALL(sleep)
 4c3:	b8 0d 00 00 00       	mov    $0xd,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <uptime>:
SYSCALL(uptime)
 4cb:	b8 0e 00 00 00       	mov    $0xe,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <halt>:
SYSCALL(halt)
 4d3:	b8 16 00 00 00       	mov    $0x16,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <date>:
SYSCALL(date)
 4db:	b8 17 00 00 00       	mov    $0x17,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <getuid>:
SYSCALL(getuid)
 4e3:	b8 18 00 00 00       	mov    $0x18,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <getgid>:
SYSCALL(getgid)
 4eb:	b8 19 00 00 00       	mov    $0x19,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <getppid>:
SYSCALL(getppid)
 4f3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <setuid>:
SYSCALL(setuid)
 4fb:	b8 1b 00 00 00       	mov    $0x1b,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <setgid>:
SYSCALL(setgid)
 503:	b8 1c 00 00 00       	mov    $0x1c,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <getprocs>:
SYSCALL(getprocs)
 50b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <setpriority>:
SYSCALL(setpriority)
 513:	b8 1e 00 00 00       	mov    $0x1e,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 51b:	55                   	push   %ebp
 51c:	89 e5                	mov    %esp,%ebp
 51e:	83 ec 18             	sub    $0x18,%esp
 521:	8b 45 0c             	mov    0xc(%ebp),%eax
 524:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 527:	83 ec 04             	sub    $0x4,%esp
 52a:	6a 01                	push   $0x1
 52c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 52f:	50                   	push   %eax
 530:	ff 75 08             	pushl  0x8(%ebp)
 533:	e8 1b ff ff ff       	call   453 <write>
 538:	83 c4 10             	add    $0x10,%esp
}
 53b:	90                   	nop
 53c:	c9                   	leave  
 53d:	c3                   	ret    

0000053e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 53e:	55                   	push   %ebp
 53f:	89 e5                	mov    %esp,%ebp
 541:	53                   	push   %ebx
 542:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 545:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 54c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 550:	74 17                	je     569 <printint+0x2b>
 552:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 556:	79 11                	jns    569 <printint+0x2b>
    neg = 1;
 558:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 55f:	8b 45 0c             	mov    0xc(%ebp),%eax
 562:	f7 d8                	neg    %eax
 564:	89 45 ec             	mov    %eax,-0x14(%ebp)
 567:	eb 06                	jmp    56f <printint+0x31>
  } else {
    x = xx;
 569:	8b 45 0c             	mov    0xc(%ebp),%eax
 56c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 56f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 576:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 579:	8d 41 01             	lea    0x1(%ecx),%eax
 57c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 57f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 582:	8b 45 ec             	mov    -0x14(%ebp),%eax
 585:	ba 00 00 00 00       	mov    $0x0,%edx
 58a:	f7 f3                	div    %ebx
 58c:	89 d0                	mov    %edx,%eax
 58e:	0f b6 80 2c 0c 00 00 	movzbl 0xc2c(%eax),%eax
 595:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 599:	8b 5d 10             	mov    0x10(%ebp),%ebx
 59c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 59f:	ba 00 00 00 00       	mov    $0x0,%edx
 5a4:	f7 f3                	div    %ebx
 5a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5a9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5ad:	75 c7                	jne    576 <printint+0x38>
  if(neg)
 5af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5b3:	74 2d                	je     5e2 <printint+0xa4>
    buf[i++] = '-';
 5b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b8:	8d 50 01             	lea    0x1(%eax),%edx
 5bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5be:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5c3:	eb 1d                	jmp    5e2 <printint+0xa4>
    putc(fd, buf[i]);
 5c5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5cb:	01 d0                	add    %edx,%eax
 5cd:	0f b6 00             	movzbl (%eax),%eax
 5d0:	0f be c0             	movsbl %al,%eax
 5d3:	83 ec 08             	sub    $0x8,%esp
 5d6:	50                   	push   %eax
 5d7:	ff 75 08             	pushl  0x8(%ebp)
 5da:	e8 3c ff ff ff       	call   51b <putc>
 5df:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5e2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5ea:	79 d9                	jns    5c5 <printint+0x87>
    putc(fd, buf[i]);
}
 5ec:	90                   	nop
 5ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5f0:	c9                   	leave  
 5f1:	c3                   	ret    

000005f2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5f2:	55                   	push   %ebp
 5f3:	89 e5                	mov    %esp,%ebp
 5f5:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5f8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5ff:	8d 45 0c             	lea    0xc(%ebp),%eax
 602:	83 c0 04             	add    $0x4,%eax
 605:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 608:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 60f:	e9 59 01 00 00       	jmp    76d <printf+0x17b>
    c = fmt[i] & 0xff;
 614:	8b 55 0c             	mov    0xc(%ebp),%edx
 617:	8b 45 f0             	mov    -0x10(%ebp),%eax
 61a:	01 d0                	add    %edx,%eax
 61c:	0f b6 00             	movzbl (%eax),%eax
 61f:	0f be c0             	movsbl %al,%eax
 622:	25 ff 00 00 00       	and    $0xff,%eax
 627:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 62a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 62e:	75 2c                	jne    65c <printf+0x6a>
      if(c == '%'){
 630:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 634:	75 0c                	jne    642 <printf+0x50>
        state = '%';
 636:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 63d:	e9 27 01 00 00       	jmp    769 <printf+0x177>
      } else {
        putc(fd, c);
 642:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 645:	0f be c0             	movsbl %al,%eax
 648:	83 ec 08             	sub    $0x8,%esp
 64b:	50                   	push   %eax
 64c:	ff 75 08             	pushl  0x8(%ebp)
 64f:	e8 c7 fe ff ff       	call   51b <putc>
 654:	83 c4 10             	add    $0x10,%esp
 657:	e9 0d 01 00 00       	jmp    769 <printf+0x177>
      }
    } else if(state == '%'){
 65c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 660:	0f 85 03 01 00 00    	jne    769 <printf+0x177>
      if(c == 'd'){
 666:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 66a:	75 1e                	jne    68a <printf+0x98>
        printint(fd, *ap, 10, 1);
 66c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66f:	8b 00                	mov    (%eax),%eax
 671:	6a 01                	push   $0x1
 673:	6a 0a                	push   $0xa
 675:	50                   	push   %eax
 676:	ff 75 08             	pushl  0x8(%ebp)
 679:	e8 c0 fe ff ff       	call   53e <printint>
 67e:	83 c4 10             	add    $0x10,%esp
        ap++;
 681:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 685:	e9 d8 00 00 00       	jmp    762 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 68a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 68e:	74 06                	je     696 <printf+0xa4>
 690:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 694:	75 1e                	jne    6b4 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 696:	8b 45 e8             	mov    -0x18(%ebp),%eax
 699:	8b 00                	mov    (%eax),%eax
 69b:	6a 00                	push   $0x0
 69d:	6a 10                	push   $0x10
 69f:	50                   	push   %eax
 6a0:	ff 75 08             	pushl  0x8(%ebp)
 6a3:	e8 96 fe ff ff       	call   53e <printint>
 6a8:	83 c4 10             	add    $0x10,%esp
        ap++;
 6ab:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6af:	e9 ae 00 00 00       	jmp    762 <printf+0x170>
      } else if(c == 's'){
 6b4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6b8:	75 43                	jne    6fd <printf+0x10b>
        s = (char*)*ap;
 6ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6bd:	8b 00                	mov    (%eax),%eax
 6bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6c2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6ca:	75 25                	jne    6f1 <printf+0xff>
          s = "(null)";
 6cc:	c7 45 f4 bd 09 00 00 	movl   $0x9bd,-0xc(%ebp)
        while(*s != 0){
 6d3:	eb 1c                	jmp    6f1 <printf+0xff>
          putc(fd, *s);
 6d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d8:	0f b6 00             	movzbl (%eax),%eax
 6db:	0f be c0             	movsbl %al,%eax
 6de:	83 ec 08             	sub    $0x8,%esp
 6e1:	50                   	push   %eax
 6e2:	ff 75 08             	pushl  0x8(%ebp)
 6e5:	e8 31 fe ff ff       	call   51b <putc>
 6ea:	83 c4 10             	add    $0x10,%esp
          s++;
 6ed:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f4:	0f b6 00             	movzbl (%eax),%eax
 6f7:	84 c0                	test   %al,%al
 6f9:	75 da                	jne    6d5 <printf+0xe3>
 6fb:	eb 65                	jmp    762 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6fd:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 701:	75 1d                	jne    720 <printf+0x12e>
        putc(fd, *ap);
 703:	8b 45 e8             	mov    -0x18(%ebp),%eax
 706:	8b 00                	mov    (%eax),%eax
 708:	0f be c0             	movsbl %al,%eax
 70b:	83 ec 08             	sub    $0x8,%esp
 70e:	50                   	push   %eax
 70f:	ff 75 08             	pushl  0x8(%ebp)
 712:	e8 04 fe ff ff       	call   51b <putc>
 717:	83 c4 10             	add    $0x10,%esp
        ap++;
 71a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 71e:	eb 42                	jmp    762 <printf+0x170>
      } else if(c == '%'){
 720:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 724:	75 17                	jne    73d <printf+0x14b>
        putc(fd, c);
 726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 729:	0f be c0             	movsbl %al,%eax
 72c:	83 ec 08             	sub    $0x8,%esp
 72f:	50                   	push   %eax
 730:	ff 75 08             	pushl  0x8(%ebp)
 733:	e8 e3 fd ff ff       	call   51b <putc>
 738:	83 c4 10             	add    $0x10,%esp
 73b:	eb 25                	jmp    762 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 73d:	83 ec 08             	sub    $0x8,%esp
 740:	6a 25                	push   $0x25
 742:	ff 75 08             	pushl  0x8(%ebp)
 745:	e8 d1 fd ff ff       	call   51b <putc>
 74a:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 74d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 750:	0f be c0             	movsbl %al,%eax
 753:	83 ec 08             	sub    $0x8,%esp
 756:	50                   	push   %eax
 757:	ff 75 08             	pushl  0x8(%ebp)
 75a:	e8 bc fd ff ff       	call   51b <putc>
 75f:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 762:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 769:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 76d:	8b 55 0c             	mov    0xc(%ebp),%edx
 770:	8b 45 f0             	mov    -0x10(%ebp),%eax
 773:	01 d0                	add    %edx,%eax
 775:	0f b6 00             	movzbl (%eax),%eax
 778:	84 c0                	test   %al,%al
 77a:	0f 85 94 fe ff ff    	jne    614 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 780:	90                   	nop
 781:	c9                   	leave  
 782:	c3                   	ret    

00000783 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 783:	55                   	push   %ebp
 784:	89 e5                	mov    %esp,%ebp
 786:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 789:	8b 45 08             	mov    0x8(%ebp),%eax
 78c:	83 e8 08             	sub    $0x8,%eax
 78f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 792:	a1 48 0c 00 00       	mov    0xc48,%eax
 797:	89 45 fc             	mov    %eax,-0x4(%ebp)
 79a:	eb 24                	jmp    7c0 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79f:	8b 00                	mov    (%eax),%eax
 7a1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a4:	77 12                	ja     7b8 <free+0x35>
 7a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7ac:	77 24                	ja     7d2 <free+0x4f>
 7ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b1:	8b 00                	mov    (%eax),%eax
 7b3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7b6:	77 1a                	ja     7d2 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bb:	8b 00                	mov    (%eax),%eax
 7bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7c6:	76 d4                	jbe    79c <free+0x19>
 7c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cb:	8b 00                	mov    (%eax),%eax
 7cd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d0:	76 ca                	jbe    79c <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d5:	8b 40 04             	mov    0x4(%eax),%eax
 7d8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e2:	01 c2                	add    %eax,%edx
 7e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e7:	8b 00                	mov    (%eax),%eax
 7e9:	39 c2                	cmp    %eax,%edx
 7eb:	75 24                	jne    811 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f0:	8b 50 04             	mov    0x4(%eax),%edx
 7f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f6:	8b 00                	mov    (%eax),%eax
 7f8:	8b 40 04             	mov    0x4(%eax),%eax
 7fb:	01 c2                	add    %eax,%edx
 7fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 800:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 803:	8b 45 fc             	mov    -0x4(%ebp),%eax
 806:	8b 00                	mov    (%eax),%eax
 808:	8b 10                	mov    (%eax),%edx
 80a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80d:	89 10                	mov    %edx,(%eax)
 80f:	eb 0a                	jmp    81b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 811:	8b 45 fc             	mov    -0x4(%ebp),%eax
 814:	8b 10                	mov    (%eax),%edx
 816:	8b 45 f8             	mov    -0x8(%ebp),%eax
 819:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 81b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81e:	8b 40 04             	mov    0x4(%eax),%eax
 821:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 828:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82b:	01 d0                	add    %edx,%eax
 82d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 830:	75 20                	jne    852 <free+0xcf>
    p->s.size += bp->s.size;
 832:	8b 45 fc             	mov    -0x4(%ebp),%eax
 835:	8b 50 04             	mov    0x4(%eax),%edx
 838:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83b:	8b 40 04             	mov    0x4(%eax),%eax
 83e:	01 c2                	add    %eax,%edx
 840:	8b 45 fc             	mov    -0x4(%ebp),%eax
 843:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 846:	8b 45 f8             	mov    -0x8(%ebp),%eax
 849:	8b 10                	mov    (%eax),%edx
 84b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84e:	89 10                	mov    %edx,(%eax)
 850:	eb 08                	jmp    85a <free+0xd7>
  } else
    p->s.ptr = bp;
 852:	8b 45 fc             	mov    -0x4(%ebp),%eax
 855:	8b 55 f8             	mov    -0x8(%ebp),%edx
 858:	89 10                	mov    %edx,(%eax)
  freep = p;
 85a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85d:	a3 48 0c 00 00       	mov    %eax,0xc48
}
 862:	90                   	nop
 863:	c9                   	leave  
 864:	c3                   	ret    

00000865 <morecore>:

static Header*
morecore(uint nu)
{
 865:	55                   	push   %ebp
 866:	89 e5                	mov    %esp,%ebp
 868:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 86b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 872:	77 07                	ja     87b <morecore+0x16>
    nu = 4096;
 874:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 87b:	8b 45 08             	mov    0x8(%ebp),%eax
 87e:	c1 e0 03             	shl    $0x3,%eax
 881:	83 ec 0c             	sub    $0xc,%esp
 884:	50                   	push   %eax
 885:	e8 31 fc ff ff       	call   4bb <sbrk>
 88a:	83 c4 10             	add    $0x10,%esp
 88d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 890:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 894:	75 07                	jne    89d <morecore+0x38>
    return 0;
 896:	b8 00 00 00 00       	mov    $0x0,%eax
 89b:	eb 26                	jmp    8c3 <morecore+0x5e>
  hp = (Header*)p;
 89d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a6:	8b 55 08             	mov    0x8(%ebp),%edx
 8a9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8af:	83 c0 08             	add    $0x8,%eax
 8b2:	83 ec 0c             	sub    $0xc,%esp
 8b5:	50                   	push   %eax
 8b6:	e8 c8 fe ff ff       	call   783 <free>
 8bb:	83 c4 10             	add    $0x10,%esp
  return freep;
 8be:	a1 48 0c 00 00       	mov    0xc48,%eax
}
 8c3:	c9                   	leave  
 8c4:	c3                   	ret    

000008c5 <malloc>:

void*
malloc(uint nbytes)
{
 8c5:	55                   	push   %ebp
 8c6:	89 e5                	mov    %esp,%ebp
 8c8:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8cb:	8b 45 08             	mov    0x8(%ebp),%eax
 8ce:	83 c0 07             	add    $0x7,%eax
 8d1:	c1 e8 03             	shr    $0x3,%eax
 8d4:	83 c0 01             	add    $0x1,%eax
 8d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8da:	a1 48 0c 00 00       	mov    0xc48,%eax
 8df:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8e6:	75 23                	jne    90b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8e8:	c7 45 f0 40 0c 00 00 	movl   $0xc40,-0x10(%ebp)
 8ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f2:	a3 48 0c 00 00       	mov    %eax,0xc48
 8f7:	a1 48 0c 00 00       	mov    0xc48,%eax
 8fc:	a3 40 0c 00 00       	mov    %eax,0xc40
    base.s.size = 0;
 901:	c7 05 44 0c 00 00 00 	movl   $0x0,0xc44
 908:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90e:	8b 00                	mov    (%eax),%eax
 910:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 913:	8b 45 f4             	mov    -0xc(%ebp),%eax
 916:	8b 40 04             	mov    0x4(%eax),%eax
 919:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 91c:	72 4d                	jb     96b <malloc+0xa6>
      if(p->s.size == nunits)
 91e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 921:	8b 40 04             	mov    0x4(%eax),%eax
 924:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 927:	75 0c                	jne    935 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 929:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92c:	8b 10                	mov    (%eax),%edx
 92e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 931:	89 10                	mov    %edx,(%eax)
 933:	eb 26                	jmp    95b <malloc+0x96>
      else {
        p->s.size -= nunits;
 935:	8b 45 f4             	mov    -0xc(%ebp),%eax
 938:	8b 40 04             	mov    0x4(%eax),%eax
 93b:	2b 45 ec             	sub    -0x14(%ebp),%eax
 93e:	89 c2                	mov    %eax,%edx
 940:	8b 45 f4             	mov    -0xc(%ebp),%eax
 943:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 946:	8b 45 f4             	mov    -0xc(%ebp),%eax
 949:	8b 40 04             	mov    0x4(%eax),%eax
 94c:	c1 e0 03             	shl    $0x3,%eax
 94f:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 952:	8b 45 f4             	mov    -0xc(%ebp),%eax
 955:	8b 55 ec             	mov    -0x14(%ebp),%edx
 958:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 95b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95e:	a3 48 0c 00 00       	mov    %eax,0xc48
      return (void*)(p + 1);
 963:	8b 45 f4             	mov    -0xc(%ebp),%eax
 966:	83 c0 08             	add    $0x8,%eax
 969:	eb 3b                	jmp    9a6 <malloc+0xe1>
    }
    if(p == freep)
 96b:	a1 48 0c 00 00       	mov    0xc48,%eax
 970:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 973:	75 1e                	jne    993 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 975:	83 ec 0c             	sub    $0xc,%esp
 978:	ff 75 ec             	pushl  -0x14(%ebp)
 97b:	e8 e5 fe ff ff       	call   865 <morecore>
 980:	83 c4 10             	add    $0x10,%esp
 983:	89 45 f4             	mov    %eax,-0xc(%ebp)
 986:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 98a:	75 07                	jne    993 <malloc+0xce>
        return 0;
 98c:	b8 00 00 00 00       	mov    $0x0,%eax
 991:	eb 13                	jmp    9a6 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 993:	8b 45 f4             	mov    -0xc(%ebp),%eax
 996:	89 45 f0             	mov    %eax,-0x10(%ebp)
 999:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99c:	8b 00                	mov    (%eax),%eax
 99e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9a1:	e9 6d ff ff ff       	jmp    913 <malloc+0x4e>
}
 9a6:	c9                   	leave  
 9a7:	c3                   	ret    
