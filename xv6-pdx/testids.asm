
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
  14:	68 7d 09 00 00       	push   $0x97d
  19:	6a 02                	push   $0x2
  1b:	e8 a7 05 00 00       	call   5c7 <printf>
  20:	83 c4 10             	add    $0x10,%esp
    printf(2, "Setting UID to 100\n");
  23:	83 ec 08             	sub    $0x8,%esp
  26:	68 91 09 00 00       	push   $0x991
  2b:	6a 02                	push   $0x2
  2d:	e8 95 05 00 00       	call   5c7 <printf>
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
  50:	68 7d 09 00 00       	push   $0x97d
  55:	6a 02                	push   $0x2
  57:	e8 6b 05 00 00       	call   5c7 <printf>
  5c:	83 c4 10             	add    $0x10,%esp

    gid = getgid();
  5f:	e8 6c 04 00 00       	call   4d0 <getgid>
  64:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(2, "Current GID is: %d\n", gid);
  67:	83 ec 04             	sub    $0x4,%esp
  6a:	ff 75 f0             	pushl  -0x10(%ebp)
  6d:	68 a5 09 00 00       	push   $0x9a5
  72:	6a 02                	push   $0x2
  74:	e8 4e 05 00 00       	call   5c7 <printf>
  79:	83 c4 10             	add    $0x10,%esp
    printf(2, "Setting GID to 100\n");
  7c:	83 ec 08             	sub    $0x8,%esp
  7f:	68 b9 09 00 00       	push   $0x9b9
  84:	6a 02                	push   $0x2
  86:	e8 3c 05 00 00       	call   5c7 <printf>
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
  a9:	68 a5 09 00 00       	push   $0x9a5
  ae:	6a 02                	push   $0x2
  b0:	e8 12 05 00 00       	call   5c7 <printf>
  b5:	83 c4 10             	add    $0x10,%esp

    ppid = getppid();
  b8:	e8 1b 04 00 00       	call   4d8 <getppid>
  bd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(2, "My parent process is: %d\n", ppid);
  c0:	83 ec 04             	sub    $0x4,%esp
  c3:	ff 75 ec             	pushl  -0x14(%ebp)
  c6:	68 cd 09 00 00       	push   $0x9cd
  cb:	6a 02                	push   $0x2
  cd:	e8 f5 04 00 00       	call   5c7 <printf>
  d2:	83 c4 10             	add    $0x10,%esp
    printf(2, "Done!\n");
  d5:	83 ec 08             	sub    $0x8,%esp
  d8:	68 e7 09 00 00       	push   $0x9e7
  dd:	6a 02                	push   $0x2
  df:	e8 e3 04 00 00       	call   5c7 <printf>
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

000004f0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4f0:	55                   	push   %ebp
 4f1:	89 e5                	mov    %esp,%ebp
 4f3:	83 ec 18             	sub    $0x18,%esp
 4f6:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4fc:	83 ec 04             	sub    $0x4,%esp
 4ff:	6a 01                	push   $0x1
 501:	8d 45 f4             	lea    -0xc(%ebp),%eax
 504:	50                   	push   %eax
 505:	ff 75 08             	pushl  0x8(%ebp)
 508:	e8 2b ff ff ff       	call   438 <write>
 50d:	83 c4 10             	add    $0x10,%esp
}
 510:	90                   	nop
 511:	c9                   	leave  
 512:	c3                   	ret    

