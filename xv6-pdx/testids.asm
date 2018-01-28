
_testids:     file format elf32-i386


Disassembly of section .text:

00000000 <testuidgid>:

#include "types.h"
#include "user.h"

int
testuidgid(void) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
    uint uid, gid, ppid;

    uid = getuid();
   6:	e8 bd 04 00 00       	call   4c8 <getuid>
   b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(2, "Current UID is: %d\n", uid);
   e:	83 ec 04             	sub    $0x4,%esp
  11:	ff 75 f4             	pushl  -0xc(%ebp)
  14:	68 85 09 00 00       	push   $0x985
  19:	6a 02                	push   $0x2
  1b:	e8 af 05 00 00       	call   5cf <printf>
  20:	83 c4 10             	add    $0x10,%esp
    printf(2, "Setting UID to 100\n");
  23:	83 ec 08             	sub    $0x8,%esp
  26:	68 99 09 00 00       	push   $0x999
  2b:	6a 02                	push   $0x2
  2d:	e8 9d 05 00 00       	call   5cf <printf>
  32:	83 c4 10             	add    $0x10,%esp
    setuid(100);
  35:	83 ec 0c             	sub    $0xc,%esp
  38:	6a 64                	push   $0x64
  3a:	e8 a1 04 00 00       	call   4e0 <setuid>
  3f:	83 c4 10             	add    $0x10,%esp
    uid = getuid();
  42:	e8 81 04 00 00       	call   4c8 <getuid>
  47:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(2, "Current UID is: %d\n", uid);
  4a:	83 ec 04             	sub    $0x4,%esp
  4d:	ff 75 f4             	pushl  -0xc(%ebp)
  50:	68 85 09 00 00       	push   $0x985
  55:	6a 02                	push   $0x2
  57:	e8 73 05 00 00       	call   5cf <printf>
  5c:	83 c4 10             	add    $0x10,%esp

    gid = getgid();
  5f:	e8 6c 04 00 00       	call   4d0 <getgid>
  64:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(2, "Current GID is: %d\n", gid);
  67:	83 ec 04             	sub    $0x4,%esp
  6a:	ff 75 f0             	pushl  -0x10(%ebp)
  6d:	68 ad 09 00 00       	push   $0x9ad
  72:	6a 02                	push   $0x2
  74:	e8 56 05 00 00       	call   5cf <printf>
  79:	83 c4 10             	add    $0x10,%esp
    printf(2, "Setting GID to 100\n");
  7c:	83 ec 08             	sub    $0x8,%esp
  7f:	68 c1 09 00 00       	push   $0x9c1
  84:	6a 02                	push   $0x2
  86:	e8 44 05 00 00       	call   5cf <printf>
  8b:	83 c4 10             	add    $0x10,%esp
    setgid(100);
  8e:	83 ec 0c             	sub    $0xc,%esp
  91:	6a 64                	push   $0x64
  93:	e8 50 04 00 00       	call   4e8 <setgid>
  98:	83 c4 10             	add    $0x10,%esp
    gid = getgid();
  9b:	e8 30 04 00 00       	call   4d0 <getgid>
  a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(2, "Current GID is: %d\n", gid);
  a3:	83 ec 04             	sub    $0x4,%esp
  a6:	ff 75 f0             	pushl  -0x10(%ebp)
  a9:	68 ad 09 00 00       	push   $0x9ad
  ae:	6a 02                	push   $0x2
  b0:	e8 1a 05 00 00       	call   5cf <printf>
  b5:	83 c4 10             	add    $0x10,%esp

    ppid = getppid();
  b8:	e8 1b 04 00 00       	call   4d8 <getppid>
  bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(2, "My parent process is: %d\n", ppid);
  c0:	83 ec 04             	sub    $0x4,%esp
  c3:	ff 75 ec             	pushl  -0x14(%ebp)
  c6:	68 d5 09 00 00       	push   $0x9d5
  cb:	6a 02                	push   $0x2
  cd:	e8 fd 04 00 00       	call   5cf <printf>
  d2:	83 c4 10             	add    $0x10,%esp
    printf(2, "Done!\n");
  d5:	83 ec 08             	sub    $0x8,%esp
  d8:	68 ef 09 00 00       	push   $0x9ef
  dd:	6a 02                	push   $0x2
  df:	e8 eb 04 00 00       	call   5cf <printf>
  e4:	83 c4 10             	add    $0x10,%esp

    return 0;
  e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  ec:	c9                   	leave  
  ed:	c3                   	ret    

000000ee <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  ee:	55                   	push   %ebp
  ef:	89 e5                	mov    %esp,%ebp
  f1:	57                   	push   %edi
  f2:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  f6:	8b 55 10             	mov    0x10(%ebp),%edx
  f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  fc:	89 cb                	mov    %ecx,%ebx
  fe:	89 df                	mov    %ebx,%edi
 100:	89 d1                	mov    %edx,%ecx
 102:	fc                   	cld    
 103:	f3 aa                	rep stos %al,%es:(%edi)
 105:	89 ca                	mov    %ecx,%edx
 107:	89 fb                	mov    %edi,%ebx
 109:	89 5d 08             	mov    %ebx,0x8(%ebp)
 10c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 10f:	90                   	nop
 110:	5b                   	pop    %ebx
 111:	5f                   	pop    %edi
 112:	5d                   	pop    %ebp
 113:	c3                   	ret    

