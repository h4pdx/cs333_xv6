
_time:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int
main(int argc, char * argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 20             	sub    $0x20,%esp
  12:	89 cb                	mov    %ecx,%ebx
    if (argc < 0) {
  14:	83 3b 00             	cmpl   $0x0,(%ebx)
  17:	79 05                	jns    1e <main+0x1e>
        exit();
  19:	e8 6c 04 00 00       	call   48a <exit>
    }
    uint start_time = 0, end_time = 0, pid = 0, elapsed_time = 0, sec = 0, milisec_ten = 0, milisec_hund = 0;
  1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  25:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  2c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  33:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  3a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  41:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  48:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    if (argc == 1) {
  4f:	83 3b 01             	cmpl   $0x1,(%ebx)
  52:	75 1d                	jne    71 <main+0x71>
        printf(1, "%s ran in 0.00 seconds\n", argv[0]);
  54:	8b 43 04             	mov    0x4(%ebx),%eax
  57:	8b 00                	mov    (%eax),%eax
  59:	83 ec 04             	sub    $0x4,%esp
  5c:	50                   	push   %eax
  5d:	68 f7 09 00 00       	push   $0x9f7
  62:	6a 01                	push   $0x1
  64:	e8 d8 05 00 00       	call   641 <printf>
  69:	83 c4 10             	add    $0x10,%esp
        exit();
  6c:	e8 19 04 00 00       	call   48a <exit>
    }
    pid = fork(); // fork new process
  71:	e8 0c 04 00 00       	call   482 <fork>
  76:	89 45 ec             	mov    %eax,-0x14(%ebp)
    start_time = uptime(); // start uptime
  79:	e8 a4 04 00 00       	call   522 <uptime>
  7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (pid > 0) {
  81:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  85:	74 0a                	je     91 <main+0x91>
        pid = wait(); // wait for child to finish
  87:	e8 06 04 00 00       	call   492 <wait>
  8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8f:	eb 26                	jmp    b7 <main+0xb7>
    }
    else if (pid == 0) {
  91:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  95:	75 20                	jne    b7 <main+0xb7>
        exec(argv[1], (argv+1)); // pointer arithmetic to skip first index of argv (always will be time)
  97:	8b 43 04             	mov    0x4(%ebx),%eax
  9a:	8d 50 04             	lea    0x4(%eax),%edx
  9d:	8b 43 04             	mov    0x4(%ebx),%eax
  a0:	83 c0 04             	add    $0x4,%eax
  a3:	8b 00                	mov    (%eax),%eax
  a5:	83 ec 08             	sub    $0x8,%esp
  a8:	52                   	push   %edx
  a9:	50                   	push   %eax
  aa:	e8 13 04 00 00       	call   4c2 <exec>
  af:	83 c4 10             	add    $0x10,%esp
        exit();
  b2:	e8 d3 03 00 00       	call   48a <exit>
    }
    end_time = uptime(); // record end time
  b7:	e8 66 04 00 00       	call   522 <uptime>
  bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    elapsed_time = (end_time - start_time); // calc elapsed time
  bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  c2:	2b 45 f4             	sub    -0xc(%ebp),%eax
  c5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    sec = (elapsed_time / 1000); // divide for whole seconds
  c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  cb:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
  d0:	f7 e2                	mul    %edx
  d2:	89 d0                	mov    %edx,%eax
  d4:	c1 e8 06             	shr    $0x6,%eax
  d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    milisec_ten = ((elapsed_time %= 1000) / 100); // mod and divide for miliseconds
  da:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  dd:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
  e2:	89 c8                	mov    %ecx,%eax
  e4:	f7 e2                	mul    %edx
  e6:	89 d0                	mov    %edx,%eax
  e8:	c1 e8 06             	shr    $0x6,%eax
  eb:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
  f1:	29 c1                	sub    %eax,%ecx
  f3:	89 c8                	mov    %ecx,%eax
  f5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  fb:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 100:	f7 e2                	mul    %edx
 102:	89 d0                	mov    %edx,%eax
 104:	c1 e8 05             	shr    $0x5,%eax
 107:	89 45 e0             	mov    %eax,-0x20(%ebp)
    milisec_ten = ((elapsed_time %= 100) / 10);
 10a:	8b 4d e8             	mov    -0x18(%ebp),%ecx
 10d:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 112:	89 c8                	mov    %ecx,%eax
 114:	f7 e2                	mul    %edx
 116:	89 d0                	mov    %edx,%eax
 118:	c1 e8 05             	shr    $0x5,%eax
 11b:	6b c0 64             	imul   $0x64,%eax,%eax
 11e:	29 c1                	sub    %eax,%ecx
 120:	89 c8                	mov    %ecx,%eax
 122:	89 45 e8             	mov    %eax,-0x18(%ebp)
 125:	8b 45 e8             	mov    -0x18(%ebp),%eax
 128:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 12d:	f7 e2                	mul    %edx
 12f:	89 d0                	mov    %edx,%eax
 131:	c1 e8 03             	shr    $0x3,%eax
 134:	89 45 e0             	mov    %eax,-0x20(%ebp)

    printf(1, "%s ran in %d.%d%d seconds\n", argv[1], sec, milisec_ten, milisec_hund);
 137:	8b 43 04             	mov    0x4(%ebx),%eax
 13a:	83 c0 04             	add    $0x4,%eax
 13d:	8b 00                	mov    (%eax),%eax
 13f:	83 ec 08             	sub    $0x8,%esp
 142:	ff 75 dc             	pushl  -0x24(%ebp)
 145:	ff 75 e0             	pushl  -0x20(%ebp)
 148:	ff 75 e4             	pushl  -0x1c(%ebp)
 14b:	50                   	push   %eax
 14c:	68 0f 0a 00 00       	push   $0xa0f
 151:	6a 01                	push   $0x1
 153:	e8 e9 04 00 00       	call   641 <printf>
 158:	83 c4 20             	add    $0x20,%esp
    exit();
 15b:	e8 2a 03 00 00       	call   48a <exit>

00000160 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	57                   	push   %edi
 164:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 165:	8b 4d 08             	mov    0x8(%ebp),%ecx
 168:	8b 55 10             	mov    0x10(%ebp),%edx
 16b:	8b 45 0c             	mov    0xc(%ebp),%eax
 16e:	89 cb                	mov    %ecx,%ebx
 170:	89 df                	mov    %ebx,%edi
 172:	89 d1                	mov    %edx,%ecx
 174:	fc                   	cld    
 175:	f3 aa                	rep stos %al,%es:(%edi)
 177:	89 ca                	mov    %ecx,%edx
 179:	89 fb                	mov    %edi,%ebx
 17b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 17e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 181:	90                   	nop
 182:	5b                   	pop    %ebx
 183:	5f                   	pop    %edi
 184:	5d                   	pop    %ebp
 185:	c3                   	ret    

00000186 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 186:	55                   	push   %ebp
 187:	89 e5                	mov    %esp,%ebp
 189:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 192:	90                   	nop
 193:	8b 45 08             	mov    0x8(%ebp),%eax
 196:	8d 50 01             	lea    0x1(%eax),%edx
 199:	89 55 08             	mov    %edx,0x8(%ebp)
 19c:	8b 55 0c             	mov    0xc(%ebp),%edx
 19f:	8d 4a 01             	lea    0x1(%edx),%ecx
 1a2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1a5:	0f b6 12             	movzbl (%edx),%edx
 1a8:	88 10                	mov    %dl,(%eax)
 1aa:	0f b6 00             	movzbl (%eax),%eax
 1ad:	84 c0                	test   %al,%al
 1af:	75 e2                	jne    193 <strcpy+0xd>
    ;
  return os;
 1b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1b4:	c9                   	leave  
 1b5:	c3                   	ret    

000001b6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b6:	55                   	push   %ebp
 1b7:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1b9:	eb 08                	jmp    1c3 <strcmp+0xd>
    p++, q++;
 1bb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1bf:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1c3:	8b 45 08             	mov    0x8(%ebp),%eax
 1c6:	0f b6 00             	movzbl (%eax),%eax
 1c9:	84 c0                	test   %al,%al
 1cb:	74 10                	je     1dd <strcmp+0x27>
 1cd:	8b 45 08             	mov    0x8(%ebp),%eax
 1d0:	0f b6 10             	movzbl (%eax),%edx
 1d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d6:	0f b6 00             	movzbl (%eax),%eax
 1d9:	38 c2                	cmp    %al,%dl
 1db:	74 de                	je     1bb <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	0f b6 00             	movzbl (%eax),%eax
 1e3:	0f b6 d0             	movzbl %al,%edx
 1e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e9:	0f b6 00             	movzbl (%eax),%eax
 1ec:	0f b6 c0             	movzbl %al,%eax
 1ef:	29 c2                	sub    %eax,%edx
 1f1:	89 d0                	mov    %edx,%eax
}
 1f3:	5d                   	pop    %ebp
 1f4:	c3                   	ret    

