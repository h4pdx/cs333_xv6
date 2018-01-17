
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 69                	jmp    8b <wc+0x8b>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 58                	jmp    83 <wc+0x83>
      c++;
  2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	05 40 0d 00 00       	add    $0xd40,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 40 0d 00 00       	add    $0xd40,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	83 ec 08             	sub    $0x8,%esp
  53:	50                   	push   %eax
  54:	68 24 0a 00 00       	push   $0xa24
  59:	e8 35 02 00 00       	call   293 <strchr>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	85 c0                	test   %eax,%eax
  63:	74 09                	je     6e <wc+0x6e>
        inword = 0;
  65:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6c:	eb 11                	jmp    7f <wc+0x7f>
      else if(!inword){
  6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  72:	75 0b                	jne    7f <wc+0x7f>
        w++;
  74:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  78:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  7f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  86:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  89:	7c a0                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8b:	83 ec 04             	sub    $0x4,%esp
  8e:	68 00 02 00 00       	push   $0x200
  93:	68 40 0d 00 00       	push   $0xd40
  98:	ff 75 08             	pushl  0x8(%ebp)
  9b:	e8 5f 04 00 00       	call   4ff <read>
  a0:	83 c4 10             	add    $0x10,%esp
  a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  aa:	0f 8f 72 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b4:	79 17                	jns    cd <wc+0xcd>
    printf(1, "wc: read error\n");
  b6:	83 ec 08             	sub    $0x8,%esp
  b9:	68 2a 0a 00 00       	push   $0xa2a
  be:	6a 01                	push   $0x1
  c0:	e8 a9 05 00 00       	call   66e <printf>
  c5:	83 c4 10             	add    $0x10,%esp
    exit();
  c8:	e8 1a 04 00 00       	call   4e7 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  cd:	83 ec 08             	sub    $0x8,%esp
  d0:	ff 75 0c             	pushl  0xc(%ebp)
  d3:	ff 75 e8             	pushl  -0x18(%ebp)
  d6:	ff 75 ec             	pushl  -0x14(%ebp)
  d9:	ff 75 f0             	pushl  -0x10(%ebp)
  dc:	68 3a 0a 00 00       	push   $0xa3a
  e1:	6a 01                	push   $0x1
  e3:	e8 86 05 00 00       	call   66e <printf>
  e8:	83 c4 20             	add    $0x20,%esp
}
  eb:	90                   	nop
  ec:	c9                   	leave  
  ed:	c3                   	ret    

