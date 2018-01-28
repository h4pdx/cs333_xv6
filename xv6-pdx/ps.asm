
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "uproc.h"

int
main(int argc, char* argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 24             	sub    $0x24,%esp
  11:	89 c8                	mov    %ecx,%eax
  int utablesize = 0;
  13:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int max = 32;
  1a:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
  int active_uprocs = 0;
  21:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  struct uproc* utable;

  if (argc < 0) {
  28:	83 38 00             	cmpl   $0x0,(%eax)
  2b:	79 17                	jns    44 <main+0x44>
      printf(2, "Invalid input.\n");
  2d:	83 ec 08             	sub    $0x8,%esp
  30:	68 10 0a 00 00       	push   $0xa10
  35:	6a 02                	push   $0x2
  37:	e8 1b 06 00 00       	call   657 <printf>
  3c:	83 c4 10             	add    $0x10,%esp
      exit();
  3f:	e8 5c 04 00 00       	call   4a0 <exit>
  }
  if (argc > 1) {
  44:	83 38 01             	cmpl   $0x1,(%eax)
  47:	7e 17                	jle    60 <main+0x60>
      max = atoi(argv[1]);
  49:	8b 40 04             	mov    0x4(%eax),%eax
  4c:	83 c0 04             	add    $0x4,%eax
  4f:	8b 00                	mov    (%eax),%eax
  51:	83 ec 0c             	sub    $0xc,%esp
  54:	50                   	push   %eax
  55:	e8 e1 02 00 00       	call   33b <atoi>
  5a:	83 c4 10             	add    $0x10,%esp
  5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  
  utable = (struct uproc*) malloc(max * sizeof(struct uproc));
  60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  63:	6b c0 5c             	imul   $0x5c,%eax,%eax
  66:	83 ec 0c             	sub    $0xc,%esp
  69:	50                   	push   %eax
  6a:	e8 bb 08 00 00       	call   92a <malloc>
  6f:	83 c4 10             	add    $0x10,%esp
  72:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  utablesize = sizeof(utable);
  75:	c7 45 ec 04 00 00 00 	movl   $0x4,-0x14(%ebp)
  printf(1, "Size of utable: %d\n", utablesize); // output at runtime says 4, is this ok?
  7c:	83 ec 04             	sub    $0x4,%esp
  7f:	ff 75 ec             	pushl  -0x14(%ebp)
  82:	68 20 0a 00 00       	push   $0xa20
  87:	6a 01                	push   $0x1
  89:	e8 c9 05 00 00       	call   657 <printf>
  8e:	83 c4 10             	add    $0x10,%esp
  printf(1, "utable allocated.\n");  
  91:	83 ec 08             	sub    $0x8,%esp
  94:	68 34 0a 00 00       	push   $0xa34
  99:	6a 01                	push   $0x1
  9b:	e8 b7 05 00 00       	call   657 <printf>
  a0:	83 c4 10             	add    $0x10,%esp
  active_uprocs = getprocs(max, utable);
  a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  a6:	83 ec 08             	sub    $0x8,%esp
  a9:	ff 75 e4             	pushl  -0x1c(%ebp)
  ac:	50                   	push   %eax
  ad:	e8 c6 04 00 00       	call   578 <getprocs>
  b2:	83 c4 10             	add    $0x10,%esp
  b5:	89 45 e8             	mov    %eax,-0x18(%ebp)

  printf(1, "%s = %d\n", " >> ps.c - active_uprocs", active_uprocs);
  b8:	ff 75 e8             	pushl  -0x18(%ebp)
  bb:	68 47 0a 00 00       	push   $0xa47
  c0:	68 60 0a 00 00       	push   $0xa60
  c5:	6a 01                	push   $0x1
  c7:	e8 8b 05 00 00       	call   657 <printf>
  cc:	83 c4 10             	add    $0x10,%esp
  if (active_uprocs == -1) {
  cf:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
  d3:	75 25                	jne    fa <main+0xfa>
      printf(1, "Error in active process table creation.\n");
  d5:	83 ec 08             	sub    $0x8,%esp
  d8:	68 6c 0a 00 00       	push   $0xa6c
  dd:	6a 01                	push   $0x1
  df:	e8 73 05 00 00       	call   657 <printf>
  e4:	83 c4 10             	add    $0x10,%esp
      free(utable);
  e7:	83 ec 0c             	sub    $0xc,%esp
  ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  ed:	e8 f6 06 00 00       	call   7e8 <free>
  f2:	83 c4 10             	add    $0x10,%esp
      exit();
  f5:	e8 a6 03 00 00       	call   4a0 <exit>
  }
  else if (active_uprocs == 0) {
  fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  fe:	75 25                	jne    125 <main+0x125>
      printf(1, "No active processes.\n");
 100:	83 ec 08             	sub    $0x8,%esp
 103:	68 95 0a 00 00       	push   $0xa95
 108:	6a 01                	push   $0x1
 10a:	e8 48 05 00 00       	call   657 <printf>
 10f:	83 c4 10             	add    $0x10,%esp
      free(utable);
 112:	83 ec 0c             	sub    $0xc,%esp
 115:	ff 75 e4             	pushl  -0x1c(%ebp)
 118:	e8 cb 06 00 00       	call   7e8 <free>
 11d:	83 c4 10             	add    $0x10,%esp
      exit();
 120:	e8 7b 03 00 00       	call   4a0 <exit>
  } 
  else if (active_uprocs > 0) {
 125:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 129:	7e 38                	jle    163 <main+0x163>
      for (int i = 0; i < active_uprocs; i++) {
 12b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 132:	eb 27                	jmp    15b <main+0x15b>
          printf(1, "%s: %s\n", "Process name", utable[i].name);
 134:	8b 45 f0             	mov    -0x10(%ebp),%eax
 137:	6b d0 5c             	imul   $0x5c,%eax,%edx
 13a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 13d:	01 d0                	add    %edx,%eax
 13f:	83 c0 3c             	add    $0x3c,%eax
 142:	50                   	push   %eax
 143:	68 ab 0a 00 00       	push   $0xaab
 148:	68 b8 0a 00 00       	push   $0xab8
 14d:	6a 01                	push   $0x1
 14f:	e8 03 05 00 00       	call   657 <printf>
 154:	83 c4 10             	add    $0x10,%esp
      printf(1, "No active processes.\n");
      free(utable);
      exit();
  } 
  else if (active_uprocs > 0) {
      for (int i = 0; i < active_uprocs; i++) {
 157:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 15b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 15e:	3b 45 e8             	cmp    -0x18(%ebp),%eax
 161:	7c d1                	jl     134 <main+0x134>
          printf(1, "%s: %s\n", "Process name", utable[i].name);
          //printf(1, "%s: %d\n","Uproc number", i);
      }
  }
  free(utable);
 163:	83 ec 0c             	sub    $0xc,%esp
 166:	ff 75 e4             	pushl  -0x1c(%ebp)
 169:	e8 7a 06 00 00       	call   7e8 <free>
 16e:	83 c4 10             	add    $0x10,%esp
  exit();
 171:	e8 2a 03 00 00       	call   4a0 <exit>

00000176 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 176:	55                   	push   %ebp
 177:	89 e5                	mov    %esp,%ebp
 179:	57                   	push   %edi
 17a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 17b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 17e:	8b 55 10             	mov    0x10(%ebp),%edx
 181:	8b 45 0c             	mov    0xc(%ebp),%eax
 184:	89 cb                	mov    %ecx,%ebx
 186:	89 df                	mov    %ebx,%edi
 188:	89 d1                	mov    %edx,%ecx
 18a:	fc                   	cld    
 18b:	f3 aa                	rep stos %al,%es:(%edi)
 18d:	89 ca                	mov    %ecx,%edx
 18f:	89 fb                	mov    %edi,%ebx
 191:	89 5d 08             	mov    %ebx,0x8(%ebp)
 194:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 197:	90                   	nop
 198:	5b                   	pop    %ebx
 199:	5f                   	pop    %edi
 19a:	5d                   	pop    %ebp
 19b:	c3                   	ret    

0000019c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 19c:	55                   	push   %ebp
 19d:	89 e5                	mov    %esp,%ebp
 19f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1a2:	8b 45 08             	mov    0x8(%ebp),%eax
 1a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1a8:	90                   	nop
 1a9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ac:	8d 50 01             	lea    0x1(%eax),%edx
 1af:	89 55 08             	mov    %edx,0x8(%ebp)
 1b2:	8b 55 0c             	mov    0xc(%ebp),%edx
 1b5:	8d 4a 01             	lea    0x1(%edx),%ecx
 1b8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1bb:	0f b6 12             	movzbl (%edx),%edx
 1be:	88 10                	mov    %dl,(%eax)
 1c0:	0f b6 00             	movzbl (%eax),%eax
 1c3:	84 c0                	test   %al,%al
 1c5:	75 e2                	jne    1a9 <strcpy+0xd>
    ;
  return os;
 1c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ca:	c9                   	leave  
 1cb:	c3                   	ret    

000001cc <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1cc:	55                   	push   %ebp
 1cd:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1cf:	eb 08                	jmp    1d9 <strcmp+0xd>
    p++, q++;
 1d1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1d5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1d9:	8b 45 08             	mov    0x8(%ebp),%eax
 1dc:	0f b6 00             	movzbl (%eax),%eax
 1df:	84 c0                	test   %al,%al
 1e1:	74 10                	je     1f3 <strcmp+0x27>
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	0f b6 10             	movzbl (%eax),%edx
 1e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ec:	0f b6 00             	movzbl (%eax),%eax
 1ef:	38 c2                	cmp    %al,%dl
 1f1:	74 de                	je     1d1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	0f b6 00             	movzbl (%eax),%eax
 1f9:	0f b6 d0             	movzbl %al,%edx
 1fc:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ff:	0f b6 00             	movzbl (%eax),%eax
 202:	0f b6 c0             	movzbl %al,%eax
 205:	29 c2                	sub    %eax,%edx
 207:	89 d0                	mov    %edx,%eax
}
 209:	5d                   	pop    %ebp
 20a:	c3                   	ret    

0000020b <strlen>:

uint
strlen(char *s)
{
 20b:	55                   	push   %ebp
 20c:	89 e5                	mov    %esp,%ebp
 20e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 211:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 218:	eb 04                	jmp    21e <strlen+0x13>
 21a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 21e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 221:	8b 45 08             	mov    0x8(%ebp),%eax
 224:	01 d0                	add    %edx,%eax
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	84 c0                	test   %al,%al
 22b:	75 ed                	jne    21a <strlen+0xf>
    ;
  return n;
 22d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 230:	c9                   	leave  
 231:	c3                   	ret    

00000232 <memset>:

void*
memset(void *dst, int c, uint n)
{
 232:	55                   	push   %ebp
 233:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 235:	8b 45 10             	mov    0x10(%ebp),%eax
 238:	50                   	push   %eax
 239:	ff 75 0c             	pushl  0xc(%ebp)
 23c:	ff 75 08             	pushl  0x8(%ebp)
 23f:	e8 32 ff ff ff       	call   176 <stosb>
 244:	83 c4 0c             	add    $0xc,%esp
  return dst;
 247:	8b 45 08             	mov    0x8(%ebp),%eax
}
 24a:	c9                   	leave  
 24b:	c3                   	ret    

0000024c <strchr>:

char*
strchr(const char *s, char c)
{
 24c:	55                   	push   %ebp
 24d:	89 e5                	mov    %esp,%ebp
 24f:	83 ec 04             	sub    $0x4,%esp
 252:	8b 45 0c             	mov    0xc(%ebp),%eax
 255:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 258:	eb 14                	jmp    26e <strchr+0x22>
    if(*s == c)
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	3a 45 fc             	cmp    -0x4(%ebp),%al
 263:	75 05                	jne    26a <strchr+0x1e>
      return (char*)s;
 265:	8b 45 08             	mov    0x8(%ebp),%eax
 268:	eb 13                	jmp    27d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 26a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
 271:	0f b6 00             	movzbl (%eax),%eax
 274:	84 c0                	test   %al,%al
 276:	75 e2                	jne    25a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 278:	b8 00 00 00 00       	mov    $0x0,%eax
}
 27d:	c9                   	leave  
 27e:	c3                   	ret    

0000027f <gets>:

char*
gets(char *buf, int max)
{
 27f:	55                   	push   %ebp
 280:	89 e5                	mov    %esp,%ebp
 282:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 285:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 28c:	eb 42                	jmp    2d0 <gets+0x51>
    cc = read(0, &c, 1);
 28e:	83 ec 04             	sub    $0x4,%esp
 291:	6a 01                	push   $0x1
 293:	8d 45 ef             	lea    -0x11(%ebp),%eax
 296:	50                   	push   %eax
 297:	6a 00                	push   $0x0
 299:	e8 1a 02 00 00       	call   4b8 <read>
 29e:	83 c4 10             	add    $0x10,%esp
 2a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2a4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2a8:	7e 33                	jle    2dd <gets+0x5e>
      break;
    buf[i++] = c;
 2aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ad:	8d 50 01             	lea    0x1(%eax),%edx
 2b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2b3:	89 c2                	mov    %eax,%edx
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	01 c2                	add    %eax,%edx
 2ba:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2be:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2c0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2c4:	3c 0a                	cmp    $0xa,%al
 2c6:	74 16                	je     2de <gets+0x5f>
 2c8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2cc:	3c 0d                	cmp    $0xd,%al
 2ce:	74 0e                	je     2de <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d3:	83 c0 01             	add    $0x1,%eax
 2d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2d9:	7c b3                	jl     28e <gets+0xf>
 2db:	eb 01                	jmp    2de <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2dd:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2de:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2e1:	8b 45 08             	mov    0x8(%ebp),%eax
 2e4:	01 d0                	add    %edx,%eax
 2e6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ec:	c9                   	leave  
 2ed:	c3                   	ret    

000002ee <stat>:

int
stat(char *n, struct stat *st)
{
 2ee:	55                   	push   %ebp
 2ef:	89 e5                	mov    %esp,%ebp
 2f1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2f4:	83 ec 08             	sub    $0x8,%esp
 2f7:	6a 00                	push   $0x0
 2f9:	ff 75 08             	pushl  0x8(%ebp)
 2fc:	e8 df 01 00 00       	call   4e0 <open>
 301:	83 c4 10             	add    $0x10,%esp
 304:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 307:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 30b:	79 07                	jns    314 <stat+0x26>
    return -1;
 30d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 312:	eb 25                	jmp    339 <stat+0x4b>
  r = fstat(fd, st);
 314:	83 ec 08             	sub    $0x8,%esp
 317:	ff 75 0c             	pushl  0xc(%ebp)
 31a:	ff 75 f4             	pushl  -0xc(%ebp)
 31d:	e8 d6 01 00 00       	call   4f8 <fstat>
 322:	83 c4 10             	add    $0x10,%esp
 325:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 328:	83 ec 0c             	sub    $0xc,%esp
 32b:	ff 75 f4             	pushl  -0xc(%ebp)
 32e:	e8 95 01 00 00       	call   4c8 <close>
 333:	83 c4 10             	add    $0x10,%esp
  return r;
 336:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 339:	c9                   	leave  
 33a:	c3                   	ret    

0000033b <atoi>:

int
atoi(const char *s)
{
 33b:	55                   	push   %ebp
 33c:	89 e5                	mov    %esp,%ebp
 33e:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 341:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 348:	eb 04                	jmp    34e <atoi+0x13>
 34a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 34e:	8b 45 08             	mov    0x8(%ebp),%eax
 351:	0f b6 00             	movzbl (%eax),%eax
 354:	3c 20                	cmp    $0x20,%al
 356:	74 f2                	je     34a <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 358:	8b 45 08             	mov    0x8(%ebp),%eax
 35b:	0f b6 00             	movzbl (%eax),%eax
 35e:	3c 2d                	cmp    $0x2d,%al
 360:	75 07                	jne    369 <atoi+0x2e>
 362:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 367:	eb 05                	jmp    36e <atoi+0x33>
 369:	b8 01 00 00 00       	mov    $0x1,%eax
 36e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 371:	8b 45 08             	mov    0x8(%ebp),%eax
 374:	0f b6 00             	movzbl (%eax),%eax
 377:	3c 2b                	cmp    $0x2b,%al
 379:	74 0a                	je     385 <atoi+0x4a>
 37b:	8b 45 08             	mov    0x8(%ebp),%eax
 37e:	0f b6 00             	movzbl (%eax),%eax
 381:	3c 2d                	cmp    $0x2d,%al
 383:	75 2b                	jne    3b0 <atoi+0x75>
    s++;
 385:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 389:	eb 25                	jmp    3b0 <atoi+0x75>
    n = n*10 + *s++ - '0';
 38b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 38e:	89 d0                	mov    %edx,%eax
 390:	c1 e0 02             	shl    $0x2,%eax
 393:	01 d0                	add    %edx,%eax
 395:	01 c0                	add    %eax,%eax
 397:	89 c1                	mov    %eax,%ecx
 399:	8b 45 08             	mov    0x8(%ebp),%eax
 39c:	8d 50 01             	lea    0x1(%eax),%edx
 39f:	89 55 08             	mov    %edx,0x8(%ebp)
 3a2:	0f b6 00             	movzbl (%eax),%eax
 3a5:	0f be c0             	movsbl %al,%eax
 3a8:	01 c8                	add    %ecx,%eax
 3aa:	83 e8 30             	sub    $0x30,%eax
 3ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 3b0:	8b 45 08             	mov    0x8(%ebp),%eax
 3b3:	0f b6 00             	movzbl (%eax),%eax
 3b6:	3c 2f                	cmp    $0x2f,%al
 3b8:	7e 0a                	jle    3c4 <atoi+0x89>
 3ba:	8b 45 08             	mov    0x8(%ebp),%eax
 3bd:	0f b6 00             	movzbl (%eax),%eax
 3c0:	3c 39                	cmp    $0x39,%al
 3c2:	7e c7                	jle    38b <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 3c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3c7:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3cb:	c9                   	leave  
 3cc:	c3                   	ret    

000003cd <atoo>:

int
atoo(const char *s)
{
 3cd:	55                   	push   %ebp
 3ce:	89 e5                	mov    %esp,%ebp
 3d0:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 3da:	eb 04                	jmp    3e0 <atoo+0x13>
 3dc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3e0:	8b 45 08             	mov    0x8(%ebp),%eax
 3e3:	0f b6 00             	movzbl (%eax),%eax
 3e6:	3c 20                	cmp    $0x20,%al
 3e8:	74 f2                	je     3dc <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 3ea:	8b 45 08             	mov    0x8(%ebp),%eax
 3ed:	0f b6 00             	movzbl (%eax),%eax
 3f0:	3c 2d                	cmp    $0x2d,%al
 3f2:	75 07                	jne    3fb <atoo+0x2e>
 3f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3f9:	eb 05                	jmp    400 <atoo+0x33>
 3fb:	b8 01 00 00 00       	mov    $0x1,%eax
 400:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 403:	8b 45 08             	mov    0x8(%ebp),%eax
 406:	0f b6 00             	movzbl (%eax),%eax
 409:	3c 2b                	cmp    $0x2b,%al
 40b:	74 0a                	je     417 <atoo+0x4a>
 40d:	8b 45 08             	mov    0x8(%ebp),%eax
 410:	0f b6 00             	movzbl (%eax),%eax
 413:	3c 2d                	cmp    $0x2d,%al
 415:	75 27                	jne    43e <atoo+0x71>
    s++;
 417:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 41b:	eb 21                	jmp    43e <atoo+0x71>
    n = n*8 + *s++ - '0';
 41d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 420:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 427:	8b 45 08             	mov    0x8(%ebp),%eax
 42a:	8d 50 01             	lea    0x1(%eax),%edx
 42d:	89 55 08             	mov    %edx,0x8(%ebp)
 430:	0f b6 00             	movzbl (%eax),%eax
 433:	0f be c0             	movsbl %al,%eax
 436:	01 c8                	add    %ecx,%eax
 438:	83 e8 30             	sub    $0x30,%eax
 43b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 43e:	8b 45 08             	mov    0x8(%ebp),%eax
 441:	0f b6 00             	movzbl (%eax),%eax
 444:	3c 2f                	cmp    $0x2f,%al
 446:	7e 0a                	jle    452 <atoo+0x85>
 448:	8b 45 08             	mov    0x8(%ebp),%eax
 44b:	0f b6 00             	movzbl (%eax),%eax
 44e:	3c 37                	cmp    $0x37,%al
 450:	7e cb                	jle    41d <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 452:	8b 45 f8             	mov    -0x8(%ebp),%eax
 455:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 459:	c9                   	leave  
 45a:	c3                   	ret    

0000045b <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 45b:	55                   	push   %ebp
 45c:	89 e5                	mov    %esp,%ebp
 45e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 461:	8b 45 08             	mov    0x8(%ebp),%eax
 464:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 467:	8b 45 0c             	mov    0xc(%ebp),%eax
 46a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 46d:	eb 17                	jmp    486 <memmove+0x2b>
    *dst++ = *src++;
 46f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 472:	8d 50 01             	lea    0x1(%eax),%edx
 475:	89 55 fc             	mov    %edx,-0x4(%ebp)
 478:	8b 55 f8             	mov    -0x8(%ebp),%edx
 47b:	8d 4a 01             	lea    0x1(%edx),%ecx
 47e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 481:	0f b6 12             	movzbl (%edx),%edx
 484:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 486:	8b 45 10             	mov    0x10(%ebp),%eax
 489:	8d 50 ff             	lea    -0x1(%eax),%edx
 48c:	89 55 10             	mov    %edx,0x10(%ebp)
 48f:	85 c0                	test   %eax,%eax
 491:	7f dc                	jg     46f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 493:	8b 45 08             	mov    0x8(%ebp),%eax
}
 496:	c9                   	leave  
 497:	c3                   	ret    

00000498 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 498:	b8 01 00 00 00       	mov    $0x1,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <exit>:
SYSCALL(exit)
 4a0:	b8 02 00 00 00       	mov    $0x2,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <wait>:
SYSCALL(wait)
 4a8:	b8 03 00 00 00       	mov    $0x3,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <pipe>:
SYSCALL(pipe)
 4b0:	b8 04 00 00 00       	mov    $0x4,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <read>:
SYSCALL(read)
 4b8:	b8 05 00 00 00       	mov    $0x5,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <write>:
SYSCALL(write)
 4c0:	b8 10 00 00 00       	mov    $0x10,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <close>:
SYSCALL(close)
 4c8:	b8 15 00 00 00       	mov    $0x15,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <kill>:
SYSCALL(kill)
 4d0:	b8 06 00 00 00       	mov    $0x6,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <exec>:
SYSCALL(exec)
 4d8:	b8 07 00 00 00       	mov    $0x7,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <open>:
SYSCALL(open)
 4e0:	b8 0f 00 00 00       	mov    $0xf,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <mknod>:
SYSCALL(mknod)
 4e8:	b8 11 00 00 00       	mov    $0x11,%eax
 4ed:	cd 40                	int    $0x40
 4ef:	c3                   	ret    

000004f0 <unlink>:
SYSCALL(unlink)
 4f0:	b8 12 00 00 00       	mov    $0x12,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <fstat>:
SYSCALL(fstat)
 4f8:	b8 08 00 00 00       	mov    $0x8,%eax
 4fd:	cd 40                	int    $0x40
 4ff:	c3                   	ret    

00000500 <link>:
SYSCALL(link)
 500:	b8 13 00 00 00       	mov    $0x13,%eax
 505:	cd 40                	int    $0x40
 507:	c3                   	ret    

00000508 <mkdir>:
SYSCALL(mkdir)
 508:	b8 14 00 00 00       	mov    $0x14,%eax
 50d:	cd 40                	int    $0x40
 50f:	c3                   	ret    

00000510 <chdir>:
SYSCALL(chdir)
 510:	b8 09 00 00 00       	mov    $0x9,%eax
 515:	cd 40                	int    $0x40
 517:	c3                   	ret    

00000518 <dup>:
SYSCALL(dup)
 518:	b8 0a 00 00 00       	mov    $0xa,%eax
 51d:	cd 40                	int    $0x40
 51f:	c3                   	ret    

00000520 <getpid>:
SYSCALL(getpid)
 520:	b8 0b 00 00 00       	mov    $0xb,%eax
 525:	cd 40                	int    $0x40
 527:	c3                   	ret    

00000528 <sbrk>:
SYSCALL(sbrk)
 528:	b8 0c 00 00 00       	mov    $0xc,%eax
 52d:	cd 40                	int    $0x40
 52f:	c3                   	ret    

00000530 <sleep>:
SYSCALL(sleep)
 530:	b8 0d 00 00 00       	mov    $0xd,%eax
 535:	cd 40                	int    $0x40
 537:	c3                   	ret    

00000538 <uptime>:
SYSCALL(uptime)
 538:	b8 0e 00 00 00       	mov    $0xe,%eax
 53d:	cd 40                	int    $0x40
 53f:	c3                   	ret    

00000540 <halt>:
SYSCALL(halt)
 540:	b8 16 00 00 00       	mov    $0x16,%eax
 545:	cd 40                	int    $0x40
 547:	c3                   	ret    

00000548 <date>:
SYSCALL(date)
 548:	b8 17 00 00 00       	mov    $0x17,%eax
 54d:	cd 40                	int    $0x40
 54f:	c3                   	ret    

00000550 <getuid>:
SYSCALL(getuid)
 550:	b8 18 00 00 00       	mov    $0x18,%eax
 555:	cd 40                	int    $0x40
 557:	c3                   	ret    

00000558 <getgid>:
SYSCALL(getgid)
 558:	b8 19 00 00 00       	mov    $0x19,%eax
 55d:	cd 40                	int    $0x40
 55f:	c3                   	ret    

00000560 <getppid>:
SYSCALL(getppid)
 560:	b8 1a 00 00 00       	mov    $0x1a,%eax
 565:	cd 40                	int    $0x40
 567:	c3                   	ret    

00000568 <setuid>:
SYSCALL(setuid)
 568:	b8 1b 00 00 00       	mov    $0x1b,%eax
 56d:	cd 40                	int    $0x40
 56f:	c3                   	ret    

00000570 <setgid>:
SYSCALL(setgid)
 570:	b8 1c 00 00 00       	mov    $0x1c,%eax
 575:	cd 40                	int    $0x40
 577:	c3                   	ret    

00000578 <getprocs>:
SYSCALL(getprocs)
 578:	b8 1d 00 00 00       	mov    $0x1d,%eax
 57d:	cd 40                	int    $0x40
 57f:	c3                   	ret    

00000580 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	83 ec 18             	sub    $0x18,%esp
 586:	8b 45 0c             	mov    0xc(%ebp),%eax
 589:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 58c:	83 ec 04             	sub    $0x4,%esp
 58f:	6a 01                	push   $0x1
 591:	8d 45 f4             	lea    -0xc(%ebp),%eax
 594:	50                   	push   %eax
 595:	ff 75 08             	pushl  0x8(%ebp)
 598:	e8 23 ff ff ff       	call   4c0 <write>
 59d:	83 c4 10             	add    $0x10,%esp
}
 5a0:	90                   	nop
 5a1:	c9                   	leave  
 5a2:	c3                   	ret    

000005a3 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5a3:	55                   	push   %ebp
 5a4:	89 e5                	mov    %esp,%ebp
 5a6:	53                   	push   %ebx
 5a7:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5b1:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5b5:	74 17                	je     5ce <printint+0x2b>
 5b7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5bb:	79 11                	jns    5ce <printint+0x2b>
    neg = 1;
 5bd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c7:	f7 d8                	neg    %eax
 5c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5cc:	eb 06                	jmp    5d4 <printint+0x31>
  } else {
    x = xx;
 5ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 5d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5db:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5de:	8d 41 01             	lea    0x1(%ecx),%eax
 5e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5e4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5ea:	ba 00 00 00 00       	mov    $0x0,%edx
 5ef:	f7 f3                	div    %ebx
 5f1:	89 d0                	mov    %edx,%eax
 5f3:	0f b6 80 30 0d 00 00 	movzbl 0xd30(%eax),%eax
 5fa:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
 601:	8b 45 ec             	mov    -0x14(%ebp),%eax
 604:	ba 00 00 00 00       	mov    $0x0,%edx
 609:	f7 f3                	div    %ebx
 60b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 60e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 612:	75 c7                	jne    5db <printint+0x38>
  if(neg)
 614:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 618:	74 2d                	je     647 <printint+0xa4>
    buf[i++] = '-';
 61a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61d:	8d 50 01             	lea    0x1(%eax),%edx
 620:	89 55 f4             	mov    %edx,-0xc(%ebp)
 623:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 628:	eb 1d                	jmp    647 <printint+0xa4>
    putc(fd, buf[i]);
 62a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 62d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 630:	01 d0                	add    %edx,%eax
 632:	0f b6 00             	movzbl (%eax),%eax
 635:	0f be c0             	movsbl %al,%eax
 638:	83 ec 08             	sub    $0x8,%esp
 63b:	50                   	push   %eax
 63c:	ff 75 08             	pushl  0x8(%ebp)
 63f:	e8 3c ff ff ff       	call   580 <putc>
 644:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 647:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 64b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 64f:	79 d9                	jns    62a <printint+0x87>
    putc(fd, buf[i]);
}
 651:	90                   	nop
 652:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 655:	c9                   	leave  
 656:	c3                   	ret    

00000657 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 657:	55                   	push   %ebp
 658:	89 e5                	mov    %esp,%ebp
 65a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 65d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 664:	8d 45 0c             	lea    0xc(%ebp),%eax
 667:	83 c0 04             	add    $0x4,%eax
 66a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 66d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 674:	e9 59 01 00 00       	jmp    7d2 <printf+0x17b>
    c = fmt[i] & 0xff;
 679:	8b 55 0c             	mov    0xc(%ebp),%edx
 67c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 67f:	01 d0                	add    %edx,%eax
 681:	0f b6 00             	movzbl (%eax),%eax
 684:	0f be c0             	movsbl %al,%eax
 687:	25 ff 00 00 00       	and    $0xff,%eax
 68c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 68f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 693:	75 2c                	jne    6c1 <printf+0x6a>
      if(c == '%'){
 695:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 699:	75 0c                	jne    6a7 <printf+0x50>
        state = '%';
 69b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6a2:	e9 27 01 00 00       	jmp    7ce <printf+0x177>
      } else {
        putc(fd, c);
 6a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6aa:	0f be c0             	movsbl %al,%eax
 6ad:	83 ec 08             	sub    $0x8,%esp
 6b0:	50                   	push   %eax
 6b1:	ff 75 08             	pushl  0x8(%ebp)
 6b4:	e8 c7 fe ff ff       	call   580 <putc>
 6b9:	83 c4 10             	add    $0x10,%esp
 6bc:	e9 0d 01 00 00       	jmp    7ce <printf+0x177>
      }
    } else if(state == '%'){
 6c1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6c5:	0f 85 03 01 00 00    	jne    7ce <printf+0x177>
      if(c == 'd'){
 6cb:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6cf:	75 1e                	jne    6ef <printf+0x98>
        printint(fd, *ap, 10, 1);
 6d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d4:	8b 00                	mov    (%eax),%eax
 6d6:	6a 01                	push   $0x1
 6d8:	6a 0a                	push   $0xa
 6da:	50                   	push   %eax
 6db:	ff 75 08             	pushl  0x8(%ebp)
 6de:	e8 c0 fe ff ff       	call   5a3 <printint>
 6e3:	83 c4 10             	add    $0x10,%esp
        ap++;
 6e6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ea:	e9 d8 00 00 00       	jmp    7c7 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6ef:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6f3:	74 06                	je     6fb <printf+0xa4>
 6f5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6f9:	75 1e                	jne    719 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6fe:	8b 00                	mov    (%eax),%eax
 700:	6a 00                	push   $0x0
 702:	6a 10                	push   $0x10
 704:	50                   	push   %eax
 705:	ff 75 08             	pushl  0x8(%ebp)
 708:	e8 96 fe ff ff       	call   5a3 <printint>
 70d:	83 c4 10             	add    $0x10,%esp
        ap++;
 710:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 714:	e9 ae 00 00 00       	jmp    7c7 <printf+0x170>
      } else if(c == 's'){
 719:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 71d:	75 43                	jne    762 <printf+0x10b>
        s = (char*)*ap;
 71f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 722:	8b 00                	mov    (%eax),%eax
 724:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 727:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 72b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 72f:	75 25                	jne    756 <printf+0xff>
          s = "(null)";
 731:	c7 45 f4 c0 0a 00 00 	movl   $0xac0,-0xc(%ebp)
        while(*s != 0){
 738:	eb 1c                	jmp    756 <printf+0xff>
          putc(fd, *s);
 73a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73d:	0f b6 00             	movzbl (%eax),%eax
 740:	0f be c0             	movsbl %al,%eax
 743:	83 ec 08             	sub    $0x8,%esp
 746:	50                   	push   %eax
 747:	ff 75 08             	pushl  0x8(%ebp)
 74a:	e8 31 fe ff ff       	call   580 <putc>
 74f:	83 c4 10             	add    $0x10,%esp
          s++;
 752:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 756:	8b 45 f4             	mov    -0xc(%ebp),%eax
 759:	0f b6 00             	movzbl (%eax),%eax
 75c:	84 c0                	test   %al,%al
 75e:	75 da                	jne    73a <printf+0xe3>
 760:	eb 65                	jmp    7c7 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 762:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 766:	75 1d                	jne    785 <printf+0x12e>
        putc(fd, *ap);
 768:	8b 45 e8             	mov    -0x18(%ebp),%eax
 76b:	8b 00                	mov    (%eax),%eax
 76d:	0f be c0             	movsbl %al,%eax
 770:	83 ec 08             	sub    $0x8,%esp
 773:	50                   	push   %eax
 774:	ff 75 08             	pushl  0x8(%ebp)
 777:	e8 04 fe ff ff       	call   580 <putc>
 77c:	83 c4 10             	add    $0x10,%esp
        ap++;
 77f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 783:	eb 42                	jmp    7c7 <printf+0x170>
      } else if(c == '%'){
 785:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 789:	75 17                	jne    7a2 <printf+0x14b>
        putc(fd, c);
 78b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 78e:	0f be c0             	movsbl %al,%eax
 791:	83 ec 08             	sub    $0x8,%esp
 794:	50                   	push   %eax
 795:	ff 75 08             	pushl  0x8(%ebp)
 798:	e8 e3 fd ff ff       	call   580 <putc>
 79d:	83 c4 10             	add    $0x10,%esp
 7a0:	eb 25                	jmp    7c7 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7a2:	83 ec 08             	sub    $0x8,%esp
 7a5:	6a 25                	push   $0x25
 7a7:	ff 75 08             	pushl  0x8(%ebp)
 7aa:	e8 d1 fd ff ff       	call   580 <putc>
 7af:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 7b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7b5:	0f be c0             	movsbl %al,%eax
 7b8:	83 ec 08             	sub    $0x8,%esp
 7bb:	50                   	push   %eax
 7bc:	ff 75 08             	pushl  0x8(%ebp)
 7bf:	e8 bc fd ff ff       	call   580 <putc>
 7c4:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7ce:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7d2:	8b 55 0c             	mov    0xc(%ebp),%edx
 7d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7d8:	01 d0                	add    %edx,%eax
 7da:	0f b6 00             	movzbl (%eax),%eax
 7dd:	84 c0                	test   %al,%al
 7df:	0f 85 94 fe ff ff    	jne    679 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7e5:	90                   	nop
 7e6:	c9                   	leave  
 7e7:	c3                   	ret    

000007e8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e8:	55                   	push   %ebp
 7e9:	89 e5                	mov    %esp,%ebp
 7eb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ee:	8b 45 08             	mov    0x8(%ebp),%eax
 7f1:	83 e8 08             	sub    $0x8,%eax
 7f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f7:	a1 4c 0d 00 00       	mov    0xd4c,%eax
 7fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7ff:	eb 24                	jmp    825 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 801:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804:	8b 00                	mov    (%eax),%eax
 806:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 809:	77 12                	ja     81d <free+0x35>
 80b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 811:	77 24                	ja     837 <free+0x4f>
 813:	8b 45 fc             	mov    -0x4(%ebp),%eax
 816:	8b 00                	mov    (%eax),%eax
 818:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 81b:	77 1a                	ja     837 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 81d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 820:	8b 00                	mov    (%eax),%eax
 822:	89 45 fc             	mov    %eax,-0x4(%ebp)
 825:	8b 45 f8             	mov    -0x8(%ebp),%eax
 828:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 82b:	76 d4                	jbe    801 <free+0x19>
 82d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 830:	8b 00                	mov    (%eax),%eax
 832:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 835:	76 ca                	jbe    801 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 837:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83a:	8b 40 04             	mov    0x4(%eax),%eax
 83d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 844:	8b 45 f8             	mov    -0x8(%ebp),%eax
 847:	01 c2                	add    %eax,%edx
 849:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84c:	8b 00                	mov    (%eax),%eax
 84e:	39 c2                	cmp    %eax,%edx
 850:	75 24                	jne    876 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 852:	8b 45 f8             	mov    -0x8(%ebp),%eax
 855:	8b 50 04             	mov    0x4(%eax),%edx
 858:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85b:	8b 00                	mov    (%eax),%eax
 85d:	8b 40 04             	mov    0x4(%eax),%eax
 860:	01 c2                	add    %eax,%edx
 862:	8b 45 f8             	mov    -0x8(%ebp),%eax
 865:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 868:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86b:	8b 00                	mov    (%eax),%eax
 86d:	8b 10                	mov    (%eax),%edx
 86f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 872:	89 10                	mov    %edx,(%eax)
 874:	eb 0a                	jmp    880 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 876:	8b 45 fc             	mov    -0x4(%ebp),%eax
 879:	8b 10                	mov    (%eax),%edx
 87b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 880:	8b 45 fc             	mov    -0x4(%ebp),%eax
 883:	8b 40 04             	mov    0x4(%eax),%eax
 886:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 88d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 890:	01 d0                	add    %edx,%eax
 892:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 895:	75 20                	jne    8b7 <free+0xcf>
    p->s.size += bp->s.size;
 897:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89a:	8b 50 04             	mov    0x4(%eax),%edx
 89d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a0:	8b 40 04             	mov    0x4(%eax),%eax
 8a3:	01 c2                	add    %eax,%edx
 8a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ae:	8b 10                	mov    (%eax),%edx
 8b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b3:	89 10                	mov    %edx,(%eax)
 8b5:	eb 08                	jmp    8bf <free+0xd7>
  } else
    p->s.ptr = bp;
 8b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ba:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8bd:	89 10                	mov    %edx,(%eax)
  freep = p;
 8bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c2:	a3 4c 0d 00 00       	mov    %eax,0xd4c
}
 8c7:	90                   	nop
 8c8:	c9                   	leave  
 8c9:	c3                   	ret    

000008ca <morecore>:

static Header*
morecore(uint nu)
{
 8ca:	55                   	push   %ebp
 8cb:	89 e5                	mov    %esp,%ebp
 8cd:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8d0:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8d7:	77 07                	ja     8e0 <morecore+0x16>
    nu = 4096;
 8d9:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8e0:	8b 45 08             	mov    0x8(%ebp),%eax
 8e3:	c1 e0 03             	shl    $0x3,%eax
 8e6:	83 ec 0c             	sub    $0xc,%esp
 8e9:	50                   	push   %eax
 8ea:	e8 39 fc ff ff       	call   528 <sbrk>
 8ef:	83 c4 10             	add    $0x10,%esp
 8f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8f5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8f9:	75 07                	jne    902 <morecore+0x38>
    return 0;
 8fb:	b8 00 00 00 00       	mov    $0x0,%eax
 900:	eb 26                	jmp    928 <morecore+0x5e>
  hp = (Header*)p;
 902:	8b 45 f4             	mov    -0xc(%ebp),%eax
 905:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 908:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90b:	8b 55 08             	mov    0x8(%ebp),%edx
 90e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 911:	8b 45 f0             	mov    -0x10(%ebp),%eax
 914:	83 c0 08             	add    $0x8,%eax
 917:	83 ec 0c             	sub    $0xc,%esp
 91a:	50                   	push   %eax
 91b:	e8 c8 fe ff ff       	call   7e8 <free>
 920:	83 c4 10             	add    $0x10,%esp
  return freep;
 923:	a1 4c 0d 00 00       	mov    0xd4c,%eax
}
 928:	c9                   	leave  
 929:	c3                   	ret    

0000092a <malloc>:

void*
malloc(uint nbytes)
{
 92a:	55                   	push   %ebp
 92b:	89 e5                	mov    %esp,%ebp
 92d:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 930:	8b 45 08             	mov    0x8(%ebp),%eax
 933:	83 c0 07             	add    $0x7,%eax
 936:	c1 e8 03             	shr    $0x3,%eax
 939:	83 c0 01             	add    $0x1,%eax
 93c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 93f:	a1 4c 0d 00 00       	mov    0xd4c,%eax
 944:	89 45 f0             	mov    %eax,-0x10(%ebp)
 947:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 94b:	75 23                	jne    970 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 94d:	c7 45 f0 44 0d 00 00 	movl   $0xd44,-0x10(%ebp)
 954:	8b 45 f0             	mov    -0x10(%ebp),%eax
 957:	a3 4c 0d 00 00       	mov    %eax,0xd4c
 95c:	a1 4c 0d 00 00       	mov    0xd4c,%eax
 961:	a3 44 0d 00 00       	mov    %eax,0xd44
    base.s.size = 0;
 966:	c7 05 48 0d 00 00 00 	movl   $0x0,0xd48
 96d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 970:	8b 45 f0             	mov    -0x10(%ebp),%eax
 973:	8b 00                	mov    (%eax),%eax
 975:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 978:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97b:	8b 40 04             	mov    0x4(%eax),%eax
 97e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 981:	72 4d                	jb     9d0 <malloc+0xa6>
      if(p->s.size == nunits)
 983:	8b 45 f4             	mov    -0xc(%ebp),%eax
 986:	8b 40 04             	mov    0x4(%eax),%eax
 989:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 98c:	75 0c                	jne    99a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 98e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 991:	8b 10                	mov    (%eax),%edx
 993:	8b 45 f0             	mov    -0x10(%ebp),%eax
 996:	89 10                	mov    %edx,(%eax)
 998:	eb 26                	jmp    9c0 <malloc+0x96>
      else {
        p->s.size -= nunits;
 99a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99d:	8b 40 04             	mov    0x4(%eax),%eax
 9a0:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9a3:	89 c2                	mov    %eax,%edx
 9a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a8:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ae:	8b 40 04             	mov    0x4(%eax),%eax
 9b1:	c1 e0 03             	shl    $0x3,%eax
 9b4:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9bd:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c3:	a3 4c 0d 00 00       	mov    %eax,0xd4c
      return (void*)(p + 1);
 9c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9cb:	83 c0 08             	add    $0x8,%eax
 9ce:	eb 3b                	jmp    a0b <malloc+0xe1>
    }
    if(p == freep)
 9d0:	a1 4c 0d 00 00       	mov    0xd4c,%eax
 9d5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9d8:	75 1e                	jne    9f8 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 9da:	83 ec 0c             	sub    $0xc,%esp
 9dd:	ff 75 ec             	pushl  -0x14(%ebp)
 9e0:	e8 e5 fe ff ff       	call   8ca <morecore>
 9e5:	83 c4 10             	add    $0x10,%esp
 9e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9ef:	75 07                	jne    9f8 <malloc+0xce>
        return 0;
 9f1:	b8 00 00 00 00       	mov    $0x0,%eax
 9f6:	eb 13                	jmp    a0b <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a01:	8b 00                	mov    (%eax),%eax
 a03:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a06:	e9 6d ff ff ff       	jmp    978 <malloc+0x4e>
}
 a0b:	c9                   	leave  
 a0c:	c3                   	ret    
