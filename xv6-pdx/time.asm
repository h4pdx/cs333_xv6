
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
    if (argc <= 0) {
  14:	83 3b 00             	cmpl   $0x0,(%ebx)
  17:	7f 05                	jg     1e <main+0x1e>
        exit();
  19:	e8 9b 04 00 00       	call   4b9 <exit>
    }
    uint start_time = 0, end_time = 0, pid = 0,
  1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  25:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  2c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
         elapsed_time = 0, sec = 0, milisec_ten = 0, milisec_hund = 0, milisec_thou = 0;
  33:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  3a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  41:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  48:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  4f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
    if (argc == 1) {
  56:	83 3b 01             	cmpl   $0x1,(%ebx)
  59:	75 1d                	jne    78 <main+0x78>
        printf(1, "%s ran in 0.000 seconds\n", argv[0]);
  5b:	8b 43 04             	mov    0x4(%ebx),%eax
  5e:	8b 00                	mov    (%eax),%eax
  60:	83 ec 04             	sub    $0x4,%esp
  63:	50                   	push   %eax
  64:	68 46 0a 00 00       	push   $0xa46
  69:	6a 01                	push   $0x1
  6b:	e8 20 06 00 00       	call   690 <printf>
  70:	83 c4 10             	add    $0x10,%esp
        exit();
  73:	e8 41 04 00 00       	call   4b9 <exit>
    }
    start_time = uptime(); // start uptime
  78:	e8 d4 04 00 00       	call   551 <uptime>
  7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    pid = fork(); // fork new process
  80:	e8 2c 04 00 00       	call   4b1 <fork>
  85:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (pid > 0) {
  88:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8c:	74 0a                	je     98 <main+0x98>
        pid = wait(); // wait for child to finish
  8e:	e8 2e 04 00 00       	call   4c1 <wait>
  93:	89 45 ec             	mov    %eax,-0x14(%ebp)
  96:	eb 26                	jmp    be <main+0xbe>
    }
    else if (pid == 0) {
  98:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  9c:	75 20                	jne    be <main+0xbe>
        exec(argv[1], (argv+1)); // pointer arithmetic to skip first index of argv (always will be time)
  9e:	8b 43 04             	mov    0x4(%ebx),%eax
  a1:	8d 50 04             	lea    0x4(%eax),%edx
  a4:	8b 43 04             	mov    0x4(%ebx),%eax
  a7:	83 c0 04             	add    $0x4,%eax
  aa:	8b 00                	mov    (%eax),%eax
  ac:	83 ec 08             	sub    $0x8,%esp
  af:	52                   	push   %edx
  b0:	50                   	push   %eax
  b1:	e8 3b 04 00 00       	call   4f1 <exec>
  b6:	83 c4 10             	add    $0x10,%esp
        exit();
  b9:	e8 fb 03 00 00       	call   4b9 <exit>
    }
    end_time = uptime(); // record end time
  be:	e8 8e 04 00 00       	call   551 <uptime>
  c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    elapsed_time = (end_time - start_time); // calc elapsed time
  c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  c9:	2b 45 f4             	sub    -0xc(%ebp),%eax
  cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    sec = (elapsed_time / 1000); // divide for whole seconds
  cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  d2:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
  d7:	f7 e2                	mul    %edx
  d9:	89 d0                	mov    %edx,%eax
  db:	c1 e8 06             	shr    $0x6,%eax
  de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    milisec_ten = ((elapsed_time %= 1000) / 100); // mod and divide for miliseconds
  e1:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  e4:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
  e9:	89 c8                	mov    %ecx,%eax
  eb:	f7 e2                	mul    %edx
  ed:	89 d0                	mov    %edx,%eax
  ef:	c1 e8 06             	shr    $0x6,%eax
  f2:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
  f8:	29 c1                	sub    %eax,%ecx
  fa:	89 c8                	mov    %ecx,%eax
  fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
 102:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 107:	f7 e2                	mul    %edx
 109:	89 d0                	mov    %edx,%eax
 10b:	c1 e8 05             	shr    $0x5,%eax
 10e:	89 45 e0             	mov    %eax,-0x20(%ebp)
    milisec_hund = ((elapsed_time %= 100) / 10);
 111:	8b 4d e8             	mov    -0x18(%ebp),%ecx
 114:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
 119:	89 c8                	mov    %ecx,%eax
 11b:	f7 e2                	mul    %edx
 11d:	89 d0                	mov    %edx,%eax
 11f:	c1 e8 05             	shr    $0x5,%eax
 122:	6b c0 64             	imul   $0x64,%eax,%eax
 125:	29 c1                	sub    %eax,%ecx
 127:	89 c8                	mov    %ecx,%eax
 129:	89 45 e8             	mov    %eax,-0x18(%ebp)
 12c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 12f:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 134:	f7 e2                	mul    %edx
 136:	89 d0                	mov    %edx,%eax
 138:	c1 e8 03             	shr    $0x3,%eax
 13b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    milisec_thou = (elapsed_time %= 10);
 13e:	8b 4d e8             	mov    -0x18(%ebp),%ecx
 141:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
 146:	89 c8                	mov    %ecx,%eax
 148:	f7 e2                	mul    %edx
 14a:	c1 ea 03             	shr    $0x3,%edx
 14d:	89 d0                	mov    %edx,%eax
 14f:	c1 e0 02             	shl    $0x2,%eax
 152:	01 d0                	add    %edx,%eax
 154:	01 c0                	add    %eax,%eax
 156:	29 c1                	sub    %eax,%ecx
 158:	89 c8                	mov    %ecx,%eax
 15a:	89 45 e8             	mov    %eax,-0x18(%ebp)
 15d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 160:	89 45 d8             	mov    %eax,-0x28(%ebp)

    printf(1, "%s ran in %d.%d%d%d seconds\n", argv[1], sec, milisec_ten, milisec_hund, milisec_thou);
 163:	8b 43 04             	mov    0x4(%ebx),%eax
 166:	83 c0 04             	add    $0x4,%eax
 169:	8b 00                	mov    (%eax),%eax
 16b:	83 ec 04             	sub    $0x4,%esp
 16e:	ff 75 d8             	pushl  -0x28(%ebp)
 171:	ff 75 dc             	pushl  -0x24(%ebp)
 174:	ff 75 e0             	pushl  -0x20(%ebp)
 177:	ff 75 e4             	pushl  -0x1c(%ebp)
 17a:	50                   	push   %eax
 17b:	68 5f 0a 00 00       	push   $0xa5f
 180:	6a 01                	push   $0x1
 182:	e8 09 05 00 00       	call   690 <printf>
 187:	83 c4 20             	add    $0x20,%esp
    exit();
 18a:	e8 2a 03 00 00       	call   4b9 <exit>