000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  f2:	83 e4 f0             	and    $0xfffffff0,%esp
  f5:	ff 71 fc             	pushl  -0x4(%ecx)
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	53                   	push   %ebx
  fc:	51                   	push   %ecx
  fd:	83 ec 10             	sub    $0x10,%esp
 100:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
 102:	83 3b 01             	cmpl   $0x1,(%ebx)
 105:	7f 17                	jg     11e <main+0x30>
    wc(0, "");
 107:	83 ec 08             	sub    $0x8,%esp
 10a:	68 47 0a 00 00       	push   $0xa47
 10f:	6a 00                	push   $0x0
 111:	e8 ea fe ff ff       	call   0 <wc>
 116:	83 c4 10             	add    $0x10,%esp
    exit();
 119:	e8 c9 03 00 00       	call   4e7 <exit>
  }

  for(i = 1; i < argc; i++){
 11e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 125:	e9 83 00 00 00       	jmp    1ad <main+0xbf>
    if((fd = open(argv[i], 0)) < 0){
 12a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 12d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 134:	8b 43 04             	mov    0x4(%ebx),%eax
 137:	01 d0                	add    %edx,%eax
 139:	8b 00                	mov    (%eax),%eax
 13b:	83 ec 08             	sub    $0x8,%esp
 13e:	6a 00                	push   $0x0
 140:	50                   	push   %eax
 141:	e8 e1 03 00 00       	call   527 <open>
 146:	83 c4 10             	add    $0x10,%esp
 149:	89 45 f0             	mov    %eax,-0x10(%ebp)
 14c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 150:	79 29                	jns    17b <main+0x8d>
      printf(1, "wc: cannot open %s\n", argv[i]);
 152:	8b 45 f4             	mov    -0xc(%ebp),%eax
 155:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 15c:	8b 43 04             	mov    0x4(%ebx),%eax
 15f:	01 d0                	add    %edx,%eax
 161:	8b 00                	mov    (%eax),%eax
 163:	83 ec 04             	sub    $0x4,%esp
 166:	50                   	push   %eax
 167:	68 48 0a 00 00       	push   $0xa48
 16c:	6a 01                	push   $0x1
 16e:	e8 fb 04 00 00       	call   66e <printf>
 173:	83 c4 10             	add    $0x10,%esp
      exit();
 176:	e8 6c 03 00 00       	call   4e7 <exit>
    }
    wc(fd, argv[i]);
 17b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 17e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 185:	8b 43 04             	mov    0x4(%ebx),%eax
 188:	01 d0                	add    %edx,%eax
 18a:	8b 00                	mov    (%eax),%eax
 18c:	83 ec 08             	sub    $0x8,%esp
 18f:	50                   	push   %eax
 190:	ff 75 f0             	pushl  -0x10(%ebp)
 193:	e8 68 fe ff ff       	call   0 <wc>
 198:	83 c4 10             	add    $0x10,%esp
    close(fd);
 19b:	83 ec 0c             	sub    $0xc,%esp
 19e:	ff 75 f0             	pushl  -0x10(%ebp)
 1a1:	e8 69 03 00 00       	call   50f <close>
 1a6:	83 c4 10             	add    $0x10,%esp
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 1a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b0:	3b 03                	cmp    (%ebx),%eax
 1b2:	0f 8c 72 ff ff ff    	jl     12a <main+0x3c>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 1b8:	e8 2a 03 00 00       	call   4e7 <exit>

000001bd <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1bd:	55                   	push   %ebp
 1be:	89 e5                	mov    %esp,%ebp
 1c0:	57                   	push   %edi
 1c1:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c5:	8b 55 10             	mov    0x10(%ebp),%edx
 1c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cb:	89 cb                	mov    %ecx,%ebx
 1cd:	89 df                	mov    %ebx,%edi
 1cf:	89 d1                	mov    %edx,%ecx
 1d1:	fc                   	cld    
 1d2:	f3 aa                	rep stos %al,%es:(%edi)
 1d4:	89 ca                	mov    %ecx,%edx
 1d6:	89 fb                	mov    %edi,%ebx
 1d8:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1db:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1de:	90                   	nop
 1df:	5b                   	pop    %ebx
 1e0:	5f                   	pop    %edi
 1e1:	5d                   	pop    %ebp
 1e2:	c3                   	ret    

000001e3 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 1e3:	55                   	push   %ebp
 1e4:	89 e5                	mov    %esp,%ebp
 1e6:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1ef:	90                   	nop
 1f0:	8b 45 08             	mov    0x8(%ebp),%eax
 1f3:	8d 50 01             	lea    0x1(%eax),%edx
 1f6:	89 55 08             	mov    %edx,0x8(%ebp)
 1f9:	8b 55 0c             	mov    0xc(%ebp),%edx
 1fc:	8d 4a 01             	lea    0x1(%edx),%ecx
 1ff:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 202:	0f b6 12             	movzbl (%edx),%edx
 205:	88 10                	mov    %dl,(%eax)
 207:	0f b6 00             	movzbl (%eax),%eax
 20a:	84 c0                	test   %al,%al
 20c:	75 e2                	jne    1f0 <strcpy+0xd>
    ;
  return os;
 20e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 211:	c9                   	leave  
 212:	c3                   	ret    

00000213 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 213:	55                   	push   %ebp
 214:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 216:	eb 08                	jmp    220 <strcmp+0xd>
    p++, q++;
 218:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 220:	8b 45 08             	mov    0x8(%ebp),%eax
 223:	0f b6 00             	movzbl (%eax),%eax
 226:	84 c0                	test   %al,%al
 228:	74 10                	je     23a <strcmp+0x27>
 22a:	8b 45 08             	mov    0x8(%ebp),%eax
 22d:	0f b6 10             	movzbl (%eax),%edx
 230:	8b 45 0c             	mov    0xc(%ebp),%eax
 233:	0f b6 00             	movzbl (%eax),%eax
 236:	38 c2                	cmp    %al,%dl
 238:	74 de                	je     218 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 00             	movzbl (%eax),%eax
 240:	0f b6 d0             	movzbl %al,%edx
 243:	8b 45 0c             	mov    0xc(%ebp),%eax
 246:	0f b6 00             	movzbl (%eax),%eax
 249:	0f b6 c0             	movzbl %al,%eax
 24c:	29 c2                	sub    %eax,%edx
 24e:	89 d0                	mov    %edx,%eax
}
 250:	5d                   	pop    %ebp
 251:	c3                   	ret    

00000252 <strlen>:

uint
strlen(char *s)
{
 252:	55                   	push   %ebp
 253:	89 e5                	mov    %esp,%ebp
 255:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 258:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25f:	eb 04                	jmp    265 <strlen+0x13>
 261:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 265:	8b 55 fc             	mov    -0x4(%ebp),%edx
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	01 d0                	add    %edx,%eax
 26d:	0f b6 00             	movzbl (%eax),%eax
 270:	84 c0                	test   %al,%al
 272:	75 ed                	jne    261 <strlen+0xf>
    ;
  return n;
 274:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 277:	c9                   	leave  
 278:	c3                   	ret    

00000279 <memset>:

void*
memset(void *dst, int c, uint n)
{
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 27c:	8b 45 10             	mov    0x10(%ebp),%eax
 27f:	50                   	push   %eax
 280:	ff 75 0c             	pushl  0xc(%ebp)
 283:	ff 75 08             	pushl  0x8(%ebp)
 286:	e8 32 ff ff ff       	call   1bd <stosb>
 28b:	83 c4 0c             	add    $0xc,%esp
  return dst;
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 291:	c9                   	leave  
 292:	c3                   	ret    

00000293 <strchr>:

char*
strchr(const char *s, char c)
{
 293:	55                   	push   %ebp
 294:	89 e5                	mov    %esp,%ebp
 296:	83 ec 04             	sub    $0x4,%esp
 299:	8b 45 0c             	mov    0xc(%ebp),%eax
 29c:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 29f:	eb 14                	jmp    2b5 <strchr+0x22>
    if(*s == c)
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
 2a4:	0f b6 00             	movzbl (%eax),%eax
 2a7:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2aa:	75 05                	jne    2b1 <strchr+0x1e>
      return (char*)s;
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	eb 13                	jmp    2c4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	0f b6 00             	movzbl (%eax),%eax
 2bb:	84 c0                	test   %al,%al
 2bd:	75 e2                	jne    2a1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <gets>:

char*
gets(char *buf, int max)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2d3:	eb 42                	jmp    317 <gets+0x51>
    cc = read(0, &c, 1);
 2d5:	83 ec 04             	sub    $0x4,%esp
 2d8:	6a 01                	push   $0x1
 2da:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2dd:	50                   	push   %eax
 2de:	6a 00                	push   $0x0
 2e0:	e8 1a 02 00 00       	call   4ff <read>
 2e5:	83 c4 10             	add    $0x10,%esp
 2e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2ef:	7e 33                	jle    324 <gets+0x5e>
      break;
    buf[i++] = c;
 2f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2fa:	89 c2                	mov    %eax,%edx
 2fc:	8b 45 08             	mov    0x8(%ebp),%eax
 2ff:	01 c2                	add    %eax,%edx
 301:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 305:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 307:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30b:	3c 0a                	cmp    $0xa,%al
 30d:	74 16                	je     325 <gets+0x5f>
 30f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 313:	3c 0d                	cmp    $0xd,%al
 315:	74 0e                	je     325 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 317:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31a:	83 c0 01             	add    $0x1,%eax
 31d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 320:	7c b3                	jl     2d5 <gets+0xf>
 322:	eb 01                	jmp    325 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 324:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 325:	8b 55 f4             	mov    -0xc(%ebp),%edx
 328:	8b 45 08             	mov    0x8(%ebp),%eax
 32b:	01 d0                	add    %edx,%eax
 32d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 330:	8b 45 08             	mov    0x8(%ebp),%eax
}
 333:	c9                   	leave  
 334:	c3                   	ret    

00000335 <stat>:

int
stat(char *n, struct stat *st)
{
 335:	55                   	push   %ebp
 336:	89 e5                	mov    %esp,%ebp
 338:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33b:	83 ec 08             	sub    $0x8,%esp
 33e:	6a 00                	push   $0x0
 340:	ff 75 08             	pushl  0x8(%ebp)
 343:	e8 df 01 00 00       	call   527 <open>
 348:	83 c4 10             	add    $0x10,%esp
 34b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 34e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 352:	79 07                	jns    35b <stat+0x26>
    return -1;
 354:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 359:	eb 25                	jmp    380 <stat+0x4b>
  r = fstat(fd, st);
 35b:	83 ec 08             	sub    $0x8,%esp
 35e:	ff 75 0c             	pushl  0xc(%ebp)
 361:	ff 75 f4             	pushl  -0xc(%ebp)
 364:	e8 d6 01 00 00       	call   53f <fstat>
 369:	83 c4 10             	add    $0x10,%esp
 36c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 36f:	83 ec 0c             	sub    $0xc,%esp
 372:	ff 75 f4             	pushl  -0xc(%ebp)
 375:	e8 95 01 00 00       	call   50f <close>
 37a:	83 c4 10             	add    $0x10,%esp
  return r;
 37d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 380:	c9                   	leave  
 381:	c3                   	ret    

00000382 <atoi>:

int
atoi(const char *s)
{
 382:	55                   	push   %ebp
 383:	89 e5                	mov    %esp,%ebp
 385:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 388:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 38f:	eb 04                	jmp    395 <atoi+0x13>
 391:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 395:	8b 45 08             	mov    0x8(%ebp),%eax
 398:	0f b6 00             	movzbl (%eax),%eax
 39b:	3c 20                	cmp    $0x20,%al
 39d:	74 f2                	je     391 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 39f:	8b 45 08             	mov    0x8(%ebp),%eax
 3a2:	0f b6 00             	movzbl (%eax),%eax
 3a5:	3c 2d                	cmp    $0x2d,%al
 3a7:	75 07                	jne    3b0 <atoi+0x2e>
 3a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3ae:	eb 05                	jmp    3b5 <atoi+0x33>
 3b0:	b8 01 00 00 00       	mov    $0x1,%eax
 3b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3b8:	8b 45 08             	mov    0x8(%ebp),%eax
 3bb:	0f b6 00             	movzbl (%eax),%eax
 3be:	3c 2b                	cmp    $0x2b,%al
 3c0:	74 0a                	je     3cc <atoi+0x4a>
 3c2:	8b 45 08             	mov    0x8(%ebp),%eax
 3c5:	0f b6 00             	movzbl (%eax),%eax
 3c8:	3c 2d                	cmp    $0x2d,%al
 3ca:	75 2b                	jne    3f7 <atoi+0x75>
    s++;
 3cc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 3d0:	eb 25                	jmp    3f7 <atoi+0x75>
    n = n*10 + *s++ - '0';
 3d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3d5:	89 d0                	mov    %edx,%eax
 3d7:	c1 e0 02             	shl    $0x2,%eax
 3da:	01 d0                	add    %edx,%eax
 3dc:	01 c0                	add    %eax,%eax
 3de:	89 c1                	mov    %eax,%ecx
 3e0:	8b 45 08             	mov    0x8(%ebp),%eax
 3e3:	8d 50 01             	lea    0x1(%eax),%edx
 3e6:	89 55 08             	mov    %edx,0x8(%ebp)
 3e9:	0f b6 00             	movzbl (%eax),%eax
 3ec:	0f be c0             	movsbl %al,%eax
 3ef:	01 c8                	add    %ecx,%eax
 3f1:	83 e8 30             	sub    $0x30,%eax
 3f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 3f7:	8b 45 08             	mov    0x8(%ebp),%eax
 3fa:	0f b6 00             	movzbl (%eax),%eax
 3fd:	3c 2f                	cmp    $0x2f,%al
 3ff:	7e 0a                	jle    40b <atoi+0x89>
 401:	8b 45 08             	mov    0x8(%ebp),%eax
 404:	0f b6 00             	movzbl (%eax),%eax
 407:	3c 39                	cmp    $0x39,%al
 409:	7e c7                	jle    3d2 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 40b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 40e:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 412:	c9                   	leave  
 413:	c3                   	ret    

00000414 <atoo>:

int
atoo(const char *s)
{
 414:	55                   	push   %ebp
 415:	89 e5                	mov    %esp,%ebp
 417:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 41a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 421:	eb 04                	jmp    427 <atoo+0x13>
 423:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 427:	8b 45 08             	mov    0x8(%ebp),%eax
 42a:	0f b6 00             	movzbl (%eax),%eax
 42d:	3c 20                	cmp    $0x20,%al
 42f:	74 f2                	je     423 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 431:	8b 45 08             	mov    0x8(%ebp),%eax
 434:	0f b6 00             	movzbl (%eax),%eax
 437:	3c 2d                	cmp    $0x2d,%al
 439:	75 07                	jne    442 <atoo+0x2e>
 43b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 440:	eb 05                	jmp    447 <atoo+0x33>
 442:	b8 01 00 00 00       	mov    $0x1,%eax
 447:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 44a:	8b 45 08             	mov    0x8(%ebp),%eax
 44d:	0f b6 00             	movzbl (%eax),%eax
 450:	3c 2b                	cmp    $0x2b,%al
 452:	74 0a                	je     45e <atoo+0x4a>
 454:	8b 45 08             	mov    0x8(%ebp),%eax
 457:	0f b6 00             	movzbl (%eax),%eax
 45a:	3c 2d                	cmp    $0x2d,%al
 45c:	75 27                	jne    485 <atoo+0x71>
    s++;
 45e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 462:	eb 21                	jmp    485 <atoo+0x71>
    n = n*8 + *s++ - '0';
 464:	8b 45 fc             	mov    -0x4(%ebp),%eax
 467:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 46e:	8b 45 08             	mov    0x8(%ebp),%eax
 471:	8d 50 01             	lea    0x1(%eax),%edx
 474:	89 55 08             	mov    %edx,0x8(%ebp)
 477:	0f b6 00             	movzbl (%eax),%eax
 47a:	0f be c0             	movsbl %al,%eax
 47d:	01 c8                	add    %ecx,%eax
 47f:	83 e8 30             	sub    $0x30,%eax
 482:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 485:	8b 45 08             	mov    0x8(%ebp),%eax
 488:	0f b6 00             	movzbl (%eax),%eax
 48b:	3c 2f                	cmp    $0x2f,%al
 48d:	7e 0a                	jle    499 <atoo+0x85>
 48f:	8b 45 08             	mov    0x8(%ebp),%eax
 492:	0f b6 00             	movzbl (%eax),%eax
 495:	3c 37                	cmp    $0x37,%al
 497:	7e cb                	jle    464 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 499:	8b 45 f8             	mov    -0x8(%ebp),%eax
 49c:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 4a0:	c9                   	leave  
 4a1:	c3                   	ret    

000004a2 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 4a2:	55                   	push   %ebp
 4a3:	89 e5                	mov    %esp,%ebp
 4a5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4a8:	8b 45 08             	mov    0x8(%ebp),%eax
 4ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4b4:	eb 17                	jmp    4cd <memmove+0x2b>
    *dst++ = *src++;
 4b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4b9:	8d 50 01             	lea    0x1(%eax),%edx
 4bc:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4bf:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4c2:	8d 4a 01             	lea    0x1(%edx),%ecx
 4c5:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4c8:	0f b6 12             	movzbl (%edx),%edx
 4cb:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4cd:	8b 45 10             	mov    0x10(%ebp),%eax
 4d0:	8d 50 ff             	lea    -0x1(%eax),%edx
 4d3:	89 55 10             	mov    %edx,0x10(%ebp)
 4d6:	85 c0                	test   %eax,%eax
 4d8:	7f dc                	jg     4b6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4da:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4dd:	c9                   	leave  
 4de:	c3                   	ret    

000004df <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4df:	b8 01 00 00 00       	mov    $0x1,%eax
 4e4:	cd 40                	int    $0x40
 4e6:	c3                   	ret    

000004e7 <exit>:
SYSCALL(exit)
 4e7:	b8 02 00 00 00       	mov    $0x2,%eax
 4ec:	cd 40                	int    $0x40
 4ee:	c3                   	ret    

000004ef <wait>:
SYSCALL(wait)
 4ef:	b8 03 00 00 00       	mov    $0x3,%eax
 4f4:	cd 40                	int    $0x40
 4f6:	c3                   	ret    

000004f7 <pipe>:
SYSCALL(pipe)
 4f7:	b8 04 00 00 00       	mov    $0x4,%eax
 4fc:	cd 40                	int    $0x40
 4fe:	c3                   	ret    

000004ff <read>:
SYSCALL(read)
 4ff:	b8 05 00 00 00       	mov    $0x5,%eax
 504:	cd 40                	int    $0x40
 506:	c3                   	ret    

00000507 <write>:
SYSCALL(write)
 507:	b8 10 00 00 00       	mov    $0x10,%eax
 50c:	cd 40                	int    $0x40
 50e:	c3                   	ret    

0000050f <close>:
SYSCALL(close)
 50f:	b8 15 00 00 00       	mov    $0x15,%eax
 514:	cd 40                	int    $0x40
 516:	c3                   	ret    

00000517 <kill>:
SYSCALL(kill)
 517:	b8 06 00 00 00       	mov    $0x6,%eax
 51c:	cd 40                	int    $0x40
 51e:	c3                   	ret    

0000051f <exec>:
SYSCALL(exec)
 51f:	b8 07 00 00 00       	mov    $0x7,%eax
 524:	cd 40                	int    $0x40
 526:	c3                   	ret    

00000527 <open>:
SYSCALL(open)
 527:	b8 0f 00 00 00       	mov    $0xf,%eax
 52c:	cd 40                	int    $0x40
 52e:	c3                   	ret    

0000052f <mknod>:
SYSCALL(mknod)
 52f:	b8 11 00 00 00       	mov    $0x11,%eax
 534:	cd 40                	int    $0x40
 536:	c3                   	ret    

00000537 <unlink>:
SYSCALL(unlink)
 537:	b8 12 00 00 00       	mov    $0x12,%eax
 53c:	cd 40                	int    $0x40
 53e:	c3                   	ret    

0000053f <fstat>:
SYSCALL(fstat)
 53f:	b8 08 00 00 00       	mov    $0x8,%eax
 544:	cd 40                	int    $0x40
 546:	c3                   	ret    

00000547 <link>:
SYSCALL(link)
 547:	b8 13 00 00 00       	mov    $0x13,%eax
 54c:	cd 40                	int    $0x40
 54e:	c3                   	ret    

0000054f <mkdir>:
SYSCALL(mkdir)
 54f:	b8 14 00 00 00       	mov    $0x14,%eax
 554:	cd 40                	int    $0x40
 556:	c3                   	ret    

00000557 <chdir>:
SYSCALL(chdir)
 557:	b8 09 00 00 00       	mov    $0x9,%eax
 55c:	cd 40                	int    $0x40
 55e:	c3                   	ret    

0000055f <dup>:
SYSCALL(dup)
 55f:	b8 0a 00 00 00       	mov    $0xa,%eax
 564:	cd 40                	int    $0x40
 566:	c3                   	ret    

00000567 <getpid>:
SYSCALL(getpid)
 567:	b8 0b 00 00 00       	mov    $0xb,%eax
 56c:	cd 40                	int    $0x40
 56e:	c3                   	ret    

0000056f <sbrk>:
SYSCALL(sbrk)
 56f:	b8 0c 00 00 00       	mov    $0xc,%eax
 574:	cd 40                	int    $0x40
 576:	c3                   	ret    

00000577 <sleep>:
SYSCALL(sleep)
 577:	b8 0d 00 00 00       	mov    $0xd,%eax
 57c:	cd 40                	int    $0x40
 57e:	c3                   	ret    

0000057f <uptime>:
SYSCALL(uptime)
 57f:	b8 0e 00 00 00       	mov    $0xe,%eax
 584:	cd 40                	int    $0x40
 586:	c3                   	ret    

00000587 <halt>:
SYSCALL(halt)
 587:	b8 16 00 00 00       	mov    $0x16,%eax
 58c:	cd 40                	int    $0x40
 58e:	c3                   	ret    

0000058f <date>:
SYSCALL(date)
 58f:	b8 17 00 00 00       	mov    $0x17,%eax
 594:	cd 40                	int    $0x40
 596:	c3                   	ret    

00000597 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 597:	55                   	push   %ebp
 598:	89 e5                	mov    %esp,%ebp
 59a:	83 ec 18             	sub    $0x18,%esp
 59d:	8b 45 0c             	mov    0xc(%ebp),%eax
 5a0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5a3:	83 ec 04             	sub    $0x4,%esp
 5a6:	6a 01                	push   $0x1
 5a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5ab:	50                   	push   %eax
 5ac:	ff 75 08             	pushl  0x8(%ebp)
 5af:	e8 53 ff ff ff       	call   507 <write>
 5b4:	83 c4 10             	add    $0x10,%esp
}
 5b7:	90                   	nop
 5b8:	c9                   	leave  
 5b9:	c3                   	ret    

000005ba <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5ba:	55                   	push   %ebp
 5bb:	89 e5                	mov    %esp,%ebp
 5bd:	53                   	push   %ebx
 5be:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5c8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5cc:	74 17                	je     5e5 <printint+0x2b>
 5ce:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5d2:	79 11                	jns    5e5 <printint+0x2b>
    neg = 1;
 5d4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5db:	8b 45 0c             	mov    0xc(%ebp),%eax
 5de:	f7 d8                	neg    %eax
 5e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5e3:	eb 06                	jmp    5eb <printint+0x31>
  } else {
    x = xx;
 5e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 5e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5f2:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5f5:	8d 41 01             	lea    0x1(%ecx),%eax
 5f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
 601:	ba 00 00 00 00       	mov    $0x0,%edx
 606:	f7 f3                	div    %ebx
 608:	89 d0                	mov    %edx,%eax
 60a:	0f b6 80 f0 0c 00 00 	movzbl 0xcf0(%eax),%eax
 611:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 615:	8b 5d 10             	mov    0x10(%ebp),%ebx
 618:	8b 45 ec             	mov    -0x14(%ebp),%eax
 61b:	ba 00 00 00 00       	mov    $0x0,%edx
 620:	f7 f3                	div    %ebx
 622:	89 45 ec             	mov    %eax,-0x14(%ebp)
 625:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 629:	75 c7                	jne    5f2 <printint+0x38>
  if(neg)
 62b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 62f:	74 2d                	je     65e <printint+0xa4>
    buf[i++] = '-';
 631:	8b 45 f4             	mov    -0xc(%ebp),%eax
 634:	8d 50 01             	lea    0x1(%eax),%edx
 637:	89 55 f4             	mov    %edx,-0xc(%ebp)
 63a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 63f:	eb 1d                	jmp    65e <printint+0xa4>
    putc(fd, buf[i]);
 641:	8d 55 dc             	lea    -0x24(%ebp),%edx
 644:	8b 45 f4             	mov    -0xc(%ebp),%eax
 647:	01 d0                	add    %edx,%eax
 649:	0f b6 00             	movzbl (%eax),%eax
 64c:	0f be c0             	movsbl %al,%eax
 64f:	83 ec 08             	sub    $0x8,%esp
 652:	50                   	push   %eax
 653:	ff 75 08             	pushl  0x8(%ebp)
 656:	e8 3c ff ff ff       	call   597 <putc>
 65b:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 65e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 662:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 666:	79 d9                	jns    641 <printint+0x87>
    putc(fd, buf[i]);
}
 668:	90                   	nop
 669:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 66c:	c9                   	leave  
 66d:	c3                   	ret    

0000066e <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 66e:	55                   	push   %ebp
 66f:	89 e5                	mov    %esp,%ebp
 671:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 674:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 67b:	8d 45 0c             	lea    0xc(%ebp),%eax
 67e:	83 c0 04             	add    $0x4,%eax
 681:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 684:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 68b:	e9 59 01 00 00       	jmp    7e9 <printf+0x17b>
    c = fmt[i] & 0xff;
 690:	8b 55 0c             	mov    0xc(%ebp),%edx
 693:	8b 45 f0             	mov    -0x10(%ebp),%eax
 696:	01 d0                	add    %edx,%eax
 698:	0f b6 00             	movzbl (%eax),%eax
 69b:	0f be c0             	movsbl %al,%eax
 69e:	25 ff 00 00 00       	and    $0xff,%eax
 6a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6aa:	75 2c                	jne    6d8 <printf+0x6a>
      if(c == '%'){
 6ac:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6b0:	75 0c                	jne    6be <printf+0x50>
        state = '%';
 6b2:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6b9:	e9 27 01 00 00       	jmp    7e5 <printf+0x177>
      } else {
        putc(fd, c);
 6be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c1:	0f be c0             	movsbl %al,%eax
 6c4:	83 ec 08             	sub    $0x8,%esp
 6c7:	50                   	push   %eax
 6c8:	ff 75 08             	pushl  0x8(%ebp)
 6cb:	e8 c7 fe ff ff       	call   597 <putc>
 6d0:	83 c4 10             	add    $0x10,%esp
 6d3:	e9 0d 01 00 00       	jmp    7e5 <printf+0x177>
      }
    } else if(state == '%'){
 6d8:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6dc:	0f 85 03 01 00 00    	jne    7e5 <printf+0x177>
      if(c == 'd'){
 6e2:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6e6:	75 1e                	jne    706 <printf+0x98>
        printint(fd, *ap, 10, 1);
 6e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6eb:	8b 00                	mov    (%eax),%eax
 6ed:	6a 01                	push   $0x1
 6ef:	6a 0a                	push   $0xa
 6f1:	50                   	push   %eax
 6f2:	ff 75 08             	pushl  0x8(%ebp)
 6f5:	e8 c0 fe ff ff       	call   5ba <printint>
 6fa:	83 c4 10             	add    $0x10,%esp
        ap++;
 6fd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 701:	e9 d8 00 00 00       	jmp    7de <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 706:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 70a:	74 06                	je     712 <printf+0xa4>
 70c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 710:	75 1e                	jne    730 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 712:	8b 45 e8             	mov    -0x18(%ebp),%eax
 715:	8b 00                	mov    (%eax),%eax
 717:	6a 00                	push   $0x0
 719:	6a 10                	push   $0x10
 71b:	50                   	push   %eax
 71c:	ff 75 08             	pushl  0x8(%ebp)
 71f:	e8 96 fe ff ff       	call   5ba <printint>
 724:	83 c4 10             	add    $0x10,%esp
        ap++;
 727:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 72b:	e9 ae 00 00 00       	jmp    7de <printf+0x170>
      } else if(c == 's'){
 730:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 734:	75 43                	jne    779 <printf+0x10b>
        s = (char*)*ap;
 736:	8b 45 e8             	mov    -0x18(%ebp),%eax
 739:	8b 00                	mov    (%eax),%eax
 73b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 73e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 742:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 746:	75 25                	jne    76d <printf+0xff>
          s = "(null)";
 748:	c7 45 f4 5c 0a 00 00 	movl   $0xa5c,-0xc(%ebp)
        while(*s != 0){
 74f:	eb 1c                	jmp    76d <printf+0xff>
          putc(fd, *s);
 751:	8b 45 f4             	mov    -0xc(%ebp),%eax
 754:	0f b6 00             	movzbl (%eax),%eax
 757:	0f be c0             	movsbl %al,%eax
 75a:	83 ec 08             	sub    $0x8,%esp
 75d:	50                   	push   %eax
 75e:	ff 75 08             	pushl  0x8(%ebp)
 761:	e8 31 fe ff ff       	call   597 <putc>
 766:	83 c4 10             	add    $0x10,%esp
          s++;
 769:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 76d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 770:	0f b6 00             	movzbl (%eax),%eax
 773:	84 c0                	test   %al,%al
 775:	75 da                	jne    751 <printf+0xe3>
 777:	eb 65                	jmp    7de <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 779:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 77d:	75 1d                	jne    79c <printf+0x12e>
        putc(fd, *ap);
 77f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 782:	8b 00                	mov    (%eax),%eax
 784:	0f be c0             	movsbl %al,%eax
 787:	83 ec 08             	sub    $0x8,%esp
 78a:	50                   	push   %eax
 78b:	ff 75 08             	pushl  0x8(%ebp)
 78e:	e8 04 fe ff ff       	call   597 <putc>
 793:	83 c4 10             	add    $0x10,%esp
        ap++;
 796:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 79a:	eb 42                	jmp    7de <printf+0x170>
      } else if(c == '%'){
 79c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7a0:	75 17                	jne    7b9 <printf+0x14b>
        putc(fd, c);
 7a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7a5:	0f be c0             	movsbl %al,%eax
 7a8:	83 ec 08             	sub    $0x8,%esp
 7ab:	50                   	push   %eax
 7ac:	ff 75 08             	pushl  0x8(%ebp)
 7af:	e8 e3 fd ff ff       	call   597 <putc>
 7b4:	83 c4 10             	add    $0x10,%esp
 7b7:	eb 25                	jmp    7de <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7b9:	83 ec 08             	sub    $0x8,%esp
 7bc:	6a 25                	push   $0x25
 7be:	ff 75 08             	pushl  0x8(%ebp)
 7c1:	e8 d1 fd ff ff       	call   597 <putc>
 7c6:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 7c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7cc:	0f be c0             	movsbl %al,%eax
 7cf:	83 ec 08             	sub    $0x8,%esp
 7d2:	50                   	push   %eax
 7d3:	ff 75 08             	pushl  0x8(%ebp)
 7d6:	e8 bc fd ff ff       	call   597 <putc>
 7db:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7de:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7e5:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7e9:	8b 55 0c             	mov    0xc(%ebp),%edx
 7ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ef:	01 d0                	add    %edx,%eax
 7f1:	0f b6 00             	movzbl (%eax),%eax
 7f4:	84 c0                	test   %al,%al
 7f6:	0f 85 94 fe ff ff    	jne    690 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7fc:	90                   	nop
 7fd:	c9                   	leave  
 7fe:	c3                   	ret    

000007ff <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ff:	55                   	push   %ebp
 800:	89 e5                	mov    %esp,%ebp
 802:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 805:	8b 45 08             	mov    0x8(%ebp),%eax
 808:	83 e8 08             	sub    $0x8,%eax
 80b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80e:	a1 28 0d 00 00       	mov    0xd28,%eax
 813:	89 45 fc             	mov    %eax,-0x4(%ebp)
 816:	eb 24                	jmp    83c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 818:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81b:	8b 00                	mov    (%eax),%eax
 81d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 820:	77 12                	ja     834 <free+0x35>
 822:	8b 45 f8             	mov    -0x8(%ebp),%eax
 825:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 828:	77 24                	ja     84e <free+0x4f>
 82a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82d:	8b 00                	mov    (%eax),%eax
 82f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 832:	77 1a                	ja     84e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 834:	8b 45 fc             	mov    -0x4(%ebp),%eax
 837:	8b 00                	mov    (%eax),%eax
 839:	89 45 fc             	mov    %eax,-0x4(%ebp)
 83c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 83f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 842:	76 d4                	jbe    818 <free+0x19>
 844:	8b 45 fc             	mov    -0x4(%ebp),%eax
 847:	8b 00                	mov    (%eax),%eax
 849:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 84c:	76 ca                	jbe    818 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 84e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 851:	8b 40 04             	mov    0x4(%eax),%eax
 854:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 85b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85e:	01 c2                	add    %eax,%edx
 860:	8b 45 fc             	mov    -0x4(%ebp),%eax
 863:	8b 00                	mov    (%eax),%eax
 865:	39 c2                	cmp    %eax,%edx
 867:	75 24                	jne    88d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 869:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86c:	8b 50 04             	mov    0x4(%eax),%edx
 86f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 872:	8b 00                	mov    (%eax),%eax
 874:	8b 40 04             	mov    0x4(%eax),%eax
 877:	01 c2                	add    %eax,%edx
 879:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 87f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 882:	8b 00                	mov    (%eax),%eax
 884:	8b 10                	mov    (%eax),%edx
 886:	8b 45 f8             	mov    -0x8(%ebp),%eax
 889:	89 10                	mov    %edx,(%eax)
 88b:	eb 0a                	jmp    897 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 88d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 890:	8b 10                	mov    (%eax),%edx
 892:	8b 45 f8             	mov    -0x8(%ebp),%eax
 895:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 897:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89a:	8b 40 04             	mov    0x4(%eax),%eax
 89d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a7:	01 d0                	add    %edx,%eax
 8a9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8ac:	75 20                	jne    8ce <free+0xcf>
    p->s.size += bp->s.size;
 8ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b1:	8b 50 04             	mov    0x4(%eax),%edx
 8b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b7:	8b 40 04             	mov    0x4(%eax),%eax
 8ba:	01 c2                	add    %eax,%edx
 8bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c5:	8b 10                	mov    (%eax),%edx
 8c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ca:	89 10                	mov    %edx,(%eax)
 8cc:	eb 08                	jmp    8d6 <free+0xd7>
  } else
    p->s.ptr = bp;
 8ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8d4:	89 10                	mov    %edx,(%eax)
  freep = p;
 8d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d9:	a3 28 0d 00 00       	mov    %eax,0xd28
}
 8de:	90                   	nop
 8df:	c9                   	leave  
 8e0:	c3                   	ret    

000008e1 <morecore>:

static Header*
morecore(uint nu)
{
 8e1:	55                   	push   %ebp
 8e2:	89 e5                	mov    %esp,%ebp
 8e4:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8e7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8ee:	77 07                	ja     8f7 <morecore+0x16>
    nu = 4096;
 8f0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8f7:	8b 45 08             	mov    0x8(%ebp),%eax
 8fa:	c1 e0 03             	shl    $0x3,%eax
 8fd:	83 ec 0c             	sub    $0xc,%esp
 900:	50                   	push   %eax
 901:	e8 69 fc ff ff       	call   56f <sbrk>
 906:	83 c4 10             	add    $0x10,%esp
 909:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 90c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 910:	75 07                	jne    919 <morecore+0x38>
    return 0;
 912:	b8 00 00 00 00       	mov    $0x0,%eax
 917:	eb 26                	jmp    93f <morecore+0x5e>
  hp = (Header*)p;
 919:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 91f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 922:	8b 55 08             	mov    0x8(%ebp),%edx
 925:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 928:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92b:	83 c0 08             	add    $0x8,%eax
 92e:	83 ec 0c             	sub    $0xc,%esp
 931:	50                   	push   %eax
 932:	e8 c8 fe ff ff       	call   7ff <free>
 937:	83 c4 10             	add    $0x10,%esp
  return freep;
 93a:	a1 28 0d 00 00       	mov    0xd28,%eax
}
 93f:	c9                   	leave  
 940:	c3                   	ret    

00000941 <malloc>:

void*
malloc(uint nbytes)
{
 941:	55                   	push   %ebp
 942:	89 e5                	mov    %esp,%ebp
 944:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 947:	8b 45 08             	mov    0x8(%ebp),%eax
 94a:	83 c0 07             	add    $0x7,%eax
 94d:	c1 e8 03             	shr    $0x3,%eax
 950:	83 c0 01             	add    $0x1,%eax
 953:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 956:	a1 28 0d 00 00       	mov    0xd28,%eax
 95b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 95e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 962:	75 23                	jne    987 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 964:	c7 45 f0 20 0d 00 00 	movl   $0xd20,-0x10(%ebp)
 96b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 96e:	a3 28 0d 00 00       	mov    %eax,0xd28
 973:	a1 28 0d 00 00       	mov    0xd28,%eax
 978:	a3 20 0d 00 00       	mov    %eax,0xd20
    base.s.size = 0;
 97d:	c7 05 24 0d 00 00 00 	movl   $0x0,0xd24
 984:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 987:	8b 45 f0             	mov    -0x10(%ebp),%eax
 98a:	8b 00                	mov    (%eax),%eax
 98c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 98f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 992:	8b 40 04             	mov    0x4(%eax),%eax
 995:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 998:	72 4d                	jb     9e7 <malloc+0xa6>
      if(p->s.size == nunits)
 99a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99d:	8b 40 04             	mov    0x4(%eax),%eax
 9a0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9a3:	75 0c                	jne    9b1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a8:	8b 10                	mov    (%eax),%edx
 9aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ad:	89 10                	mov    %edx,(%eax)
 9af:	eb 26                	jmp    9d7 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b4:	8b 40 04             	mov    0x4(%eax),%eax
 9b7:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9ba:	89 c2                	mov    %eax,%edx
 9bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bf:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c5:	8b 40 04             	mov    0x4(%eax),%eax
 9c8:	c1 e0 03             	shl    $0x3,%eax
 9cb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9d4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9da:	a3 28 0d 00 00       	mov    %eax,0xd28
      return (void*)(p + 1);
 9df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e2:	83 c0 08             	add    $0x8,%eax
 9e5:	eb 3b                	jmp    a22 <malloc+0xe1>
    }
    if(p == freep)
 9e7:	a1 28 0d 00 00       	mov    0xd28,%eax
 9ec:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9ef:	75 1e                	jne    a0f <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 9f1:	83 ec 0c             	sub    $0xc,%esp
 9f4:	ff 75 ec             	pushl  -0x14(%ebp)
 9f7:	e8 e5 fe ff ff       	call   8e1 <morecore>
 9fc:	83 c4 10             	add    $0x10,%esp
 9ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a06:	75 07                	jne    a0f <malloc+0xce>
        return 0;
 a08:	b8 00 00 00 00       	mov    $0x0,%eax
 a0d:	eb 13                	jmp    a22 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a12:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a18:	8b 00                	mov    (%eax),%eax
 a1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a1d:	e9 6d ff ff ff       	jmp    98f <malloc+0x4e>
}
 a22:	c9                   	leave  
 a23:	c3                   	ret    
