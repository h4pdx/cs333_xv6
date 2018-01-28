
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "uproc.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 14             	sub    $0x14,%esp
  int max = 32, active_procs = 0;
  11:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
  18:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  struct uproc* utable;
  utable = (struct uproc*) malloc(max * sizeof(struct uproc));
  1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  22:	6b c0 5c             	imul   $0x5c,%eax,%eax
  25:	83 ec 0c             	sub    $0xc,%esp
  28:	50                   	push   %eax
  29:	e8 76 08 00 00       	call   8a4 <malloc>
  2e:	83 c4 10             	add    $0x10,%esp
  31:	89 45 e8             	mov    %eax,-0x18(%ebp)
  // system call -> sysproc.c -> proc.c -> return
  active_procs = getprocs(max, utable); // populate utable
  34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  37:	83 ec 08             	sub    $0x8,%esp
  3a:	ff 75 e8             	pushl  -0x18(%ebp)
  3d:	50                   	push   %eax
  3e:	e8 af 04 00 00       	call   4f2 <getprocs>
  43:	83 c4 10             	add    $0x10,%esp
  46:	89 45 ec             	mov    %eax,-0x14(%ebp)
  // error somewhere along the way
  if (active_procs == -1) {
  49:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
  4d:	75 25                	jne    74 <main+0x74>
      printf(1, "Error in active process table creation.\n");
  4f:	83 ec 08             	sub    $0x8,%esp
  52:	68 88 09 00 00       	push   $0x988
  57:	6a 01                	push   $0x1
  59:	e8 73 05 00 00       	call   5d1 <printf>
  5e:	83 c4 10             	add    $0x10,%esp
      free(utable);
  61:	83 ec 0c             	sub    $0xc,%esp
  64:	ff 75 e8             	pushl  -0x18(%ebp)
  67:	e8 f6 06 00 00       	call   762 <free>
  6c:	83 c4 10             	add    $0x10,%esp
      exit();
  6f:	e8 a6 03 00 00       	call   41a <exit>
  }
  // no active processes
  else if (active_procs == 0) {
  74:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  78:	75 25                	jne    9f <main+0x9f>
      printf(1, "No active processes.\n");
  7a:	83 ec 08             	sub    $0x8,%esp
  7d:	68 b1 09 00 00       	push   $0x9b1
  82:	6a 01                	push   $0x1
  84:	e8 48 05 00 00       	call   5d1 <printf>
  89:	83 c4 10             	add    $0x10,%esp
      free(utable);
  8c:	83 ec 0c             	sub    $0xc,%esp
  8f:	ff 75 e8             	pushl  -0x18(%ebp)
  92:	e8 cb 06 00 00       	call   762 <free>
  97:	83 c4 10             	add    $0x10,%esp
      exit();
  9a:	e8 7b 03 00 00       	call   41a <exit>
  }
  // loop utable and print process information
  else if (active_procs > 0) {
  9f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  a3:	7e 38                	jle    dd <main+0xdd>
      for (int i = 0; i < active_procs; i++) {
  a5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ac:	eb 27                	jmp    d5 <main+0xd5>
          printf(1, "%s: %s\n", "Process name", utable[i].name);
  ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  b1:	6b d0 5c             	imul   $0x5c,%eax,%edx
  b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  b7:	01 d0                	add    %edx,%eax
  b9:	83 c0 3c             	add    $0x3c,%eax
  bc:	50                   	push   %eax
  bd:	68 c7 09 00 00       	push   $0x9c7
  c2:	68 d4 09 00 00       	push   $0x9d4
  c7:	6a 01                	push   $0x1
  c9:	e8 03 05 00 00       	call   5d1 <printf>
  ce:	83 c4 10             	add    $0x10,%esp
      free(utable);
      exit();
  }
  // loop utable and print process information
  else if (active_procs > 0) {
      for (int i = 0; i < active_procs; i++) {
  d1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  db:	7c d1                	jl     ae <main+0xae>
          printf(1, "%s: %s\n", "Process name", utable[i].name);
      }
  }
  free(utable);
  dd:	83 ec 0c             	sub    $0xc,%esp
  e0:	ff 75 e8             	pushl  -0x18(%ebp)
  e3:	e8 7a 06 00 00       	call   762 <free>
  e8:	83 c4 10             	add    $0x10,%esp
  exit();
  eb:	e8 2a 03 00 00       	call   41a <exit>

000000f0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	57                   	push   %edi
  f4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  f8:	8b 55 10             	mov    0x10(%ebp),%edx
  fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  fe:	89 cb                	mov    %ecx,%ebx
 100:	89 df                	mov    %ebx,%edi
 102:	89 d1                	mov    %edx,%ecx
 104:	fc                   	cld    
 105:	f3 aa                	rep stos %al,%es:(%edi)
 107:	89 ca                	mov    %ecx,%edx
 109:	89 fb                	mov    %edi,%ebx
 10b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 10e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 111:	90                   	nop
 112:	5b                   	pop    %ebx
 113:	5f                   	pop    %edi
 114:	5d                   	pop    %ebp
 115:	c3                   	ret    

00000116 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 116:	55                   	push   %ebp
 117:	89 e5                	mov    %esp,%ebp
 119:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 11c:	8b 45 08             	mov    0x8(%ebp),%eax
 11f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 122:	90                   	nop
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	8d 50 01             	lea    0x1(%eax),%edx
 129:	89 55 08             	mov    %edx,0x8(%ebp)
 12c:	8b 55 0c             	mov    0xc(%ebp),%edx
 12f:	8d 4a 01             	lea    0x1(%edx),%ecx
 132:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 135:	0f b6 12             	movzbl (%edx),%edx
 138:	88 10                	mov    %dl,(%eax)
 13a:	0f b6 00             	movzbl (%eax),%eax
 13d:	84 c0                	test   %al,%al
 13f:	75 e2                	jne    123 <strcpy+0xd>
    ;
  return os;
 141:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 144:	c9                   	leave  
 145:	c3                   	ret    

00000146 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 146:	55                   	push   %ebp
 147:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 149:	eb 08                	jmp    153 <strcmp+0xd>
    p++, q++;
 14b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 14f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	0f b6 00             	movzbl (%eax),%eax
 159:	84 c0                	test   %al,%al
 15b:	74 10                	je     16d <strcmp+0x27>
 15d:	8b 45 08             	mov    0x8(%ebp),%eax
 160:	0f b6 10             	movzbl (%eax),%edx
 163:	8b 45 0c             	mov    0xc(%ebp),%eax
 166:	0f b6 00             	movzbl (%eax),%eax
 169:	38 c2                	cmp    %al,%dl
 16b:	74 de                	je     14b <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	0f b6 00             	movzbl (%eax),%eax
 173:	0f b6 d0             	movzbl %al,%edx
 176:	8b 45 0c             	mov    0xc(%ebp),%eax
 179:	0f b6 00             	movzbl (%eax),%eax
 17c:	0f b6 c0             	movzbl %al,%eax
 17f:	29 c2                	sub    %eax,%edx
 181:	89 d0                	mov    %edx,%eax
}
 183:	5d                   	pop    %ebp
 184:	c3                   	ret    