00000114 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 11a:	8b 45 08             	mov    0x8(%ebp),%eax
 11d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 120:	90                   	nop
 121:	8b 45 08             	mov    0x8(%ebp),%eax
 124:	8d 50 01             	lea    0x1(%eax),%edx
 127:	89 55 08             	mov    %edx,0x8(%ebp)
 12a:	8b 55 0c             	mov    0xc(%ebp),%edx
 12d:	8d 4a 01             	lea    0x1(%edx),%ecx
 130:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 133:	0f b6 12             	movzbl (%edx),%edx
 136:	88 10                	mov    %dl,(%eax)
 138:	0f b6 00             	movzbl (%eax),%eax
 13b:	84 c0                	test   %al,%al
 13d:	75 e2                	jne    121 <strcpy+0xd>
    ;
  return os;
 13f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 142:	c9                   	leave  
 143:	c3                   	ret    

00000144 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 144:	55                   	push   %ebp
 145:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 147:	eb 08                	jmp    151 <strcmp+0xd>
    p++, q++;
 149:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 14d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 151:	8b 45 08             	mov    0x8(%ebp),%eax
 154:	0f b6 00             	movzbl (%eax),%eax
 157:	84 c0                	test   %al,%al
 159:	74 10                	je     16b <strcmp+0x27>
 15b:	8b 45 08             	mov    0x8(%ebp),%eax
 15e:	0f b6 10             	movzbl (%eax),%edx
 161:	8b 45 0c             	mov    0xc(%ebp),%eax
 164:	0f b6 00             	movzbl (%eax),%eax
 167:	38 c2                	cmp    %al,%dl
 169:	74 de                	je     149 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	0f b6 00             	movzbl (%eax),%eax
 171:	0f b6 d0             	movzbl %al,%edx
 174:	8b 45 0c             	mov    0xc(%ebp),%eax
 177:	0f b6 00             	movzbl (%eax),%eax
 17a:	0f b6 c0             	movzbl %al,%eax
 17d:	29 c2                	sub    %eax,%edx
 17f:	89 d0                	mov    %edx,%eax
}
 181:	5d                   	pop    %ebp
 182:	c3                   	ret    

00000183 <strlen>:

uint
strlen(char *s)
{
 183:	55                   	push   %ebp
 184:	89 e5                	mov    %esp,%ebp
 186:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 189:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 190:	eb 04                	jmp    196 <strlen+0x13>
 192:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 196:	8b 55 fc             	mov    -0x4(%ebp),%edx
 199:	8b 45 08             	mov    0x8(%ebp),%eax
 19c:	01 d0                	add    %edx,%eax
 19e:	0f b6 00             	movzbl (%eax),%eax
 1a1:	84 c0                	test   %al,%al
 1a3:	75 ed                	jne    192 <strlen+0xf>
    ;
  return n;
 1a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1a8:	c9                   	leave  
 1a9:	c3                   	ret    

000001aa <memset>:

void*
memset(void *dst, int c, uint n)
{
 1aa:	55                   	push   %ebp
 1ab:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1ad:	8b 45 10             	mov    0x10(%ebp),%eax
 1b0:	50                   	push   %eax
 1b1:	ff 75 0c             	pushl  0xc(%ebp)
 1b4:	ff 75 08             	pushl  0x8(%ebp)
 1b7:	e8 32 ff ff ff       	call   ee <stosb>
 1bc:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1bf:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1c2:	c9                   	leave  
 1c3:	c3                   	ret    

000001c4 <strchr>:

char*
strchr(const char *s, char c)
{
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	83 ec 04             	sub    $0x4,%esp
 1ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cd:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1d0:	eb 14                	jmp    1e6 <strchr+0x22>
    if(*s == c)
 1d2:	8b 45 08             	mov    0x8(%ebp),%eax
 1d5:	0f b6 00             	movzbl (%eax),%eax
 1d8:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1db:	75 05                	jne    1e2 <strchr+0x1e>
      return (char*)s;
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	eb 13                	jmp    1f5 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1e2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1e6:	8b 45 08             	mov    0x8(%ebp),%eax
 1e9:	0f b6 00             	movzbl (%eax),%eax
 1ec:	84 c0                	test   %al,%al
 1ee:	75 e2                	jne    1d2 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1f5:	c9                   	leave  
 1f6:	c3                   	ret    

000001f7 <gets>:

char*
gets(char *buf, int max)
{
 1f7:	55                   	push   %ebp
 1f8:	89 e5                	mov    %esp,%ebp
 1fa:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 204:	eb 42                	jmp    248 <gets+0x51>
    cc = read(0, &c, 1);
 206:	83 ec 04             	sub    $0x4,%esp
 209:	6a 01                	push   $0x1
 20b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 20e:	50                   	push   %eax
 20f:	6a 00                	push   $0x0
 211:	e8 1a 02 00 00       	call   430 <read>
 216:	83 c4 10             	add    $0x10,%esp
 219:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 21c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 220:	7e 33                	jle    255 <gets+0x5e>
      break;
    buf[i++] = c;
 222:	8b 45 f4             	mov    -0xc(%ebp),%eax
 225:	8d 50 01             	lea    0x1(%eax),%edx
 228:	89 55 f4             	mov    %edx,-0xc(%ebp)
 22b:	89 c2                	mov    %eax,%edx
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	01 c2                	add    %eax,%edx
 232:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 236:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 238:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 23c:	3c 0a                	cmp    $0xa,%al
 23e:	74 16                	je     256 <gets+0x5f>
 240:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 244:	3c 0d                	cmp    $0xd,%al
 246:	74 0e                	je     256 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 248:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24b:	83 c0 01             	add    $0x1,%eax
 24e:	3b 45 0c             	cmp    0xc(%ebp),%eax
 251:	7c b3                	jl     206 <gets+0xf>
 253:	eb 01                	jmp    256 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 255:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 256:	8b 55 f4             	mov    -0xc(%ebp),%edx
 259:	8b 45 08             	mov    0x8(%ebp),%eax
 25c:	01 d0                	add    %edx,%eax
 25e:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 261:	8b 45 08             	mov    0x8(%ebp),%eax
}
 264:	c9                   	leave  
 265:	c3                   	ret    

00000266 <stat>:

int
stat(char *n, struct stat *st)
{
 266:	55                   	push   %ebp
 267:	89 e5                	mov    %esp,%ebp
 269:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 26c:	83 ec 08             	sub    $0x8,%esp
 26f:	6a 00                	push   $0x0
 271:	ff 75 08             	pushl  0x8(%ebp)
 274:	e8 df 01 00 00       	call   458 <open>
 279:	83 c4 10             	add    $0x10,%esp
 27c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 27f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 283:	79 07                	jns    28c <stat+0x26>
    return -1;
 285:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 28a:	eb 25                	jmp    2b1 <stat+0x4b>
  r = fstat(fd, st);
 28c:	83 ec 08             	sub    $0x8,%esp
 28f:	ff 75 0c             	pushl  0xc(%ebp)
 292:	ff 75 f4             	pushl  -0xc(%ebp)
 295:	e8 d6 01 00 00       	call   470 <fstat>
 29a:	83 c4 10             	add    $0x10,%esp
 29d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2a0:	83 ec 0c             	sub    $0xc,%esp
 2a3:	ff 75 f4             	pushl  -0xc(%ebp)
 2a6:	e8 95 01 00 00       	call   440 <close>
 2ab:	83 c4 10             	add    $0x10,%esp
  return r;
 2ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2b1:	c9                   	leave  
 2b2:	c3                   	ret    

000002b3 <atoi>:

int
atoi(const char *s)
{
 2b3:	55                   	push   %ebp
 2b4:	89 e5                	mov    %esp,%ebp
 2b6:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2c0:	eb 04                	jmp    2c6 <atoi+0x13>
 2c2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2c6:	8b 45 08             	mov    0x8(%ebp),%eax
 2c9:	0f b6 00             	movzbl (%eax),%eax
 2cc:	3c 20                	cmp    $0x20,%al
 2ce:	74 f2                	je     2c2 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
 2d3:	0f b6 00             	movzbl (%eax),%eax
 2d6:	3c 2d                	cmp    $0x2d,%al
 2d8:	75 07                	jne    2e1 <atoi+0x2e>
 2da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2df:	eb 05                	jmp    2e6 <atoi+0x33>
 2e1:	b8 01 00 00 00       	mov    $0x1,%eax
 2e6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2e9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ec:	0f b6 00             	movzbl (%eax),%eax
 2ef:	3c 2b                	cmp    $0x2b,%al
 2f1:	74 0a                	je     2fd <atoi+0x4a>
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	0f b6 00             	movzbl (%eax),%eax
 2f9:	3c 2d                	cmp    $0x2d,%al
 2fb:	75 2b                	jne    328 <atoi+0x75>
    s++;
 2fd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 301:	eb 25                	jmp    328 <atoi+0x75>
    n = n*10 + *s++ - '0';
 303:	8b 55 fc             	mov    -0x4(%ebp),%edx
 306:	89 d0                	mov    %edx,%eax
 308:	c1 e0 02             	shl    $0x2,%eax
 30b:	01 d0                	add    %edx,%eax
 30d:	01 c0                	add    %eax,%eax
 30f:	89 c1                	mov    %eax,%ecx
 311:	8b 45 08             	mov    0x8(%ebp),%eax
 314:	8d 50 01             	lea    0x1(%eax),%edx
 317:	89 55 08             	mov    %edx,0x8(%ebp)
 31a:	0f b6 00             	movzbl (%eax),%eax
 31d:	0f be c0             	movsbl %al,%eax
 320:	01 c8                	add    %ecx,%eax
 322:	83 e8 30             	sub    $0x30,%eax
 325:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	0f b6 00             	movzbl (%eax),%eax
 32e:	3c 2f                	cmp    $0x2f,%al
 330:	7e 0a                	jle    33c <atoi+0x89>
 332:	8b 45 08             	mov    0x8(%ebp),%eax
 335:	0f b6 00             	movzbl (%eax),%eax
 338:	3c 39                	cmp    $0x39,%al
 33a:	7e c7                	jle    303 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 33c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 33f:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 343:	c9                   	leave  
 344:	c3                   	ret    

00000345 <atoo>:

int
atoo(const char *s)
{
 345:	55                   	push   %ebp
 346:	89 e5                	mov    %esp,%ebp
 348:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 34b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 352:	eb 04                	jmp    358 <atoo+0x13>
 354:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 358:	8b 45 08             	mov    0x8(%ebp),%eax
 35b:	0f b6 00             	movzbl (%eax),%eax
 35e:	3c 20                	cmp    $0x20,%al
 360:	74 f2                	je     354 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 362:	8b 45 08             	mov    0x8(%ebp),%eax
 365:	0f b6 00             	movzbl (%eax),%eax
 368:	3c 2d                	cmp    $0x2d,%al
 36a:	75 07                	jne    373 <atoo+0x2e>
 36c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 371:	eb 05                	jmp    378 <atoo+0x33>
 373:	b8 01 00 00 00       	mov    $0x1,%eax
 378:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 37b:	8b 45 08             	mov    0x8(%ebp),%eax
 37e:	0f b6 00             	movzbl (%eax),%eax
 381:	3c 2b                	cmp    $0x2b,%al
 383:	74 0a                	je     38f <atoo+0x4a>
 385:	8b 45 08             	mov    0x8(%ebp),%eax
 388:	0f b6 00             	movzbl (%eax),%eax
 38b:	3c 2d                	cmp    $0x2d,%al
 38d:	75 27                	jne    3b6 <atoo+0x71>
    s++;
 38f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 393:	eb 21                	jmp    3b6 <atoo+0x71>
    n = n*8 + *s++ - '0';
 395:	8b 45 fc             	mov    -0x4(%ebp),%eax
 398:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 39f:	8b 45 08             	mov    0x8(%ebp),%eax
 3a2:	8d 50 01             	lea    0x1(%eax),%edx
 3a5:	89 55 08             	mov    %edx,0x8(%ebp)
 3a8:	0f b6 00             	movzbl (%eax),%eax
 3ab:	0f be c0             	movsbl %al,%eax
 3ae:	01 c8                	add    %ecx,%eax
 3b0:	83 e8 30             	sub    $0x30,%eax
 3b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 3b6:	8b 45 08             	mov    0x8(%ebp),%eax
 3b9:	0f b6 00             	movzbl (%eax),%eax
 3bc:	3c 2f                	cmp    $0x2f,%al
 3be:	7e 0a                	jle    3ca <atoo+0x85>
 3c0:	8b 45 08             	mov    0x8(%ebp),%eax
 3c3:	0f b6 00             	movzbl (%eax),%eax
 3c6:	3c 37                	cmp    $0x37,%al
 3c8:	7e cb                	jle    395 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 3ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3cd:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3d1:	c9                   	leave  
 3d2:	c3                   	ret    

000003d3 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 3d3:	55                   	push   %ebp
 3d4:	89 e5                	mov    %esp,%ebp
 3d6:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3d9:	8b 45 08             	mov    0x8(%ebp),%eax
 3dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3df:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3e5:	eb 17                	jmp    3fe <memmove+0x2b>
    *dst++ = *src++;
 3e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ea:	8d 50 01             	lea    0x1(%eax),%edx
 3ed:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3f0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3f3:	8d 4a 01             	lea    0x1(%edx),%ecx
 3f6:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3f9:	0f b6 12             	movzbl (%edx),%edx
 3fc:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3fe:	8b 45 10             	mov    0x10(%ebp),%eax
 401:	8d 50 ff             	lea    -0x1(%eax),%edx
 404:	89 55 10             	mov    %edx,0x10(%ebp)
 407:	85 c0                	test   %eax,%eax
 409:	7f dc                	jg     3e7 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 40b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40e:	c9                   	leave  
 40f:	c3                   	ret    

00000410 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 410:	b8 01 00 00 00       	mov    $0x1,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <exit>:
SYSCALL(exit)
 418:	b8 02 00 00 00       	mov    $0x2,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <wait>:
SYSCALL(wait)
 420:	b8 03 00 00 00       	mov    $0x3,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <pipe>:
SYSCALL(pipe)
 428:	b8 04 00 00 00       	mov    $0x4,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <read>:
SYSCALL(read)
 430:	b8 05 00 00 00       	mov    $0x5,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <write>:
SYSCALL(write)
 438:	b8 10 00 00 00       	mov    $0x10,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <close>:
SYSCALL(close)
 440:	b8 15 00 00 00       	mov    $0x15,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <kill>:
SYSCALL(kill)
 448:	b8 06 00 00 00       	mov    $0x6,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <exec>:
SYSCALL(exec)
 450:	b8 07 00 00 00       	mov    $0x7,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <open>:
SYSCALL(open)
 458:	b8 0f 00 00 00       	mov    $0xf,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <mknod>:
SYSCALL(mknod)
 460:	b8 11 00 00 00       	mov    $0x11,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <unlink>:
SYSCALL(unlink)
 468:	b8 12 00 00 00       	mov    $0x12,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <fstat>:
SYSCALL(fstat)
 470:	b8 08 00 00 00       	mov    $0x8,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <link>:
SYSCALL(link)
 478:	b8 13 00 00 00       	mov    $0x13,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <mkdir>:
SYSCALL(mkdir)
 480:	b8 14 00 00 00       	mov    $0x14,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <chdir>:
SYSCALL(chdir)
 488:	b8 09 00 00 00       	mov    $0x9,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <dup>:
SYSCALL(dup)
 490:	b8 0a 00 00 00       	mov    $0xa,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <getpid>:
SYSCALL(getpid)
 498:	b8 0b 00 00 00       	mov    $0xb,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <sbrk>:
SYSCALL(sbrk)
 4a0:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <sleep>:
SYSCALL(sleep)
 4a8:	b8 0d 00 00 00       	mov    $0xd,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <uptime>:
SYSCALL(uptime)
 4b0:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <halt>:
SYSCALL(halt)
 4b8:	b8 16 00 00 00       	mov    $0x16,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <date>:
SYSCALL(date)
 4c0:	b8 17 00 00 00       	mov    $0x17,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <getuid>:
SYSCALL(getuid)
 4c8:	b8 18 00 00 00       	mov    $0x18,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <getgid>:
SYSCALL(getgid)
 4d0:	b8 19 00 00 00       	mov    $0x19,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <getppid>:
SYSCALL(getppid)
 4d8:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <setuid>:
SYSCALL(setuid)
 4e0:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <setgid>:
SYSCALL(setgid)
 4e8:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4ed:	cd 40                	int    $0x40
 4ef:	c3                   	ret    

000004f0 <getprocs>:
SYSCALL(getprocs)
 4f0:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4f8:	55                   	push   %ebp
 4f9:	89 e5                	mov    %esp,%ebp
 4fb:	83 ec 18             	sub    $0x18,%esp
 4fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 501:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 504:	83 ec 04             	sub    $0x4,%esp
 507:	6a 01                	push   $0x1
 509:	8d 45 f4             	lea    -0xc(%ebp),%eax
 50c:	50                   	push   %eax
 50d:	ff 75 08             	pushl  0x8(%ebp)
 510:	e8 23 ff ff ff       	call   438 <write>
 515:	83 c4 10             	add    $0x10,%esp
}
 518:	90                   	nop
 519:	c9                   	leave  
 51a:	c3                   	ret    

0000051b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 51b:	55                   	push   %ebp
 51c:	89 e5                	mov    %esp,%ebp
 51e:	53                   	push   %ebx
 51f:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 522:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 529:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 52d:	74 17                	je     546 <printint+0x2b>
 52f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 533:	79 11                	jns    546 <printint+0x2b>
    neg = 1;
 535:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 53c:	8b 45 0c             	mov    0xc(%ebp),%eax
 53f:	f7 d8                	neg    %eax
 541:	89 45 ec             	mov    %eax,-0x14(%ebp)
 544:	eb 06                	jmp    54c <printint+0x31>
  } else {
    x = xx;
 546:	8b 45 0c             	mov    0xc(%ebp),%eax
 549:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 54c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 553:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 556:	8d 41 01             	lea    0x1(%ecx),%eax
 559:	89 45 f4             	mov    %eax,-0xc(%ebp)
 55c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 55f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 562:	ba 00 00 00 00       	mov    $0x0,%edx
 567:	f7 f3                	div    %ebx
 569:	89 d0                	mov    %edx,%eax
 56b:	0f b6 80 64 0c 00 00 	movzbl 0xc64(%eax),%eax
 572:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 576:	8b 5d 10             	mov    0x10(%ebp),%ebx
 579:	8b 45 ec             	mov    -0x14(%ebp),%eax
 57c:	ba 00 00 00 00       	mov    $0x0,%edx
 581:	f7 f3                	div    %ebx
 583:	89 45 ec             	mov    %eax,-0x14(%ebp)
 586:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 58a:	75 c7                	jne    553 <printint+0x38>
  if(neg)
 58c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 590:	74 2d                	je     5bf <printint+0xa4>
    buf[i++] = '-';
 592:	8b 45 f4             	mov    -0xc(%ebp),%eax
 595:	8d 50 01             	lea    0x1(%eax),%edx
 598:	89 55 f4             	mov    %edx,-0xc(%ebp)
 59b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5a0:	eb 1d                	jmp    5bf <printint+0xa4>
    putc(fd, buf[i]);
 5a2:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a8:	01 d0                	add    %edx,%eax
 5aa:	0f b6 00             	movzbl (%eax),%eax
 5ad:	0f be c0             	movsbl %al,%eax
 5b0:	83 ec 08             	sub    $0x8,%esp
 5b3:	50                   	push   %eax
 5b4:	ff 75 08             	pushl  0x8(%ebp)
 5b7:	e8 3c ff ff ff       	call   4f8 <putc>
 5bc:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5bf:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5c7:	79 d9                	jns    5a2 <printint+0x87>
    putc(fd, buf[i]);
}
 5c9:	90                   	nop
 5ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5cd:	c9                   	leave  
 5ce:	c3                   	ret    

000005cf <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5cf:	55                   	push   %ebp
 5d0:	89 e5                	mov    %esp,%ebp
 5d2:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5d5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5dc:	8d 45 0c             	lea    0xc(%ebp),%eax
 5df:	83 c0 04             	add    $0x4,%eax
 5e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5ec:	e9 59 01 00 00       	jmp    74a <printf+0x17b>
    c = fmt[i] & 0xff;
 5f1:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5f7:	01 d0                	add    %edx,%eax
 5f9:	0f b6 00             	movzbl (%eax),%eax
 5fc:	0f be c0             	movsbl %al,%eax
 5ff:	25 ff 00 00 00       	and    $0xff,%eax
 604:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 607:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 60b:	75 2c                	jne    639 <printf+0x6a>
      if(c == '%'){
 60d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 611:	75 0c                	jne    61f <printf+0x50>
        state = '%';
 613:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 61a:	e9 27 01 00 00       	jmp    746 <printf+0x177>
      } else {
        putc(fd, c);
 61f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 622:	0f be c0             	movsbl %al,%eax
 625:	83 ec 08             	sub    $0x8,%esp
 628:	50                   	push   %eax
 629:	ff 75 08             	pushl  0x8(%ebp)
 62c:	e8 c7 fe ff ff       	call   4f8 <putc>
 631:	83 c4 10             	add    $0x10,%esp
 634:	e9 0d 01 00 00       	jmp    746 <printf+0x177>
      }
    } else if(state == '%'){
 639:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 63d:	0f 85 03 01 00 00    	jne    746 <printf+0x177>
      if(c == 'd'){
 643:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 647:	75 1e                	jne    667 <printf+0x98>
        printint(fd, *ap, 10, 1);
 649:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64c:	8b 00                	mov    (%eax),%eax
 64e:	6a 01                	push   $0x1
 650:	6a 0a                	push   $0xa
 652:	50                   	push   %eax
 653:	ff 75 08             	pushl  0x8(%ebp)
 656:	e8 c0 fe ff ff       	call   51b <printint>
 65b:	83 c4 10             	add    $0x10,%esp
        ap++;
 65e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 662:	e9 d8 00 00 00       	jmp    73f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 667:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 66b:	74 06                	je     673 <printf+0xa4>
 66d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 671:	75 1e                	jne    691 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 673:	8b 45 e8             	mov    -0x18(%ebp),%eax
 676:	8b 00                	mov    (%eax),%eax
 678:	6a 00                	push   $0x0
 67a:	6a 10                	push   $0x10
 67c:	50                   	push   %eax
 67d:	ff 75 08             	pushl  0x8(%ebp)
 680:	e8 96 fe ff ff       	call   51b <printint>
 685:	83 c4 10             	add    $0x10,%esp
        ap++;
 688:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 68c:	e9 ae 00 00 00       	jmp    73f <printf+0x170>
      } else if(c == 's'){
 691:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 695:	75 43                	jne    6da <printf+0x10b>
        s = (char*)*ap;
 697:	8b 45 e8             	mov    -0x18(%ebp),%eax
 69a:	8b 00                	mov    (%eax),%eax
 69c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 69f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6a7:	75 25                	jne    6ce <printf+0xff>
          s = "(null)";
 6a9:	c7 45 f4 f6 09 00 00 	movl   $0x9f6,-0xc(%ebp)
        while(*s != 0){
 6b0:	eb 1c                	jmp    6ce <printf+0xff>
          putc(fd, *s);
 6b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b5:	0f b6 00             	movzbl (%eax),%eax
 6b8:	0f be c0             	movsbl %al,%eax
 6bb:	83 ec 08             	sub    $0x8,%esp
 6be:	50                   	push   %eax
 6bf:	ff 75 08             	pushl  0x8(%ebp)
 6c2:	e8 31 fe ff ff       	call   4f8 <putc>
 6c7:	83 c4 10             	add    $0x10,%esp
          s++;
 6ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d1:	0f b6 00             	movzbl (%eax),%eax
 6d4:	84 c0                	test   %al,%al
 6d6:	75 da                	jne    6b2 <printf+0xe3>
 6d8:	eb 65                	jmp    73f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6da:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6de:	75 1d                	jne    6fd <printf+0x12e>
        putc(fd, *ap);
 6e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e3:	8b 00                	mov    (%eax),%eax
 6e5:	0f be c0             	movsbl %al,%eax
 6e8:	83 ec 08             	sub    $0x8,%esp
 6eb:	50                   	push   %eax
 6ec:	ff 75 08             	pushl  0x8(%ebp)
 6ef:	e8 04 fe ff ff       	call   4f8 <putc>
 6f4:	83 c4 10             	add    $0x10,%esp
        ap++;
 6f7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6fb:	eb 42                	jmp    73f <printf+0x170>
      } else if(c == '%'){
 6fd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 701:	75 17                	jne    71a <printf+0x14b>
        putc(fd, c);
 703:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 706:	0f be c0             	movsbl %al,%eax
 709:	83 ec 08             	sub    $0x8,%esp
 70c:	50                   	push   %eax
 70d:	ff 75 08             	pushl  0x8(%ebp)
 710:	e8 e3 fd ff ff       	call   4f8 <putc>
 715:	83 c4 10             	add    $0x10,%esp
 718:	eb 25                	jmp    73f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 71a:	83 ec 08             	sub    $0x8,%esp
 71d:	6a 25                	push   $0x25
 71f:	ff 75 08             	pushl  0x8(%ebp)
 722:	e8 d1 fd ff ff       	call   4f8 <putc>
 727:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 72a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 72d:	0f be c0             	movsbl %al,%eax
 730:	83 ec 08             	sub    $0x8,%esp
 733:	50                   	push   %eax
 734:	ff 75 08             	pushl  0x8(%ebp)
 737:	e8 bc fd ff ff       	call   4f8 <putc>
 73c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 73f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 746:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 74a:	8b 55 0c             	mov    0xc(%ebp),%edx
 74d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 750:	01 d0                	add    %edx,%eax
 752:	0f b6 00             	movzbl (%eax),%eax
 755:	84 c0                	test   %al,%al
 757:	0f 85 94 fe ff ff    	jne    5f1 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 75d:	90                   	nop
 75e:	c9                   	leave  
 75f:	c3                   	ret    

00000760 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 760:	55                   	push   %ebp
 761:	89 e5                	mov    %esp,%ebp
 763:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 766:	8b 45 08             	mov    0x8(%ebp),%eax
 769:	83 e8 08             	sub    $0x8,%eax
 76c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76f:	a1 80 0c 00 00       	mov    0xc80,%eax
 774:	89 45 fc             	mov    %eax,-0x4(%ebp)
 777:	eb 24                	jmp    79d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 779:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77c:	8b 00                	mov    (%eax),%eax
 77e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 781:	77 12                	ja     795 <free+0x35>
 783:	8b 45 f8             	mov    -0x8(%ebp),%eax
 786:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 789:	77 24                	ja     7af <free+0x4f>
 78b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78e:	8b 00                	mov    (%eax),%eax
 790:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 793:	77 1a                	ja     7af <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 795:	8b 45 fc             	mov    -0x4(%ebp),%eax
 798:	8b 00                	mov    (%eax),%eax
 79a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 79d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a3:	76 d4                	jbe    779 <free+0x19>
 7a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a8:	8b 00                	mov    (%eax),%eax
 7aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7ad:	76 ca                	jbe    779 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b2:	8b 40 04             	mov    0x4(%eax),%eax
 7b5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bf:	01 c2                	add    %eax,%edx
 7c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c4:	8b 00                	mov    (%eax),%eax
 7c6:	39 c2                	cmp    %eax,%edx
 7c8:	75 24                	jne    7ee <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cd:	8b 50 04             	mov    0x4(%eax),%edx
 7d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d3:	8b 00                	mov    (%eax),%eax
 7d5:	8b 40 04             	mov    0x4(%eax),%eax
 7d8:	01 c2                	add    %eax,%edx
 7da:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7dd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e3:	8b 00                	mov    (%eax),%eax
 7e5:	8b 10                	mov    (%eax),%edx
 7e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ea:	89 10                	mov    %edx,(%eax)
 7ec:	eb 0a                	jmp    7f8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f1:	8b 10                	mov    (%eax),%edx
 7f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fb:	8b 40 04             	mov    0x4(%eax),%eax
 7fe:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 805:	8b 45 fc             	mov    -0x4(%ebp),%eax
 808:	01 d0                	add    %edx,%eax
 80a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 80d:	75 20                	jne    82f <free+0xcf>
    p->s.size += bp->s.size;
 80f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 812:	8b 50 04             	mov    0x4(%eax),%edx
 815:	8b 45 f8             	mov    -0x8(%ebp),%eax
 818:	8b 40 04             	mov    0x4(%eax),%eax
 81b:	01 c2                	add    %eax,%edx
 81d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 820:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 823:	8b 45 f8             	mov    -0x8(%ebp),%eax
 826:	8b 10                	mov    (%eax),%edx
 828:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82b:	89 10                	mov    %edx,(%eax)
 82d:	eb 08                	jmp    837 <free+0xd7>
  } else
    p->s.ptr = bp;
 82f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 832:	8b 55 f8             	mov    -0x8(%ebp),%edx
 835:	89 10                	mov    %edx,(%eax)
  freep = p;
 837:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83a:	a3 80 0c 00 00       	mov    %eax,0xc80
}
 83f:	90                   	nop
 840:	c9                   	leave  
 841:	c3                   	ret    

00000842 <morecore>:

static Header*
morecore(uint nu)
{
 842:	55                   	push   %ebp
 843:	89 e5                	mov    %esp,%ebp
 845:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 848:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 84f:	77 07                	ja     858 <morecore+0x16>
    nu = 4096;
 851:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 858:	8b 45 08             	mov    0x8(%ebp),%eax
 85b:	c1 e0 03             	shl    $0x3,%eax
 85e:	83 ec 0c             	sub    $0xc,%esp
 861:	50                   	push   %eax
 862:	e8 39 fc ff ff       	call   4a0 <sbrk>
 867:	83 c4 10             	add    $0x10,%esp
 86a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 86d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 871:	75 07                	jne    87a <morecore+0x38>
    return 0;
 873:	b8 00 00 00 00       	mov    $0x0,%eax
 878:	eb 26                	jmp    8a0 <morecore+0x5e>
  hp = (Header*)p;
 87a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 880:	8b 45 f0             	mov    -0x10(%ebp),%eax
 883:	8b 55 08             	mov    0x8(%ebp),%edx
 886:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 889:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88c:	83 c0 08             	add    $0x8,%eax
 88f:	83 ec 0c             	sub    $0xc,%esp
 892:	50                   	push   %eax
 893:	e8 c8 fe ff ff       	call   760 <free>
 898:	83 c4 10             	add    $0x10,%esp
  return freep;
 89b:	a1 80 0c 00 00       	mov    0xc80,%eax
}
 8a0:	c9                   	leave  
 8a1:	c3                   	ret    

000008a2 <malloc>:

void*
malloc(uint nbytes)
{
 8a2:	55                   	push   %ebp
 8a3:	89 e5                	mov    %esp,%ebp
 8a5:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a8:	8b 45 08             	mov    0x8(%ebp),%eax
 8ab:	83 c0 07             	add    $0x7,%eax
 8ae:	c1 e8 03             	shr    $0x3,%eax
 8b1:	83 c0 01             	add    $0x1,%eax
 8b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8b7:	a1 80 0c 00 00       	mov    0xc80,%eax
 8bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8c3:	75 23                	jne    8e8 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8c5:	c7 45 f0 78 0c 00 00 	movl   $0xc78,-0x10(%ebp)
 8cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8cf:	a3 80 0c 00 00       	mov    %eax,0xc80
 8d4:	a1 80 0c 00 00       	mov    0xc80,%eax
 8d9:	a3 78 0c 00 00       	mov    %eax,0xc78
    base.s.size = 0;
 8de:	c7 05 7c 0c 00 00 00 	movl   $0x0,0xc7c
 8e5:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8eb:	8b 00                	mov    (%eax),%eax
 8ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f3:	8b 40 04             	mov    0x4(%eax),%eax
 8f6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8f9:	72 4d                	jb     948 <malloc+0xa6>
      if(p->s.size == nunits)
 8fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fe:	8b 40 04             	mov    0x4(%eax),%eax
 901:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 904:	75 0c                	jne    912 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 906:	8b 45 f4             	mov    -0xc(%ebp),%eax
 909:	8b 10                	mov    (%eax),%edx
 90b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90e:	89 10                	mov    %edx,(%eax)
 910:	eb 26                	jmp    938 <malloc+0x96>
      else {
        p->s.size -= nunits;
 912:	8b 45 f4             	mov    -0xc(%ebp),%eax
 915:	8b 40 04             	mov    0x4(%eax),%eax
 918:	2b 45 ec             	sub    -0x14(%ebp),%eax
 91b:	89 c2                	mov    %eax,%edx
 91d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 920:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 923:	8b 45 f4             	mov    -0xc(%ebp),%eax
 926:	8b 40 04             	mov    0x4(%eax),%eax
 929:	c1 e0 03             	shl    $0x3,%eax
 92c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 92f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 932:	8b 55 ec             	mov    -0x14(%ebp),%edx
 935:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 938:	8b 45 f0             	mov    -0x10(%ebp),%eax
 93b:	a3 80 0c 00 00       	mov    %eax,0xc80
      return (void*)(p + 1);
 940:	8b 45 f4             	mov    -0xc(%ebp),%eax
 943:	83 c0 08             	add    $0x8,%eax
 946:	eb 3b                	jmp    983 <malloc+0xe1>
    }
    if(p == freep)
 948:	a1 80 0c 00 00       	mov    0xc80,%eax
 94d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 950:	75 1e                	jne    970 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 952:	83 ec 0c             	sub    $0xc,%esp
 955:	ff 75 ec             	pushl  -0x14(%ebp)
 958:	e8 e5 fe ff ff       	call   842 <morecore>
 95d:	83 c4 10             	add    $0x10,%esp
 960:	89 45 f4             	mov    %eax,-0xc(%ebp)
 963:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 967:	75 07                	jne    970 <malloc+0xce>
        return 0;
 969:	b8 00 00 00 00       	mov    $0x0,%eax
 96e:	eb 13                	jmp    983 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 970:	8b 45 f4             	mov    -0xc(%ebp),%eax
 973:	89 45 f0             	mov    %eax,-0x10(%ebp)
 976:	8b 45 f4             	mov    -0xc(%ebp),%eax
 979:	8b 00                	mov    (%eax),%eax
 97b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 97e:	e9 6d ff ff ff       	jmp    8f0 <malloc+0x4e>
}
 983:	c9                   	leave  
 984:	c3                   	ret    
