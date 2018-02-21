
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
   e:	81 ec a4 01 00 00    	sub    $0x1a4,%esp

// fork a bunch of infinite loops
    int pid[100];
    int ppid = getpid();
  14:	e8 00 04 00 00       	call   419 <getpid>
  19:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int i = 0;
  1c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (i < 100) {
  23:	eb 30                	jmp    55 <main+0x55>
        pid[i] = fork();
  25:	e8 67 03 00 00       	call   391 <fork>
  2a:	89 c2                	mov    %eax,%edx
  2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2f:	89 94 85 60 fe ff ff 	mov    %edx,-0x1a0(%ebp,%eax,4)
        if (ppid != getpid()) {
  36:	e8 de 03 00 00       	call   419 <getpid>
  3b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  3e:	74 02                	je     42 <main+0x42>
            //for(int x = 0; x < 100000000000; x++); // cycle runnable and ready
            //sleep(2000); // put to sleep
            for(;;);
  40:	eb fe                	jmp    40 <main+0x40>
            exit();
        }
        if (pid[i] == -1) {
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	8b 84 85 60 fe ff ff 	mov    -0x1a0(%ebp,%eax,4),%eax
  4c:	83 f8 ff             	cmp    $0xffffffff,%eax
  4f:	74 0c                	je     5d <main+0x5d>
            break;
        }
        i++;
  51:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

// fork a bunch of infinite loops
    int pid[100];
    int ppid = getpid();
    int i = 0;
    while (i < 100) {
  55:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
  59:	7e ca                	jle    25 <main+0x25>
  5b:	eb 01                	jmp    5e <main+0x5e>
            //sleep(2000); // put to sleep
            for(;;);
            exit();
        }
        if (pid[i] == -1) {
            break;
  5d:	90                   	nop
        }
        i++;
    }

    if (ppid == getpid()) {
  5e:	e8 b6 03 00 00       	call   419 <getpid>
  63:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  66:	75 02                	jne    6a <main+0x6a>
        for(;;);
  68:	eb fe                	jmp    68 <main+0x68>
            printf(1, "Reaped %d.\n", pid[j]);
            j++;
        }
        */
    }
    exit();
  6a:	e8 2a 03 00 00       	call   399 <exit>

0000006f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  6f:	55                   	push   %ebp
  70:	89 e5                	mov    %esp,%ebp
  72:	57                   	push   %edi
  73:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  74:	8b 4d 08             	mov    0x8(%ebp),%ecx
  77:	8b 55 10             	mov    0x10(%ebp),%edx
  7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  7d:	89 cb                	mov    %ecx,%ebx
  7f:	89 df                	mov    %ebx,%edi
  81:	89 d1                	mov    %edx,%ecx
  83:	fc                   	cld    
  84:	f3 aa                	rep stos %al,%es:(%edi)
  86:	89 ca                	mov    %ecx,%edx
  88:	89 fb                	mov    %edi,%ebx
  8a:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  90:	90                   	nop
  91:	5b                   	pop    %ebx
  92:	5f                   	pop    %edi
  93:	5d                   	pop    %ebp
  94:	c3                   	ret    

00000095 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  95:	55                   	push   %ebp
  96:	89 e5                	mov    %esp,%ebp
  98:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  9b:	8b 45 08             	mov    0x8(%ebp),%eax
  9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a1:	90                   	nop
  a2:	8b 45 08             	mov    0x8(%ebp),%eax
  a5:	8d 50 01             	lea    0x1(%eax),%edx
  a8:	89 55 08             	mov    %edx,0x8(%ebp)
  ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  ae:	8d 4a 01             	lea    0x1(%edx),%ecx
  b1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b4:	0f b6 12             	movzbl (%edx),%edx
  b7:	88 10                	mov    %dl,(%eax)
  b9:	0f b6 00             	movzbl (%eax),%eax
  bc:	84 c0                	test   %al,%al
  be:	75 e2                	jne    a2 <strcpy+0xd>
    ;
  return os;
  c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c3:	c9                   	leave  
  c4:	c3                   	ret    

000000c5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c5:	55                   	push   %ebp
  c6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c8:	eb 08                	jmp    d2 <strcmp+0xd>
    p++, q++;
  ca:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ce:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	0f b6 00             	movzbl (%eax),%eax
  d8:	84 c0                	test   %al,%al
  da:	74 10                	je     ec <strcmp+0x27>
  dc:	8b 45 08             	mov    0x8(%ebp),%eax
  df:	0f b6 10             	movzbl (%eax),%edx
  e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  e5:	0f b6 00             	movzbl (%eax),%eax
  e8:	38 c2                	cmp    %al,%dl
  ea:	74 de                	je     ca <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  ec:	8b 45 08             	mov    0x8(%ebp),%eax
  ef:	0f b6 00             	movzbl (%eax),%eax
  f2:	0f b6 d0             	movzbl %al,%edx
  f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  f8:	0f b6 00             	movzbl (%eax),%eax
  fb:	0f b6 c0             	movzbl %al,%eax
  fe:	29 c2                	sub    %eax,%edx
 100:	89 d0                	mov    %edx,%eax
}
 102:	5d                   	pop    %ebp
 103:	c3                   	ret    

