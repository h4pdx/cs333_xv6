
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
  14:	e8 90 04 00 00       	call   4a9 <getpid>
  19:	89 45 e8             	mov    %eax,-0x18(%ebp)

    int i = 0;
  1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (i < 100) {
  23:	eb 3b                	jmp    60 <main+0x60>
        pid[i] = fork();
  25:	e8 f7 03 00 00       	call   421 <fork>
  2a:	89 c2                	mov    %eax,%edx
  2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2f:	89 94 85 58 fe ff ff 	mov    %edx,-0x1a8(%ebp,%eax,4)
        if (ppid != getpid()) {
  36:	e8 6e 04 00 00       	call   4a9 <getpid>
  3b:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  3e:	74 0d                	je     4d <main+0x4d>
            for(int x = 0; x < 100000000000; x++); // cycle runnable and ready
  40:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  47:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  4b:	eb fa                	jmp    47 <main+0x47>
            sleep(2000); // put to sleep
            exit();
        }
        if (pid[i] == -1) {
  4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  50:	8b 84 85 58 fe ff ff 	mov    -0x1a8(%ebp,%eax,4),%eax
  57:	83 f8 ff             	cmp    $0xffffffff,%eax
  5a:	74 0c                	je     68 <main+0x68>
            break;
        }
        i++;
  5c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
int main(void) {
    int pid[100];
    int ppid = getpid();

    int i = 0;
    while (i < 100) {
  60:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  64:	7e bf                	jle    25 <main+0x25>
  66:	eb 01                	jmp    69 <main+0x69>
            for(int x = 0; x < 100000000000; x++); // cycle runnable and ready
            sleep(2000); // put to sleep
            exit();
        }
        if (pid[i] == -1) {
            break;
  68:	90                   	nop
        }
        i++;
    }

    if (ppid == getpid()) {
  69:	e8 3b 04 00 00       	call   4a9 <getpid>
  6e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  71:	0f 85 83 00 00 00    	jne    fa <main+0xfa>
        printf(1, "Killed.\n");
  77:	83 ec 08             	sub    $0x8,%esp
  7a:	68 96 09 00 00       	push   $0x996
  7f:	6a 01                	push   $0x1
  81:	e8 5a 05 00 00       	call   5e0 <printf>
  86:	83 c4 10             	add    $0x10,%esp
        sleep(4000);
  89:	83 ec 0c             	sub    $0xc,%esp
  8c:	68 a0 0f 00 00       	push   $0xfa0
  91:	e8 23 04 00 00       	call   4b9 <sleep>
  96:	83 c4 10             	add    $0x10,%esp
        int j = 0;
  99:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
        while (j < 64) {
  a0:	eb 52                	jmp    f4 <main+0xf4>
            kill(pid[j]);
  a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  a5:	8b 84 85 58 fe ff ff 	mov    -0x1a8(%ebp,%eax,4),%eax
  ac:	83 ec 0c             	sub    $0xc,%esp
  af:	50                   	push   %eax
  b0:	e8 a4 03 00 00       	call   459 <kill>
  b5:	83 c4 10             	add    $0x10,%esp
            sleep(2000);
  b8:	83 ec 0c             	sub    $0xc,%esp
  bb:	68 d0 07 00 00       	push   $0x7d0
  c0:	e8 f4 03 00 00       	call   4b9 <sleep>
  c5:	83 c4 10             	add    $0x10,%esp
            while (wait() == -1) {}
  c8:	90                   	nop
  c9:	e8 63 03 00 00       	call   431 <wait>
  ce:	83 f8 ff             	cmp    $0xffffffff,%eax
  d1:	74 f6                	je     c9 <main+0xc9>
            printf(1, "Reaped %d.\n", pid[j]);
  d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  d6:	8b 84 85 58 fe ff ff 	mov    -0x1a8(%ebp,%eax,4),%eax
  dd:	83 ec 04             	sub    $0x4,%esp
  e0:	50                   	push   %eax
  e1:	68 9f 09 00 00       	push   $0x99f
  e6:	6a 01                	push   $0x1
  e8:	e8 f3 04 00 00       	call   5e0 <printf>
  ed:	83 c4 10             	add    $0x10,%esp
            j++;
  f0:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

    if (ppid == getpid()) {
        printf(1, "Killed.\n");
        sleep(4000);
        int j = 0;
        while (j < 64) {
  f4:	83 7d ec 3f          	cmpl   $0x3f,-0x14(%ebp)
  f8:	7e a8                	jle    a2 <main+0xa2>
            while (wait() == -1) {}
            printf(1, "Reaped %d.\n", pid[j]);
            j++;
        }
    }
    exit();
  fa:	e8 2a 03 00 00       	call   429 <exit>

000000ff <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  ff:	55                   	push   %ebp
 100:	89 e5                	mov    %esp,%ebp
 102:	57                   	push   %edi
 103:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 104:	8b 4d 08             	mov    0x8(%ebp),%ecx
 107:	8b 55 10             	mov    0x10(%ebp),%edx
 10a:	8b 45 0c             	mov    0xc(%ebp),%eax
 10d:	89 cb                	mov    %ecx,%ebx
 10f:	89 df                	mov    %ebx,%edi
 111:	89 d1                	mov    %edx,%ecx
 113:	fc                   	cld    
 114:	f3 aa                	rep stos %al,%es:(%edi)
 116:	89 ca                	mov    %ecx,%edx
 118:	89 fb                	mov    %edi,%ebx
 11a:	89 5d 08             	mov    %ebx,0x8(%ebp)
 11d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 120:	90                   	nop
 121:	5b                   	pop    %ebx
 122:	5f                   	pop    %edi
 123:	5d                   	pop    %ebp
 124:	c3                   	ret    

00000125 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 125:	55                   	push   %ebp
 126:	89 e5                	mov    %esp,%ebp
 128:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 12b:	8b 45 08             	mov    0x8(%ebp),%eax
 12e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 131:	90                   	nop
 132:	8b 45 08             	mov    0x8(%ebp),%eax
 135:	8d 50 01             	lea    0x1(%eax),%edx
 138:	89 55 08             	mov    %edx,0x8(%ebp)
 13b:	8b 55 0c             	mov    0xc(%ebp),%edx
 13e:	8d 4a 01             	lea    0x1(%edx),%ecx
 141:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 144:	0f b6 12             	movzbl (%edx),%edx
 147:	88 10                	mov    %dl,(%eax)
 149:	0f b6 00             	movzbl (%eax),%eax
 14c:	84 c0                	test   %al,%al
 14e:	75 e2                	jne    132 <strcpy+0xd>
    ;
  return os;
 150:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 153:	c9                   	leave  
 154:	c3                   	ret    

00000155 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 155:	55                   	push   %ebp
 156:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 158:	eb 08                	jmp    162 <strcmp+0xd>
    p++, q++;
 15a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 15e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 162:	8b 45 08             	mov    0x8(%ebp),%eax
 165:	0f b6 00             	movzbl (%eax),%eax
 168:	84 c0                	test   %al,%al
 16a:	74 10                	je     17c <strcmp+0x27>
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 10             	movzbl (%eax),%edx
 172:	8b 45 0c             	mov    0xc(%ebp),%eax
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	38 c2                	cmp    %al,%dl
 17a:	74 de                	je     15a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	0f b6 00             	movzbl (%eax),%eax
 182:	0f b6 d0             	movzbl %al,%edx
 185:	8b 45 0c             	mov    0xc(%ebp),%eax
 188:	0f b6 00             	movzbl (%eax),%eax
 18b:	0f b6 c0             	movzbl %al,%eax
 18e:	29 c2                	sub    %eax,%edx
 190:	89 d0                	mov    %edx,%eax
}
 192:	5d                   	pop    %ebp
 193:	c3                   	ret    

00000194 <strlen>:

uint
strlen(char *s)
{
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 19a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1a1:	eb 04                	jmp    1a7 <strlen+0x13>
 1a3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1aa:	8b 45 08             	mov    0x8(%ebp),%eax
 1ad:	01 d0                	add    %edx,%eax
 1af:	0f b6 00             	movzbl (%eax),%eax
 1b2:	84 c0                	test   %al,%al
 1b4:	75 ed                	jne    1a3 <strlen+0xf>
    ;
  return n;
 1b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1b9:	c9                   	leave  
 1ba:	c3                   	ret    

000001bb <memset>:

void*
memset(void *dst, int c, uint n)
{
 1bb:	55                   	push   %ebp
 1bc:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1be:	8b 45 10             	mov    0x10(%ebp),%eax
 1c1:	50                   	push   %eax
 1c2:	ff 75 0c             	pushl  0xc(%ebp)
 1c5:	ff 75 08             	pushl  0x8(%ebp)
 1c8:	e8 32 ff ff ff       	call   ff <stosb>
 1cd:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1d3:	c9                   	leave  
 1d4:	c3                   	ret    

000001d5 <strchr>:

char*
strchr(const char *s, char c)
{
 1d5:	55                   	push   %ebp
 1d6:	89 e5                	mov    %esp,%ebp
 1d8:	83 ec 04             	sub    $0x4,%esp
 1db:	8b 45 0c             	mov    0xc(%ebp),%eax
 1de:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1e1:	eb 14                	jmp    1f7 <strchr+0x22>
    if(*s == c)
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	0f b6 00             	movzbl (%eax),%eax
 1e9:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1ec:	75 05                	jne    1f3 <strchr+0x1e>
      return (char*)s;
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
 1f1:	eb 13                	jmp    206 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1f3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
 1fa:	0f b6 00             	movzbl (%eax),%eax
 1fd:	84 c0                	test   %al,%al
 1ff:	75 e2                	jne    1e3 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 201:	b8 00 00 00 00       	mov    $0x0,%eax
}
 206:	c9                   	leave  
 207:	c3                   	ret    

00000208 <gets>:

char*
gets(char *buf, int max)
{
 208:	55                   	push   %ebp
 209:	89 e5                	mov    %esp,%ebp
 20b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 20e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 215:	eb 42                	jmp    259 <gets+0x51>
    cc = read(0, &c, 1);
 217:	83 ec 04             	sub    $0x4,%esp
 21a:	6a 01                	push   $0x1
 21c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 21f:	50                   	push   %eax
 220:	6a 00                	push   $0x0
 222:	e8 1a 02 00 00       	call   441 <read>
 227:	83 c4 10             	add    $0x10,%esp
 22a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 22d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 231:	7e 33                	jle    266 <gets+0x5e>
      break;
    buf[i++] = c;
 233:	8b 45 f4             	mov    -0xc(%ebp),%eax
 236:	8d 50 01             	lea    0x1(%eax),%edx
 239:	89 55 f4             	mov    %edx,-0xc(%ebp)
 23c:	89 c2                	mov    %eax,%edx
 23e:	8b 45 08             	mov    0x8(%ebp),%eax
 241:	01 c2                	add    %eax,%edx
 243:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 247:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 249:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 24d:	3c 0a                	cmp    $0xa,%al
 24f:	74 16                	je     267 <gets+0x5f>
 251:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 255:	3c 0d                	cmp    $0xd,%al
 257:	74 0e                	je     267 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 259:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25c:	83 c0 01             	add    $0x1,%eax
 25f:	3b 45 0c             	cmp    0xc(%ebp),%eax
 262:	7c b3                	jl     217 <gets+0xf>
 264:	eb 01                	jmp    267 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 266:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 267:	8b 55 f4             	mov    -0xc(%ebp),%edx
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	01 d0                	add    %edx,%eax
 26f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 272:	8b 45 08             	mov    0x8(%ebp),%eax
}
 275:	c9                   	leave  
 276:	c3                   	ret    

00000277 <stat>:

int
stat(char *n, struct stat *st)
{
 277:	55                   	push   %ebp
 278:	89 e5                	mov    %esp,%ebp
 27a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27d:	83 ec 08             	sub    $0x8,%esp
 280:	6a 00                	push   $0x0
 282:	ff 75 08             	pushl  0x8(%ebp)
 285:	e8 df 01 00 00       	call   469 <open>
 28a:	83 c4 10             	add    $0x10,%esp
 28d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 290:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 294:	79 07                	jns    29d <stat+0x26>
    return -1;
 296:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 29b:	eb 25                	jmp    2c2 <stat+0x4b>
  r = fstat(fd, st);
 29d:	83 ec 08             	sub    $0x8,%esp
 2a0:	ff 75 0c             	pushl  0xc(%ebp)
 2a3:	ff 75 f4             	pushl  -0xc(%ebp)
 2a6:	e8 d6 01 00 00       	call   481 <fstat>
 2ab:	83 c4 10             	add    $0x10,%esp
 2ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2b1:	83 ec 0c             	sub    $0xc,%esp
 2b4:	ff 75 f4             	pushl  -0xc(%ebp)
 2b7:	e8 95 01 00 00       	call   451 <close>
 2bc:	83 c4 10             	add    $0x10,%esp
  return r;
 2bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2c2:	c9                   	leave  
 2c3:	c3                   	ret    

000002c4 <atoi>:

int
atoi(const char *s)
{
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2d1:	eb 04                	jmp    2d7 <atoi+0x13>
 2d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2d7:	8b 45 08             	mov    0x8(%ebp),%eax
 2da:	0f b6 00             	movzbl (%eax),%eax
 2dd:	3c 20                	cmp    $0x20,%al
 2df:	74 f2                	je     2d3 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 2e1:	8b 45 08             	mov    0x8(%ebp),%eax
 2e4:	0f b6 00             	movzbl (%eax),%eax
 2e7:	3c 2d                	cmp    $0x2d,%al
 2e9:	75 07                	jne    2f2 <atoi+0x2e>
 2eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2f0:	eb 05                	jmp    2f7 <atoi+0x33>
 2f2:	b8 01 00 00 00       	mov    $0x1,%eax
 2f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2fa:	8b 45 08             	mov    0x8(%ebp),%eax
 2fd:	0f b6 00             	movzbl (%eax),%eax
 300:	3c 2b                	cmp    $0x2b,%al
 302:	74 0a                	je     30e <atoi+0x4a>
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	0f b6 00             	movzbl (%eax),%eax
 30a:	3c 2d                	cmp    $0x2d,%al
 30c:	75 2b                	jne    339 <atoi+0x75>
    s++;
 30e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 312:	eb 25                	jmp    339 <atoi+0x75>
    n = n*10 + *s++ - '0';
 314:	8b 55 fc             	mov    -0x4(%ebp),%edx
 317:	89 d0                	mov    %edx,%eax
 319:	c1 e0 02             	shl    $0x2,%eax
 31c:	01 d0                	add    %edx,%eax
 31e:	01 c0                	add    %eax,%eax
 320:	89 c1                	mov    %eax,%ecx
 322:	8b 45 08             	mov    0x8(%ebp),%eax
 325:	8d 50 01             	lea    0x1(%eax),%edx
 328:	89 55 08             	mov    %edx,0x8(%ebp)
 32b:	0f b6 00             	movzbl (%eax),%eax
 32e:	0f be c0             	movsbl %al,%eax
 331:	01 c8                	add    %ecx,%eax
 333:	83 e8 30             	sub    $0x30,%eax
 336:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 339:	8b 45 08             	mov    0x8(%ebp),%eax
 33c:	0f b6 00             	movzbl (%eax),%eax
 33f:	3c 2f                	cmp    $0x2f,%al
 341:	7e 0a                	jle    34d <atoi+0x89>
 343:	8b 45 08             	mov    0x8(%ebp),%eax
 346:	0f b6 00             	movzbl (%eax),%eax
 349:	3c 39                	cmp    $0x39,%al
 34b:	7e c7                	jle    314 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 34d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 350:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 354:	c9                   	leave  
 355:	c3                   	ret    

00000356 <atoo>:

int
atoo(const char *s)
{
 356:	55                   	push   %ebp
 357:	89 e5                	mov    %esp,%ebp
 359:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 35c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 363:	eb 04                	jmp    369 <atoo+0x13>
 365:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 369:	8b 45 08             	mov    0x8(%ebp),%eax
 36c:	0f b6 00             	movzbl (%eax),%eax
 36f:	3c 20                	cmp    $0x20,%al
 371:	74 f2                	je     365 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	0f b6 00             	movzbl (%eax),%eax
 379:	3c 2d                	cmp    $0x2d,%al
 37b:	75 07                	jne    384 <atoo+0x2e>
 37d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 382:	eb 05                	jmp    389 <atoo+0x33>
 384:	b8 01 00 00 00       	mov    $0x1,%eax
 389:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 38c:	8b 45 08             	mov    0x8(%ebp),%eax
 38f:	0f b6 00             	movzbl (%eax),%eax
 392:	3c 2b                	cmp    $0x2b,%al
 394:	74 0a                	je     3a0 <atoo+0x4a>
 396:	8b 45 08             	mov    0x8(%ebp),%eax
 399:	0f b6 00             	movzbl (%eax),%eax
 39c:	3c 2d                	cmp    $0x2d,%al
 39e:	75 27                	jne    3c7 <atoo+0x71>
    s++;
 3a0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 3a4:	eb 21                	jmp    3c7 <atoo+0x71>
    n = n*8 + *s++ - '0';
 3a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3a9:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 3b0:	8b 45 08             	mov    0x8(%ebp),%eax
 3b3:	8d 50 01             	lea    0x1(%eax),%edx
 3b6:	89 55 08             	mov    %edx,0x8(%ebp)
 3b9:	0f b6 00             	movzbl (%eax),%eax
 3bc:	0f be c0             	movsbl %al,%eax
 3bf:	01 c8                	add    %ecx,%eax
 3c1:	83 e8 30             	sub    $0x30,%eax
 3c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	0f b6 00             	movzbl (%eax),%eax
 3cd:	3c 2f                	cmp    $0x2f,%al
 3cf:	7e 0a                	jle    3db <atoo+0x85>
 3d1:	8b 45 08             	mov    0x8(%ebp),%eax
 3d4:	0f b6 00             	movzbl (%eax),%eax
 3d7:	3c 37                	cmp    $0x37,%al
 3d9:	7e cb                	jle    3a6 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 3db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3de:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3e2:	c9                   	leave  
 3e3:	c3                   	ret    

000003e4 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 3e4:	55                   	push   %ebp
 3e5:	89 e5                	mov    %esp,%ebp
 3e7:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3ea:	8b 45 08             	mov    0x8(%ebp),%eax
 3ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3f6:	eb 17                	jmp    40f <memmove+0x2b>
    *dst++ = *src++;
 3f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3fb:	8d 50 01             	lea    0x1(%eax),%edx
 3fe:	89 55 fc             	mov    %edx,-0x4(%ebp)
 401:	8b 55 f8             	mov    -0x8(%ebp),%edx
 404:	8d 4a 01             	lea    0x1(%edx),%ecx
 407:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 40a:	0f b6 12             	movzbl (%edx),%edx
 40d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 40f:	8b 45 10             	mov    0x10(%ebp),%eax
 412:	8d 50 ff             	lea    -0x1(%eax),%edx
 415:	89 55 10             	mov    %edx,0x10(%ebp)
 418:	85 c0                	test   %eax,%eax
 41a:	7f dc                	jg     3f8 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 41c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 41f:	c9                   	leave  
 420:	c3                   	ret    

00000421 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 421:	b8 01 00 00 00       	mov    $0x1,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <exit>:
SYSCALL(exit)
 429:	b8 02 00 00 00       	mov    $0x2,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <wait>:
SYSCALL(wait)
 431:	b8 03 00 00 00       	mov    $0x3,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <pipe>:
SYSCALL(pipe)
 439:	b8 04 00 00 00       	mov    $0x4,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <read>:
SYSCALL(read)
 441:	b8 05 00 00 00       	mov    $0x5,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <write>:
SYSCALL(write)
 449:	b8 10 00 00 00       	mov    $0x10,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <close>:
SYSCALL(close)
 451:	b8 15 00 00 00       	mov    $0x15,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <kill>:
SYSCALL(kill)
 459:	b8 06 00 00 00       	mov    $0x6,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <exec>:
SYSCALL(exec)
 461:	b8 07 00 00 00       	mov    $0x7,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <open>:
SYSCALL(open)
 469:	b8 0f 00 00 00       	mov    $0xf,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <mknod>:
SYSCALL(mknod)
 471:	b8 11 00 00 00       	mov    $0x11,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <unlink>:
SYSCALL(unlink)
 479:	b8 12 00 00 00       	mov    $0x12,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <fstat>:
SYSCALL(fstat)
 481:	b8 08 00 00 00       	mov    $0x8,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <link>:
SYSCALL(link)
 489:	b8 13 00 00 00       	mov    $0x13,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <mkdir>:
SYSCALL(mkdir)
 491:	b8 14 00 00 00       	mov    $0x14,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <chdir>:
SYSCALL(chdir)
 499:	b8 09 00 00 00       	mov    $0x9,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <dup>:
SYSCALL(dup)
 4a1:	b8 0a 00 00 00       	mov    $0xa,%eax
 4a6:	cd 40                	int    $0x40
 4a8:	c3                   	ret    

000004a9 <getpid>:
SYSCALL(getpid)
 4a9:	b8 0b 00 00 00       	mov    $0xb,%eax
 4ae:	cd 40                	int    $0x40
 4b0:	c3                   	ret    

000004b1 <sbrk>:
SYSCALL(sbrk)
 4b1:	b8 0c 00 00 00       	mov    $0xc,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <sleep>:
SYSCALL(sleep)
 4b9:	b8 0d 00 00 00       	mov    $0xd,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <uptime>:
SYSCALL(uptime)
 4c1:	b8 0e 00 00 00       	mov    $0xe,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <halt>:
SYSCALL(halt)
 4c9:	b8 16 00 00 00       	mov    $0x16,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <date>:
SYSCALL(date)
 4d1:	b8 17 00 00 00       	mov    $0x17,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <getuid>:
SYSCALL(getuid)
 4d9:	b8 18 00 00 00       	mov    $0x18,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <getgid>:
SYSCALL(getgid)
 4e1:	b8 19 00 00 00       	mov    $0x19,%eax
 4e6:	cd 40                	int    $0x40
 4e8:	c3                   	ret    

000004e9 <getppid>:
SYSCALL(getppid)
 4e9:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4ee:	cd 40                	int    $0x40
 4f0:	c3                   	ret    

000004f1 <setuid>:
SYSCALL(setuid)
 4f1:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4f6:	cd 40                	int    $0x40
 4f8:	c3                   	ret    

000004f9 <setgid>:
SYSCALL(setgid)
 4f9:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4fe:	cd 40                	int    $0x40
 500:	c3                   	ret    

00000501 <getprocs>:
SYSCALL(getprocs)
 501:	b8 1d 00 00 00       	mov    $0x1d,%eax
 506:	cd 40                	int    $0x40
 508:	c3                   	ret    

00000509 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 509:	55                   	push   %ebp
 50a:	89 e5                	mov    %esp,%ebp
 50c:	83 ec 18             	sub    $0x18,%esp
 50f:	8b 45 0c             	mov    0xc(%ebp),%eax
 512:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 515:	83 ec 04             	sub    $0x4,%esp
 518:	6a 01                	push   $0x1
 51a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 51d:	50                   	push   %eax
 51e:	ff 75 08             	pushl  0x8(%ebp)
 521:	e8 23 ff ff ff       	call   449 <write>
 526:	83 c4 10             	add    $0x10,%esp
}
 529:	90                   	nop
 52a:	c9                   	leave  
 52b:	c3                   	ret    

0000052c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 52c:	55                   	push   %ebp
 52d:	89 e5                	mov    %esp,%ebp
 52f:	53                   	push   %ebx
 530:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 533:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 53a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 53e:	74 17                	je     557 <printint+0x2b>
 540:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 544:	79 11                	jns    557 <printint+0x2b>
    neg = 1;
 546:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 54d:	8b 45 0c             	mov    0xc(%ebp),%eax
 550:	f7 d8                	neg    %eax
 552:	89 45 ec             	mov    %eax,-0x14(%ebp)
 555:	eb 06                	jmp    55d <printint+0x31>
  } else {
    x = xx;
 557:	8b 45 0c             	mov    0xc(%ebp),%eax
 55a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 55d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 564:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 567:	8d 41 01             	lea    0x1(%ecx),%eax
 56a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 56d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 570:	8b 45 ec             	mov    -0x14(%ebp),%eax
 573:	ba 00 00 00 00       	mov    $0x0,%edx
 578:	f7 f3                	div    %ebx
 57a:	89 d0                	mov    %edx,%eax
 57c:	0f b6 80 1c 0c 00 00 	movzbl 0xc1c(%eax),%eax
 583:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 587:	8b 5d 10             	mov    0x10(%ebp),%ebx
 58a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 58d:	ba 00 00 00 00       	mov    $0x0,%edx
 592:	f7 f3                	div    %ebx
 594:	89 45 ec             	mov    %eax,-0x14(%ebp)
 597:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 59b:	75 c7                	jne    564 <printint+0x38>
  if(neg)
 59d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5a1:	74 2d                	je     5d0 <printint+0xa4>
    buf[i++] = '-';
 5a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a6:	8d 50 01             	lea    0x1(%eax),%edx
 5a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5ac:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5b1:	eb 1d                	jmp    5d0 <printint+0xa4>
    putc(fd, buf[i]);
 5b3:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5b9:	01 d0                	add    %edx,%eax
 5bb:	0f b6 00             	movzbl (%eax),%eax
 5be:	0f be c0             	movsbl %al,%eax
 5c1:	83 ec 08             	sub    $0x8,%esp
 5c4:	50                   	push   %eax
 5c5:	ff 75 08             	pushl  0x8(%ebp)
 5c8:	e8 3c ff ff ff       	call   509 <putc>
 5cd:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5d0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5d8:	79 d9                	jns    5b3 <printint+0x87>
    putc(fd, buf[i]);
}
 5da:	90                   	nop
 5db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5de:	c9                   	leave  
 5df:	c3                   	ret    

000005e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5e0:	55                   	push   %ebp
 5e1:	89 e5                	mov    %esp,%ebp
 5e3:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5e6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5ed:	8d 45 0c             	lea    0xc(%ebp),%eax
 5f0:	83 c0 04             	add    $0x4,%eax
 5f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5fd:	e9 59 01 00 00       	jmp    75b <printf+0x17b>
    c = fmt[i] & 0xff;
 602:	8b 55 0c             	mov    0xc(%ebp),%edx
 605:	8b 45 f0             	mov    -0x10(%ebp),%eax
 608:	01 d0                	add    %edx,%eax
 60a:	0f b6 00             	movzbl (%eax),%eax
 60d:	0f be c0             	movsbl %al,%eax
 610:	25 ff 00 00 00       	and    $0xff,%eax
 615:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 618:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 61c:	75 2c                	jne    64a <printf+0x6a>
      if(c == '%'){
 61e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 622:	75 0c                	jne    630 <printf+0x50>
        state = '%';
 624:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 62b:	e9 27 01 00 00       	jmp    757 <printf+0x177>
      } else {
        putc(fd, c);
 630:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 633:	0f be c0             	movsbl %al,%eax
 636:	83 ec 08             	sub    $0x8,%esp
 639:	50                   	push   %eax
 63a:	ff 75 08             	pushl  0x8(%ebp)
 63d:	e8 c7 fe ff ff       	call   509 <putc>
 642:	83 c4 10             	add    $0x10,%esp
 645:	e9 0d 01 00 00       	jmp    757 <printf+0x177>
      }
    } else if(state == '%'){
 64a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 64e:	0f 85 03 01 00 00    	jne    757 <printf+0x177>
      if(c == 'd'){
 654:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 658:	75 1e                	jne    678 <printf+0x98>
        printint(fd, *ap, 10, 1);
 65a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65d:	8b 00                	mov    (%eax),%eax
 65f:	6a 01                	push   $0x1
 661:	6a 0a                	push   $0xa
 663:	50                   	push   %eax
 664:	ff 75 08             	pushl  0x8(%ebp)
 667:	e8 c0 fe ff ff       	call   52c <printint>
 66c:	83 c4 10             	add    $0x10,%esp
        ap++;
 66f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 673:	e9 d8 00 00 00       	jmp    750 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 678:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 67c:	74 06                	je     684 <printf+0xa4>
 67e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 682:	75 1e                	jne    6a2 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 684:	8b 45 e8             	mov    -0x18(%ebp),%eax
 687:	8b 00                	mov    (%eax),%eax
 689:	6a 00                	push   $0x0
 68b:	6a 10                	push   $0x10
 68d:	50                   	push   %eax
 68e:	ff 75 08             	pushl  0x8(%ebp)
 691:	e8 96 fe ff ff       	call   52c <printint>
 696:	83 c4 10             	add    $0x10,%esp
        ap++;
 699:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 69d:	e9 ae 00 00 00       	jmp    750 <printf+0x170>
      } else if(c == 's'){
 6a2:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6a6:	75 43                	jne    6eb <printf+0x10b>
        s = (char*)*ap;
 6a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ab:	8b 00                	mov    (%eax),%eax
 6ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6b0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6b8:	75 25                	jne    6df <printf+0xff>
          s = "(null)";
 6ba:	c7 45 f4 ab 09 00 00 	movl   $0x9ab,-0xc(%ebp)
        while(*s != 0){
 6c1:	eb 1c                	jmp    6df <printf+0xff>
          putc(fd, *s);
 6c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c6:	0f b6 00             	movzbl (%eax),%eax
 6c9:	0f be c0             	movsbl %al,%eax
 6cc:	83 ec 08             	sub    $0x8,%esp
 6cf:	50                   	push   %eax
 6d0:	ff 75 08             	pushl  0x8(%ebp)
 6d3:	e8 31 fe ff ff       	call   509 <putc>
 6d8:	83 c4 10             	add    $0x10,%esp
          s++;
 6db:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6e2:	0f b6 00             	movzbl (%eax),%eax
 6e5:	84 c0                	test   %al,%al
 6e7:	75 da                	jne    6c3 <printf+0xe3>
 6e9:	eb 65                	jmp    750 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6eb:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6ef:	75 1d                	jne    70e <printf+0x12e>
        putc(fd, *ap);
 6f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6f4:	8b 00                	mov    (%eax),%eax
 6f6:	0f be c0             	movsbl %al,%eax
 6f9:	83 ec 08             	sub    $0x8,%esp
 6fc:	50                   	push   %eax
 6fd:	ff 75 08             	pushl  0x8(%ebp)
 700:	e8 04 fe ff ff       	call   509 <putc>
 705:	83 c4 10             	add    $0x10,%esp
        ap++;
 708:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 70c:	eb 42                	jmp    750 <printf+0x170>
      } else if(c == '%'){
 70e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 712:	75 17                	jne    72b <printf+0x14b>
        putc(fd, c);
 714:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 717:	0f be c0             	movsbl %al,%eax
 71a:	83 ec 08             	sub    $0x8,%esp
 71d:	50                   	push   %eax
 71e:	ff 75 08             	pushl  0x8(%ebp)
 721:	e8 e3 fd ff ff       	call   509 <putc>
 726:	83 c4 10             	add    $0x10,%esp
 729:	eb 25                	jmp    750 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 72b:	83 ec 08             	sub    $0x8,%esp
 72e:	6a 25                	push   $0x25
 730:	ff 75 08             	pushl  0x8(%ebp)
 733:	e8 d1 fd ff ff       	call   509 <putc>
 738:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 73b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 73e:	0f be c0             	movsbl %al,%eax
 741:	83 ec 08             	sub    $0x8,%esp
 744:	50                   	push   %eax
 745:	ff 75 08             	pushl  0x8(%ebp)
 748:	e8 bc fd ff ff       	call   509 <putc>
 74d:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 750:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 757:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 75b:	8b 55 0c             	mov    0xc(%ebp),%edx
 75e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 761:	01 d0                	add    %edx,%eax
 763:	0f b6 00             	movzbl (%eax),%eax
 766:	84 c0                	test   %al,%al
 768:	0f 85 94 fe ff ff    	jne    602 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 76e:	90                   	nop
 76f:	c9                   	leave  
 770:	c3                   	ret    

00000771 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 771:	55                   	push   %ebp
 772:	89 e5                	mov    %esp,%ebp
 774:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 777:	8b 45 08             	mov    0x8(%ebp),%eax
 77a:	83 e8 08             	sub    $0x8,%eax
 77d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 780:	a1 38 0c 00 00       	mov    0xc38,%eax
 785:	89 45 fc             	mov    %eax,-0x4(%ebp)
 788:	eb 24                	jmp    7ae <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 78a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78d:	8b 00                	mov    (%eax),%eax
 78f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 792:	77 12                	ja     7a6 <free+0x35>
 794:	8b 45 f8             	mov    -0x8(%ebp),%eax
 797:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 79a:	77 24                	ja     7c0 <free+0x4f>
 79c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79f:	8b 00                	mov    (%eax),%eax
 7a1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a4:	77 1a                	ja     7c0 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a9:	8b 00                	mov    (%eax),%eax
 7ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7b4:	76 d4                	jbe    78a <free+0x19>
 7b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b9:	8b 00                	mov    (%eax),%eax
 7bb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7be:	76 ca                	jbe    78a <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c3:	8b 40 04             	mov    0x4(%eax),%eax
 7c6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d0:	01 c2                	add    %eax,%edx
 7d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d5:	8b 00                	mov    (%eax),%eax
 7d7:	39 c2                	cmp    %eax,%edx
 7d9:	75 24                	jne    7ff <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7de:	8b 50 04             	mov    0x4(%eax),%edx
 7e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e4:	8b 00                	mov    (%eax),%eax
 7e6:	8b 40 04             	mov    0x4(%eax),%eax
 7e9:	01 c2                	add    %eax,%edx
 7eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ee:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f4:	8b 00                	mov    (%eax),%eax
 7f6:	8b 10                	mov    (%eax),%edx
 7f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fb:	89 10                	mov    %edx,(%eax)
 7fd:	eb 0a                	jmp    809 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 802:	8b 10                	mov    (%eax),%edx
 804:	8b 45 f8             	mov    -0x8(%ebp),%eax
 807:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 809:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80c:	8b 40 04             	mov    0x4(%eax),%eax
 80f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 816:	8b 45 fc             	mov    -0x4(%ebp),%eax
 819:	01 d0                	add    %edx,%eax
 81b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 81e:	75 20                	jne    840 <free+0xcf>
    p->s.size += bp->s.size;
 820:	8b 45 fc             	mov    -0x4(%ebp),%eax
 823:	8b 50 04             	mov    0x4(%eax),%edx
 826:	8b 45 f8             	mov    -0x8(%ebp),%eax
 829:	8b 40 04             	mov    0x4(%eax),%eax
 82c:	01 c2                	add    %eax,%edx
 82e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 831:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 834:	8b 45 f8             	mov    -0x8(%ebp),%eax
 837:	8b 10                	mov    (%eax),%edx
 839:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83c:	89 10                	mov    %edx,(%eax)
 83e:	eb 08                	jmp    848 <free+0xd7>
  } else
    p->s.ptr = bp;
 840:	8b 45 fc             	mov    -0x4(%ebp),%eax
 843:	8b 55 f8             	mov    -0x8(%ebp),%edx
 846:	89 10                	mov    %edx,(%eax)
  freep = p;
 848:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84b:	a3 38 0c 00 00       	mov    %eax,0xc38
}
 850:	90                   	nop
 851:	c9                   	leave  
 852:	c3                   	ret    

00000853 <morecore>:

static Header*
morecore(uint nu)
{
 853:	55                   	push   %ebp
 854:	89 e5                	mov    %esp,%ebp
 856:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 859:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 860:	77 07                	ja     869 <morecore+0x16>
    nu = 4096;
 862:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 869:	8b 45 08             	mov    0x8(%ebp),%eax
 86c:	c1 e0 03             	shl    $0x3,%eax
 86f:	83 ec 0c             	sub    $0xc,%esp
 872:	50                   	push   %eax
 873:	e8 39 fc ff ff       	call   4b1 <sbrk>
 878:	83 c4 10             	add    $0x10,%esp
 87b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 87e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 882:	75 07                	jne    88b <morecore+0x38>
    return 0;
 884:	b8 00 00 00 00       	mov    $0x0,%eax
 889:	eb 26                	jmp    8b1 <morecore+0x5e>
  hp = (Header*)p;
 88b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 891:	8b 45 f0             	mov    -0x10(%ebp),%eax
 894:	8b 55 08             	mov    0x8(%ebp),%edx
 897:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 89a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89d:	83 c0 08             	add    $0x8,%eax
 8a0:	83 ec 0c             	sub    $0xc,%esp
 8a3:	50                   	push   %eax
 8a4:	e8 c8 fe ff ff       	call   771 <free>
 8a9:	83 c4 10             	add    $0x10,%esp
  return freep;
 8ac:	a1 38 0c 00 00       	mov    0xc38,%eax
}
 8b1:	c9                   	leave  
 8b2:	c3                   	ret    

000008b3 <malloc>:

void*
malloc(uint nbytes)
{
 8b3:	55                   	push   %ebp
 8b4:	89 e5                	mov    %esp,%ebp
 8b6:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8b9:	8b 45 08             	mov    0x8(%ebp),%eax
 8bc:	83 c0 07             	add    $0x7,%eax
 8bf:	c1 e8 03             	shr    $0x3,%eax
 8c2:	83 c0 01             	add    $0x1,%eax
 8c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8c8:	a1 38 0c 00 00       	mov    0xc38,%eax
 8cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8d4:	75 23                	jne    8f9 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8d6:	c7 45 f0 30 0c 00 00 	movl   $0xc30,-0x10(%ebp)
 8dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e0:	a3 38 0c 00 00       	mov    %eax,0xc38
 8e5:	a1 38 0c 00 00       	mov    0xc38,%eax
 8ea:	a3 30 0c 00 00       	mov    %eax,0xc30
    base.s.size = 0;
 8ef:	c7 05 34 0c 00 00 00 	movl   $0x0,0xc34
 8f6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fc:	8b 00                	mov    (%eax),%eax
 8fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 901:	8b 45 f4             	mov    -0xc(%ebp),%eax
 904:	8b 40 04             	mov    0x4(%eax),%eax
 907:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 90a:	72 4d                	jb     959 <malloc+0xa6>
      if(p->s.size == nunits)
 90c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90f:	8b 40 04             	mov    0x4(%eax),%eax
 912:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 915:	75 0c                	jne    923 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 917:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91a:	8b 10                	mov    (%eax),%edx
 91c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91f:	89 10                	mov    %edx,(%eax)
 921:	eb 26                	jmp    949 <malloc+0x96>
      else {
        p->s.size -= nunits;
 923:	8b 45 f4             	mov    -0xc(%ebp),%eax
 926:	8b 40 04             	mov    0x4(%eax),%eax
 929:	2b 45 ec             	sub    -0x14(%ebp),%eax
 92c:	89 c2                	mov    %eax,%edx
 92e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 931:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 934:	8b 45 f4             	mov    -0xc(%ebp),%eax
 937:	8b 40 04             	mov    0x4(%eax),%eax
 93a:	c1 e0 03             	shl    $0x3,%eax
 93d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 940:	8b 45 f4             	mov    -0xc(%ebp),%eax
 943:	8b 55 ec             	mov    -0x14(%ebp),%edx
 946:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 949:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94c:	a3 38 0c 00 00       	mov    %eax,0xc38
      return (void*)(p + 1);
 951:	8b 45 f4             	mov    -0xc(%ebp),%eax
 954:	83 c0 08             	add    $0x8,%eax
 957:	eb 3b                	jmp    994 <malloc+0xe1>
    }
    if(p == freep)
 959:	a1 38 0c 00 00       	mov    0xc38,%eax
 95e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 961:	75 1e                	jne    981 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 963:	83 ec 0c             	sub    $0xc,%esp
 966:	ff 75 ec             	pushl  -0x14(%ebp)
 969:	e8 e5 fe ff ff       	call   853 <morecore>
 96e:	83 c4 10             	add    $0x10,%esp
 971:	89 45 f4             	mov    %eax,-0xc(%ebp)
 974:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 978:	75 07                	jne    981 <malloc+0xce>
        return 0;
 97a:	b8 00 00 00 00       	mov    $0x0,%eax
 97f:	eb 13                	jmp    994 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 981:	8b 45 f4             	mov    -0xc(%ebp),%eax
 984:	89 45 f0             	mov    %eax,-0x10(%ebp)
 987:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98a:	8b 00                	mov    (%eax),%eax
 98c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 98f:	e9 6d ff ff ff       	jmp    901 <malloc+0x4e>
}
 994:	c9                   	leave  
 995:	c3                   	ret    