00000513 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 513:	55                   	push   %ebp
 514:	89 e5                	mov    %esp,%ebp
 516:	53                   	push   %ebx
 517:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 51a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 521:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 525:	74 17                	je     53e <printint+0x2b>
 527:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 52b:	79 11                	jns    53e <printint+0x2b>
    neg = 1;
 52d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 534:	8b 45 0c             	mov    0xc(%ebp),%eax
 537:	f7 d8                	neg    %eax
 539:	89 45 ec             	mov    %eax,-0x14(%ebp)
 53c:	eb 06                	jmp    544 <printint+0x31>
  } else {
    x = xx;
 53e:	8b 45 0c             	mov    0xc(%ebp),%eax
 541:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 544:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 54b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 54e:	8d 41 01             	lea    0x1(%ecx),%eax
 551:	89 45 f4             	mov    %eax,-0xc(%ebp)
 554:	8b 5d 10             	mov    0x10(%ebp),%ebx
 557:	8b 45 ec             	mov    -0x14(%ebp),%eax
 55a:	ba 00 00 00 00       	mov    $0x0,%edx
 55f:	f7 f3                	div    %ebx
 561:	89 d0                	mov    %edx,%eax
 563:	0f b6 80 5c 0c 00 00 	movzbl 0xc5c(%eax),%eax
 56a:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 56e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 571:	8b 45 ec             	mov    -0x14(%ebp),%eax
 574:	ba 00 00 00 00       	mov    $0x0,%edx
 579:	f7 f3                	div    %ebx
 57b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 57e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 582:	75 c7                	jne    54b <printint+0x38>
  if(neg)
 584:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 588:	74 2d                	je     5b7 <printint+0xa4>
    buf[i++] = '-';
 58a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 58d:	8d 50 01             	lea    0x1(%eax),%edx
 590:	89 55 f4             	mov    %edx,-0xc(%ebp)
 593:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 598:	eb 1d                	jmp    5b7 <printint+0xa4>
    putc(fd, buf[i]);
 59a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 59d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5a0:	01 d0                	add    %edx,%eax
 5a2:	0f b6 00             	movzbl (%eax),%eax
 5a5:	0f be c0             	movsbl %al,%eax
 5a8:	83 ec 08             	sub    $0x8,%esp
 5ab:	50                   	push   %eax
 5ac:	ff 75 08             	pushl  0x8(%ebp)
 5af:	e8 3c ff ff ff       	call   4f0 <putc>
 5b4:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5b7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5bf:	79 d9                	jns    59a <printint+0x87>
    putc(fd, buf[i]);
}
 5c1:	90                   	nop
 5c2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5c5:	c9                   	leave  
 5c6:	c3                   	ret    