0000018f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 18f:	55                   	push   %ebp
 190:	89 e5                	mov    %esp,%ebp
 192:	57                   	push   %edi
 193:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 194:	8b 4d 08             	mov    0x8(%ebp),%ecx
 197:	8b 55 10             	mov    0x10(%ebp),%edx
 19a:	8b 45 0c             	mov    0xc(%ebp),%eax
 19d:	89 cb                	mov    %ecx,%ebx
 19f:	89 df                	mov    %ebx,%edi
 1a1:	89 d1                	mov    %edx,%ecx
 1a3:	fc                   	cld    
 1a4:	f3 aa                	rep stos %al,%es:(%edi)
 1a6:	89 ca                	mov    %ecx,%edx
 1a8:	89 fb                	mov    %edi,%ebx
 1aa:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1ad:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1b0:	90                   	nop
 1b1:	5b                   	pop    %ebx
 1b2:	5f                   	pop    %edi
 1b3:	5d                   	pop    %ebp
 1b4:	c3                   	ret    

000001b5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1b5:	55                   	push   %ebp
 1b6:	89 e5                	mov    %esp,%ebp
 1b8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1bb:	8b 45 08             	mov    0x8(%ebp),%eax
 1be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1c1:	90                   	nop
 1c2:	8b 45 08             	mov    0x8(%ebp),%eax
 1c5:	8d 50 01             	lea    0x1(%eax),%edx
 1c8:	89 55 08             	mov    %edx,0x8(%ebp)
 1cb:	8b 55 0c             	mov    0xc(%ebp),%edx
 1ce:	8d 4a 01             	lea    0x1(%edx),%ecx
 1d1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1d4:	0f b6 12             	movzbl (%edx),%edx
 1d7:	88 10                	mov    %dl,(%eax)
 1d9:	0f b6 00             	movzbl (%eax),%eax
 1dc:	84 c0                	test   %al,%al
 1de:	75 e2                	jne    1c2 <strcpy+0xd>
    ;
  return os;
 1e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1e3:	c9                   	leave  
 1e4:	c3                   	ret    

000001e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1e5:	55                   	push   %ebp
 1e6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1e8:	eb 08                	jmp    1f2 <strcmp+0xd>
    p++, q++;
 1ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1ee:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1f2:	8b 45 08             	mov    0x8(%ebp),%eax
 1f5:	0f b6 00             	movzbl (%eax),%eax
 1f8:	84 c0                	test   %al,%al
 1fa:	74 10                	je     20c <strcmp+0x27>
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
 1ff:	0f b6 10             	movzbl (%eax),%edx
 202:	8b 45 0c             	mov    0xc(%ebp),%eax
 205:	0f b6 00             	movzbl (%eax),%eax
 208:	38 c2                	cmp    %al,%dl
 20a:	74 de                	je     1ea <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	0f b6 00             	movzbl (%eax),%eax
 212:	0f b6 d0             	movzbl %al,%edx
 215:	8b 45 0c             	mov    0xc(%ebp),%eax
 218:	0f b6 00             	movzbl (%eax),%eax
 21b:	0f b6 c0             	movzbl %al,%eax
 21e:	29 c2                	sub    %eax,%edx
 220:	89 d0                	mov    %edx,%eax
}
 222:	5d                   	pop    %ebp
 223:	c3                   	ret    

00000224 <strlen>:

uint
strlen(char *s)
{
 224:	55                   	push   %ebp
 225:	89 e5                	mov    %esp,%ebp
 227:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 22a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 231:	eb 04                	jmp    237 <strlen+0x13>
 233:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 237:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	01 d0                	add    %edx,%eax
 23f:	0f b6 00             	movzbl (%eax),%eax
 242:	84 c0                	test   %al,%al
 244:	75 ed                	jne    233 <strlen+0xf>
    ;
  return n;
 246:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 249:	c9                   	leave  
 24a:	c3                   	ret    

0000024b <memset>:

void*
memset(void *dst, int c, uint n)
{
 24b:	55                   	push   %ebp
 24c:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 24e:	8b 45 10             	mov    0x10(%ebp),%eax
 251:	50                   	push   %eax
 252:	ff 75 0c             	pushl  0xc(%ebp)
 255:	ff 75 08             	pushl  0x8(%ebp)
 258:	e8 32 ff ff ff       	call   18f <stosb>
 25d:	83 c4 0c             	add    $0xc,%esp
  return dst;
 260:	8b 45 08             	mov    0x8(%ebp),%eax
}
 263:	c9                   	leave  
 264:	c3                   	ret    

00000265 <strchr>:

char*
strchr(const char *s, char c)
{
 265:	55                   	push   %ebp
 266:	89 e5                	mov    %esp,%ebp
 268:	83 ec 04             	sub    $0x4,%esp
 26b:	8b 45 0c             	mov    0xc(%ebp),%eax
 26e:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 271:	eb 14                	jmp    287 <strchr+0x22>
    if(*s == c)
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	0f b6 00             	movzbl (%eax),%eax
 279:	3a 45 fc             	cmp    -0x4(%ebp),%al
 27c:	75 05                	jne    283 <strchr+0x1e>
      return (char*)s;
 27e:	8b 45 08             	mov    0x8(%ebp),%eax
 281:	eb 13                	jmp    296 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 283:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 287:	8b 45 08             	mov    0x8(%ebp),%eax
 28a:	0f b6 00             	movzbl (%eax),%eax
 28d:	84 c0                	test   %al,%al
 28f:	75 e2                	jne    273 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 291:	b8 00 00 00 00       	mov    $0x0,%eax
}
 296:	c9                   	leave  
 297:	c3                   	ret    

00000298 <gets>:

char*
gets(char *buf, int max)
{
 298:	55                   	push   %ebp
 299:	89 e5                	mov    %esp,%ebp
 29b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 29e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2a5:	eb 42                	jmp    2e9 <gets+0x51>
    cc = read(0, &c, 1);
 2a7:	83 ec 04             	sub    $0x4,%esp
 2aa:	6a 01                	push   $0x1
 2ac:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2af:	50                   	push   %eax
 2b0:	6a 00                	push   $0x0
 2b2:	e8 1a 02 00 00       	call   4d1 <read>
 2b7:	83 c4 10             	add    $0x10,%esp
 2ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2c1:	7e 33                	jle    2f6 <gets+0x5e>
      break;
    buf[i++] = c;
 2c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2c6:	8d 50 01             	lea    0x1(%eax),%edx
 2c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2cc:	89 c2                	mov    %eax,%edx
 2ce:	8b 45 08             	mov    0x8(%ebp),%eax
 2d1:	01 c2                	add    %eax,%edx
 2d3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2d7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2d9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2dd:	3c 0a                	cmp    $0xa,%al
 2df:	74 16                	je     2f7 <gets+0x5f>
 2e1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2e5:	3c 0d                	cmp    $0xd,%al
 2e7:	74 0e                	je     2f7 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ec:	83 c0 01             	add    $0x1,%eax
 2ef:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2f2:	7c b3                	jl     2a7 <gets+0xf>
 2f4:	eb 01                	jmp    2f7 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2f6:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2fa:	8b 45 08             	mov    0x8(%ebp),%eax
 2fd:	01 d0                	add    %edx,%eax
 2ff:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 302:	8b 45 08             	mov    0x8(%ebp),%eax
}
 305:	c9                   	leave  
 306:	c3                   	ret    

00000307 <stat>:

int
stat(char *n, struct stat *st)
{
 307:	55                   	push   %ebp
 308:	89 e5                	mov    %esp,%ebp
 30a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 30d:	83 ec 08             	sub    $0x8,%esp
 310:	6a 00                	push   $0x0
 312:	ff 75 08             	pushl  0x8(%ebp)
 315:	e8 df 01 00 00       	call   4f9 <open>
 31a:	83 c4 10             	add    $0x10,%esp
 31d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 320:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 324:	79 07                	jns    32d <stat+0x26>
    return -1;
 326:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 32b:	eb 25                	jmp    352 <stat+0x4b>
  r = fstat(fd, st);
 32d:	83 ec 08             	sub    $0x8,%esp
 330:	ff 75 0c             	pushl  0xc(%ebp)
 333:	ff 75 f4             	pushl  -0xc(%ebp)
 336:	e8 d6 01 00 00       	call   511 <fstat>
 33b:	83 c4 10             	add    $0x10,%esp
 33e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 341:	83 ec 0c             	sub    $0xc,%esp
 344:	ff 75 f4             	pushl  -0xc(%ebp)
 347:	e8 95 01 00 00       	call   4e1 <close>
 34c:	83 c4 10             	add    $0x10,%esp
  return r;
 34f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 352:	c9                   	leave  
 353:	c3                   	ret    

00000354 <atoi>:

int
atoi(const char *s)
{
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 35a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 361:	eb 04                	jmp    367 <atoi+0x13>
 363:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 367:	8b 45 08             	mov    0x8(%ebp),%eax
 36a:	0f b6 00             	movzbl (%eax),%eax
 36d:	3c 20                	cmp    $0x20,%al
 36f:	74 f2                	je     363 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 371:	8b 45 08             	mov    0x8(%ebp),%eax
 374:	0f b6 00             	movzbl (%eax),%eax
 377:	3c 2d                	cmp    $0x2d,%al
 379:	75 07                	jne    382 <atoi+0x2e>
 37b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 380:	eb 05                	jmp    387 <atoi+0x33>
 382:	b8 01 00 00 00       	mov    $0x1,%eax
 387:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 38a:	8b 45 08             	mov    0x8(%ebp),%eax
 38d:	0f b6 00             	movzbl (%eax),%eax
 390:	3c 2b                	cmp    $0x2b,%al
 392:	74 0a                	je     39e <atoi+0x4a>
 394:	8b 45 08             	mov    0x8(%ebp),%eax
 397:	0f b6 00             	movzbl (%eax),%eax
 39a:	3c 2d                	cmp    $0x2d,%al
 39c:	75 2b                	jne    3c9 <atoi+0x75>
    s++;
 39e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 3a2:	eb 25                	jmp    3c9 <atoi+0x75>
    n = n*10 + *s++ - '0';
 3a4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3a7:	89 d0                	mov    %edx,%eax
 3a9:	c1 e0 02             	shl    $0x2,%eax
 3ac:	01 d0                	add    %edx,%eax
 3ae:	01 c0                	add    %eax,%eax
 3b0:	89 c1                	mov    %eax,%ecx
 3b2:	8b 45 08             	mov    0x8(%ebp),%eax
 3b5:	8d 50 01             	lea    0x1(%eax),%edx
 3b8:	89 55 08             	mov    %edx,0x8(%ebp)
 3bb:	0f b6 00             	movzbl (%eax),%eax
 3be:	0f be c0             	movsbl %al,%eax
 3c1:	01 c8                	add    %ecx,%eax
 3c3:	83 e8 30             	sub    $0x30,%eax
 3c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 3c9:	8b 45 08             	mov    0x8(%ebp),%eax
 3cc:	0f b6 00             	movzbl (%eax),%eax
 3cf:	3c 2f                	cmp    $0x2f,%al
 3d1:	7e 0a                	jle    3dd <atoi+0x89>
 3d3:	8b 45 08             	mov    0x8(%ebp),%eax
 3d6:	0f b6 00             	movzbl (%eax),%eax
 3d9:	3c 39                	cmp    $0x39,%al
 3db:	7e c7                	jle    3a4 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 3dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3e0:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3e4:	c9                   	leave  
 3e5:	c3                   	ret    

000003e6 <atoo>:

int
atoo(const char *s)
{
 3e6:	55                   	push   %ebp
 3e7:	89 e5                	mov    %esp,%ebp
 3e9:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 3f3:	eb 04                	jmp    3f9 <atoo+0x13>
 3f5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3f9:	8b 45 08             	mov    0x8(%ebp),%eax
 3fc:	0f b6 00             	movzbl (%eax),%eax
 3ff:	3c 20                	cmp    $0x20,%al
 401:	74 f2                	je     3f5 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 403:	8b 45 08             	mov    0x8(%ebp),%eax
 406:	0f b6 00             	movzbl (%eax),%eax
 409:	3c 2d                	cmp    $0x2d,%al
 40b:	75 07                	jne    414 <atoo+0x2e>
 40d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 412:	eb 05                	jmp    419 <atoo+0x33>
 414:	b8 01 00 00 00       	mov    $0x1,%eax
 419:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 41c:	8b 45 08             	mov    0x8(%ebp),%eax
 41f:	0f b6 00             	movzbl (%eax),%eax
 422:	3c 2b                	cmp    $0x2b,%al
 424:	74 0a                	je     430 <atoo+0x4a>
 426:	8b 45 08             	mov    0x8(%ebp),%eax
 429:	0f b6 00             	movzbl (%eax),%eax
 42c:	3c 2d                	cmp    $0x2d,%al
 42e:	75 27                	jne    457 <atoo+0x71>
    s++;
 430:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 434:	eb 21                	jmp    457 <atoo+0x71>
    n = n*8 + *s++ - '0';
 436:	8b 45 fc             	mov    -0x4(%ebp),%eax
 439:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 440:	8b 45 08             	mov    0x8(%ebp),%eax
 443:	8d 50 01             	lea    0x1(%eax),%edx
 446:	89 55 08             	mov    %edx,0x8(%ebp)
 449:	0f b6 00             	movzbl (%eax),%eax
 44c:	0f be c0             	movsbl %al,%eax
 44f:	01 c8                	add    %ecx,%eax
 451:	83 e8 30             	sub    $0x30,%eax
 454:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 457:	8b 45 08             	mov    0x8(%ebp),%eax
 45a:	0f b6 00             	movzbl (%eax),%eax
 45d:	3c 2f                	cmp    $0x2f,%al
 45f:	7e 0a                	jle    46b <atoo+0x85>
 461:	8b 45 08             	mov    0x8(%ebp),%eax
 464:	0f b6 00             	movzbl (%eax),%eax
 467:	3c 37                	cmp    $0x37,%al
 469:	7e cb                	jle    436 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 46b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 46e:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 472:	c9                   	leave  
 473:	c3                   	ret    

00000474 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 474:	55                   	push   %ebp
 475:	89 e5                	mov    %esp,%ebp
 477:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 47a:	8b 45 08             	mov    0x8(%ebp),%eax
 47d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 480:	8b 45 0c             	mov    0xc(%ebp),%eax
 483:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 486:	eb 17                	jmp    49f <memmove+0x2b>
    *dst++ = *src++;
 488:	8b 45 fc             	mov    -0x4(%ebp),%eax
 48b:	8d 50 01             	lea    0x1(%eax),%edx
 48e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 491:	8b 55 f8             	mov    -0x8(%ebp),%edx
 494:	8d 4a 01             	lea    0x1(%edx),%ecx
 497:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 49a:	0f b6 12             	movzbl (%edx),%edx
 49d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 49f:	8b 45 10             	mov    0x10(%ebp),%eax
 4a2:	8d 50 ff             	lea    -0x1(%eax),%edx
 4a5:	89 55 10             	mov    %edx,0x10(%ebp)
 4a8:	85 c0                	test   %eax,%eax
 4aa:	7f dc                	jg     488 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4af:	c9                   	leave  
 4b0:	c3                   	ret    

000004b1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4b1:	b8 01 00 00 00       	mov    $0x1,%eax
 4b6:	cd 40                	int    $0x40
 4b8:	c3                   	ret    

000004b9 <exit>:
SYSCALL(exit)
 4b9:	b8 02 00 00 00       	mov    $0x2,%eax
 4be:	cd 40                	int    $0x40
 4c0:	c3                   	ret    

000004c1 <wait>:
SYSCALL(wait)
 4c1:	b8 03 00 00 00       	mov    $0x3,%eax
 4c6:	cd 40                	int    $0x40
 4c8:	c3                   	ret    

000004c9 <pipe>:
SYSCALL(pipe)
 4c9:	b8 04 00 00 00       	mov    $0x4,%eax
 4ce:	cd 40                	int    $0x40
 4d0:	c3                   	ret    

000004d1 <read>:
SYSCALL(read)
 4d1:	b8 05 00 00 00       	mov    $0x5,%eax
 4d6:	cd 40                	int    $0x40
 4d8:	c3                   	ret    

000004d9 <write>:
SYSCALL(write)
 4d9:	b8 10 00 00 00       	mov    $0x10,%eax
 4de:	cd 40                	int    $0x40
 4e0:	c3                   	ret    

000004e1 <close>:
SYSCALL(close)
 4e1:	b8 15 00 00 00       	mov    $0x15,%eax
 4e6:	cd 40                	int    $0x40
 4e8:	c3                   	ret    

000004e9 <kill>:
SYSCALL(kill)
 4e9:	b8 06 00 00 00       	mov    $0x6,%eax
 4ee:	cd 40                	int    $0x40
 4f0:	c3                   	ret    

000004f1 <exec>:
SYSCALL(exec)
 4f1:	b8 07 00 00 00       	mov    $0x7,%eax
 4f6:	cd 40                	int    $0x40
 4f8:	c3                   	ret    

000004f9 <open>:
SYSCALL(open)
 4f9:	b8 0f 00 00 00       	mov    $0xf,%eax
 4fe:	cd 40                	int    $0x40
 500:	c3                   	ret    

00000501 <mknod>:
SYSCALL(mknod)
 501:	b8 11 00 00 00       	mov    $0x11,%eax
 506:	cd 40                	int    $0x40
 508:	c3                   	ret    

00000509 <unlink>:
SYSCALL(unlink)
 509:	b8 12 00 00 00       	mov    $0x12,%eax
 50e:	cd 40                	int    $0x40
 510:	c3                   	ret    

00000511 <fstat>:
SYSCALL(fstat)
 511:	b8 08 00 00 00       	mov    $0x8,%eax
 516:	cd 40                	int    $0x40
 518:	c3                   	ret    

00000519 <link>:
SYSCALL(link)
 519:	b8 13 00 00 00       	mov    $0x13,%eax
 51e:	cd 40                	int    $0x40
 520:	c3                   	ret    

00000521 <mkdir>:
SYSCALL(mkdir)
 521:	b8 14 00 00 00       	mov    $0x14,%eax
 526:	cd 40                	int    $0x40
 528:	c3                   	ret    

00000529 <chdir>:
SYSCALL(chdir)
 529:	b8 09 00 00 00       	mov    $0x9,%eax
 52e:	cd 40                	int    $0x40
 530:	c3                   	ret    

00000531 <dup>:
SYSCALL(dup)
 531:	b8 0a 00 00 00       	mov    $0xa,%eax
 536:	cd 40                	int    $0x40
 538:	c3                   	ret    

00000539 <getpid>:
SYSCALL(getpid)
 539:	b8 0b 00 00 00       	mov    $0xb,%eax
 53e:	cd 40                	int    $0x40
 540:	c3                   	ret    

00000541 <sbrk>:
SYSCALL(sbrk)
 541:	b8 0c 00 00 00       	mov    $0xc,%eax
 546:	cd 40                	int    $0x40
 548:	c3                   	ret    

00000549 <sleep>:
SYSCALL(sleep)
 549:	b8 0d 00 00 00       	mov    $0xd,%eax
 54e:	cd 40                	int    $0x40
 550:	c3                   	ret    

00000551 <uptime>:
SYSCALL(uptime)
 551:	b8 0e 00 00 00       	mov    $0xe,%eax
 556:	cd 40                	int    $0x40
 558:	c3                   	ret    

00000559 <halt>:
SYSCALL(halt)
 559:	b8 16 00 00 00       	mov    $0x16,%eax
 55e:	cd 40                	int    $0x40
 560:	c3                   	ret    

00000561 <date>:
SYSCALL(date)
 561:	b8 17 00 00 00       	mov    $0x17,%eax
 566:	cd 40                	int    $0x40
 568:	c3                   	ret    

00000569 <getuid>:
SYSCALL(getuid)
 569:	b8 18 00 00 00       	mov    $0x18,%eax
 56e:	cd 40                	int    $0x40
 570:	c3                   	ret    

00000571 <getgid>:
SYSCALL(getgid)
 571:	b8 19 00 00 00       	mov    $0x19,%eax
 576:	cd 40                	int    $0x40
 578:	c3                   	ret    

00000579 <getppid>:
SYSCALL(getppid)
 579:	b8 1a 00 00 00       	mov    $0x1a,%eax
 57e:	cd 40                	int    $0x40
 580:	c3                   	ret    

00000581 <setuid>:
SYSCALL(setuid)
 581:	b8 1b 00 00 00       	mov    $0x1b,%eax
 586:	cd 40                	int    $0x40
 588:	c3                   	ret    

00000589 <setgid>:
SYSCALL(setgid)
 589:	b8 1c 00 00 00       	mov    $0x1c,%eax
 58e:	cd 40                	int    $0x40
 590:	c3                   	ret    

00000591 <getprocs>:
SYSCALL(getprocs)
 591:	b8 1d 00 00 00       	mov    $0x1d,%eax
 596:	cd 40                	int    $0x40
 598:	c3                   	ret    

00000599 <setpriority>:
SYSCALL(setpriority)
 599:	b8 1e 00 00 00       	mov    $0x1e,%eax
 59e:	cd 40                	int    $0x40
 5a0:	c3                   	ret    

000005a1 <chmod>:
SYSCALL(chmod)
 5a1:	b8 1f 00 00 00       	mov    $0x1f,%eax
 5a6:	cd 40                	int    $0x40
 5a8:	c3                   	ret    

000005a9 <chown>:
SYSCALL(chown)
 5a9:	b8 20 00 00 00       	mov    $0x20,%eax
 5ae:	cd 40                	int    $0x40
 5b0:	c3                   	ret    

000005b1 <chgrp>:
SYSCALL(chgrp)
 5b1:	b8 21 00 00 00       	mov    $0x21,%eax
 5b6:	cd 40                	int    $0x40
 5b8:	c3                   	ret    

000005b9 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5b9:	55                   	push   %ebp
 5ba:	89 e5                	mov    %esp,%ebp
 5bc:	83 ec 18             	sub    $0x18,%esp
 5bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c2:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5c5:	83 ec 04             	sub    $0x4,%esp
 5c8:	6a 01                	push   $0x1
 5ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5cd:	50                   	push   %eax
 5ce:	ff 75 08             	pushl  0x8(%ebp)
 5d1:	e8 03 ff ff ff       	call   4d9 <write>
 5d6:	83 c4 10             	add    $0x10,%esp
}
 5d9:	90                   	nop
 5da:	c9                   	leave  
 5db:	c3                   	ret    

000005dc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5dc:	55                   	push   %ebp
 5dd:	89 e5                	mov    %esp,%ebp
 5df:	53                   	push   %ebx
 5e0:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5ea:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5ee:	74 17                	je     607 <printint+0x2b>
 5f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5f4:	79 11                	jns    607 <printint+0x2b>
    neg = 1;
 5f6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 600:	f7 d8                	neg    %eax
 602:	89 45 ec             	mov    %eax,-0x14(%ebp)
 605:	eb 06                	jmp    60d <printint+0x31>
  } else {
    x = xx;
 607:	8b 45 0c             	mov    0xc(%ebp),%eax
 60a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 60d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 614:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 617:	8d 41 01             	lea    0x1(%ecx),%eax
 61a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 61d:	8b 5d 10             	mov    0x10(%ebp),%ebx
 620:	8b 45 ec             	mov    -0x14(%ebp),%eax
 623:	ba 00 00 00 00       	mov    $0x0,%edx
 628:	f7 f3                	div    %ebx
 62a:	89 d0                	mov    %edx,%eax
 62c:	0f b6 80 f0 0c 00 00 	movzbl 0xcf0(%eax),%eax
 633:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 637:	8b 5d 10             	mov    0x10(%ebp),%ebx
 63a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 63d:	ba 00 00 00 00       	mov    $0x0,%edx
 642:	f7 f3                	div    %ebx
 644:	89 45 ec             	mov    %eax,-0x14(%ebp)
 647:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 64b:	75 c7                	jne    614 <printint+0x38>
  if(neg)
 64d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 651:	74 2d                	je     680 <printint+0xa4>
    buf[i++] = '-';
 653:	8b 45 f4             	mov    -0xc(%ebp),%eax
 656:	8d 50 01             	lea    0x1(%eax),%edx
 659:	89 55 f4             	mov    %edx,-0xc(%ebp)
 65c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 661:	eb 1d                	jmp    680 <printint+0xa4>
    putc(fd, buf[i]);
 663:	8d 55 dc             	lea    -0x24(%ebp),%edx
 666:	8b 45 f4             	mov    -0xc(%ebp),%eax
 669:	01 d0                	add    %edx,%eax
 66b:	0f b6 00             	movzbl (%eax),%eax
 66e:	0f be c0             	movsbl %al,%eax
 671:	83 ec 08             	sub    $0x8,%esp
 674:	50                   	push   %eax
 675:	ff 75 08             	pushl  0x8(%ebp)
 678:	e8 3c ff ff ff       	call   5b9 <putc>
 67d:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 680:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 684:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 688:	79 d9                	jns    663 <printint+0x87>
    putc(fd, buf[i]);
}
 68a:	90                   	nop
 68b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 68e:	c9                   	leave  
 68f:	c3                   	ret    

00000690 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 696:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 69d:	8d 45 0c             	lea    0xc(%ebp),%eax
 6a0:	83 c0 04             	add    $0x4,%eax
 6a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6ad:	e9 59 01 00 00       	jmp    80b <printf+0x17b>
    c = fmt[i] & 0xff;
 6b2:	8b 55 0c             	mov    0xc(%ebp),%edx
 6b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6b8:	01 d0                	add    %edx,%eax
 6ba:	0f b6 00             	movzbl (%eax),%eax
 6bd:	0f be c0             	movsbl %al,%eax
 6c0:	25 ff 00 00 00       	and    $0xff,%eax
 6c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6c8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6cc:	75 2c                	jne    6fa <printf+0x6a>
      if(c == '%'){
 6ce:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6d2:	75 0c                	jne    6e0 <printf+0x50>
        state = '%';
 6d4:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6db:	e9 27 01 00 00       	jmp    807 <printf+0x177>
      } else {
        putc(fd, c);
 6e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6e3:	0f be c0             	movsbl %al,%eax
 6e6:	83 ec 08             	sub    $0x8,%esp
 6e9:	50                   	push   %eax
 6ea:	ff 75 08             	pushl  0x8(%ebp)
 6ed:	e8 c7 fe ff ff       	call   5b9 <putc>
 6f2:	83 c4 10             	add    $0x10,%esp
 6f5:	e9 0d 01 00 00       	jmp    807 <printf+0x177>
      }
    } else if(state == '%'){
 6fa:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6fe:	0f 85 03 01 00 00    	jne    807 <printf+0x177>
      if(c == 'd'){
 704:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 708:	75 1e                	jne    728 <printf+0x98>
        printint(fd, *ap, 10, 1);
 70a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 70d:	8b 00                	mov    (%eax),%eax
 70f:	6a 01                	push   $0x1
 711:	6a 0a                	push   $0xa
 713:	50                   	push   %eax
 714:	ff 75 08             	pushl  0x8(%ebp)
 717:	e8 c0 fe ff ff       	call   5dc <printint>
 71c:	83 c4 10             	add    $0x10,%esp
        ap++;
 71f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 723:	e9 d8 00 00 00       	jmp    800 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 728:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 72c:	74 06                	je     734 <printf+0xa4>
 72e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 732:	75 1e                	jne    752 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 734:	8b 45 e8             	mov    -0x18(%ebp),%eax
 737:	8b 00                	mov    (%eax),%eax
 739:	6a 00                	push   $0x0
 73b:	6a 10                	push   $0x10
 73d:	50                   	push   %eax
 73e:	ff 75 08             	pushl  0x8(%ebp)
 741:	e8 96 fe ff ff       	call   5dc <printint>
 746:	83 c4 10             	add    $0x10,%esp
        ap++;
 749:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 74d:	e9 ae 00 00 00       	jmp    800 <printf+0x170>
      } else if(c == 's'){
 752:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 756:	75 43                	jne    79b <printf+0x10b>
        s = (char*)*ap;
 758:	8b 45 e8             	mov    -0x18(%ebp),%eax
 75b:	8b 00                	mov    (%eax),%eax
 75d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 760:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 764:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 768:	75 25                	jne    78f <printf+0xff>
          s = "(null)";
 76a:	c7 45 f4 7c 0a 00 00 	movl   $0xa7c,-0xc(%ebp)
        while(*s != 0){
 771:	eb 1c                	jmp    78f <printf+0xff>
          putc(fd, *s);
 773:	8b 45 f4             	mov    -0xc(%ebp),%eax
 776:	0f b6 00             	movzbl (%eax),%eax
 779:	0f be c0             	movsbl %al,%eax
 77c:	83 ec 08             	sub    $0x8,%esp
 77f:	50                   	push   %eax
 780:	ff 75 08             	pushl  0x8(%ebp)
 783:	e8 31 fe ff ff       	call   5b9 <putc>
 788:	83 c4 10             	add    $0x10,%esp
          s++;
 78b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 78f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 792:	0f b6 00             	movzbl (%eax),%eax
 795:	84 c0                	test   %al,%al
 797:	75 da                	jne    773 <printf+0xe3>
 799:	eb 65                	jmp    800 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 79b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 79f:	75 1d                	jne    7be <printf+0x12e>
        putc(fd, *ap);
 7a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7a4:	8b 00                	mov    (%eax),%eax
 7a6:	0f be c0             	movsbl %al,%eax
 7a9:	83 ec 08             	sub    $0x8,%esp
 7ac:	50                   	push   %eax
 7ad:	ff 75 08             	pushl  0x8(%ebp)
 7b0:	e8 04 fe ff ff       	call   5b9 <putc>
 7b5:	83 c4 10             	add    $0x10,%esp
        ap++;
 7b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7bc:	eb 42                	jmp    800 <printf+0x170>
      } else if(c == '%'){
 7be:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7c2:	75 17                	jne    7db <printf+0x14b>
        putc(fd, c);
 7c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7c7:	0f be c0             	movsbl %al,%eax
 7ca:	83 ec 08             	sub    $0x8,%esp
 7cd:	50                   	push   %eax
 7ce:	ff 75 08             	pushl  0x8(%ebp)
 7d1:	e8 e3 fd ff ff       	call   5b9 <putc>
 7d6:	83 c4 10             	add    $0x10,%esp
 7d9:	eb 25                	jmp    800 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7db:	83 ec 08             	sub    $0x8,%esp
 7de:	6a 25                	push   $0x25
 7e0:	ff 75 08             	pushl  0x8(%ebp)
 7e3:	e8 d1 fd ff ff       	call   5b9 <putc>
 7e8:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 7eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7ee:	0f be c0             	movsbl %al,%eax
 7f1:	83 ec 08             	sub    $0x8,%esp
 7f4:	50                   	push   %eax
 7f5:	ff 75 08             	pushl  0x8(%ebp)
 7f8:	e8 bc fd ff ff       	call   5b9 <putc>
 7fd:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 800:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 807:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 80b:	8b 55 0c             	mov    0xc(%ebp),%edx
 80e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 811:	01 d0                	add    %edx,%eax
 813:	0f b6 00             	movzbl (%eax),%eax
 816:	84 c0                	test   %al,%al
 818:	0f 85 94 fe ff ff    	jne    6b2 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 81e:	90                   	nop
 81f:	c9                   	leave  
 820:	c3                   	ret    

00000821 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 821:	55                   	push   %ebp
 822:	89 e5                	mov    %esp,%ebp
 824:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 827:	8b 45 08             	mov    0x8(%ebp),%eax
 82a:	83 e8 08             	sub    $0x8,%eax
 82d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 830:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 835:	89 45 fc             	mov    %eax,-0x4(%ebp)
 838:	eb 24                	jmp    85e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83d:	8b 00                	mov    (%eax),%eax
 83f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 842:	77 12                	ja     856 <free+0x35>
 844:	8b 45 f8             	mov    -0x8(%ebp),%eax
 847:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 84a:	77 24                	ja     870 <free+0x4f>
 84c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84f:	8b 00                	mov    (%eax),%eax
 851:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 854:	77 1a                	ja     870 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 856:	8b 45 fc             	mov    -0x4(%ebp),%eax
 859:	8b 00                	mov    (%eax),%eax
 85b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 85e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 861:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 864:	76 d4                	jbe    83a <free+0x19>
 866:	8b 45 fc             	mov    -0x4(%ebp),%eax
 869:	8b 00                	mov    (%eax),%eax
 86b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 86e:	76 ca                	jbe    83a <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 870:	8b 45 f8             	mov    -0x8(%ebp),%eax
 873:	8b 40 04             	mov    0x4(%eax),%eax
 876:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 87d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 880:	01 c2                	add    %eax,%edx
 882:	8b 45 fc             	mov    -0x4(%ebp),%eax
 885:	8b 00                	mov    (%eax),%eax
 887:	39 c2                	cmp    %eax,%edx
 889:	75 24                	jne    8af <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 88b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88e:	8b 50 04             	mov    0x4(%eax),%edx
 891:	8b 45 fc             	mov    -0x4(%ebp),%eax
 894:	8b 00                	mov    (%eax),%eax
 896:	8b 40 04             	mov    0x4(%eax),%eax
 899:	01 c2                	add    %eax,%edx
 89b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a4:	8b 00                	mov    (%eax),%eax
 8a6:	8b 10                	mov    (%eax),%edx
 8a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ab:	89 10                	mov    %edx,(%eax)
 8ad:	eb 0a                	jmp    8b9 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b2:	8b 10                	mov    (%eax),%edx
 8b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b7:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bc:	8b 40 04             	mov    0x4(%eax),%eax
 8bf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c9:	01 d0                	add    %edx,%eax
 8cb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8ce:	75 20                	jne    8f0 <free+0xcf>
    p->s.size += bp->s.size;
 8d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d3:	8b 50 04             	mov    0x4(%eax),%edx
 8d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d9:	8b 40 04             	mov    0x4(%eax),%eax
 8dc:	01 c2                	add    %eax,%edx
 8de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e1:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e7:	8b 10                	mov    (%eax),%edx
 8e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ec:	89 10                	mov    %edx,(%eax)
 8ee:	eb 08                	jmp    8f8 <free+0xd7>
  } else
    p->s.ptr = bp;
 8f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8f6:	89 10                	mov    %edx,(%eax)
  freep = p;
 8f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fb:	a3 0c 0d 00 00       	mov    %eax,0xd0c
}
 900:	90                   	nop
 901:	c9                   	leave  
 902:	c3                   	ret    

00000903 <morecore>:

static Header*
morecore(uint nu)
{
 903:	55                   	push   %ebp
 904:	89 e5                	mov    %esp,%ebp
 906:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 909:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 910:	77 07                	ja     919 <morecore+0x16>
    nu = 4096;
 912:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 919:	8b 45 08             	mov    0x8(%ebp),%eax
 91c:	c1 e0 03             	shl    $0x3,%eax
 91f:	83 ec 0c             	sub    $0xc,%esp
 922:	50                   	push   %eax
 923:	e8 19 fc ff ff       	call   541 <sbrk>
 928:	83 c4 10             	add    $0x10,%esp
 92b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 92e:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 932:	75 07                	jne    93b <morecore+0x38>
    return 0;
 934:	b8 00 00 00 00       	mov    $0x0,%eax
 939:	eb 26                	jmp    961 <morecore+0x5e>
  hp = (Header*)p;
 93b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 941:	8b 45 f0             	mov    -0x10(%ebp),%eax
 944:	8b 55 08             	mov    0x8(%ebp),%edx
 947:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 94a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94d:	83 c0 08             	add    $0x8,%eax
 950:	83 ec 0c             	sub    $0xc,%esp
 953:	50                   	push   %eax
 954:	e8 c8 fe ff ff       	call   821 <free>
 959:	83 c4 10             	add    $0x10,%esp
  return freep;
 95c:	a1 0c 0d 00 00       	mov    0xd0c,%eax
}
 961:	c9                   	leave  
 962:	c3                   	ret    

00000963 <malloc>:

void*
malloc(uint nbytes)
{
 963:	55                   	push   %ebp
 964:	89 e5                	mov    %esp,%ebp
 966:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 969:	8b 45 08             	mov    0x8(%ebp),%eax
 96c:	83 c0 07             	add    $0x7,%eax
 96f:	c1 e8 03             	shr    $0x3,%eax
 972:	83 c0 01             	add    $0x1,%eax
 975:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 978:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 97d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 980:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 984:	75 23                	jne    9a9 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 986:	c7 45 f0 04 0d 00 00 	movl   $0xd04,-0x10(%ebp)
 98d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 990:	a3 0c 0d 00 00       	mov    %eax,0xd0c
 995:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 99a:	a3 04 0d 00 00       	mov    %eax,0xd04
    base.s.size = 0;
 99f:	c7 05 08 0d 00 00 00 	movl   $0x0,0xd08
 9a6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ac:	8b 00                	mov    (%eax),%eax
 9ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b4:	8b 40 04             	mov    0x4(%eax),%eax
 9b7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9ba:	72 4d                	jb     a09 <malloc+0xa6>
      if(p->s.size == nunits)
 9bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bf:	8b 40 04             	mov    0x4(%eax),%eax
 9c2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9c5:	75 0c                	jne    9d3 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ca:	8b 10                	mov    (%eax),%edx
 9cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9cf:	89 10                	mov    %edx,(%eax)
 9d1:	eb 26                	jmp    9f9 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d6:	8b 40 04             	mov    0x4(%eax),%eax
 9d9:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9dc:	89 c2                	mov    %eax,%edx
 9de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e7:	8b 40 04             	mov    0x4(%eax),%eax
 9ea:	c1 e0 03             	shl    $0x3,%eax
 9ed:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9f6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9fc:	a3 0c 0d 00 00       	mov    %eax,0xd0c
      return (void*)(p + 1);
 a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a04:	83 c0 08             	add    $0x8,%eax
 a07:	eb 3b                	jmp    a44 <malloc+0xe1>
    }
    if(p == freep)
 a09:	a1 0c 0d 00 00       	mov    0xd0c,%eax
 a0e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a11:	75 1e                	jne    a31 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a13:	83 ec 0c             	sub    $0xc,%esp
 a16:	ff 75 ec             	pushl  -0x14(%ebp)
 a19:	e8 e5 fe ff ff       	call   903 <morecore>
 a1e:	83 c4 10             	add    $0x10,%esp
 a21:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a28:	75 07                	jne    a31 <malloc+0xce>
        return 0;
 a2a:	b8 00 00 00 00       	mov    $0x0,%eax
 a2f:	eb 13                	jmp    a44 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a34:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3a:	8b 00                	mov    (%eax),%eax
 a3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a3f:	e9 6d ff ff ff       	jmp    9b1 <malloc+0x4e>
}
 a44:	c9                   	leave  
 a45:	c3                   	ret    
