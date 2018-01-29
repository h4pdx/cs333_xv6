
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
   6:	e8 8d 05 00 00       	call   598 <getuid>
   b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(2, "Current UID: %d\n", uid);
   e:	83 ec 04             	sub    $0x4,%esp
  11:	ff 75 f4             	pushl  -0xc(%ebp)
  14:	68 58 0a 00 00       	push   $0xa58
  19:	6a 02                	push   $0x2
  1b:	e8 7f 06 00 00       	call   69f <printf>
  20:	83 c4 10             	add    $0x10,%esp
    
    // test setting uid and getting again
    printf(2, "Setting UID to 100...\n");
  23:	83 ec 08             	sub    $0x8,%esp
  26:	68 69 0a 00 00       	push   $0xa69
  2b:	6a 02                	push   $0x2
  2d:	e8 6d 06 00 00       	call   69f <printf>
  32:	83 c4 10             	add    $0x10,%esp
    if (setuid(100) == 0) {
  35:	83 ec 0c             	sub    $0xc,%esp
  38:	6a 64                	push   $0x64
  3a:	e8 71 05 00 00       	call   5b0 <setuid>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	85 c0                	test   %eax,%eax
  44:	75 12                	jne    58 <testuidgid+0x58>
        printf(2, "UID set.\n");
  46:	83 ec 08             	sub    $0x8,%esp
  49:	68 80 0a 00 00       	push   $0xa80
  4e:	6a 02                	push   $0x2
  50:	e8 4a 06 00 00       	call   69f <printf>
  55:	83 c4 10             	add    $0x10,%esp
    }
    uid = getuid();
  58:	e8 3b 05 00 00       	call   598 <getuid>
  5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    printf(2, "UID updated: %d\n", uid);
  60:	83 ec 04             	sub    $0x4,%esp
  63:	ff 75 f4             	pushl  -0xc(%ebp)
  66:	68 8a 0a 00 00       	push   $0xa8a
  6b:	6a 02                	push   $0x2
  6d:	e8 2d 06 00 00       	call   69f <printf>
  72:	83 c4 10             	add    $0x10,%esp

    // test getting set gid
    gid = getgid();
  75:	e8 26 05 00 00       	call   5a0 <getgid>
  7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(2, "Current GID: %d\n", gid);
  7d:	83 ec 04             	sub    $0x4,%esp
  80:	ff 75 f0             	pushl  -0x10(%ebp)
  83:	68 9b 0a 00 00       	push   $0xa9b
  88:	6a 02                	push   $0x2
  8a:	e8 10 06 00 00       	call   69f <printf>
  8f:	83 c4 10             	add    $0x10,%esp

    // test gid setting and getting
    printf(2, "Setting GID to 100...\n");
  92:	83 ec 08             	sub    $0x8,%esp
  95:	68 ac 0a 00 00       	push   $0xaac
  9a:	6a 02                	push   $0x2
  9c:	e8 fe 05 00 00       	call   69f <printf>
  a1:	83 c4 10             	add    $0x10,%esp
    if (setgid(100) == 0) {
  a4:	83 ec 0c             	sub    $0xc,%esp
  a7:	6a 64                	push   $0x64
  a9:	e8 0a 05 00 00       	call   5b8 <setgid>
  ae:	83 c4 10             	add    $0x10,%esp
  b1:	85 c0                	test   %eax,%eax
  b3:	75 12                	jne    c7 <testuidgid+0xc7>
        printf(2, "GID set.\n");
  b5:	83 ec 08             	sub    $0x8,%esp
  b8:	68 c3 0a 00 00       	push   $0xac3
  bd:	6a 02                	push   $0x2
  bf:	e8 db 05 00 00       	call   69f <printf>
  c4:	83 c4 10             	add    $0x10,%esp
    }
    gid = getgid();
  c7:	e8 d4 04 00 00       	call   5a0 <getgid>
  cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(2, "GID updated: %d\n", gid);
  cf:	83 ec 04             	sub    $0x4,%esp
  d2:	ff 75 f0             	pushl  -0x10(%ebp)
  d5:	68 cd 0a 00 00       	push   $0xacd
  da:	6a 02                	push   $0x2
  dc:	e8 be 05 00 00       	call   69f <printf>
  e1:	83 c4 10             	add    $0x10,%esp

    // testprocess
    ppid = getppid();
  e4:	e8 bf 04 00 00       	call   5a8 <getppid>
  e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    printf(2, "Parent Process ID: %d\n", ppid);
  ec:	83 ec 04             	sub    $0x4,%esp
  ef:	ff 75 ec             	pushl  -0x14(%ebp)
  f2:	68 de 0a 00 00       	push   $0xade
  f7:	6a 02                	push   $0x2
  f9:	e8 a1 05 00 00       	call   69f <printf>
  fe:	83 c4 10             	add    $0x10,%esp

    // test proper failure 
    printf(2, "Setting current UID to 33000 (max is 32767).\n");
 101:	83 ec 08             	sub    $0x8,%esp
 104:	68 f8 0a 00 00       	push   $0xaf8
 109:	6a 02                	push   $0x2
 10b:	e8 8f 05 00 00       	call   69f <printf>
 110:	83 c4 10             	add    $0x10,%esp
    if (setuid(33000) < 0) {
 113:	83 ec 0c             	sub    $0xc,%esp
 116:	68 e8 80 00 00       	push   $0x80e8
 11b:	e8 90 04 00 00       	call   5b0 <setuid>
 120:	83 c4 10             	add    $0x10,%esp
 123:	85 c0                	test   %eax,%eax
 125:	79 2d                	jns    154 <testuidgid+0x154>
        printf(2, "Proper error code returned.\n");
 127:	83 ec 08             	sub    $0x8,%esp
 12a:	68 26 0b 00 00       	push   $0xb26
 12f:	6a 02                	push   $0x2
 131:	e8 69 05 00 00       	call   69f <printf>
 136:	83 c4 10             	add    $0x10,%esp
        if (getuid() == 0) {
 139:	e8 5a 04 00 00       	call   598 <getuid>
 13e:	85 c0                	test   %eax,%eax
 140:	75 12                	jne    154 <testuidgid+0x154>
            printf(2, "UID set to 0 after error.\n");
 142:	83 ec 08             	sub    $0x8,%esp
 145:	68 43 0b 00 00       	push   $0xb43
 14a:	6a 02                	push   $0x2
 14c:	e8 4e 05 00 00       	call   69f <printf>
 151:	83 c4 10             	add    $0x10,%esp
        }
    }

    // test proper failures
    printf(2, "Setting current GID to 33000 (max is 32767).\n");
 154:	83 ec 08             	sub    $0x8,%esp
 157:	68 60 0b 00 00       	push   $0xb60
 15c:	6a 02                	push   $0x2
 15e:	e8 3c 05 00 00       	call   69f <printf>
 163:	83 c4 10             	add    $0x10,%esp
    if (setgid(33000) < 0) {
 166:	83 ec 0c             	sub    $0xc,%esp
 169:	68 e8 80 00 00       	push   $0x80e8
 16e:	e8 45 04 00 00       	call   5b8 <setgid>
 173:	83 c4 10             	add    $0x10,%esp
 176:	85 c0                	test   %eax,%eax
 178:	79 2d                	jns    1a7 <testuidgid+0x1a7>
        printf(2, "Proper error code returned.\n");
 17a:	83 ec 08             	sub    $0x8,%esp
 17d:	68 26 0b 00 00       	push   $0xb26
 182:	6a 02                	push   $0x2
 184:	e8 16 05 00 00       	call   69f <printf>
 189:	83 c4 10             	add    $0x10,%esp
        if (getgid() == 0) {
 18c:	e8 0f 04 00 00       	call   5a0 <getgid>
 191:	85 c0                	test   %eax,%eax
 193:	75 12                	jne    1a7 <testuidgid+0x1a7>
            printf(2, "GID set to 0 after error.\n");
 195:	83 ec 08             	sub    $0x8,%esp
 198:	68 8e 0b 00 00       	push   $0xb8e
 19d:	6a 02                	push   $0x2
 19f:	e8 fb 04 00 00       	call   69f <printf>
 1a4:	83 c4 10             	add    $0x10,%esp
        }
    }
    printf(2, "Done!\n");
 1a7:	83 ec 08             	sub    $0x8,%esp
 1aa:	68 a9 0b 00 00       	push   $0xba9
 1af:	6a 02                	push   $0x2
 1b1:	e8 e9 04 00 00       	call   69f <printf>
 1b6:	83 c4 10             	add    $0x10,%esp
    exit();
 1b9:	e8 2a 03 00 00       	call   4e8 <exit>

