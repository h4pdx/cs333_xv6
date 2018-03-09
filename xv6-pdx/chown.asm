
_chown:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
// Argument order is reversed for syscall
// syscall - chown(TARGET, OWNER);
// usercmd - chown OWNER TARGET

int
main(int argc, char **argv) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
    if (argc != 3) {
  14:	83 3b 03             	cmpl   $0x3,(%ebx)
  17:	74 17                	je     30 <main+0x30>
        printf(1, "Invalid arguments.\n"); // no more, no less, than 3
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 58 09 00 00       	push   $0x958
  21:	6a 01                	push   $0x1
  23:	e8 7a 05 00 00       	call   5a2 <printf>
  28:	83 c4 10             	add    $0x10,%esp
        exit();
  2b:	e8 9b 03 00 00       	call   3cb <exit>
    }
    char * path;
    int owner, rc;
    owner = atoi(argv[1]); // convert to int
  30:	8b 43 04             	mov    0x4(%ebx),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	83 ec 0c             	sub    $0xc,%esp
  3b:	50                   	push   %eax
  3c:	e8 25 02 00 00       	call   266 <atoi>
  41:	83 c4 10             	add    $0x10,%esp
  44:	89 45 f4             	mov    %eax,-0xc(%ebp)
    path = argv[2]; // already a char*
  47:	8b 43 04             	mov    0x4(%ebx),%eax
  4a:	8b 40 08             	mov    0x8(%eax),%eax
  4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    rc = chown(path, owner); // Arg order is reveresed for system call
  50:	83 ec 08             	sub    $0x8,%esp
  53:	ff 75 f4             	pushl  -0xc(%ebp)
  56:	ff 75 f0             	pushl  -0x10(%ebp)
  59:	e8 5d 04 00 00       	call   4bb <chown>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (rc < 0) {
  64:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  68:	79 32                	jns    9c <main+0x9c>
        if (rc == -1) {
  6a:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
  6e:	75 14                	jne    84 <main+0x84>
            printf(1, "chown: Invalid pathname.\n");
  70:	83 ec 08             	sub    $0x8,%esp
  73:	68 6c 09 00 00       	push   $0x96c
  78:	6a 01                	push   $0x1
  7a:	e8 23 05 00 00       	call   5a2 <printf>
  7f:	83 c4 10             	add    $0x10,%esp
  82:	eb 18                	jmp    9c <main+0x9c>
        }
        else if (rc == -2) {
  84:	83 7d ec fe          	cmpl   $0xfffffffe,-0x14(%ebp)
  88:	75 12                	jne    9c <main+0x9c>
            printf(1, "chown: Invalid UID.\n");
  8a:	83 ec 08             	sub    $0x8,%esp
  8d:	68 86 09 00 00       	push   $0x986
  92:	6a 01                	push   $0x1
  94:	e8 09 05 00 00       	call   5a2 <printf>
  99:	83 c4 10             	add    $0x10,%esp
        }
    }   
    exit();
  9c:	e8 2a 03 00 00       	call   3cb <exit>

000000a1 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  a1:	55                   	push   %ebp
  a2:	89 e5                	mov    %esp,%ebp
  a4:	57                   	push   %edi
  a5:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  a9:	8b 55 10             	mov    0x10(%ebp),%edx
  ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  af:	89 cb                	mov    %ecx,%ebx
  b1:	89 df                	mov    %ebx,%edi
  b3:	89 d1                	mov    %edx,%ecx
  b5:	fc                   	cld    
  b6:	f3 aa                	rep stos %al,%es:(%edi)
  b8:	89 ca                	mov    %ecx,%edx
  ba:	89 fb                	mov    %edi,%ebx
  bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
  bf:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  c2:	90                   	nop
  c3:	5b                   	pop    %ebx
  c4:	5f                   	pop    %edi
  c5:	5d                   	pop    %ebp
  c6:	c3                   	ret    

000000c7 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  c7:	55                   	push   %ebp
  c8:	89 e5                	mov    %esp,%ebp
  ca:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  cd:	8b 45 08             	mov    0x8(%ebp),%eax
  d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  d3:	90                   	nop
  d4:	8b 45 08             	mov    0x8(%ebp),%eax
  d7:	8d 50 01             	lea    0x1(%eax),%edx
  da:	89 55 08             	mov    %edx,0x8(%ebp)
  dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  e0:	8d 4a 01             	lea    0x1(%edx),%ecx
  e3:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  e6:	0f b6 12             	movzbl (%edx),%edx
  e9:	88 10                	mov    %dl,(%eax)
  eb:	0f b6 00             	movzbl (%eax),%eax
  ee:	84 c0                	test   %al,%al
  f0:	75 e2                	jne    d4 <strcpy+0xd>
    ;
  return os;
  f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  f5:	c9                   	leave  
  f6:	c3                   	ret    