000001f5 <strlen>:

uint
strlen(char *s)
{
 1f5:	55                   	push   %ebp
 1f6:	89 e5                	mov    %esp,%ebp
 1f8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1fb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 202:	eb 04                	jmp    208 <strlen+0x13>
 204:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 208:	8b 55 fc             	mov    -0x4(%ebp),%edx
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	01 d0                	add    %edx,%eax
 210:	0f b6 00             	movzbl (%eax),%eax
 213:	84 c0                	test   %al,%al
 215:	75 ed                	jne    204 <strlen+0xf>
    ;
  return n;
 217:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 21a:	c9                   	leave  
 21b:	c3                   	ret    

0000021c <memset>:

void*
memset(void *dst, int c, uint n)
{
 21c:	55                   	push   %ebp
 21d:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 21f:	8b 45 10             	mov    0x10(%ebp),%eax
 222:	50                   	push   %eax
 223:	ff 75 0c             	pushl  0xc(%ebp)
 226:	ff 75 08             	pushl  0x8(%ebp)
 229:	e8 32 ff ff ff       	call   160 <stosb>
 22e:	83 c4 0c             	add    $0xc,%esp
  return dst;
 231:	8b 45 08             	mov    0x8(%ebp),%eax
}
 234:	c9                   	leave  
 235:	c3                   	ret    

00000236 <strchr>:

char*
strchr(const char *s, char c)
{
 236:	55                   	push   %ebp
 237:	89 e5                	mov    %esp,%ebp
 239:	83 ec 04             	sub    $0x4,%esp
 23c:	8b 45 0c             	mov    0xc(%ebp),%eax
 23f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 242:	eb 14                	jmp    258 <strchr+0x22>
    if(*s == c)
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	0f b6 00             	movzbl (%eax),%eax
 24a:	3a 45 fc             	cmp    -0x4(%ebp),%al
 24d:	75 05                	jne    254 <strchr+0x1e>
      return (char*)s;
 24f:	8b 45 08             	mov    0x8(%ebp),%eax
 252:	eb 13                	jmp    267 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 254:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 258:	8b 45 08             	mov    0x8(%ebp),%eax
 25b:	0f b6 00             	movzbl (%eax),%eax
 25e:	84 c0                	test   %al,%al
 260:	75 e2                	jne    244 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 262:	b8 00 00 00 00       	mov    $0x0,%eax
}
 267:	c9                   	leave  
 268:	c3                   	ret    

00000269 <gets>:

char*
gets(char *buf, int max)
{
 269:	55                   	push   %ebp
 26a:	89 e5                	mov    %esp,%ebp
 26c:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 26f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 276:	eb 42                	jmp    2ba <gets+0x51>
    cc = read(0, &c, 1);
 278:	83 ec 04             	sub    $0x4,%esp
 27b:	6a 01                	push   $0x1
 27d:	8d 45 ef             	lea    -0x11(%ebp),%eax
 280:	50                   	push   %eax
 281:	6a 00                	push   $0x0
 283:	e8 1a 02 00 00       	call   4a2 <read>
 288:	83 c4 10             	add    $0x10,%esp
 28b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 28e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 292:	7e 33                	jle    2c7 <gets+0x5e>
      break;
    buf[i++] = c;
 294:	8b 45 f4             	mov    -0xc(%ebp),%eax
 297:	8d 50 01             	lea    0x1(%eax),%edx
 29a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 29d:	89 c2                	mov    %eax,%edx
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	01 c2                	add    %eax,%edx
 2a4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a8:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2aa:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2ae:	3c 0a                	cmp    $0xa,%al
 2b0:	74 16                	je     2c8 <gets+0x5f>
 2b2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2b6:	3c 0d                	cmp    $0xd,%al
 2b8:	74 0e                	je     2c8 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2bd:	83 c0 01             	add    $0x1,%eax
 2c0:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2c3:	7c b3                	jl     278 <gets+0xf>
 2c5:	eb 01                	jmp    2c8 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2c7:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2cb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ce:	01 d0                	add    %edx,%eax
 2d0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2d3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d6:	c9                   	leave  
 2d7:	c3                   	ret    

000002d8 <stat>:

int
stat(char *n, struct stat *st)
{
 2d8:	55                   	push   %ebp
 2d9:	89 e5                	mov    %esp,%ebp
 2db:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2de:	83 ec 08             	sub    $0x8,%esp
 2e1:	6a 00                	push   $0x0
 2e3:	ff 75 08             	pushl  0x8(%ebp)
 2e6:	e8 df 01 00 00       	call   4ca <open>
 2eb:	83 c4 10             	add    $0x10,%esp
 2ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2f5:	79 07                	jns    2fe <stat+0x26>
    return -1;
 2f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2fc:	eb 25                	jmp    323 <stat+0x4b>
  r = fstat(fd, st);
 2fe:	83 ec 08             	sub    $0x8,%esp
 301:	ff 75 0c             	pushl  0xc(%ebp)
 304:	ff 75 f4             	pushl  -0xc(%ebp)
 307:	e8 d6 01 00 00       	call   4e2 <fstat>
 30c:	83 c4 10             	add    $0x10,%esp
 30f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 312:	83 ec 0c             	sub    $0xc,%esp
 315:	ff 75 f4             	pushl  -0xc(%ebp)
 318:	e8 95 01 00 00       	call   4b2 <close>
 31d:	83 c4 10             	add    $0x10,%esp
  return r;
 320:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 323:	c9                   	leave  
 324:	c3                   	ret    

00000325 <atoi>:

int
atoi(const char *s)
{
 325:	55                   	push   %ebp
 326:	89 e5                	mov    %esp,%ebp
 328:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 32b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 332:	eb 04                	jmp    338 <atoi+0x13>
 334:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 338:	8b 45 08             	mov    0x8(%ebp),%eax
 33b:	0f b6 00             	movzbl (%eax),%eax
 33e:	3c 20                	cmp    $0x20,%al
 340:	74 f2                	je     334 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 342:	8b 45 08             	mov    0x8(%ebp),%eax
 345:	0f b6 00             	movzbl (%eax),%eax
 348:	3c 2d                	cmp    $0x2d,%al
 34a:	75 07                	jne    353 <atoi+0x2e>
 34c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 351:	eb 05                	jmp    358 <atoi+0x33>
 353:	b8 01 00 00 00       	mov    $0x1,%eax
 358:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 35b:	8b 45 08             	mov    0x8(%ebp),%eax
 35e:	0f b6 00             	movzbl (%eax),%eax
 361:	3c 2b                	cmp    $0x2b,%al
 363:	74 0a                	je     36f <atoi+0x4a>
 365:	8b 45 08             	mov    0x8(%ebp),%eax
 368:	0f b6 00             	movzbl (%eax),%eax
 36b:	3c 2d                	cmp    $0x2d,%al
 36d:	75 2b                	jne    39a <atoi+0x75>
    s++;
 36f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 373:	eb 25                	jmp    39a <atoi+0x75>
    n = n*10 + *s++ - '0';
 375:	8b 55 fc             	mov    -0x4(%ebp),%edx
 378:	89 d0                	mov    %edx,%eax
 37a:	c1 e0 02             	shl    $0x2,%eax
 37d:	01 d0                	add    %edx,%eax
 37f:	01 c0                	add    %eax,%eax
 381:	89 c1                	mov    %eax,%ecx
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	8d 50 01             	lea    0x1(%eax),%edx
 389:	89 55 08             	mov    %edx,0x8(%ebp)
 38c:	0f b6 00             	movzbl (%eax),%eax
 38f:	0f be c0             	movsbl %al,%eax
 392:	01 c8                	add    %ecx,%eax
 394:	83 e8 30             	sub    $0x30,%eax
 397:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 39a:	8b 45 08             	mov    0x8(%ebp),%eax
 39d:	0f b6 00             	movzbl (%eax),%eax
 3a0:	3c 2f                	cmp    $0x2f,%al
 3a2:	7e 0a                	jle    3ae <atoi+0x89>
 3a4:	8b 45 08             	mov    0x8(%ebp),%eax
 3a7:	0f b6 00             	movzbl (%eax),%eax
 3aa:	3c 39                	cmp    $0x39,%al
 3ac:	7e c7                	jle    375 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 3ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3b1:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3b5:	c9                   	leave  
 3b6:	c3                   	ret    

000003b7 <atoo>:

int
atoo(const char *s)
{
 3b7:	55                   	push   %ebp
 3b8:	89 e5                	mov    %esp,%ebp
 3ba:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 3c4:	eb 04                	jmp    3ca <atoo+0x13>
 3c6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3ca:	8b 45 08             	mov    0x8(%ebp),%eax
 3cd:	0f b6 00             	movzbl (%eax),%eax
 3d0:	3c 20                	cmp    $0x20,%al
 3d2:	74 f2                	je     3c6 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 3d4:	8b 45 08             	mov    0x8(%ebp),%eax
 3d7:	0f b6 00             	movzbl (%eax),%eax
 3da:	3c 2d                	cmp    $0x2d,%al
 3dc:	75 07                	jne    3e5 <atoo+0x2e>
 3de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3e3:	eb 05                	jmp    3ea <atoo+0x33>
 3e5:	b8 01 00 00 00       	mov    $0x1,%eax
 3ea:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3ed:	8b 45 08             	mov    0x8(%ebp),%eax
 3f0:	0f b6 00             	movzbl (%eax),%eax
 3f3:	3c 2b                	cmp    $0x2b,%al
 3f5:	74 0a                	je     401 <atoo+0x4a>
 3f7:	8b 45 08             	mov    0x8(%ebp),%eax
 3fa:	0f b6 00             	movzbl (%eax),%eax
 3fd:	3c 2d                	cmp    $0x2d,%al
 3ff:	75 27                	jne    428 <atoo+0x71>
    s++;
 401:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 405:	eb 21                	jmp    428 <atoo+0x71>
    n = n*8 + *s++ - '0';
 407:	8b 45 fc             	mov    -0x4(%ebp),%eax
 40a:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 411:	8b 45 08             	mov    0x8(%ebp),%eax
 414:	8d 50 01             	lea    0x1(%eax),%edx
 417:	89 55 08             	mov    %edx,0x8(%ebp)
 41a:	0f b6 00             	movzbl (%eax),%eax
 41d:	0f be c0             	movsbl %al,%eax
 420:	01 c8                	add    %ecx,%eax
 422:	83 e8 30             	sub    $0x30,%eax
 425:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 428:	8b 45 08             	mov    0x8(%ebp),%eax
 42b:	0f b6 00             	movzbl (%eax),%eax
 42e:	3c 2f                	cmp    $0x2f,%al
 430:	7e 0a                	jle    43c <atoo+0x85>
 432:	8b 45 08             	mov    0x8(%ebp),%eax
 435:	0f b6 00             	movzbl (%eax),%eax
 438:	3c 37                	cmp    $0x37,%al
 43a:	7e cb                	jle    407 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 43c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 43f:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 443:	c9                   	leave  
 444:	c3                   	ret    

00000445 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 445:	55                   	push   %ebp
 446:	89 e5                	mov    %esp,%ebp
 448:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 44b:	8b 45 08             	mov    0x8(%ebp),%eax
 44e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 451:	8b 45 0c             	mov    0xc(%ebp),%eax
 454:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 457:	eb 17                	jmp    470 <memmove+0x2b>
    *dst++ = *src++;
 459:	8b 45 fc             	mov    -0x4(%ebp),%eax
 45c:	8d 50 01             	lea    0x1(%eax),%edx
 45f:	89 55 fc             	mov    %edx,-0x4(%ebp)
 462:	8b 55 f8             	mov    -0x8(%ebp),%edx
 465:	8d 4a 01             	lea    0x1(%edx),%ecx
 468:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 46b:	0f b6 12             	movzbl (%edx),%edx
 46e:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 470:	8b 45 10             	mov    0x10(%ebp),%eax
 473:	8d 50 ff             	lea    -0x1(%eax),%edx
 476:	89 55 10             	mov    %edx,0x10(%ebp)
 479:	85 c0                	test   %eax,%eax
 47b:	7f dc                	jg     459 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 47d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 480:	c9                   	leave  
 481:	c3                   	ret    

00000482 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 482:	b8 01 00 00 00       	mov    $0x1,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <exit>:
SYSCALL(exit)
 48a:	b8 02 00 00 00       	mov    $0x2,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <wait>:
SYSCALL(wait)
 492:	b8 03 00 00 00       	mov    $0x3,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <pipe>:
SYSCALL(pipe)
 49a:	b8 04 00 00 00       	mov    $0x4,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <read>:
SYSCALL(read)
 4a2:	b8 05 00 00 00       	mov    $0x5,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <write>:
SYSCALL(write)
 4aa:	b8 10 00 00 00       	mov    $0x10,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <close>:
SYSCALL(close)
 4b2:	b8 15 00 00 00       	mov    $0x15,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <kill>:
SYSCALL(kill)
 4ba:	b8 06 00 00 00       	mov    $0x6,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <exec>:
SYSCALL(exec)
 4c2:	b8 07 00 00 00       	mov    $0x7,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <open>:
SYSCALL(open)
 4ca:	b8 0f 00 00 00       	mov    $0xf,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <mknod>:
SYSCALL(mknod)
 4d2:	b8 11 00 00 00       	mov    $0x11,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <unlink>:
SYSCALL(unlink)
 4da:	b8 12 00 00 00       	mov    $0x12,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <fstat>:
SYSCALL(fstat)
 4e2:	b8 08 00 00 00       	mov    $0x8,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <link>:
SYSCALL(link)
 4ea:	b8 13 00 00 00       	mov    $0x13,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <mkdir>:
SYSCALL(mkdir)
 4f2:	b8 14 00 00 00       	mov    $0x14,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <chdir>:
SYSCALL(chdir)
 4fa:	b8 09 00 00 00       	mov    $0x9,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <dup>:
SYSCALL(dup)
 502:	b8 0a 00 00 00       	mov    $0xa,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <getpid>:
SYSCALL(getpid)
 50a:	b8 0b 00 00 00       	mov    $0xb,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <sbrk>:
SYSCALL(sbrk)
 512:	b8 0c 00 00 00       	mov    $0xc,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <sleep>:
SYSCALL(sleep)
 51a:	b8 0d 00 00 00       	mov    $0xd,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <uptime>:
SYSCALL(uptime)
 522:	b8 0e 00 00 00       	mov    $0xe,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <halt>:
SYSCALL(halt)
 52a:	b8 16 00 00 00       	mov    $0x16,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <date>:
SYSCALL(date)
 532:	b8 17 00 00 00       	mov    $0x17,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <getuid>:
SYSCALL(getuid)
 53a:	b8 18 00 00 00       	mov    $0x18,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <getgid>:
SYSCALL(getgid)
 542:	b8 19 00 00 00       	mov    $0x19,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <getppid>:
SYSCALL(getppid)
 54a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <setuid>:
SYSCALL(setuid)
 552:	b8 1b 00 00 00       	mov    $0x1b,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <setgid>:
SYSCALL(setgid)
 55a:	b8 1c 00 00 00       	mov    $0x1c,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <getprocs>:
SYSCALL(getprocs)
 562:	b8 1d 00 00 00       	mov    $0x1d,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 56a:	55                   	push   %ebp
 56b:	89 e5                	mov    %esp,%ebp
 56d:	83 ec 18             	sub    $0x18,%esp
 570:	8b 45 0c             	mov    0xc(%ebp),%eax
 573:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 576:	83 ec 04             	sub    $0x4,%esp
 579:	6a 01                	push   $0x1
 57b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 57e:	50                   	push   %eax
 57f:	ff 75 08             	pushl  0x8(%ebp)
 582:	e8 23 ff ff ff       	call   4aa <write>
 587:	83 c4 10             	add    $0x10,%esp
}
 58a:	90                   	nop
 58b:	c9                   	leave  
 58c:	c3                   	ret    

0000058d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 58d:	55                   	push   %ebp
 58e:	89 e5                	mov    %esp,%ebp
 590:	53                   	push   %ebx
 591:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 594:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 59b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 59f:	74 17                	je     5b8 <printint+0x2b>
 5a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5a5:	79 11                	jns    5b8 <printint+0x2b>
    neg = 1;
 5a7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b1:	f7 d8                	neg    %eax
 5b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5b6:	eb 06                	jmp    5be <printint+0x31>
  } else {
    x = xx;
 5b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 5bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5c5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5c8:	8d 41 01             	lea    0x1(%ecx),%eax
 5cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5d4:	ba 00 00 00 00       	mov    $0x0,%edx
 5d9:	f7 f3                	div    %ebx
 5db:	89 d0                	mov    %edx,%eax
 5dd:	0f b6 80 a0 0c 00 00 	movzbl 0xca0(%eax),%eax
 5e4:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5ee:	ba 00 00 00 00       	mov    $0x0,%edx
 5f3:	f7 f3                	div    %ebx
 5f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5f8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5fc:	75 c7                	jne    5c5 <printint+0x38>
  if(neg)
 5fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 602:	74 2d                	je     631 <printint+0xa4>
    buf[i++] = '-';
 604:	8b 45 f4             	mov    -0xc(%ebp),%eax
 607:	8d 50 01             	lea    0x1(%eax),%edx
 60a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 60d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 612:	eb 1d                	jmp    631 <printint+0xa4>
    putc(fd, buf[i]);
 614:	8d 55 dc             	lea    -0x24(%ebp),%edx
 617:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61a:	01 d0                	add    %edx,%eax
 61c:	0f b6 00             	movzbl (%eax),%eax
 61f:	0f be c0             	movsbl %al,%eax
 622:	83 ec 08             	sub    $0x8,%esp
 625:	50                   	push   %eax
 626:	ff 75 08             	pushl  0x8(%ebp)
 629:	e8 3c ff ff ff       	call   56a <putc>
 62e:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 631:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 635:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 639:	79 d9                	jns    614 <printint+0x87>
    putc(fd, buf[i]);
}
 63b:	90                   	nop
 63c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 63f:	c9                   	leave  
 640:	c3                   	ret    

00000641 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 641:	55                   	push   %ebp
 642:	89 e5                	mov    %esp,%ebp
 644:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 647:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 64e:	8d 45 0c             	lea    0xc(%ebp),%eax
 651:	83 c0 04             	add    $0x4,%eax
 654:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 657:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 65e:	e9 59 01 00 00       	jmp    7bc <printf+0x17b>
    c = fmt[i] & 0xff;
 663:	8b 55 0c             	mov    0xc(%ebp),%edx
 666:	8b 45 f0             	mov    -0x10(%ebp),%eax
 669:	01 d0                	add    %edx,%eax
 66b:	0f b6 00             	movzbl (%eax),%eax
 66e:	0f be c0             	movsbl %al,%eax
 671:	25 ff 00 00 00       	and    $0xff,%eax
 676:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 679:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 67d:	75 2c                	jne    6ab <printf+0x6a>
      if(c == '%'){
 67f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 683:	75 0c                	jne    691 <printf+0x50>
        state = '%';
 685:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 68c:	e9 27 01 00 00       	jmp    7b8 <printf+0x177>
      } else {
        putc(fd, c);
 691:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 694:	0f be c0             	movsbl %al,%eax
 697:	83 ec 08             	sub    $0x8,%esp
 69a:	50                   	push   %eax
 69b:	ff 75 08             	pushl  0x8(%ebp)
 69e:	e8 c7 fe ff ff       	call   56a <putc>
 6a3:	83 c4 10             	add    $0x10,%esp
 6a6:	e9 0d 01 00 00       	jmp    7b8 <printf+0x177>
      }
    } else if(state == '%'){
 6ab:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6af:	0f 85 03 01 00 00    	jne    7b8 <printf+0x177>
      if(c == 'd'){
 6b5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6b9:	75 1e                	jne    6d9 <printf+0x98>
        printint(fd, *ap, 10, 1);
 6bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6be:	8b 00                	mov    (%eax),%eax
 6c0:	6a 01                	push   $0x1
 6c2:	6a 0a                	push   $0xa
 6c4:	50                   	push   %eax
 6c5:	ff 75 08             	pushl  0x8(%ebp)
 6c8:	e8 c0 fe ff ff       	call   58d <printint>
 6cd:	83 c4 10             	add    $0x10,%esp
        ap++;
 6d0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6d4:	e9 d8 00 00 00       	jmp    7b1 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6d9:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6dd:	74 06                	je     6e5 <printf+0xa4>
 6df:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6e3:	75 1e                	jne    703 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e8:	8b 00                	mov    (%eax),%eax
 6ea:	6a 00                	push   $0x0
 6ec:	6a 10                	push   $0x10
 6ee:	50                   	push   %eax
 6ef:	ff 75 08             	pushl  0x8(%ebp)
 6f2:	e8 96 fe ff ff       	call   58d <printint>
 6f7:	83 c4 10             	add    $0x10,%esp
        ap++;
 6fa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6fe:	e9 ae 00 00 00       	jmp    7b1 <printf+0x170>
      } else if(c == 's'){
 703:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 707:	75 43                	jne    74c <printf+0x10b>
        s = (char*)*ap;
 709:	8b 45 e8             	mov    -0x18(%ebp),%eax
 70c:	8b 00                	mov    (%eax),%eax
 70e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 711:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 715:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 719:	75 25                	jne    740 <printf+0xff>
          s = "(null)";
 71b:	c7 45 f4 2a 0a 00 00 	movl   $0xa2a,-0xc(%ebp)
        while(*s != 0){
 722:	eb 1c                	jmp    740 <printf+0xff>
          putc(fd, *s);
 724:	8b 45 f4             	mov    -0xc(%ebp),%eax
 727:	0f b6 00             	movzbl (%eax),%eax
 72a:	0f be c0             	movsbl %al,%eax
 72d:	83 ec 08             	sub    $0x8,%esp
 730:	50                   	push   %eax
 731:	ff 75 08             	pushl  0x8(%ebp)
 734:	e8 31 fe ff ff       	call   56a <putc>
 739:	83 c4 10             	add    $0x10,%esp
          s++;
 73c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 740:	8b 45 f4             	mov    -0xc(%ebp),%eax
 743:	0f b6 00             	movzbl (%eax),%eax
 746:	84 c0                	test   %al,%al
 748:	75 da                	jne    724 <printf+0xe3>
 74a:	eb 65                	jmp    7b1 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 74c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 750:	75 1d                	jne    76f <printf+0x12e>
        putc(fd, *ap);
 752:	8b 45 e8             	mov    -0x18(%ebp),%eax
 755:	8b 00                	mov    (%eax),%eax
 757:	0f be c0             	movsbl %al,%eax
 75a:	83 ec 08             	sub    $0x8,%esp
 75d:	50                   	push   %eax
 75e:	ff 75 08             	pushl  0x8(%ebp)
 761:	e8 04 fe ff ff       	call   56a <putc>
 766:	83 c4 10             	add    $0x10,%esp
        ap++;
 769:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 76d:	eb 42                	jmp    7b1 <printf+0x170>
      } else if(c == '%'){
 76f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 773:	75 17                	jne    78c <printf+0x14b>
        putc(fd, c);
 775:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 778:	0f be c0             	movsbl %al,%eax
 77b:	83 ec 08             	sub    $0x8,%esp
 77e:	50                   	push   %eax
 77f:	ff 75 08             	pushl  0x8(%ebp)
 782:	e8 e3 fd ff ff       	call   56a <putc>
 787:	83 c4 10             	add    $0x10,%esp
 78a:	eb 25                	jmp    7b1 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 78c:	83 ec 08             	sub    $0x8,%esp
 78f:	6a 25                	push   $0x25
 791:	ff 75 08             	pushl  0x8(%ebp)
 794:	e8 d1 fd ff ff       	call   56a <putc>
 799:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 79c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 79f:	0f be c0             	movsbl %al,%eax
 7a2:	83 ec 08             	sub    $0x8,%esp
 7a5:	50                   	push   %eax
 7a6:	ff 75 08             	pushl  0x8(%ebp)
 7a9:	e8 bc fd ff ff       	call   56a <putc>
 7ae:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7b1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7b8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7bc:	8b 55 0c             	mov    0xc(%ebp),%edx
 7bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c2:	01 d0                	add    %edx,%eax
 7c4:	0f b6 00             	movzbl (%eax),%eax
 7c7:	84 c0                	test   %al,%al
 7c9:	0f 85 94 fe ff ff    	jne    663 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7cf:	90                   	nop
 7d0:	c9                   	leave  
 7d1:	c3                   	ret    

000007d2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d2:	55                   	push   %ebp
 7d3:	89 e5                	mov    %esp,%ebp
 7d5:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7d8:	8b 45 08             	mov    0x8(%ebp),%eax
 7db:	83 e8 08             	sub    $0x8,%eax
 7de:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e1:	a1 bc 0c 00 00       	mov    0xcbc,%eax
 7e6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7e9:	eb 24                	jmp    80f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ee:	8b 00                	mov    (%eax),%eax
 7f0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7f3:	77 12                	ja     807 <free+0x35>
 7f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7fb:	77 24                	ja     821 <free+0x4f>
 7fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 800:	8b 00                	mov    (%eax),%eax
 802:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 805:	77 1a                	ja     821 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 807:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80a:	8b 00                	mov    (%eax),%eax
 80c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 80f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 812:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 815:	76 d4                	jbe    7eb <free+0x19>
 817:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81a:	8b 00                	mov    (%eax),%eax
 81c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 81f:	76 ca                	jbe    7eb <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 821:	8b 45 f8             	mov    -0x8(%ebp),%eax
 824:	8b 40 04             	mov    0x4(%eax),%eax
 827:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 82e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 831:	01 c2                	add    %eax,%edx
 833:	8b 45 fc             	mov    -0x4(%ebp),%eax
 836:	8b 00                	mov    (%eax),%eax
 838:	39 c2                	cmp    %eax,%edx
 83a:	75 24                	jne    860 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 83c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83f:	8b 50 04             	mov    0x4(%eax),%edx
 842:	8b 45 fc             	mov    -0x4(%ebp),%eax
 845:	8b 00                	mov    (%eax),%eax
 847:	8b 40 04             	mov    0x4(%eax),%eax
 84a:	01 c2                	add    %eax,%edx
 84c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 84f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 852:	8b 45 fc             	mov    -0x4(%ebp),%eax
 855:	8b 00                	mov    (%eax),%eax
 857:	8b 10                	mov    (%eax),%edx
 859:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85c:	89 10                	mov    %edx,(%eax)
 85e:	eb 0a                	jmp    86a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 860:	8b 45 fc             	mov    -0x4(%ebp),%eax
 863:	8b 10                	mov    (%eax),%edx
 865:	8b 45 f8             	mov    -0x8(%ebp),%eax
 868:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 86a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86d:	8b 40 04             	mov    0x4(%eax),%eax
 870:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 877:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87a:	01 d0                	add    %edx,%eax
 87c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 87f:	75 20                	jne    8a1 <free+0xcf>
    p->s.size += bp->s.size;
 881:	8b 45 fc             	mov    -0x4(%ebp),%eax
 884:	8b 50 04             	mov    0x4(%eax),%edx
 887:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88a:	8b 40 04             	mov    0x4(%eax),%eax
 88d:	01 c2                	add    %eax,%edx
 88f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 892:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 895:	8b 45 f8             	mov    -0x8(%ebp),%eax
 898:	8b 10                	mov    (%eax),%edx
 89a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89d:	89 10                	mov    %edx,(%eax)
 89f:	eb 08                	jmp    8a9 <free+0xd7>
  } else
    p->s.ptr = bp;
 8a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8a7:	89 10                	mov    %edx,(%eax)
  freep = p;
 8a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ac:	a3 bc 0c 00 00       	mov    %eax,0xcbc
}
 8b1:	90                   	nop
 8b2:	c9                   	leave  
 8b3:	c3                   	ret    

000008b4 <morecore>:

static Header*
morecore(uint nu)
{
 8b4:	55                   	push   %ebp
 8b5:	89 e5                	mov    %esp,%ebp
 8b7:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8ba:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8c1:	77 07                	ja     8ca <morecore+0x16>
    nu = 4096;
 8c3:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8ca:	8b 45 08             	mov    0x8(%ebp),%eax
 8cd:	c1 e0 03             	shl    $0x3,%eax
 8d0:	83 ec 0c             	sub    $0xc,%esp
 8d3:	50                   	push   %eax
 8d4:	e8 39 fc ff ff       	call   512 <sbrk>
 8d9:	83 c4 10             	add    $0x10,%esp
 8dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8df:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8e3:	75 07                	jne    8ec <morecore+0x38>
    return 0;
 8e5:	b8 00 00 00 00       	mov    $0x0,%eax
 8ea:	eb 26                	jmp    912 <morecore+0x5e>
  hp = (Header*)p;
 8ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f5:	8b 55 08             	mov    0x8(%ebp),%edx
 8f8:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fe:	83 c0 08             	add    $0x8,%eax
 901:	83 ec 0c             	sub    $0xc,%esp
 904:	50                   	push   %eax
 905:	e8 c8 fe ff ff       	call   7d2 <free>
 90a:	83 c4 10             	add    $0x10,%esp
  return freep;
 90d:	a1 bc 0c 00 00       	mov    0xcbc,%eax
}
 912:	c9                   	leave  
 913:	c3                   	ret    

00000914 <malloc>:

void*
malloc(uint nbytes)
{
 914:	55                   	push   %ebp
 915:	89 e5                	mov    %esp,%ebp
 917:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 91a:	8b 45 08             	mov    0x8(%ebp),%eax
 91d:	83 c0 07             	add    $0x7,%eax
 920:	c1 e8 03             	shr    $0x3,%eax
 923:	83 c0 01             	add    $0x1,%eax
 926:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 929:	a1 bc 0c 00 00       	mov    0xcbc,%eax
 92e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 931:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 935:	75 23                	jne    95a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 937:	c7 45 f0 b4 0c 00 00 	movl   $0xcb4,-0x10(%ebp)
 93e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 941:	a3 bc 0c 00 00       	mov    %eax,0xcbc
 946:	a1 bc 0c 00 00       	mov    0xcbc,%eax
 94b:	a3 b4 0c 00 00       	mov    %eax,0xcb4
    base.s.size = 0;
 950:	c7 05 b8 0c 00 00 00 	movl   $0x0,0xcb8
 957:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95d:	8b 00                	mov    (%eax),%eax
 95f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 962:	8b 45 f4             	mov    -0xc(%ebp),%eax
 965:	8b 40 04             	mov    0x4(%eax),%eax
 968:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 96b:	72 4d                	jb     9ba <malloc+0xa6>
      if(p->s.size == nunits)
 96d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 970:	8b 40 04             	mov    0x4(%eax),%eax
 973:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 976:	75 0c                	jne    984 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 978:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97b:	8b 10                	mov    (%eax),%edx
 97d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 980:	89 10                	mov    %edx,(%eax)
 982:	eb 26                	jmp    9aa <malloc+0x96>
      else {
        p->s.size -= nunits;
 984:	8b 45 f4             	mov    -0xc(%ebp),%eax
 987:	8b 40 04             	mov    0x4(%eax),%eax
 98a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 98d:	89 c2                	mov    %eax,%edx
 98f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 992:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 995:	8b 45 f4             	mov    -0xc(%ebp),%eax
 998:	8b 40 04             	mov    0x4(%eax),%eax
 99b:	c1 e0 03             	shl    $0x3,%eax
 99e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a4:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9a7:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ad:	a3 bc 0c 00 00       	mov    %eax,0xcbc
      return (void*)(p + 1);
 9b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b5:	83 c0 08             	add    $0x8,%eax
 9b8:	eb 3b                	jmp    9f5 <malloc+0xe1>
    }
    if(p == freep)
 9ba:	a1 bc 0c 00 00       	mov    0xcbc,%eax
 9bf:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9c2:	75 1e                	jne    9e2 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 9c4:	83 ec 0c             	sub    $0xc,%esp
 9c7:	ff 75 ec             	pushl  -0x14(%ebp)
 9ca:	e8 e5 fe ff ff       	call   8b4 <morecore>
 9cf:	83 c4 10             	add    $0x10,%esp
 9d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9d9:	75 07                	jne    9e2 <malloc+0xce>
        return 0;
 9db:	b8 00 00 00 00       	mov    $0x0,%eax
 9e0:	eb 13                	jmp    9f5 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9eb:	8b 00                	mov    (%eax),%eax
 9ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9f0:	e9 6d ff ff ff       	jmp    962 <malloc+0x4e>
}
 9f5:	c9                   	leave  
 9f6:	c3                   	ret    