000001be <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1be:	55                   	push   %ebp
 1bf:	89 e5                	mov    %esp,%ebp
 1c1:	57                   	push   %edi
 1c2:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1c3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c6:	8b 55 10             	mov    0x10(%ebp),%edx
 1c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cc:	89 cb                	mov    %ecx,%ebx
 1ce:	89 df                	mov    %ebx,%edi
 1d0:	89 d1                	mov    %edx,%ecx
 1d2:	fc                   	cld    
 1d3:	f3 aa                	rep stos %al,%es:(%edi)
 1d5:	89 ca                	mov    %ecx,%edx
 1d7:	89 fb                	mov    %edi,%ebx
 1d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1dc:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1df:	90                   	nop
 1e0:	5b                   	pop    %ebx
 1e1:	5f                   	pop    %edi
 1e2:	5d                   	pop    %ebp
 1e3:	c3                   	ret    

000001e4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1e4:	55                   	push   %ebp
 1e5:	89 e5                	mov    %esp,%ebp
 1e7:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1f0:	90                   	nop
 1f1:	8b 45 08             	mov    0x8(%ebp),%eax
 1f4:	8d 50 01             	lea    0x1(%eax),%edx
 1f7:	89 55 08             	mov    %edx,0x8(%ebp)
 1fa:	8b 55 0c             	mov    0xc(%ebp),%edx
 1fd:	8d 4a 01             	lea    0x1(%edx),%ecx
 200:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 203:	0f b6 12             	movzbl (%edx),%edx
 206:	88 10                	mov    %dl,(%eax)
 208:	0f b6 00             	movzbl (%eax),%eax
 20b:	84 c0                	test   %al,%al
 20d:	75 e2                	jne    1f1 <strcpy+0xd>
    ;
  return os;
 20f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 212:	c9                   	leave  
 213:	c3                   	ret    

00000214 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 214:	55                   	push   %ebp
 215:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 217:	eb 08                	jmp    221 <strcmp+0xd>
    p++, q++;
 219:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 221:	8b 45 08             	mov    0x8(%ebp),%eax
 224:	0f b6 00             	movzbl (%eax),%eax
 227:	84 c0                	test   %al,%al
 229:	74 10                	je     23b <strcmp+0x27>
 22b:	8b 45 08             	mov    0x8(%ebp),%eax
 22e:	0f b6 10             	movzbl (%eax),%edx
 231:	8b 45 0c             	mov    0xc(%ebp),%eax
 234:	0f b6 00             	movzbl (%eax),%eax
 237:	38 c2                	cmp    %al,%dl
 239:	74 de                	je     219 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 23b:	8b 45 08             	mov    0x8(%ebp),%eax
 23e:	0f b6 00             	movzbl (%eax),%eax
 241:	0f b6 d0             	movzbl %al,%edx
 244:	8b 45 0c             	mov    0xc(%ebp),%eax
 247:	0f b6 00             	movzbl (%eax),%eax
 24a:	0f b6 c0             	movzbl %al,%eax
 24d:	29 c2                	sub    %eax,%edx
 24f:	89 d0                	mov    %edx,%eax
}
 251:	5d                   	pop    %ebp
 252:	c3                   	ret    