000000f7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f7:	55                   	push   %ebp
  f8:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  fa:	eb 08                	jmp    104 <strcmp+0xd>
    p++, q++;
  fc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 100:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 104:	8b 45 08             	mov    0x8(%ebp),%eax
 107:	0f b6 00             	movzbl (%eax),%eax
 10a:	84 c0                	test   %al,%al
 10c:	74 10                	je     11e <strcmp+0x27>
 10e:	8b 45 08             	mov    0x8(%ebp),%eax
 111:	0f b6 10             	movzbl (%eax),%edx
 114:	8b 45 0c             	mov    0xc(%ebp),%eax
 117:	0f b6 00             	movzbl (%eax),%eax
 11a:	38 c2                	cmp    %al,%dl
 11c:	74 de                	je     fc <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 11e:	8b 45 08             	mov    0x8(%ebp),%eax
 121:	0f b6 00             	movzbl (%eax),%eax
 124:	0f b6 d0             	movzbl %al,%edx
 127:	8b 45 0c             	mov    0xc(%ebp),%eax
 12a:	0f b6 00             	movzbl (%eax),%eax
 12d:	0f b6 c0             	movzbl %al,%eax
 130:	29 c2                	sub    %eax,%edx
 132:	89 d0                	mov    %edx,%eax
}
 134:	5d                   	pop    %ebp
 135:	c3                   	ret    

00000136 <strlen>:

uint
strlen(char *s)
{
 136:	55                   	push   %ebp
 137:	89 e5                	mov    %esp,%ebp
 139:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 13c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 143:	eb 04                	jmp    149 <strlen+0x13>
 145:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 149:	8b 55 fc             	mov    -0x4(%ebp),%edx
 14c:	8b 45 08             	mov    0x8(%ebp),%eax
 14f:	01 d0                	add    %edx,%eax
 151:	0f b6 00             	movzbl (%eax),%eax
 154:	84 c0                	test   %al,%al
 156:	75 ed                	jne    145 <strlen+0xf>
    ;
  return n;
 158:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 15b:	c9                   	leave  
 15c:	c3                   	ret    

0000015d <memset>:

void*
memset(void *dst, int c, uint n)
{
 15d:	55                   	push   %ebp
 15e:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 160:	8b 45 10             	mov    0x10(%ebp),%eax
 163:	50                   	push   %eax
 164:	ff 75 0c             	pushl  0xc(%ebp)
 167:	ff 75 08             	pushl  0x8(%ebp)
 16a:	e8 32 ff ff ff       	call   a1 <stosb>
 16f:	83 c4 0c             	add    $0xc,%esp
  return dst;
 172:	8b 45 08             	mov    0x8(%ebp),%eax
}
 175:	c9                   	leave  
 176:	c3                   	ret    

00000177 <strchr>:

char*
strchr(const char *s, char c)
{
 177:	55                   	push   %ebp
 178:	89 e5                	mov    %esp,%ebp
 17a:	83 ec 04             	sub    $0x4,%esp
 17d:	8b 45 0c             	mov    0xc(%ebp),%eax
 180:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 183:	eb 14                	jmp    199 <strchr+0x22>
    if(*s == c)
 185:	8b 45 08             	mov    0x8(%ebp),%eax
 188:	0f b6 00             	movzbl (%eax),%eax
 18b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 18e:	75 05                	jne    195 <strchr+0x1e>
      return (char*)s;
 190:	8b 45 08             	mov    0x8(%ebp),%eax
 193:	eb 13                	jmp    1a8 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 195:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 199:	8b 45 08             	mov    0x8(%ebp),%eax
 19c:	0f b6 00             	movzbl (%eax),%eax
 19f:	84 c0                	test   %al,%al
 1a1:	75 e2                	jne    185 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1a8:	c9                   	leave  
 1a9:	c3                   	ret    

000001aa <gets>:

char*
gets(char *buf, int max)
{
 1aa:	55                   	push   %ebp
 1ab:	89 e5                	mov    %esp,%ebp
 1ad:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1b7:	eb 42                	jmp    1fb <gets+0x51>
    cc = read(0, &c, 1);
 1b9:	83 ec 04             	sub    $0x4,%esp
 1bc:	6a 01                	push   $0x1
 1be:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1c1:	50                   	push   %eax
 1c2:	6a 00                	push   $0x0
 1c4:	e8 1a 02 00 00       	call   3e3 <read>
 1c9:	83 c4 10             	add    $0x10,%esp
 1cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1d3:	7e 33                	jle    208 <gets+0x5e>
      break;
    buf[i++] = c;
 1d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d8:	8d 50 01             	lea    0x1(%eax),%edx
 1db:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1de:	89 c2                	mov    %eax,%edx
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	01 c2                	add    %eax,%edx
 1e5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e9:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1eb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ef:	3c 0a                	cmp    $0xa,%al
 1f1:	74 16                	je     209 <gets+0x5f>
 1f3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f7:	3c 0d                	cmp    $0xd,%al
 1f9:	74 0e                	je     209 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1fe:	83 c0 01             	add    $0x1,%eax
 201:	3b 45 0c             	cmp    0xc(%ebp),%eax
 204:	7c b3                	jl     1b9 <gets+0xf>
 206:	eb 01                	jmp    209 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 208:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 209:	8b 55 f4             	mov    -0xc(%ebp),%edx
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	01 d0                	add    %edx,%eax
 211:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 214:	8b 45 08             	mov    0x8(%ebp),%eax
}
 217:	c9                   	leave  
 218:	c3                   	ret    

00000219 <stat>:

int
stat(char *n, struct stat *st)
{
 219:	55                   	push   %ebp
 21a:	89 e5                	mov    %esp,%ebp
 21c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21f:	83 ec 08             	sub    $0x8,%esp
 222:	6a 00                	push   $0x0
 224:	ff 75 08             	pushl  0x8(%ebp)
 227:	e8 df 01 00 00       	call   40b <open>
 22c:	83 c4 10             	add    $0x10,%esp
 22f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 232:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 236:	79 07                	jns    23f <stat+0x26>
    return -1;
 238:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 23d:	eb 25                	jmp    264 <stat+0x4b>
  r = fstat(fd, st);
 23f:	83 ec 08             	sub    $0x8,%esp
 242:	ff 75 0c             	pushl  0xc(%ebp)
 245:	ff 75 f4             	pushl  -0xc(%ebp)
 248:	e8 d6 01 00 00       	call   423 <fstat>
 24d:	83 c4 10             	add    $0x10,%esp
 250:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 253:	83 ec 0c             	sub    $0xc,%esp
 256:	ff 75 f4             	pushl  -0xc(%ebp)
 259:	e8 95 01 00 00       	call   3f3 <close>
 25e:	83 c4 10             	add    $0x10,%esp
  return r;
 261:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 264:	c9                   	leave  
 265:	c3                   	ret    

00000266 <atoi>:

int
atoi(const char *s)
{
 266:	55                   	push   %ebp
 267:	89 e5                	mov    %esp,%ebp
 269:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 26c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 273:	eb 04                	jmp    279 <atoi+0x13>
 275:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 279:	8b 45 08             	mov    0x8(%ebp),%eax
 27c:	0f b6 00             	movzbl (%eax),%eax
 27f:	3c 20                	cmp    $0x20,%al
 281:	74 f2                	je     275 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	0f b6 00             	movzbl (%eax),%eax
 289:	3c 2d                	cmp    $0x2d,%al
 28b:	75 07                	jne    294 <atoi+0x2e>
 28d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 292:	eb 05                	jmp    299 <atoi+0x33>
 294:	b8 01 00 00 00       	mov    $0x1,%eax
 299:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	0f b6 00             	movzbl (%eax),%eax
 2a2:	3c 2b                	cmp    $0x2b,%al
 2a4:	74 0a                	je     2b0 <atoi+0x4a>
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	0f b6 00             	movzbl (%eax),%eax
 2ac:	3c 2d                	cmp    $0x2d,%al
 2ae:	75 2b                	jne    2db <atoi+0x75>
    s++;
 2b0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 2b4:	eb 25                	jmp    2db <atoi+0x75>
    n = n*10 + *s++ - '0';
 2b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2b9:	89 d0                	mov    %edx,%eax
 2bb:	c1 e0 02             	shl    $0x2,%eax
 2be:	01 d0                	add    %edx,%eax
 2c0:	01 c0                	add    %eax,%eax
 2c2:	89 c1                	mov    %eax,%ecx
 2c4:	8b 45 08             	mov    0x8(%ebp),%eax
 2c7:	8d 50 01             	lea    0x1(%eax),%edx
 2ca:	89 55 08             	mov    %edx,0x8(%ebp)
 2cd:	0f b6 00             	movzbl (%eax),%eax
 2d0:	0f be c0             	movsbl %al,%eax
 2d3:	01 c8                	add    %ecx,%eax
 2d5:	83 e8 30             	sub    $0x30,%eax
 2d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 2db:	8b 45 08             	mov    0x8(%ebp),%eax
 2de:	0f b6 00             	movzbl (%eax),%eax
 2e1:	3c 2f                	cmp    $0x2f,%al
 2e3:	7e 0a                	jle    2ef <atoi+0x89>
 2e5:	8b 45 08             	mov    0x8(%ebp),%eax
 2e8:	0f b6 00             	movzbl (%eax),%eax
 2eb:	3c 39                	cmp    $0x39,%al
 2ed:	7e c7                	jle    2b6 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 2ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2f2:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 2f6:	c9                   	leave  
 2f7:	c3                   	ret    

000002f8 <atoo>:

int
atoo(const char *s)
{
 2f8:	55                   	push   %ebp
 2f9:	89 e5                	mov    %esp,%ebp
 2fb:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2fe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 305:	eb 04                	jmp    30b <atoo+0x13>
 307:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 30b:	8b 45 08             	mov    0x8(%ebp),%eax
 30e:	0f b6 00             	movzbl (%eax),%eax
 311:	3c 20                	cmp    $0x20,%al
 313:	74 f2                	je     307 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 315:	8b 45 08             	mov    0x8(%ebp),%eax
 318:	0f b6 00             	movzbl (%eax),%eax
 31b:	3c 2d                	cmp    $0x2d,%al
 31d:	75 07                	jne    326 <atoo+0x2e>
 31f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 324:	eb 05                	jmp    32b <atoo+0x33>
 326:	b8 01 00 00 00       	mov    $0x1,%eax
 32b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 32e:	8b 45 08             	mov    0x8(%ebp),%eax
 331:	0f b6 00             	movzbl (%eax),%eax
 334:	3c 2b                	cmp    $0x2b,%al
 336:	74 0a                	je     342 <atoo+0x4a>
 338:	8b 45 08             	mov    0x8(%ebp),%eax
 33b:	0f b6 00             	movzbl (%eax),%eax
 33e:	3c 2d                	cmp    $0x2d,%al
 340:	75 27                	jne    369 <atoo+0x71>
    s++;
 342:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 346:	eb 21                	jmp    369 <atoo+0x71>
    n = n*8 + *s++ - '0';
 348:	8b 45 fc             	mov    -0x4(%ebp),%eax
 34b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 352:	8b 45 08             	mov    0x8(%ebp),%eax
 355:	8d 50 01             	lea    0x1(%eax),%edx
 358:	89 55 08             	mov    %edx,0x8(%ebp)
 35b:	0f b6 00             	movzbl (%eax),%eax
 35e:	0f be c0             	movsbl %al,%eax
 361:	01 c8                	add    %ecx,%eax
 363:	83 e8 30             	sub    $0x30,%eax
 366:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 369:	8b 45 08             	mov    0x8(%ebp),%eax
 36c:	0f b6 00             	movzbl (%eax),%eax
 36f:	3c 2f                	cmp    $0x2f,%al
 371:	7e 0a                	jle    37d <atoo+0x85>
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	0f b6 00             	movzbl (%eax),%eax
 379:	3c 37                	cmp    $0x37,%al
 37b:	7e cb                	jle    348 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 37d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 380:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 384:	c9                   	leave  
 385:	c3                   	ret    

00000386 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 386:	55                   	push   %ebp
 387:	89 e5                	mov    %esp,%ebp
 389:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 38c:	8b 45 08             	mov    0x8(%ebp),%eax
 38f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 392:	8b 45 0c             	mov    0xc(%ebp),%eax
 395:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 398:	eb 17                	jmp    3b1 <memmove+0x2b>
    *dst++ = *src++;
 39a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 39d:	8d 50 01             	lea    0x1(%eax),%edx
 3a0:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3a3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3a6:	8d 4a 01             	lea    0x1(%edx),%ecx
 3a9:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3ac:	0f b6 12             	movzbl (%edx),%edx
 3af:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3b1:	8b 45 10             	mov    0x10(%ebp),%eax
 3b4:	8d 50 ff             	lea    -0x1(%eax),%edx
 3b7:	89 55 10             	mov    %edx,0x10(%ebp)
 3ba:	85 c0                	test   %eax,%eax
 3bc:	7f dc                	jg     39a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3c1:	c9                   	leave  
 3c2:	c3                   	ret    

000003c3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3c3:	b8 01 00 00 00       	mov    $0x1,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <exit>:
SYSCALL(exit)
 3cb:	b8 02 00 00 00       	mov    $0x2,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <wait>:
SYSCALL(wait)
 3d3:	b8 03 00 00 00       	mov    $0x3,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <pipe>:
SYSCALL(pipe)
 3db:	b8 04 00 00 00       	mov    $0x4,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <read>:
SYSCALL(read)
 3e3:	b8 05 00 00 00       	mov    $0x5,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <write>:
SYSCALL(write)
 3eb:	b8 10 00 00 00       	mov    $0x10,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <close>:
SYSCALL(close)
 3f3:	b8 15 00 00 00       	mov    $0x15,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <kill>:
SYSCALL(kill)
 3fb:	b8 06 00 00 00       	mov    $0x6,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <exec>:
SYSCALL(exec)
 403:	b8 07 00 00 00       	mov    $0x7,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <open>:
SYSCALL(open)
 40b:	b8 0f 00 00 00       	mov    $0xf,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <mknod>:
SYSCALL(mknod)
 413:	b8 11 00 00 00       	mov    $0x11,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <unlink>:
SYSCALL(unlink)
 41b:	b8 12 00 00 00       	mov    $0x12,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <fstat>:
SYSCALL(fstat)
 423:	b8 08 00 00 00       	mov    $0x8,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <link>:
SYSCALL(link)
 42b:	b8 13 00 00 00       	mov    $0x13,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <mkdir>:
SYSCALL(mkdir)
 433:	b8 14 00 00 00       	mov    $0x14,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <chdir>:
SYSCALL(chdir)
 43b:	b8 09 00 00 00       	mov    $0x9,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <dup>:
SYSCALL(dup)
 443:	b8 0a 00 00 00       	mov    $0xa,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <getpid>:
SYSCALL(getpid)
 44b:	b8 0b 00 00 00       	mov    $0xb,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <sbrk>:
SYSCALL(sbrk)
 453:	b8 0c 00 00 00       	mov    $0xc,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <sleep>:
SYSCALL(sleep)
 45b:	b8 0d 00 00 00       	mov    $0xd,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <uptime>:
SYSCALL(uptime)
 463:	b8 0e 00 00 00       	mov    $0xe,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <halt>:
SYSCALL(halt)
 46b:	b8 16 00 00 00       	mov    $0x16,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <date>:
SYSCALL(date)
 473:	b8 17 00 00 00       	mov    $0x17,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <getuid>:
SYSCALL(getuid)
 47b:	b8 18 00 00 00       	mov    $0x18,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <getgid>:
SYSCALL(getgid)
 483:	b8 19 00 00 00       	mov    $0x19,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <getppid>:
SYSCALL(getppid)
 48b:	b8 1a 00 00 00       	mov    $0x1a,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <setuid>:
SYSCALL(setuid)
 493:	b8 1b 00 00 00       	mov    $0x1b,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <setgid>:
SYSCALL(setgid)
 49b:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <getprocs>:
SYSCALL(getprocs)
 4a3:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <setpriority>:
SYSCALL(setpriority)
 4ab:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <chmod>:
SYSCALL(chmod)
 4b3:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <chown>:
SYSCALL(chown)
 4bb:	b8 20 00 00 00       	mov    $0x20,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <chgrp>:
SYSCALL(chgrp)
 4c3:	b8 21 00 00 00       	mov    $0x21,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4cb:	55                   	push   %ebp
 4cc:	89 e5                	mov    %esp,%ebp
 4ce:	83 ec 18             	sub    $0x18,%esp
 4d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d4:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4d7:	83 ec 04             	sub    $0x4,%esp
 4da:	6a 01                	push   $0x1
 4dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4df:	50                   	push   %eax
 4e0:	ff 75 08             	pushl  0x8(%ebp)
 4e3:	e8 03 ff ff ff       	call   3eb <write>
 4e8:	83 c4 10             	add    $0x10,%esp
}
 4eb:	90                   	nop
 4ec:	c9                   	leave  
 4ed:	c3                   	ret    

000004ee <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ee:	55                   	push   %ebp
 4ef:	89 e5                	mov    %esp,%ebp
 4f1:	53                   	push   %ebx
 4f2:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4f5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4fc:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 500:	74 17                	je     519 <printint+0x2b>
 502:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 506:	79 11                	jns    519 <printint+0x2b>
    neg = 1;
 508:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 50f:	8b 45 0c             	mov    0xc(%ebp),%eax
 512:	f7 d8                	neg    %eax
 514:	89 45 ec             	mov    %eax,-0x14(%ebp)
 517:	eb 06                	jmp    51f <printint+0x31>
  } else {
    x = xx;
 519:	8b 45 0c             	mov    0xc(%ebp),%eax
 51c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 51f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 526:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 529:	8d 41 01             	lea    0x1(%ecx),%eax
 52c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 52f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 532:	8b 45 ec             	mov    -0x14(%ebp),%eax
 535:	ba 00 00 00 00       	mov    $0x0,%edx
 53a:	f7 f3                	div    %ebx
 53c:	89 d0                	mov    %edx,%eax
 53e:	0f b6 80 10 0c 00 00 	movzbl 0xc10(%eax),%eax
 545:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 549:	8b 5d 10             	mov    0x10(%ebp),%ebx
 54c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 54f:	ba 00 00 00 00       	mov    $0x0,%edx
 554:	f7 f3                	div    %ebx
 556:	89 45 ec             	mov    %eax,-0x14(%ebp)
 559:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 55d:	75 c7                	jne    526 <printint+0x38>
  if(neg)
 55f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 563:	74 2d                	je     592 <printint+0xa4>
    buf[i++] = '-';
 565:	8b 45 f4             	mov    -0xc(%ebp),%eax
 568:	8d 50 01             	lea    0x1(%eax),%edx
 56b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 56e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 573:	eb 1d                	jmp    592 <printint+0xa4>
    putc(fd, buf[i]);
 575:	8d 55 dc             	lea    -0x24(%ebp),%edx
 578:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57b:	01 d0                	add    %edx,%eax
 57d:	0f b6 00             	movzbl (%eax),%eax
 580:	0f be c0             	movsbl %al,%eax
 583:	83 ec 08             	sub    $0x8,%esp
 586:	50                   	push   %eax
 587:	ff 75 08             	pushl  0x8(%ebp)
 58a:	e8 3c ff ff ff       	call   4cb <putc>
 58f:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 592:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 596:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 59a:	79 d9                	jns    575 <printint+0x87>
    putc(fd, buf[i]);
}
 59c:	90                   	nop
 59d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5a0:	c9                   	leave  
 5a1:	c3                   	ret    

000005a2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5a2:	55                   	push   %ebp
 5a3:	89 e5                	mov    %esp,%ebp
 5a5:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5a8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5af:	8d 45 0c             	lea    0xc(%ebp),%eax
 5b2:	83 c0 04             	add    $0x4,%eax
 5b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5bf:	e9 59 01 00 00       	jmp    71d <printf+0x17b>
    c = fmt[i] & 0xff;
 5c4:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ca:	01 d0                	add    %edx,%eax
 5cc:	0f b6 00             	movzbl (%eax),%eax
 5cf:	0f be c0             	movsbl %al,%eax
 5d2:	25 ff 00 00 00       	and    $0xff,%eax
 5d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5de:	75 2c                	jne    60c <printf+0x6a>
      if(c == '%'){
 5e0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e4:	75 0c                	jne    5f2 <printf+0x50>
        state = '%';
 5e6:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5ed:	e9 27 01 00 00       	jmp    719 <printf+0x177>
      } else {
        putc(fd, c);
 5f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f5:	0f be c0             	movsbl %al,%eax
 5f8:	83 ec 08             	sub    $0x8,%esp
 5fb:	50                   	push   %eax
 5fc:	ff 75 08             	pushl  0x8(%ebp)
 5ff:	e8 c7 fe ff ff       	call   4cb <putc>
 604:	83 c4 10             	add    $0x10,%esp
 607:	e9 0d 01 00 00       	jmp    719 <printf+0x177>
      }
    } else if(state == '%'){
 60c:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 610:	0f 85 03 01 00 00    	jne    719 <printf+0x177>
      if(c == 'd'){
 616:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 61a:	75 1e                	jne    63a <printf+0x98>
        printint(fd, *ap, 10, 1);
 61c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 61f:	8b 00                	mov    (%eax),%eax
 621:	6a 01                	push   $0x1
 623:	6a 0a                	push   $0xa
 625:	50                   	push   %eax
 626:	ff 75 08             	pushl  0x8(%ebp)
 629:	e8 c0 fe ff ff       	call   4ee <printint>
 62e:	83 c4 10             	add    $0x10,%esp
        ap++;
 631:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 635:	e9 d8 00 00 00       	jmp    712 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 63a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 63e:	74 06                	je     646 <printf+0xa4>
 640:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 644:	75 1e                	jne    664 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 646:	8b 45 e8             	mov    -0x18(%ebp),%eax
 649:	8b 00                	mov    (%eax),%eax
 64b:	6a 00                	push   $0x0
 64d:	6a 10                	push   $0x10
 64f:	50                   	push   %eax
 650:	ff 75 08             	pushl  0x8(%ebp)
 653:	e8 96 fe ff ff       	call   4ee <printint>
 658:	83 c4 10             	add    $0x10,%esp
        ap++;
 65b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 65f:	e9 ae 00 00 00       	jmp    712 <printf+0x170>
      } else if(c == 's'){
 664:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 668:	75 43                	jne    6ad <printf+0x10b>
        s = (char*)*ap;
 66a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66d:	8b 00                	mov    (%eax),%eax
 66f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 672:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 676:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 67a:	75 25                	jne    6a1 <printf+0xff>
          s = "(null)";
 67c:	c7 45 f4 9b 09 00 00 	movl   $0x99b,-0xc(%ebp)
        while(*s != 0){
 683:	eb 1c                	jmp    6a1 <printf+0xff>
          putc(fd, *s);
 685:	8b 45 f4             	mov    -0xc(%ebp),%eax
 688:	0f b6 00             	movzbl (%eax),%eax
 68b:	0f be c0             	movsbl %al,%eax
 68e:	83 ec 08             	sub    $0x8,%esp
 691:	50                   	push   %eax
 692:	ff 75 08             	pushl  0x8(%ebp)
 695:	e8 31 fe ff ff       	call   4cb <putc>
 69a:	83 c4 10             	add    $0x10,%esp
          s++;
 69d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a4:	0f b6 00             	movzbl (%eax),%eax
 6a7:	84 c0                	test   %al,%al
 6a9:	75 da                	jne    685 <printf+0xe3>
 6ab:	eb 65                	jmp    712 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6ad:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6b1:	75 1d                	jne    6d0 <printf+0x12e>
        putc(fd, *ap);
 6b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b6:	8b 00                	mov    (%eax),%eax
 6b8:	0f be c0             	movsbl %al,%eax
 6bb:	83 ec 08             	sub    $0x8,%esp
 6be:	50                   	push   %eax
 6bf:	ff 75 08             	pushl  0x8(%ebp)
 6c2:	e8 04 fe ff ff       	call   4cb <putc>
 6c7:	83 c4 10             	add    $0x10,%esp
        ap++;
 6ca:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ce:	eb 42                	jmp    712 <printf+0x170>
      } else if(c == '%'){
 6d0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6d4:	75 17                	jne    6ed <printf+0x14b>
        putc(fd, c);
 6d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d9:	0f be c0             	movsbl %al,%eax
 6dc:	83 ec 08             	sub    $0x8,%esp
 6df:	50                   	push   %eax
 6e0:	ff 75 08             	pushl  0x8(%ebp)
 6e3:	e8 e3 fd ff ff       	call   4cb <putc>
 6e8:	83 c4 10             	add    $0x10,%esp
 6eb:	eb 25                	jmp    712 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6ed:	83 ec 08             	sub    $0x8,%esp
 6f0:	6a 25                	push   $0x25
 6f2:	ff 75 08             	pushl  0x8(%ebp)
 6f5:	e8 d1 fd ff ff       	call   4cb <putc>
 6fa:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 700:	0f be c0             	movsbl %al,%eax
 703:	83 ec 08             	sub    $0x8,%esp
 706:	50                   	push   %eax
 707:	ff 75 08             	pushl  0x8(%ebp)
 70a:	e8 bc fd ff ff       	call   4cb <putc>
 70f:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 712:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 719:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 71d:	8b 55 0c             	mov    0xc(%ebp),%edx
 720:	8b 45 f0             	mov    -0x10(%ebp),%eax
 723:	01 d0                	add    %edx,%eax
 725:	0f b6 00             	movzbl (%eax),%eax
 728:	84 c0                	test   %al,%al
 72a:	0f 85 94 fe ff ff    	jne    5c4 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 730:	90                   	nop
 731:	c9                   	leave  
 732:	c3                   	ret    

00000733 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 733:	55                   	push   %ebp
 734:	89 e5                	mov    %esp,%ebp
 736:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 739:	8b 45 08             	mov    0x8(%ebp),%eax
 73c:	83 e8 08             	sub    $0x8,%eax
 73f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 742:	a1 2c 0c 00 00       	mov    0xc2c,%eax
 747:	89 45 fc             	mov    %eax,-0x4(%ebp)
 74a:	eb 24                	jmp    770 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74f:	8b 00                	mov    (%eax),%eax
 751:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 754:	77 12                	ja     768 <free+0x35>
 756:	8b 45 f8             	mov    -0x8(%ebp),%eax
 759:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 75c:	77 24                	ja     782 <free+0x4f>
 75e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 761:	8b 00                	mov    (%eax),%eax
 763:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 766:	77 1a                	ja     782 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 768:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76b:	8b 00                	mov    (%eax),%eax
 76d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 770:	8b 45 f8             	mov    -0x8(%ebp),%eax
 773:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 776:	76 d4                	jbe    74c <free+0x19>
 778:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77b:	8b 00                	mov    (%eax),%eax
 77d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 780:	76 ca                	jbe    74c <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 782:	8b 45 f8             	mov    -0x8(%ebp),%eax
 785:	8b 40 04             	mov    0x4(%eax),%eax
 788:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 78f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 792:	01 c2                	add    %eax,%edx
 794:	8b 45 fc             	mov    -0x4(%ebp),%eax
 797:	8b 00                	mov    (%eax),%eax
 799:	39 c2                	cmp    %eax,%edx
 79b:	75 24                	jne    7c1 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 79d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a0:	8b 50 04             	mov    0x4(%eax),%edx
 7a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a6:	8b 00                	mov    (%eax),%eax
 7a8:	8b 40 04             	mov    0x4(%eax),%eax
 7ab:	01 c2                	add    %eax,%edx
 7ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b0:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b6:	8b 00                	mov    (%eax),%eax
 7b8:	8b 10                	mov    (%eax),%edx
 7ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bd:	89 10                	mov    %edx,(%eax)
 7bf:	eb 0a                	jmp    7cb <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c4:	8b 10                	mov    (%eax),%edx
 7c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c9:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ce:	8b 40 04             	mov    0x4(%eax),%eax
 7d1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7db:	01 d0                	add    %edx,%eax
 7dd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e0:	75 20                	jne    802 <free+0xcf>
    p->s.size += bp->s.size;
 7e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e5:	8b 50 04             	mov    0x4(%eax),%edx
 7e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7eb:	8b 40 04             	mov    0x4(%eax),%eax
 7ee:	01 c2                	add    %eax,%edx
 7f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f9:	8b 10                	mov    (%eax),%edx
 7fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fe:	89 10                	mov    %edx,(%eax)
 800:	eb 08                	jmp    80a <free+0xd7>
  } else
    p->s.ptr = bp;
 802:	8b 45 fc             	mov    -0x4(%ebp),%eax
 805:	8b 55 f8             	mov    -0x8(%ebp),%edx
 808:	89 10                	mov    %edx,(%eax)
  freep = p;
 80a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80d:	a3 2c 0c 00 00       	mov    %eax,0xc2c
}
 812:	90                   	nop
 813:	c9                   	leave  
 814:	c3                   	ret    

00000815 <morecore>:

static Header*
morecore(uint nu)
{
 815:	55                   	push   %ebp
 816:	89 e5                	mov    %esp,%ebp
 818:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 81b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 822:	77 07                	ja     82b <morecore+0x16>
    nu = 4096;
 824:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 82b:	8b 45 08             	mov    0x8(%ebp),%eax
 82e:	c1 e0 03             	shl    $0x3,%eax
 831:	83 ec 0c             	sub    $0xc,%esp
 834:	50                   	push   %eax
 835:	e8 19 fc ff ff       	call   453 <sbrk>
 83a:	83 c4 10             	add    $0x10,%esp
 83d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 840:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 844:	75 07                	jne    84d <morecore+0x38>
    return 0;
 846:	b8 00 00 00 00       	mov    $0x0,%eax
 84b:	eb 26                	jmp    873 <morecore+0x5e>
  hp = (Header*)p;
 84d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 850:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 853:	8b 45 f0             	mov    -0x10(%ebp),%eax
 856:	8b 55 08             	mov    0x8(%ebp),%edx
 859:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 85c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85f:	83 c0 08             	add    $0x8,%eax
 862:	83 ec 0c             	sub    $0xc,%esp
 865:	50                   	push   %eax
 866:	e8 c8 fe ff ff       	call   733 <free>
 86b:	83 c4 10             	add    $0x10,%esp
  return freep;
 86e:	a1 2c 0c 00 00       	mov    0xc2c,%eax
}
 873:	c9                   	leave  
 874:	c3                   	ret    

00000875 <malloc>:

void*
malloc(uint nbytes)
{
 875:	55                   	push   %ebp
 876:	89 e5                	mov    %esp,%ebp
 878:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 87b:	8b 45 08             	mov    0x8(%ebp),%eax
 87e:	83 c0 07             	add    $0x7,%eax
 881:	c1 e8 03             	shr    $0x3,%eax
 884:	83 c0 01             	add    $0x1,%eax
 887:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 88a:	a1 2c 0c 00 00       	mov    0xc2c,%eax
 88f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 892:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 896:	75 23                	jne    8bb <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 898:	c7 45 f0 24 0c 00 00 	movl   $0xc24,-0x10(%ebp)
 89f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a2:	a3 2c 0c 00 00       	mov    %eax,0xc2c
 8a7:	a1 2c 0c 00 00       	mov    0xc2c,%eax
 8ac:	a3 24 0c 00 00       	mov    %eax,0xc24
    base.s.size = 0;
 8b1:	c7 05 28 0c 00 00 00 	movl   $0x0,0xc28
 8b8:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8be:	8b 00                	mov    (%eax),%eax
 8c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c6:	8b 40 04             	mov    0x4(%eax),%eax
 8c9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8cc:	72 4d                	jb     91b <malloc+0xa6>
      if(p->s.size == nunits)
 8ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d1:	8b 40 04             	mov    0x4(%eax),%eax
 8d4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8d7:	75 0c                	jne    8e5 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8dc:	8b 10                	mov    (%eax),%edx
 8de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e1:	89 10                	mov    %edx,(%eax)
 8e3:	eb 26                	jmp    90b <malloc+0x96>
      else {
        p->s.size -= nunits;
 8e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e8:	8b 40 04             	mov    0x4(%eax),%eax
 8eb:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8ee:	89 c2                	mov    %eax,%edx
 8f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f9:	8b 40 04             	mov    0x4(%eax),%eax
 8fc:	c1 e0 03             	shl    $0x3,%eax
 8ff:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 902:	8b 45 f4             	mov    -0xc(%ebp),%eax
 905:	8b 55 ec             	mov    -0x14(%ebp),%edx
 908:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 90b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90e:	a3 2c 0c 00 00       	mov    %eax,0xc2c
      return (void*)(p + 1);
 913:	8b 45 f4             	mov    -0xc(%ebp),%eax
 916:	83 c0 08             	add    $0x8,%eax
 919:	eb 3b                	jmp    956 <malloc+0xe1>
    }
    if(p == freep)
 91b:	a1 2c 0c 00 00       	mov    0xc2c,%eax
 920:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 923:	75 1e                	jne    943 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 925:	83 ec 0c             	sub    $0xc,%esp
 928:	ff 75 ec             	pushl  -0x14(%ebp)
 92b:	e8 e5 fe ff ff       	call   815 <morecore>
 930:	83 c4 10             	add    $0x10,%esp
 933:	89 45 f4             	mov    %eax,-0xc(%ebp)
 936:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 93a:	75 07                	jne    943 <malloc+0xce>
        return 0;
 93c:	b8 00 00 00 00       	mov    $0x0,%eax
 941:	eb 13                	jmp    956 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 943:	8b 45 f4             	mov    -0xc(%ebp),%eax
 946:	89 45 f0             	mov    %eax,-0x10(%ebp)
 949:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94c:	8b 00                	mov    (%eax),%eax
 94e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 951:	e9 6d ff ff ff       	jmp    8c3 <malloc+0x4e>
}
 956:	c9                   	leave  
 957:	c3                   	ret    
