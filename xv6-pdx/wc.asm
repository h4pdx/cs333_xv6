
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
  32:	05 80 0d 00 00       	add    $0xd80,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 80 0d 00 00       	add    $0xd80,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	83 ec 08             	sub    $0x8,%esp
  53:	50                   	push   %eax
  54:	68 74 0a 00 00       	push   $0xa74
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
  93:	68 80 0d 00 00       	push   $0xd80
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
  b9:	68 7a 0a 00 00       	push   $0xa7a
  be:	6a 01                	push   $0x1
  c0:	e8 f9 05 00 00       	call   6be <printf>
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
  dc:	68 8a 0a 00 00       	push   $0xa8a
  e1:	6a 01                	push   $0x1
  e3:	e8 d6 05 00 00       	call   6be <printf>
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
 10a:	68 97 0a 00 00       	push   $0xa97
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
 167:	68 98 0a 00 00       	push   $0xa98
 16c:	6a 01                	push   $0x1
 16e:	e8 4b 05 00 00       	call   6be <printf>
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

00000597 <getuid>:
SYSCALL(getuid)
 597:	b8 18 00 00 00       	mov    $0x18,%eax
 59c:	cd 40                	int    $0x40
 59e:	c3                   	ret    

0000059f <getgid>:
SYSCALL(getgid)
 59f:	b8 19 00 00 00       	mov    $0x19,%eax
 5a4:	cd 40                	int    $0x40
 5a6:	c3                   	ret    

000005a7 <getppid>:
SYSCALL(getppid)
 5a7:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5ac:	cd 40                	int    $0x40
 5ae:	c3                   	ret    

000005af <setuid>:
SYSCALL(setuid)
 5af:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5b4:	cd 40                	int    $0x40
 5b6:	c3                   	ret    

000005b7 <setgid>:
SYSCALL(setgid)
 5b7:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5bc:	cd 40                	int    $0x40
 5be:	c3                   	ret    

000005bf <getprocs>:
SYSCALL(getprocs)
 5bf:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5c4:	cd 40                	int    $0x40
 5c6:	c3                   	ret    

000005c7 <setpriority>:
SYSCALL(setpriority)
 5c7:	b8 1e 00 00 00       	mov    $0x1e,%eax
 5cc:	cd 40                	int    $0x40
 5ce:	c3                   	ret    

000005cf <chmod>:
SYSCALL(chmod)
 5cf:	b8 1f 00 00 00       	mov    $0x1f,%eax
 5d4:	cd 40                	int    $0x40
 5d6:	c3                   	ret    

000005d7 <chown>:
SYSCALL(chown)
 5d7:	b8 20 00 00 00       	mov    $0x20,%eax
 5dc:	cd 40                	int    $0x40
 5de:	c3                   	ret    

000005df <chgrp>:
SYSCALL(chgrp)
 5df:	b8 21 00 00 00       	mov    $0x21,%eax
 5e4:	cd 40                	int    $0x40
 5e6:	c3                   	ret    

000005e7 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5e7:	55                   	push   %ebp
 5e8:	89 e5                	mov    %esp,%ebp
 5ea:	83 ec 18             	sub    $0x18,%esp
 5ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f0:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5f3:	83 ec 04             	sub    $0x4,%esp
 5f6:	6a 01                	push   $0x1
 5f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5fb:	50                   	push   %eax
 5fc:	ff 75 08             	pushl  0x8(%ebp)
 5ff:	e8 03 ff ff ff       	call   507 <write>
 604:	83 c4 10             	add    $0x10,%esp
}
 607:	90                   	nop
 608:	c9                   	leave  
 609:	c3                   	ret    