00000253 <strlen>:

uint
strlen(char *s)
{
 253:	55                   	push   %ebp
 254:	89 e5                	mov    %esp,%ebp
 256:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 259:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 260:	eb 04                	jmp    266 <strlen+0x13>
 262:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 266:	8b 55 fc             	mov    -0x4(%ebp),%edx
 269:	8b 45 08             	mov    0x8(%ebp),%eax
 26c:	01 d0                	add    %edx,%eax
 26e:	0f b6 00             	movzbl (%eax),%eax
 271:	84 c0                	test   %al,%al
 273:	75 ed                	jne    262 <strlen+0xf>
    ;
  return n;
 275:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 278:	c9                   	leave  
 279:	c3                   	ret    

0000027a <memset>:

void*
memset(void *dst, int c, uint n)
{
 27a:	55                   	push   %ebp
 27b:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 27d:	8b 45 10             	mov    0x10(%ebp),%eax
 280:	50                   	push   %eax
 281:	ff 75 0c             	pushl  0xc(%ebp)
 284:	ff 75 08             	pushl  0x8(%ebp)
 287:	e8 32 ff ff ff       	call   1be <stosb>
 28c:	83 c4 0c             	add    $0xc,%esp
  return dst;
 28f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 292:	c9                   	leave  
 293:	c3                   	ret    

00000294 <strchr>:

char*
strchr(const char *s, char c)
{
 294:	55                   	push   %ebp
 295:	89 e5                	mov    %esp,%ebp
 297:	83 ec 04             	sub    $0x4,%esp
 29a:	8b 45 0c             	mov    0xc(%ebp),%eax
 29d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2a0:	eb 14                	jmp    2b6 <strchr+0x22>
    if(*s == c)
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
 2a5:	0f b6 00             	movzbl (%eax),%eax
 2a8:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2ab:	75 05                	jne    2b2 <strchr+0x1e>
      return (char*)s;
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	eb 13                	jmp    2c5 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2b2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	0f b6 00             	movzbl (%eax),%eax
 2bc:	84 c0                	test   %al,%al
 2be:	75 e2                	jne    2a2 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2c5:	c9                   	leave  
 2c6:	c3                   	ret    

000002c7 <gets>:

char*
gets(char *buf, int max)
{
 2c7:	55                   	push   %ebp
 2c8:	89 e5                	mov    %esp,%ebp
 2ca:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2d4:	eb 42                	jmp    318 <gets+0x51>
    cc = read(0, &c, 1);
 2d6:	83 ec 04             	sub    $0x4,%esp
 2d9:	6a 01                	push   $0x1
 2db:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2de:	50                   	push   %eax
 2df:	6a 00                	push   $0x0
 2e1:	e8 1a 02 00 00       	call   500 <read>
 2e6:	83 c4 10             	add    $0x10,%esp
 2e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2f0:	7e 33                	jle    325 <gets+0x5e>
      break;
    buf[i++] = c;
 2f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f5:	8d 50 01             	lea    0x1(%eax),%edx
 2f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2fb:	89 c2                	mov    %eax,%edx
 2fd:	8b 45 08             	mov    0x8(%ebp),%eax
 300:	01 c2                	add    %eax,%edx
 302:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 306:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 308:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30c:	3c 0a                	cmp    $0xa,%al
 30e:	74 16                	je     326 <gets+0x5f>
 310:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 314:	3c 0d                	cmp    $0xd,%al
 316:	74 0e                	je     326 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 318:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31b:	83 c0 01             	add    $0x1,%eax
 31e:	3b 45 0c             	cmp    0xc(%ebp),%eax
 321:	7c b3                	jl     2d6 <gets+0xf>
 323:	eb 01                	jmp    326 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 325:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 326:	8b 55 f4             	mov    -0xc(%ebp),%edx
 329:	8b 45 08             	mov    0x8(%ebp),%eax
 32c:	01 d0                	add    %edx,%eax
 32e:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 331:	8b 45 08             	mov    0x8(%ebp),%eax
}
 334:	c9                   	leave  
 335:	c3                   	ret    

00000336 <stat>:

int
stat(char *n, struct stat *st)
{
 336:	55                   	push   %ebp
 337:	89 e5                	mov    %esp,%ebp
 339:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33c:	83 ec 08             	sub    $0x8,%esp
 33f:	6a 00                	push   $0x0
 341:	ff 75 08             	pushl  0x8(%ebp)
 344:	e8 df 01 00 00       	call   528 <open>
 349:	83 c4 10             	add    $0x10,%esp
 34c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 34f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 353:	79 07                	jns    35c <stat+0x26>
    return -1;
 355:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 35a:	eb 25                	jmp    381 <stat+0x4b>
  r = fstat(fd, st);
 35c:	83 ec 08             	sub    $0x8,%esp
 35f:	ff 75 0c             	pushl  0xc(%ebp)
 362:	ff 75 f4             	pushl  -0xc(%ebp)
 365:	e8 d6 01 00 00       	call   540 <fstat>
 36a:	83 c4 10             	add    $0x10,%esp
 36d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 370:	83 ec 0c             	sub    $0xc,%esp
 373:	ff 75 f4             	pushl  -0xc(%ebp)
 376:	e8 95 01 00 00       	call   510 <close>
 37b:	83 c4 10             	add    $0x10,%esp
  return r;
 37e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 381:	c9                   	leave  
 382:	c3                   	ret    

00000383 <atoi>:

int
atoi(const char *s)
{
 383:	55                   	push   %ebp
 384:	89 e5                	mov    %esp,%ebp
 386:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 389:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 390:	eb 04                	jmp    396 <atoi+0x13>
 392:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 396:	8b 45 08             	mov    0x8(%ebp),%eax
 399:	0f b6 00             	movzbl (%eax),%eax
 39c:	3c 20                	cmp    $0x20,%al
 39e:	74 f2                	je     392 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 3a0:	8b 45 08             	mov    0x8(%ebp),%eax
 3a3:	0f b6 00             	movzbl (%eax),%eax
 3a6:	3c 2d                	cmp    $0x2d,%al
 3a8:	75 07                	jne    3b1 <atoi+0x2e>
 3aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3af:	eb 05                	jmp    3b6 <atoi+0x33>
 3b1:	b8 01 00 00 00       	mov    $0x1,%eax
 3b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3b9:	8b 45 08             	mov    0x8(%ebp),%eax
 3bc:	0f b6 00             	movzbl (%eax),%eax
 3bf:	3c 2b                	cmp    $0x2b,%al
 3c1:	74 0a                	je     3cd <atoi+0x4a>
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	0f b6 00             	movzbl (%eax),%eax
 3c9:	3c 2d                	cmp    $0x2d,%al
 3cb:	75 2b                	jne    3f8 <atoi+0x75>
    s++;
 3cd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 3d1:	eb 25                	jmp    3f8 <atoi+0x75>
    n = n*10 + *s++ - '0';
 3d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3d6:	89 d0                	mov    %edx,%eax
 3d8:	c1 e0 02             	shl    $0x2,%eax
 3db:	01 d0                	add    %edx,%eax
 3dd:	01 c0                	add    %eax,%eax
 3df:	89 c1                	mov    %eax,%ecx
 3e1:	8b 45 08             	mov    0x8(%ebp),%eax
 3e4:	8d 50 01             	lea    0x1(%eax),%edx
 3e7:	89 55 08             	mov    %edx,0x8(%ebp)
 3ea:	0f b6 00             	movzbl (%eax),%eax
 3ed:	0f be c0             	movsbl %al,%eax
 3f0:	01 c8                	add    %ecx,%eax
 3f2:	83 e8 30             	sub    $0x30,%eax
 3f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 3f8:	8b 45 08             	mov    0x8(%ebp),%eax
 3fb:	0f b6 00             	movzbl (%eax),%eax
 3fe:	3c 2f                	cmp    $0x2f,%al
 400:	7e 0a                	jle    40c <atoi+0x89>
 402:	8b 45 08             	mov    0x8(%ebp),%eax
 405:	0f b6 00             	movzbl (%eax),%eax
 408:	3c 39                	cmp    $0x39,%al
 40a:	7e c7                	jle    3d3 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 40c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 40f:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 413:	c9                   	leave  
 414:	c3                   	ret    

00000415 <atoo>:

int
atoo(const char *s)
{
 415:	55                   	push   %ebp
 416:	89 e5                	mov    %esp,%ebp
 418:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 41b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 422:	eb 04                	jmp    428 <atoo+0x13>
 424:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 428:	8b 45 08             	mov    0x8(%ebp),%eax
 42b:	0f b6 00             	movzbl (%eax),%eax
 42e:	3c 20                	cmp    $0x20,%al
 430:	74 f2                	je     424 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 432:	8b 45 08             	mov    0x8(%ebp),%eax
 435:	0f b6 00             	movzbl (%eax),%eax
 438:	3c 2d                	cmp    $0x2d,%al
 43a:	75 07                	jne    443 <atoo+0x2e>
 43c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 441:	eb 05                	jmp    448 <atoo+0x33>
 443:	b8 01 00 00 00       	mov    $0x1,%eax
 448:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 44b:	8b 45 08             	mov    0x8(%ebp),%eax
 44e:	0f b6 00             	movzbl (%eax),%eax
 451:	3c 2b                	cmp    $0x2b,%al
 453:	74 0a                	je     45f <atoo+0x4a>
 455:	8b 45 08             	mov    0x8(%ebp),%eax
 458:	0f b6 00             	movzbl (%eax),%eax
 45b:	3c 2d                	cmp    $0x2d,%al
 45d:	75 27                	jne    486 <atoo+0x71>
    s++;
 45f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 463:	eb 21                	jmp    486 <atoo+0x71>
    n = n*8 + *s++ - '0';
 465:	8b 45 fc             	mov    -0x4(%ebp),%eax
 468:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 46f:	8b 45 08             	mov    0x8(%ebp),%eax
 472:	8d 50 01             	lea    0x1(%eax),%edx
 475:	89 55 08             	mov    %edx,0x8(%ebp)
 478:	0f b6 00             	movzbl (%eax),%eax
 47b:	0f be c0             	movsbl %al,%eax
 47e:	01 c8                	add    %ecx,%eax
 480:	83 e8 30             	sub    $0x30,%eax
 483:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 486:	8b 45 08             	mov    0x8(%ebp),%eax
 489:	0f b6 00             	movzbl (%eax),%eax
 48c:	3c 2f                	cmp    $0x2f,%al
 48e:	7e 0a                	jle    49a <atoo+0x85>
 490:	8b 45 08             	mov    0x8(%ebp),%eax
 493:	0f b6 00             	movzbl (%eax),%eax
 496:	3c 37                	cmp    $0x37,%al
 498:	7e cb                	jle    465 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 49a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 49d:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 4a1:	c9                   	leave  
 4a2:	c3                   	ret    

000004a3 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 4a3:	55                   	push   %ebp
 4a4:	89 e5                	mov    %esp,%ebp
 4a6:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4a9:	8b 45 08             	mov    0x8(%ebp),%eax
 4ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4af:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4b5:	eb 17                	jmp    4ce <memmove+0x2b>
    *dst++ = *src++;
 4b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4ba:	8d 50 01             	lea    0x1(%eax),%edx
 4bd:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4c0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4c3:	8d 4a 01             	lea    0x1(%edx),%ecx
 4c6:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4c9:	0f b6 12             	movzbl (%edx),%edx
 4cc:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4ce:	8b 45 10             	mov    0x10(%ebp),%eax
 4d1:	8d 50 ff             	lea    -0x1(%eax),%edx
 4d4:	89 55 10             	mov    %edx,0x10(%ebp)
 4d7:	85 c0                	test   %eax,%eax
 4d9:	7f dc                	jg     4b7 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4db:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4de:	c9                   	leave  
 4df:	c3                   	ret    

000004e0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4e0:	b8 01 00 00 00       	mov    $0x1,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <exit>:
SYSCALL(exit)
 4e8:	b8 02 00 00 00       	mov    $0x2,%eax
 4ed:	cd 40                	int    $0x40
 4ef:	c3                   	ret    

000004f0 <wait>:
SYSCALL(wait)
 4f0:	b8 03 00 00 00       	mov    $0x3,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <pipe>:
SYSCALL(pipe)
 4f8:	b8 04 00 00 00       	mov    $0x4,%eax
 4fd:	cd 40                	int    $0x40
 4ff:	c3                   	ret    

00000500 <read>:
SYSCALL(read)
 500:	b8 05 00 00 00       	mov    $0x5,%eax
 505:	cd 40                	int    $0x40
 507:	c3                   	ret    

00000508 <write>:
SYSCALL(write)
 508:	b8 10 00 00 00       	mov    $0x10,%eax
 50d:	cd 40                	int    $0x40
 50f:	c3                   	ret    

00000510 <close>:
SYSCALL(close)
 510:	b8 15 00 00 00       	mov    $0x15,%eax
 515:	cd 40                	int    $0x40
 517:	c3                   	ret    

00000518 <kill>:
SYSCALL(kill)
 518:	b8 06 00 00 00       	mov    $0x6,%eax
 51d:	cd 40                	int    $0x40
 51f:	c3                   	ret    

00000520 <exec>:
SYSCALL(exec)
 520:	b8 07 00 00 00       	mov    $0x7,%eax
 525:	cd 40                	int    $0x40
 527:	c3                   	ret    

00000528 <open>:
SYSCALL(open)
 528:	b8 0f 00 00 00       	mov    $0xf,%eax
 52d:	cd 40                	int    $0x40
 52f:	c3                   	ret    

00000530 <mknod>:
SYSCALL(mknod)
 530:	b8 11 00 00 00       	mov    $0x11,%eax
 535:	cd 40                	int    $0x40
 537:	c3                   	ret    

00000538 <unlink>:
SYSCALL(unlink)
 538:	b8 12 00 00 00       	mov    $0x12,%eax
 53d:	cd 40                	int    $0x40
 53f:	c3                   	ret    

00000540 <fstat>:
SYSCALL(fstat)
 540:	b8 08 00 00 00       	mov    $0x8,%eax
 545:	cd 40                	int    $0x40
 547:	c3                   	ret    

00000548 <link>:
SYSCALL(link)
 548:	b8 13 00 00 00       	mov    $0x13,%eax
 54d:	cd 40                	int    $0x40
 54f:	c3                   	ret    

00000550 <mkdir>:
SYSCALL(mkdir)
 550:	b8 14 00 00 00       	mov    $0x14,%eax
 555:	cd 40                	int    $0x40
 557:	c3                   	ret    

00000558 <chdir>:
SYSCALL(chdir)
 558:	b8 09 00 00 00       	mov    $0x9,%eax
 55d:	cd 40                	int    $0x40
 55f:	c3                   	ret    

00000560 <dup>:
SYSCALL(dup)
 560:	b8 0a 00 00 00       	mov    $0xa,%eax
 565:	cd 40                	int    $0x40
 567:	c3                   	ret    

00000568 <getpid>:
SYSCALL(getpid)
 568:	b8 0b 00 00 00       	mov    $0xb,%eax
 56d:	cd 40                	int    $0x40
 56f:	c3                   	ret    

00000570 <sbrk>:
SYSCALL(sbrk)
 570:	b8 0c 00 00 00       	mov    $0xc,%eax
 575:	cd 40                	int    $0x40
 577:	c3                   	ret    

00000578 <sleep>:
SYSCALL(sleep)
 578:	b8 0d 00 00 00       	mov    $0xd,%eax
 57d:	cd 40                	int    $0x40
 57f:	c3                   	ret    

00000580 <uptime>:
SYSCALL(uptime)
 580:	b8 0e 00 00 00       	mov    $0xe,%eax
 585:	cd 40                	int    $0x40
 587:	c3                   	ret    

00000588 <halt>:
SYSCALL(halt)
 588:	b8 16 00 00 00       	mov    $0x16,%eax
 58d:	cd 40                	int    $0x40
 58f:	c3                   	ret    

00000590 <date>:
SYSCALL(date)
 590:	b8 17 00 00 00       	mov    $0x17,%eax
 595:	cd 40                	int    $0x40
 597:	c3                   	ret    

00000598 <getuid>:
SYSCALL(getuid)
 598:	b8 18 00 00 00       	mov    $0x18,%eax
 59d:	cd 40                	int    $0x40
 59f:	c3                   	ret    

000005a0 <getgid>:
SYSCALL(getgid)
 5a0:	b8 19 00 00 00       	mov    $0x19,%eax
 5a5:	cd 40                	int    $0x40
 5a7:	c3                   	ret    

000005a8 <getppid>:
SYSCALL(getppid)
 5a8:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5ad:	cd 40                	int    $0x40
 5af:	c3                   	ret    

000005b0 <setuid>:
SYSCALL(setuid)
 5b0:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5b5:	cd 40                	int    $0x40
 5b7:	c3                   	ret    

000005b8 <setgid>:
SYSCALL(setgid)
 5b8:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5bd:	cd 40                	int    $0x40
 5bf:	c3                   	ret    

000005c0 <getprocs>:
SYSCALL(getprocs)
 5c0:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5c5:	cd 40                	int    $0x40
 5c7:	c3                   	ret    

000005c8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5c8:	55                   	push   %ebp
 5c9:	89 e5                	mov    %esp,%ebp
 5cb:	83 ec 18             	sub    $0x18,%esp
 5ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 5d1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5d4:	83 ec 04             	sub    $0x4,%esp
 5d7:	6a 01                	push   $0x1
 5d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5dc:	50                   	push   %eax
 5dd:	ff 75 08             	pushl  0x8(%ebp)
 5e0:	e8 23 ff ff ff       	call   508 <write>
 5e5:	83 c4 10             	add    $0x10,%esp
}
 5e8:	90                   	nop
 5e9:	c9                   	leave  
 5ea:	c3                   	ret    

000005eb <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5eb:	55                   	push   %ebp
 5ec:	89 e5                	mov    %esp,%ebp
 5ee:	53                   	push   %ebx
 5ef:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5f2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5f9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5fd:	74 17                	je     616 <printint+0x2b>
 5ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 603:	79 11                	jns    616 <printint+0x2b>
    neg = 1;
 605:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 60c:	8b 45 0c             	mov    0xc(%ebp),%eax
 60f:	f7 d8                	neg    %eax
 611:	89 45 ec             	mov    %eax,-0x14(%ebp)
 614:	eb 06                	jmp    61c <printint+0x31>
  } else {
    x = xx;
 616:	8b 45 0c             	mov    0xc(%ebp),%eax
 619:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 61c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 623:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 626:	8d 41 01             	lea    0x1(%ecx),%eax
 629:	89 45 f4             	mov    %eax,-0xc(%ebp)
 62c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 62f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 632:	ba 00 00 00 00       	mov    $0x0,%edx
 637:	f7 f3                	div    %ebx
 639:	89 d0                	mov    %edx,%eax
 63b:	0f b6 80 18 0e 00 00 	movzbl 0xe18(%eax),%eax
 642:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 646:	8b 5d 10             	mov    0x10(%ebp),%ebx
 649:	8b 45 ec             	mov    -0x14(%ebp),%eax
 64c:	ba 00 00 00 00       	mov    $0x0,%edx
 651:	f7 f3                	div    %ebx
 653:	89 45 ec             	mov    %eax,-0x14(%ebp)
 656:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 65a:	75 c7                	jne    623 <printint+0x38>
  if(neg)
 65c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 660:	74 2d                	je     68f <printint+0xa4>
    buf[i++] = '-';
 662:	8b 45 f4             	mov    -0xc(%ebp),%eax
 665:	8d 50 01             	lea    0x1(%eax),%edx
 668:	89 55 f4             	mov    %edx,-0xc(%ebp)
 66b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 670:	eb 1d                	jmp    68f <printint+0xa4>
    putc(fd, buf[i]);
 672:	8d 55 dc             	lea    -0x24(%ebp),%edx
 675:	8b 45 f4             	mov    -0xc(%ebp),%eax
 678:	01 d0                	add    %edx,%eax
 67a:	0f b6 00             	movzbl (%eax),%eax
 67d:	0f be c0             	movsbl %al,%eax
 680:	83 ec 08             	sub    $0x8,%esp
 683:	50                   	push   %eax
 684:	ff 75 08             	pushl  0x8(%ebp)
 687:	e8 3c ff ff ff       	call   5c8 <putc>
 68c:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 68f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 693:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 697:	79 d9                	jns    672 <printint+0x87>
    putc(fd, buf[i]);
}
 699:	90                   	nop
 69a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 69d:	c9                   	leave  
 69e:	c3                   	ret    

0000069f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 69f:	55                   	push   %ebp
 6a0:	89 e5                	mov    %esp,%ebp
 6a2:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6a5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6ac:	8d 45 0c             	lea    0xc(%ebp),%eax
 6af:	83 c0 04             	add    $0x4,%eax
 6b2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6bc:	e9 59 01 00 00       	jmp    81a <printf+0x17b>
    c = fmt[i] & 0xff;
 6c1:	8b 55 0c             	mov    0xc(%ebp),%edx
 6c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c7:	01 d0                	add    %edx,%eax
 6c9:	0f b6 00             	movzbl (%eax),%eax
 6cc:	0f be c0             	movsbl %al,%eax
 6cf:	25 ff 00 00 00       	and    $0xff,%eax
 6d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6db:	75 2c                	jne    709 <printf+0x6a>
      if(c == '%'){
 6dd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6e1:	75 0c                	jne    6ef <printf+0x50>
        state = '%';
 6e3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6ea:	e9 27 01 00 00       	jmp    816 <printf+0x177>
      } else {
        putc(fd, c);
 6ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f2:	0f be c0             	movsbl %al,%eax
 6f5:	83 ec 08             	sub    $0x8,%esp
 6f8:	50                   	push   %eax
 6f9:	ff 75 08             	pushl  0x8(%ebp)
 6fc:	e8 c7 fe ff ff       	call   5c8 <putc>
 701:	83 c4 10             	add    $0x10,%esp
 704:	e9 0d 01 00 00       	jmp    816 <printf+0x177>
      }
    } else if(state == '%'){
 709:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 70d:	0f 85 03 01 00 00    	jne    816 <printf+0x177>
      if(c == 'd'){
 713:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 717:	75 1e                	jne    737 <printf+0x98>
        printint(fd, *ap, 10, 1);
 719:	8b 45 e8             	mov    -0x18(%ebp),%eax
 71c:	8b 00                	mov    (%eax),%eax
 71e:	6a 01                	push   $0x1
 720:	6a 0a                	push   $0xa
 722:	50                   	push   %eax
 723:	ff 75 08             	pushl  0x8(%ebp)
 726:	e8 c0 fe ff ff       	call   5eb <printint>
 72b:	83 c4 10             	add    $0x10,%esp
        ap++;
 72e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 732:	e9 d8 00 00 00       	jmp    80f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 737:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 73b:	74 06                	je     743 <printf+0xa4>
 73d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 741:	75 1e                	jne    761 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 743:	8b 45 e8             	mov    -0x18(%ebp),%eax
 746:	8b 00                	mov    (%eax),%eax
 748:	6a 00                	push   $0x0
 74a:	6a 10                	push   $0x10
 74c:	50                   	push   %eax
 74d:	ff 75 08             	pushl  0x8(%ebp)
 750:	e8 96 fe ff ff       	call   5eb <printint>
 755:	83 c4 10             	add    $0x10,%esp
        ap++;
 758:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 75c:	e9 ae 00 00 00       	jmp    80f <printf+0x170>
      } else if(c == 's'){
 761:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 765:	75 43                	jne    7aa <printf+0x10b>
        s = (char*)*ap;
 767:	8b 45 e8             	mov    -0x18(%ebp),%eax
 76a:	8b 00                	mov    (%eax),%eax
 76c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 76f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 773:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 777:	75 25                	jne    79e <printf+0xff>
          s = "(null)";
 779:	c7 45 f4 b0 0b 00 00 	movl   $0xbb0,-0xc(%ebp)
        while(*s != 0){
 780:	eb 1c                	jmp    79e <printf+0xff>
          putc(fd, *s);
 782:	8b 45 f4             	mov    -0xc(%ebp),%eax
 785:	0f b6 00             	movzbl (%eax),%eax
 788:	0f be c0             	movsbl %al,%eax
 78b:	83 ec 08             	sub    $0x8,%esp
 78e:	50                   	push   %eax
 78f:	ff 75 08             	pushl  0x8(%ebp)
 792:	e8 31 fe ff ff       	call   5c8 <putc>
 797:	83 c4 10             	add    $0x10,%esp
          s++;
 79a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 79e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a1:	0f b6 00             	movzbl (%eax),%eax
 7a4:	84 c0                	test   %al,%al
 7a6:	75 da                	jne    782 <printf+0xe3>
 7a8:	eb 65                	jmp    80f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7aa:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7ae:	75 1d                	jne    7cd <printf+0x12e>
        putc(fd, *ap);
 7b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7b3:	8b 00                	mov    (%eax),%eax
 7b5:	0f be c0             	movsbl %al,%eax
 7b8:	83 ec 08             	sub    $0x8,%esp
 7bb:	50                   	push   %eax
 7bc:	ff 75 08             	pushl  0x8(%ebp)
 7bf:	e8 04 fe ff ff       	call   5c8 <putc>
 7c4:	83 c4 10             	add    $0x10,%esp
        ap++;
 7c7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7cb:	eb 42                	jmp    80f <printf+0x170>
      } else if(c == '%'){
 7cd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7d1:	75 17                	jne    7ea <printf+0x14b>
        putc(fd, c);
 7d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7d6:	0f be c0             	movsbl %al,%eax
 7d9:	83 ec 08             	sub    $0x8,%esp
 7dc:	50                   	push   %eax
 7dd:	ff 75 08             	pushl  0x8(%ebp)
 7e0:	e8 e3 fd ff ff       	call   5c8 <putc>
 7e5:	83 c4 10             	add    $0x10,%esp
 7e8:	eb 25                	jmp    80f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7ea:	83 ec 08             	sub    $0x8,%esp
 7ed:	6a 25                	push   $0x25
 7ef:	ff 75 08             	pushl  0x8(%ebp)
 7f2:	e8 d1 fd ff ff       	call   5c8 <putc>
 7f7:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 7fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7fd:	0f be c0             	movsbl %al,%eax
 800:	83 ec 08             	sub    $0x8,%esp
 803:	50                   	push   %eax
 804:	ff 75 08             	pushl  0x8(%ebp)
 807:	e8 bc fd ff ff       	call   5c8 <putc>
 80c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 80f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 816:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 81a:	8b 55 0c             	mov    0xc(%ebp),%edx
 81d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 820:	01 d0                	add    %edx,%eax
 822:	0f b6 00             	movzbl (%eax),%eax
 825:	84 c0                	test   %al,%al
 827:	0f 85 94 fe ff ff    	jne    6c1 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 82d:	90                   	nop
 82e:	c9                   	leave  
 82f:	c3                   	ret    

00000830 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 830:	55                   	push   %ebp
 831:	89 e5                	mov    %esp,%ebp
 833:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 836:	8b 45 08             	mov    0x8(%ebp),%eax
 839:	83 e8 08             	sub    $0x8,%eax
 83c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 83f:	a1 34 0e 00 00       	mov    0xe34,%eax
 844:	89 45 fc             	mov    %eax,-0x4(%ebp)
 847:	eb 24                	jmp    86d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 849:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84c:	8b 00                	mov    (%eax),%eax
 84e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 851:	77 12                	ja     865 <free+0x35>
 853:	8b 45 f8             	mov    -0x8(%ebp),%eax
 856:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 859:	77 24                	ja     87f <free+0x4f>
 85b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85e:	8b 00                	mov    (%eax),%eax
 860:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 863:	77 1a                	ja     87f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 865:	8b 45 fc             	mov    -0x4(%ebp),%eax
 868:	8b 00                	mov    (%eax),%eax
 86a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 86d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 870:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 873:	76 d4                	jbe    849 <free+0x19>
 875:	8b 45 fc             	mov    -0x4(%ebp),%eax
 878:	8b 00                	mov    (%eax),%eax
 87a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 87d:	76 ca                	jbe    849 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 87f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 882:	8b 40 04             	mov    0x4(%eax),%eax
 885:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 88c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88f:	01 c2                	add    %eax,%edx
 891:	8b 45 fc             	mov    -0x4(%ebp),%eax
 894:	8b 00                	mov    (%eax),%eax
 896:	39 c2                	cmp    %eax,%edx
 898:	75 24                	jne    8be <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 89a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89d:	8b 50 04             	mov    0x4(%eax),%edx
 8a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a3:	8b 00                	mov    (%eax),%eax
 8a5:	8b 40 04             	mov    0x4(%eax),%eax
 8a8:	01 c2                	add    %eax,%edx
 8aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ad:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b3:	8b 00                	mov    (%eax),%eax
 8b5:	8b 10                	mov    (%eax),%edx
 8b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ba:	89 10                	mov    %edx,(%eax)
 8bc:	eb 0a                	jmp    8c8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c1:	8b 10                	mov    (%eax),%edx
 8c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cb:	8b 40 04             	mov    0x4(%eax),%eax
 8ce:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d8:	01 d0                	add    %edx,%eax
 8da:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8dd:	75 20                	jne    8ff <free+0xcf>
    p->s.size += bp->s.size;
 8df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e2:	8b 50 04             	mov    0x4(%eax),%edx
 8e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e8:	8b 40 04             	mov    0x4(%eax),%eax
 8eb:	01 c2                	add    %eax,%edx
 8ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f6:	8b 10                	mov    (%eax),%edx
 8f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fb:	89 10                	mov    %edx,(%eax)
 8fd:	eb 08                	jmp    907 <free+0xd7>
  } else
    p->s.ptr = bp;
 8ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 902:	8b 55 f8             	mov    -0x8(%ebp),%edx
 905:	89 10                	mov    %edx,(%eax)
  freep = p;
 907:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90a:	a3 34 0e 00 00       	mov    %eax,0xe34
}
 90f:	90                   	nop
 910:	c9                   	leave  
 911:	c3                   	ret    

00000912 <morecore>:

static Header*
morecore(uint nu)
{
 912:	55                   	push   %ebp
 913:	89 e5                	mov    %esp,%ebp
 915:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 918:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 91f:	77 07                	ja     928 <morecore+0x16>
    nu = 4096;
 921:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 928:	8b 45 08             	mov    0x8(%ebp),%eax
 92b:	c1 e0 03             	shl    $0x3,%eax
 92e:	83 ec 0c             	sub    $0xc,%esp
 931:	50                   	push   %eax
 932:	e8 39 fc ff ff       	call   570 <sbrk>
 937:	83 c4 10             	add    $0x10,%esp
 93a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 93d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 941:	75 07                	jne    94a <morecore+0x38>
    return 0;
 943:	b8 00 00 00 00       	mov    $0x0,%eax
 948:	eb 26                	jmp    970 <morecore+0x5e>
  hp = (Header*)p;
 94a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 950:	8b 45 f0             	mov    -0x10(%ebp),%eax
 953:	8b 55 08             	mov    0x8(%ebp),%edx
 956:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 959:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95c:	83 c0 08             	add    $0x8,%eax
 95f:	83 ec 0c             	sub    $0xc,%esp
 962:	50                   	push   %eax
 963:	e8 c8 fe ff ff       	call   830 <free>
 968:	83 c4 10             	add    $0x10,%esp
  return freep;
 96b:	a1 34 0e 00 00       	mov    0xe34,%eax
}
 970:	c9                   	leave  
 971:	c3                   	ret    

00000972 <malloc>:

void*
malloc(uint nbytes)
{
 972:	55                   	push   %ebp
 973:	89 e5                	mov    %esp,%ebp
 975:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 978:	8b 45 08             	mov    0x8(%ebp),%eax
 97b:	83 c0 07             	add    $0x7,%eax
 97e:	c1 e8 03             	shr    $0x3,%eax
 981:	83 c0 01             	add    $0x1,%eax
 984:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 987:	a1 34 0e 00 00       	mov    0xe34,%eax
 98c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 98f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 993:	75 23                	jne    9b8 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 995:	c7 45 f0 2c 0e 00 00 	movl   $0xe2c,-0x10(%ebp)
 99c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 99f:	a3 34 0e 00 00       	mov    %eax,0xe34
 9a4:	a1 34 0e 00 00       	mov    0xe34,%eax
 9a9:	a3 2c 0e 00 00       	mov    %eax,0xe2c
    base.s.size = 0;
 9ae:	c7 05 30 0e 00 00 00 	movl   $0x0,0xe30
 9b5:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9bb:	8b 00                	mov    (%eax),%eax
 9bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c3:	8b 40 04             	mov    0x4(%eax),%eax
 9c6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9c9:	72 4d                	jb     a18 <malloc+0xa6>
      if(p->s.size == nunits)
 9cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ce:	8b 40 04             	mov    0x4(%eax),%eax
 9d1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9d4:	75 0c                	jne    9e2 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d9:	8b 10                	mov    (%eax),%edx
 9db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9de:	89 10                	mov    %edx,(%eax)
 9e0:	eb 26                	jmp    a08 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e5:	8b 40 04             	mov    0x4(%eax),%eax
 9e8:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9eb:	89 c2                	mov    %eax,%edx
 9ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f0:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f6:	8b 40 04             	mov    0x4(%eax),%eax
 9f9:	c1 e0 03             	shl    $0x3,%eax
 9fc:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a02:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a05:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a08:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a0b:	a3 34 0e 00 00       	mov    %eax,0xe34
      return (void*)(p + 1);
 a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a13:	83 c0 08             	add    $0x8,%eax
 a16:	eb 3b                	jmp    a53 <malloc+0xe1>
    }
    if(p == freep)
 a18:	a1 34 0e 00 00       	mov    0xe34,%eax
 a1d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a20:	75 1e                	jne    a40 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a22:	83 ec 0c             	sub    $0xc,%esp
 a25:	ff 75 ec             	pushl  -0x14(%ebp)
 a28:	e8 e5 fe ff ff       	call   912 <morecore>
 a2d:	83 c4 10             	add    $0x10,%esp
 a30:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a37:	75 07                	jne    a40 <malloc+0xce>
        return 0;
 a39:	b8 00 00 00 00       	mov    $0x0,%eax
 a3e:	eb 13                	jmp    a53 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a43:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a49:	8b 00                	mov    (%eax),%eax
 a4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a4e:	e9 6d ff ff ff       	jmp    9c0 <malloc+0x4e>
}
 a53:	c9                   	leave  
 a54:	c3                   	ret    