000005c7 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5c7:	55                   	push   %ebp
 5c8:	89 e5                	mov    %esp,%ebp
 5ca:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5cd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5d4:	8d 45 0c             	lea    0xc(%ebp),%eax
 5d7:	83 c0 04             	add    $0x4,%eax
 5da:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5e4:	e9 59 01 00 00       	jmp    742 <printf+0x17b>
    c = fmt[i] & 0xff;
 5e9:	8b 55 0c             	mov    0xc(%ebp),%edx
 5ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5ef:	01 d0                	add    %edx,%eax
 5f1:	0f b6 00             	movzbl (%eax),%eax
 5f4:	0f be c0             	movsbl %al,%eax
 5f7:	25 ff 00 00 00       	and    $0xff,%eax
 5fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 603:	75 2c                	jne    631 <printf+0x6a>
      if(c == '%'){
 605:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 609:	75 0c                	jne    617 <printf+0x50>
        state = '%';
 60b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 612:	e9 27 01 00 00       	jmp    73e <printf+0x177>
      } else {
        putc(fd, c);
 617:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 61a:	0f be c0             	movsbl %al,%eax
 61d:	83 ec 08             	sub    $0x8,%esp
 620:	50                   	push   %eax
 621:	ff 75 08             	pushl  0x8(%ebp)
 624:	e8 c7 fe ff ff       	call   4f0 <putc>
 629:	83 c4 10             	add    $0x10,%esp
 62c:	e9 0d 01 00 00       	jmp    73e <printf+0x177>
      }
    } else if(state == '%'){
 631:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 635:	0f 85 03 01 00 00    	jne    73e <printf+0x177>
      if(c == 'd'){
 63b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 63f:	75 1e                	jne    65f <printf+0x98>
        printint(fd, *ap, 10, 1);
 641:	8b 45 e8             	mov    -0x18(%ebp),%eax
 644:	8b 00                	mov    (%eax),%eax
 646:	6a 01                	push   $0x1
 648:	6a 0a                	push   $0xa
 64a:	50                   	push   %eax
 64b:	ff 75 08             	pushl  0x8(%ebp)
 64e:	e8 c0 fe ff ff       	call   513 <printint>
 653:	83 c4 10             	add    $0x10,%esp
        ap++;
 656:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 65a:	e9 d8 00 00 00       	jmp    737 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 65f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 663:	74 06                	je     66b <printf+0xa4>
 665:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 669:	75 1e                	jne    689 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 66b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66e:	8b 00                	mov    (%eax),%eax
 670:	6a 00                	push   $0x0
 672:	6a 10                	push   $0x10
 674:	50                   	push   %eax
 675:	ff 75 08             	pushl  0x8(%ebp)
 678:	e8 96 fe ff ff       	call   513 <printint>
 67d:	83 c4 10             	add    $0x10,%esp
        ap++;
 680:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 684:	e9 ae 00 00 00       	jmp    737 <printf+0x170>
      } else if(c == 's'){
 689:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 68d:	75 43                	jne    6d2 <printf+0x10b>
        s = (char*)*ap;
 68f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 692:	8b 00                	mov    (%eax),%eax
 694:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 697:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 69b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 69f:	75 25                	jne    6c6 <printf+0xff>
          s = "(null)";
 6a1:	c7 45 f4 ee 09 00 00 	movl   $0x9ee,-0xc(%ebp)
        while(*s != 0){
 6a8:	eb 1c                	jmp    6c6 <printf+0xff>
          putc(fd, *s);
 6aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ad:	0f b6 00             	movzbl (%eax),%eax
 6b0:	0f be c0             	movsbl %al,%eax
 6b3:	83 ec 08             	sub    $0x8,%esp
 6b6:	50                   	push   %eax
 6b7:	ff 75 08             	pushl  0x8(%ebp)
 6ba:	e8 31 fe ff ff       	call   4f0 <putc>
 6bf:	83 c4 10             	add    $0x10,%esp
          s++;
 6c2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c9:	0f b6 00             	movzbl (%eax),%eax
 6cc:	84 c0                	test   %al,%al
 6ce:	75 da                	jne    6aa <printf+0xe3>
 6d0:	eb 65                	jmp    737 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6d2:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6d6:	75 1d                	jne    6f5 <printf+0x12e>
        putc(fd, *ap);
 6d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6db:	8b 00                	mov    (%eax),%eax
 6dd:	0f be c0             	movsbl %al,%eax
 6e0:	83 ec 08             	sub    $0x8,%esp
 6e3:	50                   	push   %eax
 6e4:	ff 75 08             	pushl  0x8(%ebp)
 6e7:	e8 04 fe ff ff       	call   4f0 <putc>
 6ec:	83 c4 10             	add    $0x10,%esp
        ap++;
 6ef:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6f3:	eb 42                	jmp    737 <printf+0x170>
      } else if(c == '%'){
 6f5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6f9:	75 17                	jne    712 <printf+0x14b>
        putc(fd, c);
 6fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6fe:	0f be c0             	movsbl %al,%eax
 701:	83 ec 08             	sub    $0x8,%esp
 704:	50                   	push   %eax
 705:	ff 75 08             	pushl  0x8(%ebp)
 708:	e8 e3 fd ff ff       	call   4f0 <putc>
 70d:	83 c4 10             	add    $0x10,%esp
 710:	eb 25                	jmp    737 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 712:	83 ec 08             	sub    $0x8,%esp
 715:	6a 25                	push   $0x25
 717:	ff 75 08             	pushl  0x8(%ebp)
 71a:	e8 d1 fd ff ff       	call   4f0 <putc>
 71f:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 722:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 725:	0f be c0             	movsbl %al,%eax
 728:	83 ec 08             	sub    $0x8,%esp
 72b:	50                   	push   %eax
 72c:	ff 75 08             	pushl  0x8(%ebp)
 72f:	e8 bc fd ff ff       	call   4f0 <putc>
 734:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 737:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 73e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 742:	8b 55 0c             	mov    0xc(%ebp),%edx
 745:	8b 45 f0             	mov    -0x10(%ebp),%eax
 748:	01 d0                	add    %edx,%eax
 74a:	0f b6 00             	movzbl (%eax),%eax
 74d:	84 c0                	test   %al,%al
 74f:	0f 85 94 fe ff ff    	jne    5e9 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 755:	90                   	nop
 756:	c9                   	leave  
 757:	c3                   	ret    

00000758 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 758:	55                   	push   %ebp
 759:	89 e5                	mov    %esp,%ebp
 75b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75e:	8b 45 08             	mov    0x8(%ebp),%eax
 761:	83 e8 08             	sub    $0x8,%eax
 764:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 767:	a1 78 0c 00 00       	mov    0xc78,%eax
 76c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 76f:	eb 24                	jmp    795 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 771:	8b 45 fc             	mov    -0x4(%ebp),%eax
 774:	8b 00                	mov    (%eax),%eax
 776:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 779:	77 12                	ja     78d <free+0x35>
 77b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 781:	77 24                	ja     7a7 <free+0x4f>
 783:	8b 45 fc             	mov    -0x4(%ebp),%eax
 786:	8b 00                	mov    (%eax),%eax
 788:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 78b:	77 1a                	ja     7a7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 790:	8b 00                	mov    (%eax),%eax
 792:	89 45 fc             	mov    %eax,-0x4(%ebp)
 795:	8b 45 f8             	mov    -0x8(%ebp),%eax
 798:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 79b:	76 d4                	jbe    771 <free+0x19>
 79d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a0:	8b 00                	mov    (%eax),%eax
 7a2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a5:	76 ca                	jbe    771 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7aa:	8b 40 04             	mov    0x4(%eax),%eax
 7ad:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b7:	01 c2                	add    %eax,%edx
 7b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bc:	8b 00                	mov    (%eax),%eax
 7be:	39 c2                	cmp    %eax,%edx
 7c0:	75 24                	jne    7e6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c5:	8b 50 04             	mov    0x4(%eax),%edx
 7c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cb:	8b 00                	mov    (%eax),%eax
 7cd:	8b 40 04             	mov    0x4(%eax),%eax
 7d0:	01 c2                	add    %eax,%edx
 7d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7db:	8b 00                	mov    (%eax),%eax
 7dd:	8b 10                	mov    (%eax),%edx
 7df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e2:	89 10                	mov    %edx,(%eax)
 7e4:	eb 0a                	jmp    7f0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e9:	8b 10                	mov    (%eax),%edx
 7eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ee:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f3:	8b 40 04             	mov    0x4(%eax),%eax
 7f6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 800:	01 d0                	add    %edx,%eax
 802:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 805:	75 20                	jne    827 <free+0xcf>
    p->s.size += bp->s.size;
 807:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80a:	8b 50 04             	mov    0x4(%eax),%edx
 80d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 810:	8b 40 04             	mov    0x4(%eax),%eax
 813:	01 c2                	add    %eax,%edx
 815:	8b 45 fc             	mov    -0x4(%ebp),%eax
 818:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 81b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81e:	8b 10                	mov    (%eax),%edx
 820:	8b 45 fc             	mov    -0x4(%ebp),%eax
 823:	89 10                	mov    %edx,(%eax)
 825:	eb 08                	jmp    82f <free+0xd7>
  } else
    p->s.ptr = bp;
 827:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 82d:	89 10                	mov    %edx,(%eax)
  freep = p;
 82f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 832:	a3 78 0c 00 00       	mov    %eax,0xc78
}
 837:	90                   	nop
 838:	c9                   	leave  
 839:	c3                   	ret    

0000083a <morecore>:

static Header*
morecore(uint nu)
{
 83a:	55                   	push   %ebp
 83b:	89 e5                	mov    %esp,%ebp
 83d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 840:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 847:	77 07                	ja     850 <morecore+0x16>
    nu = 4096;
 849:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 850:	8b 45 08             	mov    0x8(%ebp),%eax
 853:	c1 e0 03             	shl    $0x3,%eax
 856:	83 ec 0c             	sub    $0xc,%esp
 859:	50                   	push   %eax
 85a:	e8 41 fc ff ff       	call   4a0 <sbrk>
 85f:	83 c4 10             	add    $0x10,%esp
 862:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 865:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 869:	75 07                	jne    872 <morecore+0x38>
    return 0;
 86b:	b8 00 00 00 00       	mov    $0x0,%eax
 870:	eb 26                	jmp    898 <morecore+0x5e>
  hp = (Header*)p;
 872:	8b 45 f4             	mov    -0xc(%ebp),%eax
 875:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 878:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87b:	8b 55 08             	mov    0x8(%ebp),%edx
 87e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 881:	8b 45 f0             	mov    -0x10(%ebp),%eax
 884:	83 c0 08             	add    $0x8,%eax
 887:	83 ec 0c             	sub    $0xc,%esp
 88a:	50                   	push   %eax
 88b:	e8 c8 fe ff ff       	call   758 <free>
 890:	83 c4 10             	add    $0x10,%esp
  return freep;
 893:	a1 78 0c 00 00       	mov    0xc78,%eax
}
 898:	c9                   	leave  
 899:	c3                   	ret    

0000089a <malloc>:

void*
malloc(uint nbytes)
{
 89a:	55                   	push   %ebp
 89b:	89 e5                	mov    %esp,%ebp
 89d:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a0:	8b 45 08             	mov    0x8(%ebp),%eax
 8a3:	83 c0 07             	add    $0x7,%eax
 8a6:	c1 e8 03             	shr    $0x3,%eax
 8a9:	83 c0 01             	add    $0x1,%eax
 8ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8af:	a1 78 0c 00 00       	mov    0xc78,%eax
 8b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8bb:	75 23                	jne    8e0 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8bd:	c7 45 f0 70 0c 00 00 	movl   $0xc70,-0x10(%ebp)
 8c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c7:	a3 78 0c 00 00       	mov    %eax,0xc78
 8cc:	a1 78 0c 00 00       	mov    0xc78,%eax
 8d1:	a3 70 0c 00 00       	mov    %eax,0xc70
    base.s.size = 0;
 8d6:	c7 05 74 0c 00 00 00 	movl   $0x0,0xc74
 8dd:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e3:	8b 00                	mov    (%eax),%eax
 8e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8eb:	8b 40 04             	mov    0x4(%eax),%eax
 8ee:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8f1:	72 4d                	jb     940 <malloc+0xa6>
      if(p->s.size == nunits)
 8f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f6:	8b 40 04             	mov    0x4(%eax),%eax
 8f9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8fc:	75 0c                	jne    90a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 901:	8b 10                	mov    (%eax),%edx
 903:	8b 45 f0             	mov    -0x10(%ebp),%eax
 906:	89 10                	mov    %edx,(%eax)
 908:	eb 26                	jmp    930 <malloc+0x96>
      else {
        p->s.size -= nunits;
 90a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90d:	8b 40 04             	mov    0x4(%eax),%eax
 910:	2b 45 ec             	sub    -0x14(%ebp),%eax
 913:	89 c2                	mov    %eax,%edx
 915:	8b 45 f4             	mov    -0xc(%ebp),%eax
 918:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 91b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91e:	8b 40 04             	mov    0x4(%eax),%eax
 921:	c1 e0 03             	shl    $0x3,%eax
 924:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 927:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 92d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 930:	8b 45 f0             	mov    -0x10(%ebp),%eax
 933:	a3 78 0c 00 00       	mov    %eax,0xc78
      return (void*)(p + 1);
 938:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93b:	83 c0 08             	add    $0x8,%eax
 93e:	eb 3b                	jmp    97b <malloc+0xe1>
    }
    if(p == freep)
 940:	a1 78 0c 00 00       	mov    0xc78,%eax
 945:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 948:	75 1e                	jne    968 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 94a:	83 ec 0c             	sub    $0xc,%esp
 94d:	ff 75 ec             	pushl  -0x14(%ebp)
 950:	e8 e5 fe ff ff       	call   83a <morecore>
 955:	83 c4 10             	add    $0x10,%esp
 958:	89 45 f4             	mov    %eax,-0xc(%ebp)
 95b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 95f:	75 07                	jne    968 <malloc+0xce>
        return 0;
 961:	b8 00 00 00 00       	mov    $0x0,%eax
 966:	eb 13                	jmp    97b <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 968:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 96e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 971:	8b 00                	mov    (%eax),%eax
 973:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 976:	e9 6d ff ff ff       	jmp    8e8 <malloc+0x4e>
}
 97b:	c9                   	leave  
 97c:	c3                   	ret    