0000060a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 60a:	55                   	push   %ebp
 60b:	89 e5                	mov    %esp,%ebp
 60d:	53                   	push   %ebx
 60e:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 611:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 618:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 61c:	74 17                	je     635 <printint+0x2b>
 61e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 622:	79 11                	jns    635 <printint+0x2b>
    neg = 1;
 624:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 62b:	8b 45 0c             	mov    0xc(%ebp),%eax
 62e:	f7 d8                	neg    %eax
 630:	89 45 ec             	mov    %eax,-0x14(%ebp)
 633:	eb 06                	jmp    63b <printint+0x31>
  } else {
    x = xx;
 635:	8b 45 0c             	mov    0xc(%ebp),%eax
 638:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 63b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 642:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 645:	8d 41 01             	lea    0x1(%ecx),%eax
 648:	89 45 f4             	mov    %eax,-0xc(%ebp)
 64b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 64e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 651:	ba 00 00 00 00       	mov    $0x0,%edx
 656:	f7 f3                	div    %ebx
 658:	89 d0                	mov    %edx,%eax
 65a:	0f b6 80 40 0d 00 00 	movzbl 0xd40(%eax),%eax
 661:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 665:	8b 5d 10             	mov    0x10(%ebp),%ebx
 668:	8b 45 ec             	mov    -0x14(%ebp),%eax
 66b:	ba 00 00 00 00       	mov    $0x0,%edx
 670:	f7 f3                	div    %ebx
 672:	89 45 ec             	mov    %eax,-0x14(%ebp)
 675:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 679:	75 c7                	jne    642 <printint+0x38>
  if(neg)
 67b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 67f:	74 2d                	je     6ae <printint+0xa4>
    buf[i++] = '-';
 681:	8b 45 f4             	mov    -0xc(%ebp),%eax
 684:	8d 50 01             	lea    0x1(%eax),%edx
 687:	89 55 f4             	mov    %edx,-0xc(%ebp)
 68a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 68f:	eb 1d                	jmp    6ae <printint+0xa4>
    putc(fd, buf[i]);
 691:	8d 55 dc             	lea    -0x24(%ebp),%edx
 694:	8b 45 f4             	mov    -0xc(%ebp),%eax
 697:	01 d0                	add    %edx,%eax
 699:	0f b6 00             	movzbl (%eax),%eax
 69c:	0f be c0             	movsbl %al,%eax
 69f:	83 ec 08             	sub    $0x8,%esp
 6a2:	50                   	push   %eax
 6a3:	ff 75 08             	pushl  0x8(%ebp)
 6a6:	e8 3c ff ff ff       	call   5e7 <putc>
 6ab:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6ae:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6b6:	79 d9                	jns    691 <printint+0x87>
    putc(fd, buf[i]);
}
 6b8:	90                   	nop
 6b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6bc:	c9                   	leave  
 6bd:	c3                   	ret    