00000104 <strlen>:

uint
strlen(char *s)
{
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 111:	eb 04                	jmp    117 <strlen+0x13>
 113:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 117:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11a:	8b 45 08             	mov    0x8(%ebp),%eax
 11d:	01 d0                	add    %edx,%eax
 11f:	0f b6 00             	movzbl (%eax),%eax
 122:	84 c0                	test   %al,%al
 124:	75 ed                	jne    113 <strlen+0xf>
    ;
  return n;
 126:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 129:	c9                   	leave  
 12a:	c3                   	ret    

0000012b <memset>:

void*
memset(void *dst, int c, uint n)
{
 12b:	55                   	push   %ebp
 12c:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 12e:	8b 45 10             	mov    0x10(%ebp),%eax
 131:	50                   	push   %eax
 132:	ff 75 0c             	pushl  0xc(%ebp)
 135:	ff 75 08             	pushl  0x8(%ebp)
 138:	e8 32 ff ff ff       	call   6f <stosb>
 13d:	83 c4 0c             	add    $0xc,%esp
  return dst;
 140:	8b 45 08             	mov    0x8(%ebp),%eax
}
 143:	c9                   	leave  
 144:	c3                   	ret    

00000145 <strchr>:

char*
strchr(const char *s, char c)
{
 145:	55                   	push   %ebp
 146:	89 e5                	mov    %esp,%ebp
 148:	83 ec 04             	sub    $0x4,%esp
 14b:	8b 45 0c             	mov    0xc(%ebp),%eax
 14e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 151:	eb 14                	jmp    167 <strchr+0x22>
    if(*s == c)
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	0f b6 00             	movzbl (%eax),%eax
 159:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15c:	75 05                	jne    163 <strchr+0x1e>
      return (char*)s;
 15e:	8b 45 08             	mov    0x8(%ebp),%eax
 161:	eb 13                	jmp    176 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 163:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	0f b6 00             	movzbl (%eax),%eax
 16d:	84 c0                	test   %al,%al
 16f:	75 e2                	jne    153 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 171:	b8 00 00 00 00       	mov    $0x0,%eax
}
 176:	c9                   	leave  
 177:	c3                   	ret    

00000178 <gets>:

char*
gets(char *buf, int max)
{
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 185:	eb 42                	jmp    1c9 <gets+0x51>
    cc = read(0, &c, 1);
 187:	83 ec 04             	sub    $0x4,%esp
 18a:	6a 01                	push   $0x1
 18c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 18f:	50                   	push   %eax
 190:	6a 00                	push   $0x0
 192:	e8 1a 02 00 00       	call   3b1 <read>
 197:	83 c4 10             	add    $0x10,%esp
 19a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 19d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a1:	7e 33                	jle    1d6 <gets+0x5e>
      break;
    buf[i++] = c;
 1a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a6:	8d 50 01             	lea    0x1(%eax),%edx
 1a9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1ac:	89 c2                	mov    %eax,%edx
 1ae:	8b 45 08             	mov    0x8(%ebp),%eax
 1b1:	01 c2                	add    %eax,%edx
 1b3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1b7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1b9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bd:	3c 0a                	cmp    $0xa,%al
 1bf:	74 16                	je     1d7 <gets+0x5f>
 1c1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c5:	3c 0d                	cmp    $0xd,%al
 1c7:	74 0e                	je     1d7 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cc:	83 c0 01             	add    $0x1,%eax
 1cf:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1d2:	7c b3                	jl     187 <gets+0xf>
 1d4:	eb 01                	jmp    1d7 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1d6:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1da:	8b 45 08             	mov    0x8(%ebp),%eax
 1dd:	01 d0                	add    %edx,%eax
 1df:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e5:	c9                   	leave  
 1e6:	c3                   	ret    

000001e7 <stat>:

int
stat(char *n, struct stat *st)
{
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
 1ea:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ed:	83 ec 08             	sub    $0x8,%esp
 1f0:	6a 00                	push   $0x0
 1f2:	ff 75 08             	pushl  0x8(%ebp)
 1f5:	e8 df 01 00 00       	call   3d9 <open>
 1fa:	83 c4 10             	add    $0x10,%esp
 1fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 200:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 204:	79 07                	jns    20d <stat+0x26>
    return -1;
 206:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20b:	eb 25                	jmp    232 <stat+0x4b>
  r = fstat(fd, st);
 20d:	83 ec 08             	sub    $0x8,%esp
 210:	ff 75 0c             	pushl  0xc(%ebp)
 213:	ff 75 f4             	pushl  -0xc(%ebp)
 216:	e8 d6 01 00 00       	call   3f1 <fstat>
 21b:	83 c4 10             	add    $0x10,%esp
 21e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 221:	83 ec 0c             	sub    $0xc,%esp
 224:	ff 75 f4             	pushl  -0xc(%ebp)
 227:	e8 95 01 00 00       	call   3c1 <close>
 22c:	83 c4 10             	add    $0x10,%esp
  return r;
 22f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 232:	c9                   	leave  
 233:	c3                   	ret    

00000234 <atoi>:

int
atoi(const char *s)
{
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 23a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 241:	eb 04                	jmp    247 <atoi+0x13>
 243:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	0f b6 00             	movzbl (%eax),%eax
 24d:	3c 20                	cmp    $0x20,%al
 24f:	74 f2                	je     243 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 251:	8b 45 08             	mov    0x8(%ebp),%eax
 254:	0f b6 00             	movzbl (%eax),%eax
 257:	3c 2d                	cmp    $0x2d,%al
 259:	75 07                	jne    262 <atoi+0x2e>
 25b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 260:	eb 05                	jmp    267 <atoi+0x33>
 262:	b8 01 00 00 00       	mov    $0x1,%eax
 267:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	0f b6 00             	movzbl (%eax),%eax
 270:	3c 2b                	cmp    $0x2b,%al
 272:	74 0a                	je     27e <atoi+0x4a>
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	0f b6 00             	movzbl (%eax),%eax
 27a:	3c 2d                	cmp    $0x2d,%al
 27c:	75 2b                	jne    2a9 <atoi+0x75>
    s++;
 27e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 282:	eb 25                	jmp    2a9 <atoi+0x75>
    n = n*10 + *s++ - '0';
 284:	8b 55 fc             	mov    -0x4(%ebp),%edx
 287:	89 d0                	mov    %edx,%eax
 289:	c1 e0 02             	shl    $0x2,%eax
 28c:	01 d0                	add    %edx,%eax
 28e:	01 c0                	add    %eax,%eax
 290:	89 c1                	mov    %eax,%ecx
 292:	8b 45 08             	mov    0x8(%ebp),%eax
 295:	8d 50 01             	lea    0x1(%eax),%edx
 298:	89 55 08             	mov    %edx,0x8(%ebp)
 29b:	0f b6 00             	movzbl (%eax),%eax
 29e:	0f be c0             	movsbl %al,%eax
 2a1:	01 c8                	add    %ecx,%eax
 2a3:	83 e8 30             	sub    $0x30,%eax
 2a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 2a9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ac:	0f b6 00             	movzbl (%eax),%eax
 2af:	3c 2f                	cmp    $0x2f,%al
 2b1:	7e 0a                	jle    2bd <atoi+0x89>
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	0f b6 00             	movzbl (%eax),%eax
 2b9:	3c 39                	cmp    $0x39,%al
 2bb:	7e c7                	jle    284 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 2bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2c0:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <atoo>:

int
atoo(const char *s)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2d3:	eb 04                	jmp    2d9 <atoo+0x13>
 2d5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	0f b6 00             	movzbl (%eax),%eax
 2df:	3c 20                	cmp    $0x20,%al
 2e1:	74 f2                	je     2d5 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	0f b6 00             	movzbl (%eax),%eax
 2e9:	3c 2d                	cmp    $0x2d,%al
 2eb:	75 07                	jne    2f4 <atoo+0x2e>
 2ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2f2:	eb 05                	jmp    2f9 <atoo+0x33>
 2f4:	b8 01 00 00 00       	mov    $0x1,%eax
 2f9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	0f b6 00             	movzbl (%eax),%eax
 302:	3c 2b                	cmp    $0x2b,%al
 304:	74 0a                	je     310 <atoo+0x4a>
 306:	8b 45 08             	mov    0x8(%ebp),%eax
 309:	0f b6 00             	movzbl (%eax),%eax
 30c:	3c 2d                	cmp    $0x2d,%al
 30e:	75 27                	jne    337 <atoo+0x71>
    s++;
 310:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 314:	eb 21                	jmp    337 <atoo+0x71>
    n = n*8 + *s++ - '0';
 316:	8b 45 fc             	mov    -0x4(%ebp),%eax
 319:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 320:	8b 45 08             	mov    0x8(%ebp),%eax
 323:	8d 50 01             	lea    0x1(%eax),%edx
 326:	89 55 08             	mov    %edx,0x8(%ebp)
 329:	0f b6 00             	movzbl (%eax),%eax
 32c:	0f be c0             	movsbl %al,%eax
 32f:	01 c8                	add    %ecx,%eax
 331:	83 e8 30             	sub    $0x30,%eax
 334:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 337:	8b 45 08             	mov    0x8(%ebp),%eax
 33a:	0f b6 00             	movzbl (%eax),%eax
 33d:	3c 2f                	cmp    $0x2f,%al
 33f:	7e 0a                	jle    34b <atoo+0x85>
 341:	8b 45 08             	mov    0x8(%ebp),%eax
 344:	0f b6 00             	movzbl (%eax),%eax
 347:	3c 37                	cmp    $0x37,%al
 349:	7e cb                	jle    316 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 34b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 34e:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 352:	c9                   	leave  
 353:	c3                   	ret    

00000354 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 35a:	8b 45 08             	mov    0x8(%ebp),%eax
 35d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 360:	8b 45 0c             	mov    0xc(%ebp),%eax
 363:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 366:	eb 17                	jmp    37f <memmove+0x2b>
    *dst++ = *src++;
 368:	8b 45 fc             	mov    -0x4(%ebp),%eax
 36b:	8d 50 01             	lea    0x1(%eax),%edx
 36e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 371:	8b 55 f8             	mov    -0x8(%ebp),%edx
 374:	8d 4a 01             	lea    0x1(%edx),%ecx
 377:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 37a:	0f b6 12             	movzbl (%edx),%edx
 37d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 37f:	8b 45 10             	mov    0x10(%ebp),%eax
 382:	8d 50 ff             	lea    -0x1(%eax),%edx
 385:	89 55 10             	mov    %edx,0x10(%ebp)
 388:	85 c0                	test   %eax,%eax
 38a:	7f dc                	jg     368 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 38c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 38f:	c9                   	leave  
 390:	c3                   	ret    

00000391 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 391:	b8 01 00 00 00       	mov    $0x1,%eax
 396:	cd 40                	int    $0x40
 398:	c3                   	ret    

00000399 <exit>:
SYSCALL(exit)
 399:	b8 02 00 00 00       	mov    $0x2,%eax
 39e:	cd 40                	int    $0x40
 3a0:	c3                   	ret    

000003a1 <wait>:
SYSCALL(wait)
 3a1:	b8 03 00 00 00       	mov    $0x3,%eax
 3a6:	cd 40                	int    $0x40
 3a8:	c3                   	ret    

000003a9 <pipe>:
SYSCALL(pipe)
 3a9:	b8 04 00 00 00       	mov    $0x4,%eax
 3ae:	cd 40                	int    $0x40
 3b0:	c3                   	ret    

000003b1 <read>:
SYSCALL(read)
 3b1:	b8 05 00 00 00       	mov    $0x5,%eax
 3b6:	cd 40                	int    $0x40
 3b8:	c3                   	ret    

000003b9 <write>:
SYSCALL(write)
 3b9:	b8 10 00 00 00       	mov    $0x10,%eax
 3be:	cd 40                	int    $0x40
 3c0:	c3                   	ret    

000003c1 <close>:
SYSCALL(close)
 3c1:	b8 15 00 00 00       	mov    $0x15,%eax
 3c6:	cd 40                	int    $0x40
 3c8:	c3                   	ret    

000003c9 <kill>:
SYSCALL(kill)
 3c9:	b8 06 00 00 00       	mov    $0x6,%eax
 3ce:	cd 40                	int    $0x40
 3d0:	c3                   	ret    

000003d1 <exec>:
SYSCALL(exec)
 3d1:	b8 07 00 00 00       	mov    $0x7,%eax
 3d6:	cd 40                	int    $0x40
 3d8:	c3                   	ret    

000003d9 <open>:
SYSCALL(open)
 3d9:	b8 0f 00 00 00       	mov    $0xf,%eax
 3de:	cd 40                	int    $0x40
 3e0:	c3                   	ret    

000003e1 <mknod>:
SYSCALL(mknod)
 3e1:	b8 11 00 00 00       	mov    $0x11,%eax
 3e6:	cd 40                	int    $0x40
 3e8:	c3                   	ret    

000003e9 <unlink>:
SYSCALL(unlink)
 3e9:	b8 12 00 00 00       	mov    $0x12,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <fstat>:
SYSCALL(fstat)
 3f1:	b8 08 00 00 00       	mov    $0x8,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <link>:
SYSCALL(link)
 3f9:	b8 13 00 00 00       	mov    $0x13,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <mkdir>:
SYSCALL(mkdir)
 401:	b8 14 00 00 00       	mov    $0x14,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <chdir>:
SYSCALL(chdir)
 409:	b8 09 00 00 00       	mov    $0x9,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <dup>:
SYSCALL(dup)
 411:	b8 0a 00 00 00       	mov    $0xa,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <getpid>:
SYSCALL(getpid)
 419:	b8 0b 00 00 00       	mov    $0xb,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <sbrk>:
SYSCALL(sbrk)
 421:	b8 0c 00 00 00       	mov    $0xc,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <sleep>:
SYSCALL(sleep)
 429:	b8 0d 00 00 00       	mov    $0xd,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <uptime>:
SYSCALL(uptime)
 431:	b8 0e 00 00 00       	mov    $0xe,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <halt>:
SYSCALL(halt)
 439:	b8 16 00 00 00       	mov    $0x16,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <date>:
SYSCALL(date)
 441:	b8 17 00 00 00       	mov    $0x17,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <getuid>:
SYSCALL(getuid)
 449:	b8 18 00 00 00       	mov    $0x18,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <getgid>:
SYSCALL(getgid)
 451:	b8 19 00 00 00       	mov    $0x19,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <getppid>:
SYSCALL(getppid)
 459:	b8 1a 00 00 00       	mov    $0x1a,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <setuid>:
SYSCALL(setuid)
 461:	b8 1b 00 00 00       	mov    $0x1b,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <setgid>:
SYSCALL(setgid)
 469:	b8 1c 00 00 00       	mov    $0x1c,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <getprocs>:
SYSCALL(getprocs)
 471:	b8 1d 00 00 00       	mov    $0x1d,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <setpriority>:
SYSCALL(setpriority)
 479:	b8 1e 00 00 00       	mov    $0x1e,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 481:	55                   	push   %ebp
 482:	89 e5                	mov    %esp,%ebp
 484:	83 ec 18             	sub    $0x18,%esp
 487:	8b 45 0c             	mov    0xc(%ebp),%eax
 48a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 48d:	83 ec 04             	sub    $0x4,%esp
 490:	6a 01                	push   $0x1
 492:	8d 45 f4             	lea    -0xc(%ebp),%eax
 495:	50                   	push   %eax
 496:	ff 75 08             	pushl  0x8(%ebp)
 499:	e8 1b ff ff ff       	call   3b9 <write>
 49e:	83 c4 10             	add    $0x10,%esp
}
 4a1:	90                   	nop
 4a2:	c9                   	leave  
 4a3:	c3                   	ret    

000004a4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4a4:	55                   	push   %ebp
 4a5:	89 e5                	mov    %esp,%ebp
 4a7:	53                   	push   %ebx
 4a8:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4b2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4b6:	74 17                	je     4cf <printint+0x2b>
 4b8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4bc:	79 11                	jns    4cf <printint+0x2b>
    neg = 1;
 4be:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c8:	f7 d8                	neg    %eax
 4ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4cd:	eb 06                	jmp    4d5 <printint+0x31>
  } else {
    x = xx;
 4cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4dc:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4df:	8d 41 01             	lea    0x1(%ecx),%eax
 4e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4e5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4eb:	ba 00 00 00 00       	mov    $0x0,%edx
 4f0:	f7 f3                	div    %ebx
 4f2:	89 d0                	mov    %edx,%eax
 4f4:	0f b6 80 80 0b 00 00 	movzbl 0xb80(%eax),%eax
 4fb:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4ff:	8b 5d 10             	mov    0x10(%ebp),%ebx
 502:	8b 45 ec             	mov    -0x14(%ebp),%eax
 505:	ba 00 00 00 00       	mov    $0x0,%edx
 50a:	f7 f3                	div    %ebx
 50c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 50f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 513:	75 c7                	jne    4dc <printint+0x38>
  if(neg)
 515:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 519:	74 2d                	je     548 <printint+0xa4>
    buf[i++] = '-';
 51b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51e:	8d 50 01             	lea    0x1(%eax),%edx
 521:	89 55 f4             	mov    %edx,-0xc(%ebp)
 524:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 529:	eb 1d                	jmp    548 <printint+0xa4>
    putc(fd, buf[i]);
 52b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 52e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 531:	01 d0                	add    %edx,%eax
 533:	0f b6 00             	movzbl (%eax),%eax
 536:	0f be c0             	movsbl %al,%eax
 539:	83 ec 08             	sub    $0x8,%esp
 53c:	50                   	push   %eax
 53d:	ff 75 08             	pushl  0x8(%ebp)
 540:	e8 3c ff ff ff       	call   481 <putc>
 545:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 548:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 54c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 550:	79 d9                	jns    52b <printint+0x87>
    putc(fd, buf[i]);
}
 552:	90                   	nop
 553:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 556:	c9                   	leave  
 557:	c3                   	ret    

00000558 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 558:	55                   	push   %ebp
 559:	89 e5                	mov    %esp,%ebp
 55b:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 55e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 565:	8d 45 0c             	lea    0xc(%ebp),%eax
 568:	83 c0 04             	add    $0x4,%eax
 56b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 56e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 575:	e9 59 01 00 00       	jmp    6d3 <printf+0x17b>
    c = fmt[i] & 0xff;
 57a:	8b 55 0c             	mov    0xc(%ebp),%edx
 57d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 580:	01 d0                	add    %edx,%eax
 582:	0f b6 00             	movzbl (%eax),%eax
 585:	0f be c0             	movsbl %al,%eax
 588:	25 ff 00 00 00       	and    $0xff,%eax
 58d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 590:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 594:	75 2c                	jne    5c2 <printf+0x6a>
      if(c == '%'){
 596:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 59a:	75 0c                	jne    5a8 <printf+0x50>
        state = '%';
 59c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5a3:	e9 27 01 00 00       	jmp    6cf <printf+0x177>
      } else {
        putc(fd, c);
 5a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ab:	0f be c0             	movsbl %al,%eax
 5ae:	83 ec 08             	sub    $0x8,%esp
 5b1:	50                   	push   %eax
 5b2:	ff 75 08             	pushl  0x8(%ebp)
 5b5:	e8 c7 fe ff ff       	call   481 <putc>
 5ba:	83 c4 10             	add    $0x10,%esp
 5bd:	e9 0d 01 00 00       	jmp    6cf <printf+0x177>
      }
    } else if(state == '%'){
 5c2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5c6:	0f 85 03 01 00 00    	jne    6cf <printf+0x177>
      if(c == 'd'){
 5cc:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5d0:	75 1e                	jne    5f0 <printf+0x98>
        printint(fd, *ap, 10, 1);
 5d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d5:	8b 00                	mov    (%eax),%eax
 5d7:	6a 01                	push   $0x1
 5d9:	6a 0a                	push   $0xa
 5db:	50                   	push   %eax
 5dc:	ff 75 08             	pushl  0x8(%ebp)
 5df:	e8 c0 fe ff ff       	call   4a4 <printint>
 5e4:	83 c4 10             	add    $0x10,%esp
        ap++;
 5e7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5eb:	e9 d8 00 00 00       	jmp    6c8 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5f0:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5f4:	74 06                	je     5fc <printf+0xa4>
 5f6:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5fa:	75 1e                	jne    61a <printf+0xc2>
        printint(fd, *ap, 16, 0);
 5fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ff:	8b 00                	mov    (%eax),%eax
 601:	6a 00                	push   $0x0
 603:	6a 10                	push   $0x10
 605:	50                   	push   %eax
 606:	ff 75 08             	pushl  0x8(%ebp)
 609:	e8 96 fe ff ff       	call   4a4 <printint>
 60e:	83 c4 10             	add    $0x10,%esp
        ap++;
 611:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 615:	e9 ae 00 00 00       	jmp    6c8 <printf+0x170>
      } else if(c == 's'){
 61a:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 61e:	75 43                	jne    663 <printf+0x10b>
        s = (char*)*ap;
 620:	8b 45 e8             	mov    -0x18(%ebp),%eax
 623:	8b 00                	mov    (%eax),%eax
 625:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 628:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 62c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 630:	75 25                	jne    657 <printf+0xff>
          s = "(null)";
 632:	c7 45 f4 0e 09 00 00 	movl   $0x90e,-0xc(%ebp)
        while(*s != 0){
 639:	eb 1c                	jmp    657 <printf+0xff>
          putc(fd, *s);
 63b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63e:	0f b6 00             	movzbl (%eax),%eax
 641:	0f be c0             	movsbl %al,%eax
 644:	83 ec 08             	sub    $0x8,%esp
 647:	50                   	push   %eax
 648:	ff 75 08             	pushl  0x8(%ebp)
 64b:	e8 31 fe ff ff       	call   481 <putc>
 650:	83 c4 10             	add    $0x10,%esp
          s++;
 653:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 657:	8b 45 f4             	mov    -0xc(%ebp),%eax
 65a:	0f b6 00             	movzbl (%eax),%eax
 65d:	84 c0                	test   %al,%al
 65f:	75 da                	jne    63b <printf+0xe3>
 661:	eb 65                	jmp    6c8 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 663:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 667:	75 1d                	jne    686 <printf+0x12e>
        putc(fd, *ap);
 669:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66c:	8b 00                	mov    (%eax),%eax
 66e:	0f be c0             	movsbl %al,%eax
 671:	83 ec 08             	sub    $0x8,%esp
 674:	50                   	push   %eax
 675:	ff 75 08             	pushl  0x8(%ebp)
 678:	e8 04 fe ff ff       	call   481 <putc>
 67d:	83 c4 10             	add    $0x10,%esp
        ap++;
 680:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 684:	eb 42                	jmp    6c8 <printf+0x170>
      } else if(c == '%'){
 686:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 68a:	75 17                	jne    6a3 <printf+0x14b>
        putc(fd, c);
 68c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 68f:	0f be c0             	movsbl %al,%eax
 692:	83 ec 08             	sub    $0x8,%esp
 695:	50                   	push   %eax
 696:	ff 75 08             	pushl  0x8(%ebp)
 699:	e8 e3 fd ff ff       	call   481 <putc>
 69e:	83 c4 10             	add    $0x10,%esp
 6a1:	eb 25                	jmp    6c8 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6a3:	83 ec 08             	sub    $0x8,%esp
 6a6:	6a 25                	push   $0x25
 6a8:	ff 75 08             	pushl  0x8(%ebp)
 6ab:	e8 d1 fd ff ff       	call   481 <putc>
 6b0:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b6:	0f be c0             	movsbl %al,%eax
 6b9:	83 ec 08             	sub    $0x8,%esp
 6bc:	50                   	push   %eax
 6bd:	ff 75 08             	pushl  0x8(%ebp)
 6c0:	e8 bc fd ff ff       	call   481 <putc>
 6c5:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6cf:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6d3:	8b 55 0c             	mov    0xc(%ebp),%edx
 6d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d9:	01 d0                	add    %edx,%eax
 6db:	0f b6 00             	movzbl (%eax),%eax
 6de:	84 c0                	test   %al,%al
 6e0:	0f 85 94 fe ff ff    	jne    57a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6e6:	90                   	nop
 6e7:	c9                   	leave  
 6e8:	c3                   	ret    

000006e9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e9:	55                   	push   %ebp
 6ea:	89 e5                	mov    %esp,%ebp
 6ec:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ef:	8b 45 08             	mov    0x8(%ebp),%eax
 6f2:	83 e8 08             	sub    $0x8,%eax
 6f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f8:	a1 9c 0b 00 00       	mov    0xb9c,%eax
 6fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 700:	eb 24                	jmp    726 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 702:	8b 45 fc             	mov    -0x4(%ebp),%eax
 705:	8b 00                	mov    (%eax),%eax
 707:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 70a:	77 12                	ja     71e <free+0x35>
 70c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 712:	77 24                	ja     738 <free+0x4f>
 714:	8b 45 fc             	mov    -0x4(%ebp),%eax
 717:	8b 00                	mov    (%eax),%eax
 719:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 71c:	77 1a                	ja     738 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 721:	8b 00                	mov    (%eax),%eax
 723:	89 45 fc             	mov    %eax,-0x4(%ebp)
 726:	8b 45 f8             	mov    -0x8(%ebp),%eax
 729:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 72c:	76 d4                	jbe    702 <free+0x19>
 72e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 731:	8b 00                	mov    (%eax),%eax
 733:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 736:	76 ca                	jbe    702 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 738:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73b:	8b 40 04             	mov    0x4(%eax),%eax
 73e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 745:	8b 45 f8             	mov    -0x8(%ebp),%eax
 748:	01 c2                	add    %eax,%edx
 74a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74d:	8b 00                	mov    (%eax),%eax
 74f:	39 c2                	cmp    %eax,%edx
 751:	75 24                	jne    777 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 753:	8b 45 f8             	mov    -0x8(%ebp),%eax
 756:	8b 50 04             	mov    0x4(%eax),%edx
 759:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75c:	8b 00                	mov    (%eax),%eax
 75e:	8b 40 04             	mov    0x4(%eax),%eax
 761:	01 c2                	add    %eax,%edx
 763:	8b 45 f8             	mov    -0x8(%ebp),%eax
 766:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 769:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76c:	8b 00                	mov    (%eax),%eax
 76e:	8b 10                	mov    (%eax),%edx
 770:	8b 45 f8             	mov    -0x8(%ebp),%eax
 773:	89 10                	mov    %edx,(%eax)
 775:	eb 0a                	jmp    781 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 777:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77a:	8b 10                	mov    (%eax),%edx
 77c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 781:	8b 45 fc             	mov    -0x4(%ebp),%eax
 784:	8b 40 04             	mov    0x4(%eax),%eax
 787:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 78e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 791:	01 d0                	add    %edx,%eax
 793:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 796:	75 20                	jne    7b8 <free+0xcf>
    p->s.size += bp->s.size;
 798:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79b:	8b 50 04             	mov    0x4(%eax),%edx
 79e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a1:	8b 40 04             	mov    0x4(%eax),%eax
 7a4:	01 c2                	add    %eax,%edx
 7a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a9:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7af:	8b 10                	mov    (%eax),%edx
 7b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b4:	89 10                	mov    %edx,(%eax)
 7b6:	eb 08                	jmp    7c0 <free+0xd7>
  } else
    p->s.ptr = bp;
 7b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bb:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7be:	89 10                	mov    %edx,(%eax)
  freep = p;
 7c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c3:	a3 9c 0b 00 00       	mov    %eax,0xb9c
}
 7c8:	90                   	nop
 7c9:	c9                   	leave  
 7ca:	c3                   	ret    

000007cb <morecore>:

static Header*
morecore(uint nu)
{
 7cb:	55                   	push   %ebp
 7cc:	89 e5                	mov    %esp,%ebp
 7ce:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7d1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7d8:	77 07                	ja     7e1 <morecore+0x16>
    nu = 4096;
 7da:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7e1:	8b 45 08             	mov    0x8(%ebp),%eax
 7e4:	c1 e0 03             	shl    $0x3,%eax
 7e7:	83 ec 0c             	sub    $0xc,%esp
 7ea:	50                   	push   %eax
 7eb:	e8 31 fc ff ff       	call   421 <sbrk>
 7f0:	83 c4 10             	add    $0x10,%esp
 7f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7f6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7fa:	75 07                	jne    803 <morecore+0x38>
    return 0;
 7fc:	b8 00 00 00 00       	mov    $0x0,%eax
 801:	eb 26                	jmp    829 <morecore+0x5e>
  hp = (Header*)p;
 803:	8b 45 f4             	mov    -0xc(%ebp),%eax
 806:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 809:	8b 45 f0             	mov    -0x10(%ebp),%eax
 80c:	8b 55 08             	mov    0x8(%ebp),%edx
 80f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 812:	8b 45 f0             	mov    -0x10(%ebp),%eax
 815:	83 c0 08             	add    $0x8,%eax
 818:	83 ec 0c             	sub    $0xc,%esp
 81b:	50                   	push   %eax
 81c:	e8 c8 fe ff ff       	call   6e9 <free>
 821:	83 c4 10             	add    $0x10,%esp
  return freep;
 824:	a1 9c 0b 00 00       	mov    0xb9c,%eax
}
 829:	c9                   	leave  
 82a:	c3                   	ret    

0000082b <malloc>:

void*
malloc(uint nbytes)
{
 82b:	55                   	push   %ebp
 82c:	89 e5                	mov    %esp,%ebp
 82e:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 831:	8b 45 08             	mov    0x8(%ebp),%eax
 834:	83 c0 07             	add    $0x7,%eax
 837:	c1 e8 03             	shr    $0x3,%eax
 83a:	83 c0 01             	add    $0x1,%eax
 83d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 840:	a1 9c 0b 00 00       	mov    0xb9c,%eax
 845:	89 45 f0             	mov    %eax,-0x10(%ebp)
 848:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 84c:	75 23                	jne    871 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 84e:	c7 45 f0 94 0b 00 00 	movl   $0xb94,-0x10(%ebp)
 855:	8b 45 f0             	mov    -0x10(%ebp),%eax
 858:	a3 9c 0b 00 00       	mov    %eax,0xb9c
 85d:	a1 9c 0b 00 00       	mov    0xb9c,%eax
 862:	a3 94 0b 00 00       	mov    %eax,0xb94
    base.s.size = 0;
 867:	c7 05 98 0b 00 00 00 	movl   $0x0,0xb98
 86e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 871:	8b 45 f0             	mov    -0x10(%ebp),%eax
 874:	8b 00                	mov    (%eax),%eax
 876:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 879:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87c:	8b 40 04             	mov    0x4(%eax),%eax
 87f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 882:	72 4d                	jb     8d1 <malloc+0xa6>
      if(p->s.size == nunits)
 884:	8b 45 f4             	mov    -0xc(%ebp),%eax
 887:	8b 40 04             	mov    0x4(%eax),%eax
 88a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 88d:	75 0c                	jne    89b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 88f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 892:	8b 10                	mov    (%eax),%edx
 894:	8b 45 f0             	mov    -0x10(%ebp),%eax
 897:	89 10                	mov    %edx,(%eax)
 899:	eb 26                	jmp    8c1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 89b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89e:	8b 40 04             	mov    0x4(%eax),%eax
 8a1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8a4:	89 c2                	mov    %eax,%edx
 8a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8af:	8b 40 04             	mov    0x4(%eax),%eax
 8b2:	c1 e0 03             	shl    $0x3,%eax
 8b5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8be:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c4:	a3 9c 0b 00 00       	mov    %eax,0xb9c
      return (void*)(p + 1);
 8c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cc:	83 c0 08             	add    $0x8,%eax
 8cf:	eb 3b                	jmp    90c <malloc+0xe1>
    }
    if(p == freep)
 8d1:	a1 9c 0b 00 00       	mov    0xb9c,%eax
 8d6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8d9:	75 1e                	jne    8f9 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8db:	83 ec 0c             	sub    $0xc,%esp
 8de:	ff 75 ec             	pushl  -0x14(%ebp)
 8e1:	e8 e5 fe ff ff       	call   7cb <morecore>
 8e6:	83 c4 10             	add    $0x10,%esp
 8e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8f0:	75 07                	jne    8f9 <malloc+0xce>
        return 0;
 8f2:	b8 00 00 00 00       	mov    $0x0,%eax
 8f7:	eb 13                	jmp    90c <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 902:	8b 00                	mov    (%eax),%eax
 904:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 907:	e9 6d ff ff ff       	jmp    879 <malloc+0x4e>
}
 90c:	c9                   	leave  
 90d:	c3                   	ret    