00000185 <strlen>:

uint
strlen(char *s)
{
 185:	55                   	push   %ebp
 186:	89 e5                	mov    %esp,%ebp
 188:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 18b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 192:	eb 04                	jmp    198 <strlen+0x13>
 194:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 198:	8b 55 fc             	mov    -0x4(%ebp),%edx
 19b:	8b 45 08             	mov    0x8(%ebp),%eax
 19e:	01 d0                	add    %edx,%eax
 1a0:	0f b6 00             	movzbl (%eax),%eax
 1a3:	84 c0                	test   %al,%al
 1a5:	75 ed                	jne    194 <strlen+0xf>
    ;
  return n;
 1a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1aa:	c9                   	leave  
 1ab:	c3                   	ret    

000001ac <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ac:	55                   	push   %ebp
 1ad:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1af:	8b 45 10             	mov    0x10(%ebp),%eax
 1b2:	50                   	push   %eax
 1b3:	ff 75 0c             	pushl  0xc(%ebp)
 1b6:	ff 75 08             	pushl  0x8(%ebp)
 1b9:	e8 32 ff ff ff       	call   f0 <stosb>
 1be:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1c1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1c4:	c9                   	leave  
 1c5:	c3                   	ret    

000001c6 <strchr>:

char*
strchr(const char *s, char c)
{
 1c6:	55                   	push   %ebp
 1c7:	89 e5                	mov    %esp,%ebp
 1c9:	83 ec 04             	sub    $0x4,%esp
 1cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cf:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1d2:	eb 14                	jmp    1e8 <strchr+0x22>
    if(*s == c)
 1d4:	8b 45 08             	mov    0x8(%ebp),%eax
 1d7:	0f b6 00             	movzbl (%eax),%eax
 1da:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1dd:	75 05                	jne    1e4 <strchr+0x1e>
      return (char*)s;
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	eb 13                	jmp    1f7 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1e4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1e8:	8b 45 08             	mov    0x8(%ebp),%eax
 1eb:	0f b6 00             	movzbl (%eax),%eax
 1ee:	84 c0                	test   %al,%al
 1f0:	75 e2                	jne    1d4 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1f7:	c9                   	leave  
 1f8:	c3                   	ret    

000001f9 <gets>:

char*
gets(char *buf, int max)
{
 1f9:	55                   	push   %ebp
 1fa:	89 e5                	mov    %esp,%ebp
 1fc:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 206:	eb 42                	jmp    24a <gets+0x51>
    cc = read(0, &c, 1);
 208:	83 ec 04             	sub    $0x4,%esp
 20b:	6a 01                	push   $0x1
 20d:	8d 45 ef             	lea    -0x11(%ebp),%eax
 210:	50                   	push   %eax
 211:	6a 00                	push   $0x0
 213:	e8 1a 02 00 00       	call   432 <read>
 218:	83 c4 10             	add    $0x10,%esp
 21b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 21e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 222:	7e 33                	jle    257 <gets+0x5e>
      break;
    buf[i++] = c;
 224:	8b 45 f4             	mov    -0xc(%ebp),%eax
 227:	8d 50 01             	lea    0x1(%eax),%edx
 22a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 22d:	89 c2                	mov    %eax,%edx
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	01 c2                	add    %eax,%edx
 234:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 238:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 23a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 23e:	3c 0a                	cmp    $0xa,%al
 240:	74 16                	je     258 <gets+0x5f>
 242:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 246:	3c 0d                	cmp    $0xd,%al
 248:	74 0e                	je     258 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 24a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24d:	83 c0 01             	add    $0x1,%eax
 250:	3b 45 0c             	cmp    0xc(%ebp),%eax
 253:	7c b3                	jl     208 <gets+0xf>
 255:	eb 01                	jmp    258 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 257:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 258:	8b 55 f4             	mov    -0xc(%ebp),%edx
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	01 d0                	add    %edx,%eax
 260:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 263:	8b 45 08             	mov    0x8(%ebp),%eax
}
 266:	c9                   	leave  
 267:	c3                   	ret    

00000268 <stat>:

int
stat(char *n, struct stat *st)
{
 268:	55                   	push   %ebp
 269:	89 e5                	mov    %esp,%ebp
 26b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 26e:	83 ec 08             	sub    $0x8,%esp
 271:	6a 00                	push   $0x0
 273:	ff 75 08             	pushl  0x8(%ebp)
 276:	e8 df 01 00 00       	call   45a <open>
 27b:	83 c4 10             	add    $0x10,%esp
 27e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 281:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 285:	79 07                	jns    28e <stat+0x26>
    return -1;
 287:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 28c:	eb 25                	jmp    2b3 <stat+0x4b>
  r = fstat(fd, st);
 28e:	83 ec 08             	sub    $0x8,%esp
 291:	ff 75 0c             	pushl  0xc(%ebp)
 294:	ff 75 f4             	pushl  -0xc(%ebp)
 297:	e8 d6 01 00 00       	call   472 <fstat>
 29c:	83 c4 10             	add    $0x10,%esp
 29f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2a2:	83 ec 0c             	sub    $0xc,%esp
 2a5:	ff 75 f4             	pushl  -0xc(%ebp)
 2a8:	e8 95 01 00 00       	call   442 <close>
 2ad:	83 c4 10             	add    $0x10,%esp
  return r;
 2b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2b3:	c9                   	leave  
 2b4:	c3                   	ret    

000002b5 <atoi>:

int
atoi(const char *s)
{
 2b5:	55                   	push   %ebp
 2b6:	89 e5                	mov    %esp,%ebp
 2b8:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2c2:	eb 04                	jmp    2c8 <atoi+0x13>
 2c4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2c8:	8b 45 08             	mov    0x8(%ebp),%eax
 2cb:	0f b6 00             	movzbl (%eax),%eax
 2ce:	3c 20                	cmp    $0x20,%al
 2d0:	74 f2                	je     2c4 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 2d2:	8b 45 08             	mov    0x8(%ebp),%eax
 2d5:	0f b6 00             	movzbl (%eax),%eax
 2d8:	3c 2d                	cmp    $0x2d,%al
 2da:	75 07                	jne    2e3 <atoi+0x2e>
 2dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2e1:	eb 05                	jmp    2e8 <atoi+0x33>
 2e3:	b8 01 00 00 00       	mov    $0x1,%eax
 2e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2eb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ee:	0f b6 00             	movzbl (%eax),%eax
 2f1:	3c 2b                	cmp    $0x2b,%al
 2f3:	74 0a                	je     2ff <atoi+0x4a>
 2f5:	8b 45 08             	mov    0x8(%ebp),%eax
 2f8:	0f b6 00             	movzbl (%eax),%eax
 2fb:	3c 2d                	cmp    $0x2d,%al
 2fd:	75 2b                	jne    32a <atoi+0x75>
    s++;
 2ff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 303:	eb 25                	jmp    32a <atoi+0x75>
    n = n*10 + *s++ - '0';
 305:	8b 55 fc             	mov    -0x4(%ebp),%edx
 308:	89 d0                	mov    %edx,%eax
 30a:	c1 e0 02             	shl    $0x2,%eax
 30d:	01 d0                	add    %edx,%eax
 30f:	01 c0                	add    %eax,%eax
 311:	89 c1                	mov    %eax,%ecx
 313:	8b 45 08             	mov    0x8(%ebp),%eax
 316:	8d 50 01             	lea    0x1(%eax),%edx
 319:	89 55 08             	mov    %edx,0x8(%ebp)
 31c:	0f b6 00             	movzbl (%eax),%eax
 31f:	0f be c0             	movsbl %al,%eax
 322:	01 c8                	add    %ecx,%eax
 324:	83 e8 30             	sub    $0x30,%eax
 327:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 32a:	8b 45 08             	mov    0x8(%ebp),%eax
 32d:	0f b6 00             	movzbl (%eax),%eax
 330:	3c 2f                	cmp    $0x2f,%al
 332:	7e 0a                	jle    33e <atoi+0x89>
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	0f b6 00             	movzbl (%eax),%eax
 33a:	3c 39                	cmp    $0x39,%al
 33c:	7e c7                	jle    305 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 33e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 341:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 345:	c9                   	leave  
 346:	c3                   	ret    

00000347 <atoo>:

int
atoo(const char *s)
{
 347:	55                   	push   %ebp
 348:	89 e5                	mov    %esp,%ebp
 34a:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 34d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 354:	eb 04                	jmp    35a <atoo+0x13>
 356:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 35a:	8b 45 08             	mov    0x8(%ebp),%eax
 35d:	0f b6 00             	movzbl (%eax),%eax
 360:	3c 20                	cmp    $0x20,%al
 362:	74 f2                	je     356 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 364:	8b 45 08             	mov    0x8(%ebp),%eax
 367:	0f b6 00             	movzbl (%eax),%eax
 36a:	3c 2d                	cmp    $0x2d,%al
 36c:	75 07                	jne    375 <atoo+0x2e>
 36e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 373:	eb 05                	jmp    37a <atoo+0x33>
 375:	b8 01 00 00 00       	mov    $0x1,%eax
 37a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 37d:	8b 45 08             	mov    0x8(%ebp),%eax
 380:	0f b6 00             	movzbl (%eax),%eax
 383:	3c 2b                	cmp    $0x2b,%al
 385:	74 0a                	je     391 <atoo+0x4a>
 387:	8b 45 08             	mov    0x8(%ebp),%eax
 38a:	0f b6 00             	movzbl (%eax),%eax
 38d:	3c 2d                	cmp    $0x2d,%al
 38f:	75 27                	jne    3b8 <atoo+0x71>
    s++;
 391:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 395:	eb 21                	jmp    3b8 <atoo+0x71>
    n = n*8 + *s++ - '0';
 397:	8b 45 fc             	mov    -0x4(%ebp),%eax
 39a:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 3a1:	8b 45 08             	mov    0x8(%ebp),%eax
 3a4:	8d 50 01             	lea    0x1(%eax),%edx
 3a7:	89 55 08             	mov    %edx,0x8(%ebp)
 3aa:	0f b6 00             	movzbl (%eax),%eax
 3ad:	0f be c0             	movsbl %al,%eax
 3b0:	01 c8                	add    %ecx,%eax
 3b2:	83 e8 30             	sub    $0x30,%eax
 3b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 3b8:	8b 45 08             	mov    0x8(%ebp),%eax
 3bb:	0f b6 00             	movzbl (%eax),%eax
 3be:	3c 2f                	cmp    $0x2f,%al
 3c0:	7e 0a                	jle    3cc <atoo+0x85>
 3c2:	8b 45 08             	mov    0x8(%ebp),%eax
 3c5:	0f b6 00             	movzbl (%eax),%eax
 3c8:	3c 37                	cmp    $0x37,%al
 3ca:	7e cb                	jle    397 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 3cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3cf:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3d3:	c9                   	leave  
 3d4:	c3                   	ret    

000003d5 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 3d5:	55                   	push   %ebp
 3d6:	89 e5                	mov    %esp,%ebp
 3d8:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 3db:	8b 45 08             	mov    0x8(%ebp),%eax
 3de:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3e7:	eb 17                	jmp    400 <memmove+0x2b>
    *dst++ = *src++;
 3e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ec:	8d 50 01             	lea    0x1(%eax),%edx
 3ef:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3f2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3f5:	8d 4a 01             	lea    0x1(%edx),%ecx
 3f8:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3fb:	0f b6 12             	movzbl (%edx),%edx
 3fe:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 400:	8b 45 10             	mov    0x10(%ebp),%eax
 403:	8d 50 ff             	lea    -0x1(%eax),%edx
 406:	89 55 10             	mov    %edx,0x10(%ebp)
 409:	85 c0                	test   %eax,%eax
 40b:	7f dc                	jg     3e9 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 40d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 410:	c9                   	leave  
 411:	c3                   	ret    

00000412 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 412:	b8 01 00 00 00       	mov    $0x1,%eax
 417:	cd 40                	int    $0x40
 419:	c3                   	ret    

0000041a <exit>:
SYSCALL(exit)
 41a:	b8 02 00 00 00       	mov    $0x2,%eax
 41f:	cd 40                	int    $0x40
 421:	c3                   	ret    

00000422 <wait>:
SYSCALL(wait)
 422:	b8 03 00 00 00       	mov    $0x3,%eax
 427:	cd 40                	int    $0x40
 429:	c3                   	ret    

0000042a <pipe>:
SYSCALL(pipe)
 42a:	b8 04 00 00 00       	mov    $0x4,%eax
 42f:	cd 40                	int    $0x40
 431:	c3                   	ret    

00000432 <read>:
SYSCALL(read)
 432:	b8 05 00 00 00       	mov    $0x5,%eax
 437:	cd 40                	int    $0x40
 439:	c3                   	ret    

0000043a <write>:
SYSCALL(write)
 43a:	b8 10 00 00 00       	mov    $0x10,%eax
 43f:	cd 40                	int    $0x40
 441:	c3                   	ret    

00000442 <close>:
SYSCALL(close)
 442:	b8 15 00 00 00       	mov    $0x15,%eax
 447:	cd 40                	int    $0x40
 449:	c3                   	ret    

0000044a <kill>:
SYSCALL(kill)
 44a:	b8 06 00 00 00       	mov    $0x6,%eax
 44f:	cd 40                	int    $0x40
 451:	c3                   	ret    

00000452 <exec>:
SYSCALL(exec)
 452:	b8 07 00 00 00       	mov    $0x7,%eax
 457:	cd 40                	int    $0x40
 459:	c3                   	ret    

0000045a <open>:
SYSCALL(open)
 45a:	b8 0f 00 00 00       	mov    $0xf,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <mknod>:
SYSCALL(mknod)
 462:	b8 11 00 00 00       	mov    $0x11,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <unlink>:
SYSCALL(unlink)
 46a:	b8 12 00 00 00       	mov    $0x12,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <fstat>:
SYSCALL(fstat)
 472:	b8 08 00 00 00       	mov    $0x8,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <link>:
SYSCALL(link)
 47a:	b8 13 00 00 00       	mov    $0x13,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <mkdir>:
SYSCALL(mkdir)
 482:	b8 14 00 00 00       	mov    $0x14,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <chdir>:
SYSCALL(chdir)
 48a:	b8 09 00 00 00       	mov    $0x9,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <dup>:
SYSCALL(dup)
 492:	b8 0a 00 00 00       	mov    $0xa,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <getpid>:
SYSCALL(getpid)
 49a:	b8 0b 00 00 00       	mov    $0xb,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <sbrk>:
SYSCALL(sbrk)
 4a2:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <sleep>:
SYSCALL(sleep)
 4aa:	b8 0d 00 00 00       	mov    $0xd,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <uptime>:
SYSCALL(uptime)
 4b2:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <halt>:
SYSCALL(halt)
 4ba:	b8 16 00 00 00       	mov    $0x16,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <date>:
SYSCALL(date)
 4c2:	b8 17 00 00 00       	mov    $0x17,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <getuid>:
SYSCALL(getuid)
 4ca:	b8 18 00 00 00       	mov    $0x18,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <getgid>:
SYSCALL(getgid)
 4d2:	b8 19 00 00 00       	mov    $0x19,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <getppid>:
SYSCALL(getppid)
 4da:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <setuid>:
SYSCALL(setuid)
 4e2:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <setgid>:
SYSCALL(setgid)
 4ea:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <getprocs>:
SYSCALL(getprocs)
 4f2:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4fa:	55                   	push   %ebp
 4fb:	89 e5                	mov    %esp,%ebp
 4fd:	83 ec 18             	sub    $0x18,%esp
 500:	8b 45 0c             	mov    0xc(%ebp),%eax
 503:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 506:	83 ec 04             	sub    $0x4,%esp
 509:	6a 01                	push   $0x1
 50b:	8d 45 f4             	lea    -0xc(%ebp),%eax
 50e:	50                   	push   %eax
 50f:	ff 75 08             	pushl  0x8(%ebp)
 512:	e8 23 ff ff ff       	call   43a <write>
 517:	83 c4 10             	add    $0x10,%esp
}
 51a:	90                   	nop
 51b:	c9                   	leave  
 51c:	c3                   	ret    

0000051d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 51d:	55                   	push   %ebp
 51e:	89 e5                	mov    %esp,%ebp
 520:	53                   	push   %ebx
 521:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 524:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 52b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 52f:	74 17                	je     548 <printint+0x2b>
 531:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 535:	79 11                	jns    548 <printint+0x2b>
    neg = 1;
 537:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 53e:	8b 45 0c             	mov    0xc(%ebp),%eax
 541:	f7 d8                	neg    %eax
 543:	89 45 ec             	mov    %eax,-0x14(%ebp)
 546:	eb 06                	jmp    54e <printint+0x31>
  } else {
    x = xx;
 548:	8b 45 0c             	mov    0xc(%ebp),%eax
 54b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 54e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 555:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 558:	8d 41 01             	lea    0x1(%ecx),%eax
 55b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 55e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 561:	8b 45 ec             	mov    -0x14(%ebp),%eax
 564:	ba 00 00 00 00       	mov    $0x0,%edx
 569:	f7 f3                	div    %ebx
 56b:	89 d0                	mov    %edx,%eax
 56d:	0f b6 80 4c 0c 00 00 	movzbl 0xc4c(%eax),%eax
 574:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 578:	8b 5d 10             	mov    0x10(%ebp),%ebx
 57b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 57e:	ba 00 00 00 00       	mov    $0x0,%edx
 583:	f7 f3                	div    %ebx
 585:	89 45 ec             	mov    %eax,-0x14(%ebp)
 588:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 58c:	75 c7                	jne    555 <printint+0x38>
  if(neg)
 58e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 592:	74 2d                	je     5c1 <printint+0xa4>
    buf[i++] = '-';
 594:	8b 45 f4             	mov    -0xc(%ebp),%eax
 597:	8d 50 01             	lea    0x1(%eax),%edx
 59a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 59d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5a2:	eb 1d                	jmp    5c1 <printint+0xa4>
    putc(fd, buf[i]);
 5a4:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5aa:	01 d0                	add    %edx,%eax
 5ac:	0f b6 00             	movzbl (%eax),%eax
 5af:	0f be c0             	movsbl %al,%eax
 5b2:	83 ec 08             	sub    $0x8,%esp
 5b5:	50                   	push   %eax
 5b6:	ff 75 08             	pushl  0x8(%ebp)
 5b9:	e8 3c ff ff ff       	call   4fa <putc>
 5be:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 5c1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 5c5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5c9:	79 d9                	jns    5a4 <printint+0x87>
    putc(fd, buf[i]);
}
 5cb:	90                   	nop
 5cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5cf:	c9                   	leave  
 5d0:	c3                   	ret    

000005d1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5d1:	55                   	push   %ebp
 5d2:	89 e5                	mov    %esp,%ebp
 5d4:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5de:	8d 45 0c             	lea    0xc(%ebp),%eax
 5e1:	83 c0 04             	add    $0x4,%eax
 5e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5ee:	e9 59 01 00 00       	jmp    74c <printf+0x17b>
    c = fmt[i] & 0xff;
 5f3:	8b 55 0c             	mov    0xc(%ebp),%edx
 5f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5f9:	01 d0                	add    %edx,%eax
 5fb:	0f b6 00             	movzbl (%eax),%eax
 5fe:	0f be c0             	movsbl %al,%eax
 601:	25 ff 00 00 00       	and    $0xff,%eax
 606:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 609:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 60d:	75 2c                	jne    63b <printf+0x6a>
      if(c == '%'){
 60f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 613:	75 0c                	jne    621 <printf+0x50>
        state = '%';
 615:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 61c:	e9 27 01 00 00       	jmp    748 <printf+0x177>
      } else {
        putc(fd, c);
 621:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 624:	0f be c0             	movsbl %al,%eax
 627:	83 ec 08             	sub    $0x8,%esp
 62a:	50                   	push   %eax
 62b:	ff 75 08             	pushl  0x8(%ebp)
 62e:	e8 c7 fe ff ff       	call   4fa <putc>
 633:	83 c4 10             	add    $0x10,%esp
 636:	e9 0d 01 00 00       	jmp    748 <printf+0x177>
      }
    } else if(state == '%'){
 63b:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 63f:	0f 85 03 01 00 00    	jne    748 <printf+0x177>
      if(c == 'd'){
 645:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 649:	75 1e                	jne    669 <printf+0x98>
        printint(fd, *ap, 10, 1);
 64b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 64e:	8b 00                	mov    (%eax),%eax
 650:	6a 01                	push   $0x1
 652:	6a 0a                	push   $0xa
 654:	50                   	push   %eax
 655:	ff 75 08             	pushl  0x8(%ebp)
 658:	e8 c0 fe ff ff       	call   51d <printint>
 65d:	83 c4 10             	add    $0x10,%esp
        ap++;
 660:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 664:	e9 d8 00 00 00       	jmp    741 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 669:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 66d:	74 06                	je     675 <printf+0xa4>
 66f:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 673:	75 1e                	jne    693 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 675:	8b 45 e8             	mov    -0x18(%ebp),%eax
 678:	8b 00                	mov    (%eax),%eax
 67a:	6a 00                	push   $0x0
 67c:	6a 10                	push   $0x10
 67e:	50                   	push   %eax
 67f:	ff 75 08             	pushl  0x8(%ebp)
 682:	e8 96 fe ff ff       	call   51d <printint>
 687:	83 c4 10             	add    $0x10,%esp
        ap++;
 68a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 68e:	e9 ae 00 00 00       	jmp    741 <printf+0x170>
      } else if(c == 's'){
 693:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 697:	75 43                	jne    6dc <printf+0x10b>
        s = (char*)*ap;
 699:	8b 45 e8             	mov    -0x18(%ebp),%eax
 69c:	8b 00                	mov    (%eax),%eax
 69e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6a1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6a9:	75 25                	jne    6d0 <printf+0xff>
          s = "(null)";
 6ab:	c7 45 f4 dc 09 00 00 	movl   $0x9dc,-0xc(%ebp)
        while(*s != 0){
 6b2:	eb 1c                	jmp    6d0 <printf+0xff>
          putc(fd, *s);
 6b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b7:	0f b6 00             	movzbl (%eax),%eax
 6ba:	0f be c0             	movsbl %al,%eax
 6bd:	83 ec 08             	sub    $0x8,%esp
 6c0:	50                   	push   %eax
 6c1:	ff 75 08             	pushl  0x8(%ebp)
 6c4:	e8 31 fe ff ff       	call   4fa <putc>
 6c9:	83 c4 10             	add    $0x10,%esp
          s++;
 6cc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d3:	0f b6 00             	movzbl (%eax),%eax
 6d6:	84 c0                	test   %al,%al
 6d8:	75 da                	jne    6b4 <printf+0xe3>
 6da:	eb 65                	jmp    741 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6dc:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6e0:	75 1d                	jne    6ff <printf+0x12e>
        putc(fd, *ap);
 6e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e5:	8b 00                	mov    (%eax),%eax
 6e7:	0f be c0             	movsbl %al,%eax
 6ea:	83 ec 08             	sub    $0x8,%esp
 6ed:	50                   	push   %eax
 6ee:	ff 75 08             	pushl  0x8(%ebp)
 6f1:	e8 04 fe ff ff       	call   4fa <putc>
 6f6:	83 c4 10             	add    $0x10,%esp
        ap++;
 6f9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6fd:	eb 42                	jmp    741 <printf+0x170>
      } else if(c == '%'){
 6ff:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 703:	75 17                	jne    71c <printf+0x14b>
        putc(fd, c);
 705:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 708:	0f be c0             	movsbl %al,%eax
 70b:	83 ec 08             	sub    $0x8,%esp
 70e:	50                   	push   %eax
 70f:	ff 75 08             	pushl  0x8(%ebp)
 712:	e8 e3 fd ff ff       	call   4fa <putc>
 717:	83 c4 10             	add    $0x10,%esp
 71a:	eb 25                	jmp    741 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 71c:	83 ec 08             	sub    $0x8,%esp
 71f:	6a 25                	push   $0x25
 721:	ff 75 08             	pushl  0x8(%ebp)
 724:	e8 d1 fd ff ff       	call   4fa <putc>
 729:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 72c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 72f:	0f be c0             	movsbl %al,%eax
 732:	83 ec 08             	sub    $0x8,%esp
 735:	50                   	push   %eax
 736:	ff 75 08             	pushl  0x8(%ebp)
 739:	e8 bc fd ff ff       	call   4fa <putc>
 73e:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 741:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 748:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 74c:	8b 55 0c             	mov    0xc(%ebp),%edx
 74f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 752:	01 d0                	add    %edx,%eax
 754:	0f b6 00             	movzbl (%eax),%eax
 757:	84 c0                	test   %al,%al
 759:	0f 85 94 fe ff ff    	jne    5f3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 75f:	90                   	nop
 760:	c9                   	leave  
 761:	c3                   	ret    

00000762 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 762:	55                   	push   %ebp
 763:	89 e5                	mov    %esp,%ebp
 765:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 768:	8b 45 08             	mov    0x8(%ebp),%eax
 76b:	83 e8 08             	sub    $0x8,%eax
 76e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 771:	a1 68 0c 00 00       	mov    0xc68,%eax
 776:	89 45 fc             	mov    %eax,-0x4(%ebp)
 779:	eb 24                	jmp    79f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 77b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77e:	8b 00                	mov    (%eax),%eax
 780:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 783:	77 12                	ja     797 <free+0x35>
 785:	8b 45 f8             	mov    -0x8(%ebp),%eax
 788:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 78b:	77 24                	ja     7b1 <free+0x4f>
 78d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 790:	8b 00                	mov    (%eax),%eax
 792:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 795:	77 1a                	ja     7b1 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 797:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79a:	8b 00                	mov    (%eax),%eax
 79c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 79f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7a5:	76 d4                	jbe    77b <free+0x19>
 7a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7aa:	8b 00                	mov    (%eax),%eax
 7ac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7af:	76 ca                	jbe    77b <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 7b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b4:	8b 40 04             	mov    0x4(%eax),%eax
 7b7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c1:	01 c2                	add    %eax,%edx
 7c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c6:	8b 00                	mov    (%eax),%eax
 7c8:	39 c2                	cmp    %eax,%edx
 7ca:	75 24                	jne    7f0 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7cf:	8b 50 04             	mov    0x4(%eax),%edx
 7d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d5:	8b 00                	mov    (%eax),%eax
 7d7:	8b 40 04             	mov    0x4(%eax),%eax
 7da:	01 c2                	add    %eax,%edx
 7dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7df:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e5:	8b 00                	mov    (%eax),%eax
 7e7:	8b 10                	mov    (%eax),%edx
 7e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ec:	89 10                	mov    %edx,(%eax)
 7ee:	eb 0a                	jmp    7fa <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f3:	8b 10                	mov    (%eax),%edx
 7f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f8:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fd:	8b 40 04             	mov    0x4(%eax),%eax
 800:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 807:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80a:	01 d0                	add    %edx,%eax
 80c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 80f:	75 20                	jne    831 <free+0xcf>
    p->s.size += bp->s.size;
 811:	8b 45 fc             	mov    -0x4(%ebp),%eax
 814:	8b 50 04             	mov    0x4(%eax),%edx
 817:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81a:	8b 40 04             	mov    0x4(%eax),%eax
 81d:	01 c2                	add    %eax,%edx
 81f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 822:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 825:	8b 45 f8             	mov    -0x8(%ebp),%eax
 828:	8b 10                	mov    (%eax),%edx
 82a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82d:	89 10                	mov    %edx,(%eax)
 82f:	eb 08                	jmp    839 <free+0xd7>
  } else
    p->s.ptr = bp;
 831:	8b 45 fc             	mov    -0x4(%ebp),%eax
 834:	8b 55 f8             	mov    -0x8(%ebp),%edx
 837:	89 10                	mov    %edx,(%eax)
  freep = p;
 839:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83c:	a3 68 0c 00 00       	mov    %eax,0xc68
}
 841:	90                   	nop
 842:	c9                   	leave  
 843:	c3                   	ret    

00000844 <morecore>:

static Header*
morecore(uint nu)
{
 844:	55                   	push   %ebp
 845:	89 e5                	mov    %esp,%ebp
 847:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 84a:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 851:	77 07                	ja     85a <morecore+0x16>
    nu = 4096;
 853:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 85a:	8b 45 08             	mov    0x8(%ebp),%eax
 85d:	c1 e0 03             	shl    $0x3,%eax
 860:	83 ec 0c             	sub    $0xc,%esp
 863:	50                   	push   %eax
 864:	e8 39 fc ff ff       	call   4a2 <sbrk>
 869:	83 c4 10             	add    $0x10,%esp
 86c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 86f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 873:	75 07                	jne    87c <morecore+0x38>
    return 0;
 875:	b8 00 00 00 00       	mov    $0x0,%eax
 87a:	eb 26                	jmp    8a2 <morecore+0x5e>
  hp = (Header*)p;
 87c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 882:	8b 45 f0             	mov    -0x10(%ebp),%eax
 885:	8b 55 08             	mov    0x8(%ebp),%edx
 888:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 88b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 88e:	83 c0 08             	add    $0x8,%eax
 891:	83 ec 0c             	sub    $0xc,%esp
 894:	50                   	push   %eax
 895:	e8 c8 fe ff ff       	call   762 <free>
 89a:	83 c4 10             	add    $0x10,%esp
  return freep;
 89d:	a1 68 0c 00 00       	mov    0xc68,%eax
}
 8a2:	c9                   	leave  
 8a3:	c3                   	ret    

000008a4 <malloc>:

void*
malloc(uint nbytes)
{
 8a4:	55                   	push   %ebp
 8a5:	89 e5                	mov    %esp,%ebp
 8a7:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8aa:	8b 45 08             	mov    0x8(%ebp),%eax
 8ad:	83 c0 07             	add    $0x7,%eax
 8b0:	c1 e8 03             	shr    $0x3,%eax
 8b3:	83 c0 01             	add    $0x1,%eax
 8b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8b9:	a1 68 0c 00 00       	mov    0xc68,%eax
 8be:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8c5:	75 23                	jne    8ea <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8c7:	c7 45 f0 60 0c 00 00 	movl   $0xc60,-0x10(%ebp)
 8ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d1:	a3 68 0c 00 00       	mov    %eax,0xc68
 8d6:	a1 68 0c 00 00       	mov    0xc68,%eax
 8db:	a3 60 0c 00 00       	mov    %eax,0xc60
    base.s.size = 0;
 8e0:	c7 05 64 0c 00 00 00 	movl   $0x0,0xc64
 8e7:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ed:	8b 00                	mov    (%eax),%eax
 8ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f5:	8b 40 04             	mov    0x4(%eax),%eax
 8f8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8fb:	72 4d                	jb     94a <malloc+0xa6>
      if(p->s.size == nunits)
 8fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 900:	8b 40 04             	mov    0x4(%eax),%eax
 903:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 906:	75 0c                	jne    914 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 908:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90b:	8b 10                	mov    (%eax),%edx
 90d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 910:	89 10                	mov    %edx,(%eax)
 912:	eb 26                	jmp    93a <malloc+0x96>
      else {
        p->s.size -= nunits;
 914:	8b 45 f4             	mov    -0xc(%ebp),%eax
 917:	8b 40 04             	mov    0x4(%eax),%eax
 91a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 91d:	89 c2                	mov    %eax,%edx
 91f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 922:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 925:	8b 45 f4             	mov    -0xc(%ebp),%eax
 928:	8b 40 04             	mov    0x4(%eax),%eax
 92b:	c1 e0 03             	shl    $0x3,%eax
 92e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 931:	8b 45 f4             	mov    -0xc(%ebp),%eax
 934:	8b 55 ec             	mov    -0x14(%ebp),%edx
 937:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 93a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 93d:	a3 68 0c 00 00       	mov    %eax,0xc68
      return (void*)(p + 1);
 942:	8b 45 f4             	mov    -0xc(%ebp),%eax
 945:	83 c0 08             	add    $0x8,%eax
 948:	eb 3b                	jmp    985 <malloc+0xe1>
    }
    if(p == freep)
 94a:	a1 68 0c 00 00       	mov    0xc68,%eax
 94f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 952:	75 1e                	jne    972 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 954:	83 ec 0c             	sub    $0xc,%esp
 957:	ff 75 ec             	pushl  -0x14(%ebp)
 95a:	e8 e5 fe ff ff       	call   844 <morecore>
 95f:	83 c4 10             	add    $0x10,%esp
 962:	89 45 f4             	mov    %eax,-0xc(%ebp)
 965:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 969:	75 07                	jne    972 <malloc+0xce>
        return 0;
 96b:	b8 00 00 00 00       	mov    $0x0,%eax
 970:	eb 13                	jmp    985 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 972:	8b 45 f4             	mov    -0xc(%ebp),%eax
 975:	89 45 f0             	mov    %eax,-0x10(%ebp)
 978:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97b:	8b 00                	mov    (%eax),%eax
 97d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 980:	e9 6d ff ff ff       	jmp    8f2 <malloc+0x4e>
}
 985:	c9                   	leave  
 986:	c3                   	ret    