000006be <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6be:	55                   	push   %ebp
 6bf:	89 e5                	mov    %esp,%ebp
 6c1:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6c4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6cb:	8d 45 0c             	lea    0xc(%ebp),%eax
 6ce:	83 c0 04             	add    $0x4,%eax
 6d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6d4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6db:	e9 59 01 00 00       	jmp    839 <printf+0x17b>
    c = fmt[i] & 0xff;
 6e0:	8b 55 0c             	mov    0xc(%ebp),%edx
 6e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e6:	01 d0                	add    %edx,%eax
 6e8:	0f b6 00             	movzbl (%eax),%eax
 6eb:	0f be c0             	movsbl %al,%eax
 6ee:	25 ff 00 00 00       	and    $0xff,%eax
 6f3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6f6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6fa:	75 2c                	jne    728 <printf+0x6a>
      if(c == '%'){
 6fc:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 700:	75 0c                	jne    70e <printf+0x50>
        state = '%';
 702:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 709:	e9 27 01 00 00       	jmp    835 <printf+0x177>
      } else {
        putc(fd, c);
 70e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 711:	0f be c0             	movsbl %al,%eax
 714:	83 ec 08             	sub    $0x8,%esp
 717:	50                   	push   %eax
 718:	ff 75 08             	pushl  0x8(%ebp)
 71b:	e8 c7 fe ff ff       	call   5e7 <putc>
 720:	83 c4 10             	add    $0x10,%esp
 723:	e9 0d 01 00 00       	jmp    835 <printf+0x177>
      }
    } else if(state == '%'){
 728:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 72c:	0f 85 03 01 00 00    	jne    835 <printf+0x177>
      if(c == 'd'){
 732:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 736:	75 1e                	jne    756 <printf+0x98>
        printint(fd, *ap, 10, 1);
 738:	8b 45 e8             	mov    -0x18(%ebp),%eax
 73b:	8b 00                	mov    (%eax),%eax
 73d:	6a 01                	push   $0x1
 73f:	6a 0a                	push   $0xa
 741:	50                   	push   %eax
 742:	ff 75 08             	pushl  0x8(%ebp)
 745:	e8 c0 fe ff ff       	call   60a <printint>
 74a:	83 c4 10             	add    $0x10,%esp
        ap++;
 74d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 751:	e9 d8 00 00 00       	jmp    82e <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 756:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 75a:	74 06                	je     762 <printf+0xa4>
 75c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 760:	75 1e                	jne    780 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 762:	8b 45 e8             	mov    -0x18(%ebp),%eax
 765:	8b 00                	mov    (%eax),%eax
 767:	6a 00                	push   $0x0
 769:	6a 10                	push   $0x10
 76b:	50                   	push   %eax
 76c:	ff 75 08             	pushl  0x8(%ebp)
 76f:	e8 96 fe ff ff       	call   60a <printint>
 774:	83 c4 10             	add    $0x10,%esp
        ap++;
 777:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 77b:	e9 ae 00 00 00       	jmp    82e <printf+0x170>
      } else if(c == 's'){
 780:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 784:	75 43                	jne    7c9 <printf+0x10b>
        s = (char*)*ap;
 786:	8b 45 e8             	mov    -0x18(%ebp),%eax
 789:	8b 00                	mov    (%eax),%eax
 78b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 78e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 792:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 796:	75 25                	jne    7bd <printf+0xff>
          s = "(null)";
 798:	c7 45 f4 ac 0a 00 00 	movl   $0xaac,-0xc(%ebp)
        while(*s != 0){
 79f:	eb 1c                	jmp    7bd <printf+0xff>
          putc(fd, *s);
 7a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a4:	0f b6 00             	movzbl (%eax),%eax
 7a7:	0f be c0             	movsbl %al,%eax
 7aa:	83 ec 08             	sub    $0x8,%esp
 7ad:	50                   	push   %eax
 7ae:	ff 75 08             	pushl  0x8(%ebp)
 7b1:	e8 31 fe ff ff       	call   5e7 <putc>
 7b6:	83 c4 10             	add    $0x10,%esp
          s++;
 7b9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c0:	0f b6 00             	movzbl (%eax),%eax
 7c3:	84 c0                	test   %al,%al
 7c5:	75 da                	jne    7a1 <printf+0xe3>
 7c7:	eb 65                	jmp    82e <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7c9:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7cd:	75 1d                	jne    7ec <printf+0x12e>
        putc(fd, *ap);
 7cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7d2:	8b 00                	mov    (%eax),%eax
 7d4:	0f be c0             	movsbl %al,%eax
 7d7:	83 ec 08             	sub    $0x8,%esp
 7da:	50                   	push   %eax
 7db:	ff 75 08             	pushl  0x8(%ebp)
 7de:	e8 04 fe ff ff       	call   5e7 <putc>
 7e3:	83 c4 10             	add    $0x10,%esp
        ap++;
 7e6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7ea:	eb 42                	jmp    82e <printf+0x170>
      } else if(c == '%'){
 7ec:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7f0:	75 17                	jne    809 <printf+0x14b>
        putc(fd, c);
 7f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7f5:	0f be c0             	movsbl %al,%eax
 7f8:	83 ec 08             	sub    $0x8,%esp
 7fb:	50                   	push   %eax
 7fc:	ff 75 08             	pushl  0x8(%ebp)
 7ff:	e8 e3 fd ff ff       	call   5e7 <putc>
 804:	83 c4 10             	add    $0x10,%esp
 807:	eb 25                	jmp    82e <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 809:	83 ec 08             	sub    $0x8,%esp
 80c:	6a 25                	push   $0x25
 80e:	ff 75 08             	pushl  0x8(%ebp)
 811:	e8 d1 fd ff ff       	call   5e7 <putc>
 816:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 819:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 81c:	0f be c0             	movsbl %al,%eax
 81f:	83 ec 08             	sub    $0x8,%esp
 822:	50                   	push   %eax
 823:	ff 75 08             	pushl  0x8(%ebp)
 826:	e8 bc fd ff ff       	call   5e7 <putc>
 82b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 82e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 835:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 839:	8b 55 0c             	mov    0xc(%ebp),%edx
 83c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83f:	01 d0                	add    %edx,%eax
 841:	0f b6 00             	movzbl (%eax),%eax
 844:	84 c0                	test   %al,%al
 846:	0f 85 94 fe ff ff    	jne    6e0 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 84c:	90                   	nop
 84d:	c9                   	leave  
 84e:	c3                   	ret    

0000084f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 84f:	55                   	push   %ebp
 850:	89 e5                	mov    %esp,%ebp
 852:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 855:	8b 45 08             	mov    0x8(%ebp),%eax
 858:	83 e8 08             	sub    $0x8,%eax
 85b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85e:	a1 68 0d 00 00       	mov    0xd68,%eax
 863:	89 45 fc             	mov    %eax,-0x4(%ebp)
 866:	eb 24                	jmp    88c <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 868:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86b:	8b 00                	mov    (%eax),%eax
 86d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 870:	77 12                	ja     884 <free+0x35>
 872:	8b 45 f8             	mov    -0x8(%ebp),%eax
 875:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 878:	77 24                	ja     89e <free+0x4f>
 87a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87d:	8b 00                	mov    (%eax),%eax
 87f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 882:	77 1a                	ja     89e <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 884:	8b 45 fc             	mov    -0x4(%ebp),%eax
 887:	8b 00                	mov    (%eax),%eax
 889:	89 45 fc             	mov    %eax,-0x4(%ebp)
 88c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 892:	76 d4                	jbe    868 <free+0x19>
 894:	8b 45 fc             	mov    -0x4(%ebp),%eax
 897:	8b 00                	mov    (%eax),%eax
 899:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 89c:	76 ca                	jbe    868 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 89e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a1:	8b 40 04             	mov    0x4(%eax),%eax
 8a4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ae:	01 c2                	add    %eax,%edx
 8b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b3:	8b 00                	mov    (%eax),%eax
 8b5:	39 c2                	cmp    %eax,%edx
 8b7:	75 24                	jne    8dd <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8bc:	8b 50 04             	mov    0x4(%eax),%edx
 8bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c2:	8b 00                	mov    (%eax),%eax
 8c4:	8b 40 04             	mov    0x4(%eax),%eax
 8c7:	01 c2                	add    %eax,%edx
 8c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cc:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d2:	8b 00                	mov    (%eax),%eax
 8d4:	8b 10                	mov    (%eax),%edx
 8d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d9:	89 10                	mov    %edx,(%eax)
 8db:	eb 0a                	jmp    8e7 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e0:	8b 10                	mov    (%eax),%edx
 8e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e5:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 8e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ea:	8b 40 04             	mov    0x4(%eax),%eax
 8ed:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f7:	01 d0                	add    %edx,%eax
 8f9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8fc:	75 20                	jne    91e <free+0xcf>
    p->s.size += bp->s.size;
 8fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 901:	8b 50 04             	mov    0x4(%eax),%edx
 904:	8b 45 f8             	mov    -0x8(%ebp),%eax
 907:	8b 40 04             	mov    0x4(%eax),%eax
 90a:	01 c2                	add    %eax,%edx
 90c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 912:	8b 45 f8             	mov    -0x8(%ebp),%eax
 915:	8b 10                	mov    (%eax),%edx
 917:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91a:	89 10                	mov    %edx,(%eax)
 91c:	eb 08                	jmp    926 <free+0xd7>
  } else
    p->s.ptr = bp;
 91e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 921:	8b 55 f8             	mov    -0x8(%ebp),%edx
 924:	89 10                	mov    %edx,(%eax)
  freep = p;
 926:	8b 45 fc             	mov    -0x4(%ebp),%eax
 929:	a3 68 0d 00 00       	mov    %eax,0xd68
}
 92e:	90                   	nop
 92f:	c9                   	leave  
 930:	c3                   	ret    

00000931 <morecore>:

static Header*
morecore(uint nu)
{
 931:	55                   	push   %ebp
 932:	89 e5                	mov    %esp,%ebp
 934:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 937:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 93e:	77 07                	ja     947 <morecore+0x16>
    nu = 4096;
 940:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 947:	8b 45 08             	mov    0x8(%ebp),%eax
 94a:	c1 e0 03             	shl    $0x3,%eax
 94d:	83 ec 0c             	sub    $0xc,%esp
 950:	50                   	push   %eax
 951:	e8 19 fc ff ff       	call   56f <sbrk>
 956:	83 c4 10             	add    $0x10,%esp
 959:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 95c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 960:	75 07                	jne    969 <morecore+0x38>
    return 0;
 962:	b8 00 00 00 00       	mov    $0x0,%eax
 967:	eb 26                	jmp    98f <morecore+0x5e>
  hp = (Header*)p;
 969:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 96f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 972:	8b 55 08             	mov    0x8(%ebp),%edx
 975:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 978:	8b 45 f0             	mov    -0x10(%ebp),%eax
 97b:	83 c0 08             	add    $0x8,%eax
 97e:	83 ec 0c             	sub    $0xc,%esp
 981:	50                   	push   %eax
 982:	e8 c8 fe ff ff       	call   84f <free>
 987:	83 c4 10             	add    $0x10,%esp
  return freep;
 98a:	a1 68 0d 00 00       	mov    0xd68,%eax
}
 98f:	c9                   	leave  
 990:	c3                   	ret    

00000991 <malloc>:

void*
malloc(uint nbytes)
{
 991:	55                   	push   %ebp
 992:	89 e5                	mov    %esp,%ebp
 994:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 997:	8b 45 08             	mov    0x8(%ebp),%eax
 99a:	83 c0 07             	add    $0x7,%eax
 99d:	c1 e8 03             	shr    $0x3,%eax
 9a0:	83 c0 01             	add    $0x1,%eax
 9a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9a6:	a1 68 0d 00 00       	mov    0xd68,%eax
 9ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9b2:	75 23                	jne    9d7 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9b4:	c7 45 f0 60 0d 00 00 	movl   $0xd60,-0x10(%ebp)
 9bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9be:	a3 68 0d 00 00       	mov    %eax,0xd68
 9c3:	a1 68 0d 00 00       	mov    0xd68,%eax
 9c8:	a3 60 0d 00 00       	mov    %eax,0xd60
    base.s.size = 0;
 9cd:	c7 05 64 0d 00 00 00 	movl   $0x0,0xd64
 9d4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9da:	8b 00                	mov    (%eax),%eax
 9dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e2:	8b 40 04             	mov    0x4(%eax),%eax
 9e5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9e8:	72 4d                	jb     a37 <malloc+0xa6>
      if(p->s.size == nunits)
 9ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ed:	8b 40 04             	mov    0x4(%eax),%eax
 9f0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9f3:	75 0c                	jne    a01 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f8:	8b 10                	mov    (%eax),%edx
 9fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9fd:	89 10                	mov    %edx,(%eax)
 9ff:	eb 26                	jmp    a27 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a04:	8b 40 04             	mov    0x4(%eax),%eax
 a07:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a0a:	89 c2                	mov    %eax,%edx
 a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a15:	8b 40 04             	mov    0x4(%eax),%eax
 a18:	c1 e0 03             	shl    $0x3,%eax
 a1b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a21:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a24:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2a:	a3 68 0d 00 00       	mov    %eax,0xd68
      return (void*)(p + 1);
 a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a32:	83 c0 08             	add    $0x8,%eax
 a35:	eb 3b                	jmp    a72 <malloc+0xe1>
    }
    if(p == freep)
 a37:	a1 68 0d 00 00       	mov    0xd68,%eax
 a3c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a3f:	75 1e                	jne    a5f <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a41:	83 ec 0c             	sub    $0xc,%esp
 a44:	ff 75 ec             	pushl  -0x14(%ebp)
 a47:	e8 e5 fe ff ff       	call   931 <morecore>
 a4c:	83 c4 10             	add    $0x10,%esp
 a4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a56:	75 07                	jne    a5f <malloc+0xce>
        return 0;
 a58:	b8 00 00 00 00       	mov    $0x0,%eax
 a5d:	eb 13                	jmp    a72 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a62:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a68:	8b 00                	mov    (%eax),%eax
 a6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a6d:	e9 6d ff ff ff       	jmp    9df <malloc+0x4e>
}
 a72:	c9                   	leave  
 a73:	c3                   	ret    
