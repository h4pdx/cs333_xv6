
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n, m;
  char *p, *q;
  
  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
   d:	e9 b6 00 00 00       	jmp    c8 <grep+0xc8>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    buf[m] = '\0';
  18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1b:	05 40 0f 00 00       	add    $0xf40,%eax
  20:	c6 00 00             	movb   $0x0,(%eax)
    p = buf;
  23:	c7 45 f0 40 0f 00 00 	movl   $0xf40,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  2a:	eb 4a                	jmp    76 <grep+0x76>
      *q = 0;
  2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2f:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  32:	83 ec 08             	sub    $0x8,%esp
  35:	ff 75 f0             	pushl  -0x10(%ebp)
  38:	ff 75 08             	pushl  0x8(%ebp)
  3b:	e8 9a 01 00 00       	call   1da <match>
  40:	83 c4 10             	add    $0x10,%esp
  43:	85 c0                	test   %eax,%eax
  45:	74 26                	je     6d <grep+0x6d>
        *q = '\n';
  47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  4a:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  50:	83 c0 01             	add    $0x1,%eax
  53:	89 c2                	mov    %eax,%edx
  55:	8b 45 f0             	mov    -0x10(%ebp),%eax
  58:	29 c2                	sub    %eax,%edx
  5a:	89 d0                	mov    %edx,%eax
  5c:	83 ec 04             	sub    $0x4,%esp
  5f:	50                   	push   %eax
  60:	ff 75 f0             	pushl  -0x10(%ebp)
  63:	6a 01                	push   $0x1
  65:	e8 16 06 00 00       	call   680 <write>
  6a:	83 c4 10             	add    $0x10,%esp
      }
      p = q+1;
  6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  70:	83 c0 01             	add    $0x1,%eax
  73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    m += n;
    buf[m] = '\0';
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  76:	83 ec 08             	sub    $0x8,%esp
  79:	6a 0a                	push   $0xa
  7b:	ff 75 f0             	pushl  -0x10(%ebp)
  7e:	e8 89 03 00 00       	call   40c <strchr>
  83:	83 c4 10             	add    $0x10,%esp
  86:	89 45 e8             	mov    %eax,-0x18(%ebp)
  89:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8d:	75 9d                	jne    2c <grep+0x2c>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  8f:	81 7d f0 40 0f 00 00 	cmpl   $0xf40,-0x10(%ebp)
  96:	75 07                	jne    9f <grep+0x9f>
      m = 0;
  98:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a3:	7e 23                	jle    c8 <grep+0xc8>
      m -= p - buf;
  a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  a8:	ba 40 0f 00 00       	mov    $0xf40,%edx
  ad:	29 d0                	sub    %edx,%eax
  af:	29 45 f4             	sub    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  b2:	83 ec 04             	sub    $0x4,%esp
  b5:	ff 75 f4             	pushl  -0xc(%ebp)
  b8:	ff 75 f0             	pushl  -0x10(%ebp)
  bb:	68 40 0f 00 00       	push   $0xf40
  c0:	e8 56 05 00 00       	call   61b <memmove>
  c5:	83 c4 10             	add    $0x10,%esp
{
  int n, m;
  char *p, *q;
  
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  cb:	ba ff 03 00 00       	mov    $0x3ff,%edx
  d0:	29 c2                	sub    %eax,%edx
  d2:	89 d0                	mov    %edx,%eax
  d4:	89 c2                	mov    %eax,%edx
  d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d9:	05 40 0f 00 00       	add    $0xf40,%eax
  de:	83 ec 04             	sub    $0x4,%esp
  e1:	52                   	push   %edx
  e2:	50                   	push   %eax
  e3:	ff 75 0c             	pushl  0xc(%ebp)
  e6:	e8 8d 05 00 00       	call   678 <read>
  eb:	83 c4 10             	add    $0x10,%esp
  ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  f5:	0f 8f 17 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
  fb:	90                   	nop
  fc:	c9                   	leave  
  fd:	c3                   	ret    

000000fe <main>:

int
main(int argc, char *argv[])
{
  fe:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 102:	83 e4 f0             	and    $0xfffffff0,%esp
 105:	ff 71 fc             	pushl  -0x4(%ecx)
 108:	55                   	push   %ebp
 109:	89 e5                	mov    %esp,%ebp
 10b:	53                   	push   %ebx
 10c:	51                   	push   %ecx
 10d:	83 ec 10             	sub    $0x10,%esp
 110:	89 cb                	mov    %ecx,%ebx
  int fd, i;
  char *pattern;
  
  if(argc <= 1){
 112:	83 3b 01             	cmpl   $0x1,(%ebx)
 115:	7f 17                	jg     12e <main+0x30>
    printf(2, "usage: grep pattern [file ...]\n");
 117:	83 ec 08             	sub    $0x8,%esp
 11a:	68 d0 0b 00 00       	push   $0xbd0
 11f:	6a 02                	push   $0x2
 121:	e8 f1 06 00 00       	call   817 <printf>
 126:	83 c4 10             	add    $0x10,%esp
    exit();
 129:	e8 32 05 00 00       	call   660 <exit>
  }
  pattern = argv[1];
 12e:	8b 43 04             	mov    0x4(%ebx),%eax
 131:	8b 40 04             	mov    0x4(%eax),%eax
 134:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  if(argc <= 2){
 137:	83 3b 02             	cmpl   $0x2,(%ebx)
 13a:	7f 15                	jg     151 <main+0x53>
    grep(pattern, 0);
 13c:	83 ec 08             	sub    $0x8,%esp
 13f:	6a 00                	push   $0x0
 141:	ff 75 f0             	pushl  -0x10(%ebp)
 144:	e8 b7 fe ff ff       	call   0 <grep>
 149:	83 c4 10             	add    $0x10,%esp
    exit();
 14c:	e8 0f 05 00 00       	call   660 <exit>
  }

  for(i = 2; i < argc; i++){
 151:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
 158:	eb 74                	jmp    1ce <main+0xd0>
    if((fd = open(argv[i], 0)) < 0){
 15a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 15d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 164:	8b 43 04             	mov    0x4(%ebx),%eax
 167:	01 d0                	add    %edx,%eax
 169:	8b 00                	mov    (%eax),%eax
 16b:	83 ec 08             	sub    $0x8,%esp
 16e:	6a 00                	push   $0x0
 170:	50                   	push   %eax
 171:	e8 2a 05 00 00       	call   6a0 <open>
 176:	83 c4 10             	add    $0x10,%esp
 179:	89 45 ec             	mov    %eax,-0x14(%ebp)
 17c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 180:	79 29                	jns    1ab <main+0xad>
      printf(1, "grep: cannot open %s\n", argv[i]);
 182:	8b 45 f4             	mov    -0xc(%ebp),%eax
 185:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 18c:	8b 43 04             	mov    0x4(%ebx),%eax
 18f:	01 d0                	add    %edx,%eax
 191:	8b 00                	mov    (%eax),%eax
 193:	83 ec 04             	sub    $0x4,%esp
 196:	50                   	push   %eax
 197:	68 f0 0b 00 00       	push   $0xbf0
 19c:	6a 01                	push   $0x1
 19e:	e8 74 06 00 00       	call   817 <printf>
 1a3:	83 c4 10             	add    $0x10,%esp
      exit();
 1a6:	e8 b5 04 00 00       	call   660 <exit>
    }
    grep(pattern, fd);
 1ab:	83 ec 08             	sub    $0x8,%esp
 1ae:	ff 75 ec             	pushl  -0x14(%ebp)
 1b1:	ff 75 f0             	pushl  -0x10(%ebp)
 1b4:	e8 47 fe ff ff       	call   0 <grep>
 1b9:	83 c4 10             	add    $0x10,%esp
    close(fd);
 1bc:	83 ec 0c             	sub    $0xc,%esp
 1bf:	ff 75 ec             	pushl  -0x14(%ebp)
 1c2:	e8 c1 04 00 00       	call   688 <close>
 1c7:	83 c4 10             	add    $0x10,%esp
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d1:	3b 03                	cmp    (%ebx),%eax
 1d3:	7c 85                	jl     15a <main+0x5c>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1d5:	e8 86 04 00 00       	call   660 <exit>

000001da <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1da:	55                   	push   %ebp
 1db:	89 e5                	mov    %esp,%ebp
 1dd:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '^')
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	0f b6 00             	movzbl (%eax),%eax
 1e6:	3c 5e                	cmp    $0x5e,%al
 1e8:	75 17                	jne    201 <match+0x27>
    return matchhere(re+1, text);
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	83 c0 01             	add    $0x1,%eax
 1f0:	83 ec 08             	sub    $0x8,%esp
 1f3:	ff 75 0c             	pushl  0xc(%ebp)
 1f6:	50                   	push   %eax
 1f7:	e8 38 00 00 00       	call   234 <matchhere>
 1fc:	83 c4 10             	add    $0x10,%esp
 1ff:	eb 31                	jmp    232 <match+0x58>
  do{  // must look at empty string
    if(matchhere(re, text))
 201:	83 ec 08             	sub    $0x8,%esp
 204:	ff 75 0c             	pushl  0xc(%ebp)
 207:	ff 75 08             	pushl  0x8(%ebp)
 20a:	e8 25 00 00 00       	call   234 <matchhere>
 20f:	83 c4 10             	add    $0x10,%esp
 212:	85 c0                	test   %eax,%eax
 214:	74 07                	je     21d <match+0x43>
      return 1;
 216:	b8 01 00 00 00       	mov    $0x1,%eax
 21b:	eb 15                	jmp    232 <match+0x58>
  }while(*text++ != '\0');
 21d:	8b 45 0c             	mov    0xc(%ebp),%eax
 220:	8d 50 01             	lea    0x1(%eax),%edx
 223:	89 55 0c             	mov    %edx,0xc(%ebp)
 226:	0f b6 00             	movzbl (%eax),%eax
 229:	84 c0                	test   %al,%al
 22b:	75 d4                	jne    201 <match+0x27>
  return 0;
 22d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 232:	c9                   	leave  
 233:	c3                   	ret    

00000234 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	83 ec 08             	sub    $0x8,%esp
  if(re[0] == '\0')
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	0f b6 00             	movzbl (%eax),%eax
 240:	84 c0                	test   %al,%al
 242:	75 0a                	jne    24e <matchhere+0x1a>
    return 1;
 244:	b8 01 00 00 00       	mov    $0x1,%eax
 249:	e9 99 00 00 00       	jmp    2e7 <matchhere+0xb3>
  if(re[1] == '*')
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	83 c0 01             	add    $0x1,%eax
 254:	0f b6 00             	movzbl (%eax),%eax
 257:	3c 2a                	cmp    $0x2a,%al
 259:	75 21                	jne    27c <matchhere+0x48>
    return matchstar(re[0], re+2, text);
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	8d 50 02             	lea    0x2(%eax),%edx
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	0f b6 00             	movzbl (%eax),%eax
 267:	0f be c0             	movsbl %al,%eax
 26a:	83 ec 04             	sub    $0x4,%esp
 26d:	ff 75 0c             	pushl  0xc(%ebp)
 270:	52                   	push   %edx
 271:	50                   	push   %eax
 272:	e8 72 00 00 00       	call   2e9 <matchstar>
 277:	83 c4 10             	add    $0x10,%esp
 27a:	eb 6b                	jmp    2e7 <matchhere+0xb3>
  if(re[0] == '$' && re[1] == '\0')
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	0f b6 00             	movzbl (%eax),%eax
 282:	3c 24                	cmp    $0x24,%al
 284:	75 1d                	jne    2a3 <matchhere+0x6f>
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	83 c0 01             	add    $0x1,%eax
 28c:	0f b6 00             	movzbl (%eax),%eax
 28f:	84 c0                	test   %al,%al
 291:	75 10                	jne    2a3 <matchhere+0x6f>
    return *text == '\0';
 293:	8b 45 0c             	mov    0xc(%ebp),%eax
 296:	0f b6 00             	movzbl (%eax),%eax
 299:	84 c0                	test   %al,%al
 29b:	0f 94 c0             	sete   %al
 29e:	0f b6 c0             	movzbl %al,%eax
 2a1:	eb 44                	jmp    2e7 <matchhere+0xb3>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a6:	0f b6 00             	movzbl (%eax),%eax
 2a9:	84 c0                	test   %al,%al
 2ab:	74 35                	je     2e2 <matchhere+0xae>
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	0f b6 00             	movzbl (%eax),%eax
 2b3:	3c 2e                	cmp    $0x2e,%al
 2b5:	74 10                	je     2c7 <matchhere+0x93>
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	0f b6 10             	movzbl (%eax),%edx
 2bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c0:	0f b6 00             	movzbl (%eax),%eax
 2c3:	38 c2                	cmp    %al,%dl
 2c5:	75 1b                	jne    2e2 <matchhere+0xae>
    return matchhere(re+1, text+1);
 2c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ca:	8d 50 01             	lea    0x1(%eax),%edx
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
 2d0:	83 c0 01             	add    $0x1,%eax
 2d3:	83 ec 08             	sub    $0x8,%esp
 2d6:	52                   	push   %edx
 2d7:	50                   	push   %eax
 2d8:	e8 57 ff ff ff       	call   234 <matchhere>
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	eb 05                	jmp    2e7 <matchhere+0xb3>
  return 0;
 2e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2e7:	c9                   	leave  
 2e8:	c3                   	ret    

000002e9 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2e9:	55                   	push   %ebp
 2ea:	89 e5                	mov    %esp,%ebp
 2ec:	83 ec 08             	sub    $0x8,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 2ef:	83 ec 08             	sub    $0x8,%esp
 2f2:	ff 75 10             	pushl  0x10(%ebp)
 2f5:	ff 75 0c             	pushl  0xc(%ebp)
 2f8:	e8 37 ff ff ff       	call   234 <matchhere>
 2fd:	83 c4 10             	add    $0x10,%esp
 300:	85 c0                	test   %eax,%eax
 302:	74 07                	je     30b <matchstar+0x22>
      return 1;
 304:	b8 01 00 00 00       	mov    $0x1,%eax
 309:	eb 29                	jmp    334 <matchstar+0x4b>
  }while(*text!='\0' && (*text++==c || c=='.'));
 30b:	8b 45 10             	mov    0x10(%ebp),%eax
 30e:	0f b6 00             	movzbl (%eax),%eax
 311:	84 c0                	test   %al,%al
 313:	74 1a                	je     32f <matchstar+0x46>
 315:	8b 45 10             	mov    0x10(%ebp),%eax
 318:	8d 50 01             	lea    0x1(%eax),%edx
 31b:	89 55 10             	mov    %edx,0x10(%ebp)
 31e:	0f b6 00             	movzbl (%eax),%eax
 321:	0f be c0             	movsbl %al,%eax
 324:	3b 45 08             	cmp    0x8(%ebp),%eax
 327:	74 c6                	je     2ef <matchstar+0x6>
 329:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 32d:	74 c0                	je     2ef <matchstar+0x6>
  return 0;
 32f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 334:	c9                   	leave  
 335:	c3                   	ret    

00000336 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 336:	55                   	push   %ebp
 337:	89 e5                	mov    %esp,%ebp
 339:	57                   	push   %edi
 33a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 33b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 33e:	8b 55 10             	mov    0x10(%ebp),%edx
 341:	8b 45 0c             	mov    0xc(%ebp),%eax
 344:	89 cb                	mov    %ecx,%ebx
 346:	89 df                	mov    %ebx,%edi
 348:	89 d1                	mov    %edx,%ecx
 34a:	fc                   	cld    
 34b:	f3 aa                	rep stos %al,%es:(%edi)
 34d:	89 ca                	mov    %ecx,%edx
 34f:	89 fb                	mov    %edi,%ebx
 351:	89 5d 08             	mov    %ebx,0x8(%ebp)
 354:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 357:	90                   	nop
 358:	5b                   	pop    %ebx
 359:	5f                   	pop    %edi
 35a:	5d                   	pop    %ebp
 35b:	c3                   	ret    

0000035c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 362:	8b 45 08             	mov    0x8(%ebp),%eax
 365:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 368:	90                   	nop
 369:	8b 45 08             	mov    0x8(%ebp),%eax
 36c:	8d 50 01             	lea    0x1(%eax),%edx
 36f:	89 55 08             	mov    %edx,0x8(%ebp)
 372:	8b 55 0c             	mov    0xc(%ebp),%edx
 375:	8d 4a 01             	lea    0x1(%edx),%ecx
 378:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 37b:	0f b6 12             	movzbl (%edx),%edx
 37e:	88 10                	mov    %dl,(%eax)
 380:	0f b6 00             	movzbl (%eax),%eax
 383:	84 c0                	test   %al,%al
 385:	75 e2                	jne    369 <strcpy+0xd>
    ;
  return os;
 387:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 38a:	c9                   	leave  
 38b:	c3                   	ret    

0000038c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 38c:	55                   	push   %ebp
 38d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 38f:	eb 08                	jmp    399 <strcmp+0xd>
    p++, q++;
 391:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 395:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 399:	8b 45 08             	mov    0x8(%ebp),%eax
 39c:	0f b6 00             	movzbl (%eax),%eax
 39f:	84 c0                	test   %al,%al
 3a1:	74 10                	je     3b3 <strcmp+0x27>
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
 3a6:	0f b6 10             	movzbl (%eax),%edx
 3a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ac:	0f b6 00             	movzbl (%eax),%eax
 3af:	38 c2                	cmp    %al,%dl
 3b1:	74 de                	je     391 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	0f b6 00             	movzbl (%eax),%eax
 3b9:	0f b6 d0             	movzbl %al,%edx
 3bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bf:	0f b6 00             	movzbl (%eax),%eax
 3c2:	0f b6 c0             	movzbl %al,%eax
 3c5:	29 c2                	sub    %eax,%edx
 3c7:	89 d0                	mov    %edx,%eax
}
 3c9:	5d                   	pop    %ebp
 3ca:	c3                   	ret    

000003cb <strlen>:

uint
strlen(char *s)
{
 3cb:	55                   	push   %ebp
 3cc:	89 e5                	mov    %esp,%ebp
 3ce:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3d1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3d8:	eb 04                	jmp    3de <strlen+0x13>
 3da:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3de:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3e1:	8b 45 08             	mov    0x8(%ebp),%eax
 3e4:	01 d0                	add    %edx,%eax
 3e6:	0f b6 00             	movzbl (%eax),%eax
 3e9:	84 c0                	test   %al,%al
 3eb:	75 ed                	jne    3da <strlen+0xf>
    ;
  return n;
 3ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3f0:	c9                   	leave  
 3f1:	c3                   	ret    

000003f2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3f5:	8b 45 10             	mov    0x10(%ebp),%eax
 3f8:	50                   	push   %eax
 3f9:	ff 75 0c             	pushl  0xc(%ebp)
 3fc:	ff 75 08             	pushl  0x8(%ebp)
 3ff:	e8 32 ff ff ff       	call   336 <stosb>
 404:	83 c4 0c             	add    $0xc,%esp
  return dst;
 407:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40a:	c9                   	leave  
 40b:	c3                   	ret    

0000040c <strchr>:

char*
strchr(const char *s, char c)
{
 40c:	55                   	push   %ebp
 40d:	89 e5                	mov    %esp,%ebp
 40f:	83 ec 04             	sub    $0x4,%esp
 412:	8b 45 0c             	mov    0xc(%ebp),%eax
 415:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 418:	eb 14                	jmp    42e <strchr+0x22>
    if(*s == c)
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	0f b6 00             	movzbl (%eax),%eax
 420:	3a 45 fc             	cmp    -0x4(%ebp),%al
 423:	75 05                	jne    42a <strchr+0x1e>
      return (char*)s;
 425:	8b 45 08             	mov    0x8(%ebp),%eax
 428:	eb 13                	jmp    43d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 42a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 42e:	8b 45 08             	mov    0x8(%ebp),%eax
 431:	0f b6 00             	movzbl (%eax),%eax
 434:	84 c0                	test   %al,%al
 436:	75 e2                	jne    41a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 438:	b8 00 00 00 00       	mov    $0x0,%eax
}
 43d:	c9                   	leave  
 43e:	c3                   	ret    

0000043f <gets>:

char*
gets(char *buf, int max)
{
 43f:	55                   	push   %ebp
 440:	89 e5                	mov    %esp,%ebp
 442:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 445:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 44c:	eb 42                	jmp    490 <gets+0x51>
    cc = read(0, &c, 1);
 44e:	83 ec 04             	sub    $0x4,%esp
 451:	6a 01                	push   $0x1
 453:	8d 45 ef             	lea    -0x11(%ebp),%eax
 456:	50                   	push   %eax
 457:	6a 00                	push   $0x0
 459:	e8 1a 02 00 00       	call   678 <read>
 45e:	83 c4 10             	add    $0x10,%esp
 461:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 464:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 468:	7e 33                	jle    49d <gets+0x5e>
      break;
    buf[i++] = c;
 46a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 46d:	8d 50 01             	lea    0x1(%eax),%edx
 470:	89 55 f4             	mov    %edx,-0xc(%ebp)
 473:	89 c2                	mov    %eax,%edx
 475:	8b 45 08             	mov    0x8(%ebp),%eax
 478:	01 c2                	add    %eax,%edx
 47a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 47e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 480:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 484:	3c 0a                	cmp    $0xa,%al
 486:	74 16                	je     49e <gets+0x5f>
 488:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 48c:	3c 0d                	cmp    $0xd,%al
 48e:	74 0e                	je     49e <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 490:	8b 45 f4             	mov    -0xc(%ebp),%eax
 493:	83 c0 01             	add    $0x1,%eax
 496:	3b 45 0c             	cmp    0xc(%ebp),%eax
 499:	7c b3                	jl     44e <gets+0xf>
 49b:	eb 01                	jmp    49e <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 49d:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 49e:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4a1:	8b 45 08             	mov    0x8(%ebp),%eax
 4a4:	01 d0                	add    %edx,%eax
 4a6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4ac:	c9                   	leave  
 4ad:	c3                   	ret    

000004ae <stat>:

int
stat(char *n, struct stat *st)
{
 4ae:	55                   	push   %ebp
 4af:	89 e5                	mov    %esp,%ebp
 4b1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4b4:	83 ec 08             	sub    $0x8,%esp
 4b7:	6a 00                	push   $0x0
 4b9:	ff 75 08             	pushl  0x8(%ebp)
 4bc:	e8 df 01 00 00       	call   6a0 <open>
 4c1:	83 c4 10             	add    $0x10,%esp
 4c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4cb:	79 07                	jns    4d4 <stat+0x26>
    return -1;
 4cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4d2:	eb 25                	jmp    4f9 <stat+0x4b>
  r = fstat(fd, st);
 4d4:	83 ec 08             	sub    $0x8,%esp
 4d7:	ff 75 0c             	pushl  0xc(%ebp)
 4da:	ff 75 f4             	pushl  -0xc(%ebp)
 4dd:	e8 d6 01 00 00       	call   6b8 <fstat>
 4e2:	83 c4 10             	add    $0x10,%esp
 4e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4e8:	83 ec 0c             	sub    $0xc,%esp
 4eb:	ff 75 f4             	pushl  -0xc(%ebp)
 4ee:	e8 95 01 00 00       	call   688 <close>
 4f3:	83 c4 10             	add    $0x10,%esp
  return r;
 4f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4f9:	c9                   	leave  
 4fa:	c3                   	ret    

000004fb <atoi>:

int
atoi(const char *s)
{
 4fb:	55                   	push   %ebp
 4fc:	89 e5                	mov    %esp,%ebp
 4fe:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 501:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 508:	eb 04                	jmp    50e <atoi+0x13>
 50a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 50e:	8b 45 08             	mov    0x8(%ebp),%eax
 511:	0f b6 00             	movzbl (%eax),%eax
 514:	3c 20                	cmp    $0x20,%al
 516:	74 f2                	je     50a <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 518:	8b 45 08             	mov    0x8(%ebp),%eax
 51b:	0f b6 00             	movzbl (%eax),%eax
 51e:	3c 2d                	cmp    $0x2d,%al
 520:	75 07                	jne    529 <atoi+0x2e>
 522:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 527:	eb 05                	jmp    52e <atoi+0x33>
 529:	b8 01 00 00 00       	mov    $0x1,%eax
 52e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 531:	8b 45 08             	mov    0x8(%ebp),%eax
 534:	0f b6 00             	movzbl (%eax),%eax
 537:	3c 2b                	cmp    $0x2b,%al
 539:	74 0a                	je     545 <atoi+0x4a>
 53b:	8b 45 08             	mov    0x8(%ebp),%eax
 53e:	0f b6 00             	movzbl (%eax),%eax
 541:	3c 2d                	cmp    $0x2d,%al
 543:	75 2b                	jne    570 <atoi+0x75>
    s++;
 545:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 549:	eb 25                	jmp    570 <atoi+0x75>
    n = n*10 + *s++ - '0';
 54b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 54e:	89 d0                	mov    %edx,%eax
 550:	c1 e0 02             	shl    $0x2,%eax
 553:	01 d0                	add    %edx,%eax
 555:	01 c0                	add    %eax,%eax
 557:	89 c1                	mov    %eax,%ecx
 559:	8b 45 08             	mov    0x8(%ebp),%eax
 55c:	8d 50 01             	lea    0x1(%eax),%edx
 55f:	89 55 08             	mov    %edx,0x8(%ebp)
 562:	0f b6 00             	movzbl (%eax),%eax
 565:	0f be c0             	movsbl %al,%eax
 568:	01 c8                	add    %ecx,%eax
 56a:	83 e8 30             	sub    $0x30,%eax
 56d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 570:	8b 45 08             	mov    0x8(%ebp),%eax
 573:	0f b6 00             	movzbl (%eax),%eax
 576:	3c 2f                	cmp    $0x2f,%al
 578:	7e 0a                	jle    584 <atoi+0x89>
 57a:	8b 45 08             	mov    0x8(%ebp),%eax
 57d:	0f b6 00             	movzbl (%eax),%eax
 580:	3c 39                	cmp    $0x39,%al
 582:	7e c7                	jle    54b <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 584:	8b 45 f8             	mov    -0x8(%ebp),%eax
 587:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 58b:	c9                   	leave  
 58c:	c3                   	ret    

0000058d <atoo>:

int
atoo(const char *s)
{
 58d:	55                   	push   %ebp
 58e:	89 e5                	mov    %esp,%ebp
 590:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 593:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 59a:	eb 04                	jmp    5a0 <atoo+0x13>
 59c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 5a0:	8b 45 08             	mov    0x8(%ebp),%eax
 5a3:	0f b6 00             	movzbl (%eax),%eax
 5a6:	3c 20                	cmp    $0x20,%al
 5a8:	74 f2                	je     59c <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 5aa:	8b 45 08             	mov    0x8(%ebp),%eax
 5ad:	0f b6 00             	movzbl (%eax),%eax
 5b0:	3c 2d                	cmp    $0x2d,%al
 5b2:	75 07                	jne    5bb <atoo+0x2e>
 5b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 5b9:	eb 05                	jmp    5c0 <atoo+0x33>
 5bb:	b8 01 00 00 00       	mov    $0x1,%eax
 5c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 5c3:	8b 45 08             	mov    0x8(%ebp),%eax
 5c6:	0f b6 00             	movzbl (%eax),%eax
 5c9:	3c 2b                	cmp    $0x2b,%al
 5cb:	74 0a                	je     5d7 <atoo+0x4a>
 5cd:	8b 45 08             	mov    0x8(%ebp),%eax
 5d0:	0f b6 00             	movzbl (%eax),%eax
 5d3:	3c 2d                	cmp    $0x2d,%al
 5d5:	75 27                	jne    5fe <atoo+0x71>
    s++;
 5d7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 5db:	eb 21                	jmp    5fe <atoo+0x71>
    n = n*8 + *s++ - '0';
 5dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5e0:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 5e7:	8b 45 08             	mov    0x8(%ebp),%eax
 5ea:	8d 50 01             	lea    0x1(%eax),%edx
 5ed:	89 55 08             	mov    %edx,0x8(%ebp)
 5f0:	0f b6 00             	movzbl (%eax),%eax
 5f3:	0f be c0             	movsbl %al,%eax
 5f6:	01 c8                	add    %ecx,%eax
 5f8:	83 e8 30             	sub    $0x30,%eax
 5fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 5fe:	8b 45 08             	mov    0x8(%ebp),%eax
 601:	0f b6 00             	movzbl (%eax),%eax
 604:	3c 2f                	cmp    $0x2f,%al
 606:	7e 0a                	jle    612 <atoo+0x85>
 608:	8b 45 08             	mov    0x8(%ebp),%eax
 60b:	0f b6 00             	movzbl (%eax),%eax
 60e:	3c 37                	cmp    $0x37,%al
 610:	7e cb                	jle    5dd <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 612:	8b 45 f8             	mov    -0x8(%ebp),%eax
 615:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 619:	c9                   	leave  
 61a:	c3                   	ret    

0000061b <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 61b:	55                   	push   %ebp
 61c:	89 e5                	mov    %esp,%ebp
 61e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 621:	8b 45 08             	mov    0x8(%ebp),%eax
 624:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 627:	8b 45 0c             	mov    0xc(%ebp),%eax
 62a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 62d:	eb 17                	jmp    646 <memmove+0x2b>
    *dst++ = *src++;
 62f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 632:	8d 50 01             	lea    0x1(%eax),%edx
 635:	89 55 fc             	mov    %edx,-0x4(%ebp)
 638:	8b 55 f8             	mov    -0x8(%ebp),%edx
 63b:	8d 4a 01             	lea    0x1(%edx),%ecx
 63e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 641:	0f b6 12             	movzbl (%edx),%edx
 644:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 646:	8b 45 10             	mov    0x10(%ebp),%eax
 649:	8d 50 ff             	lea    -0x1(%eax),%edx
 64c:	89 55 10             	mov    %edx,0x10(%ebp)
 64f:	85 c0                	test   %eax,%eax
 651:	7f dc                	jg     62f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 653:	8b 45 08             	mov    0x8(%ebp),%eax
}
 656:	c9                   	leave  
 657:	c3                   	ret    

00000658 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 658:	b8 01 00 00 00       	mov    $0x1,%eax
 65d:	cd 40                	int    $0x40
 65f:	c3                   	ret    

00000660 <exit>:
SYSCALL(exit)
 660:	b8 02 00 00 00       	mov    $0x2,%eax
 665:	cd 40                	int    $0x40
 667:	c3                   	ret    

00000668 <wait>:
SYSCALL(wait)
 668:	b8 03 00 00 00       	mov    $0x3,%eax
 66d:	cd 40                	int    $0x40
 66f:	c3                   	ret    

00000670 <pipe>:
SYSCALL(pipe)
 670:	b8 04 00 00 00       	mov    $0x4,%eax
 675:	cd 40                	int    $0x40
 677:	c3                   	ret    

00000678 <read>:
SYSCALL(read)
 678:	b8 05 00 00 00       	mov    $0x5,%eax
 67d:	cd 40                	int    $0x40
 67f:	c3                   	ret    

00000680 <write>:
SYSCALL(write)
 680:	b8 10 00 00 00       	mov    $0x10,%eax
 685:	cd 40                	int    $0x40
 687:	c3                   	ret    

00000688 <close>:
SYSCALL(close)
 688:	b8 15 00 00 00       	mov    $0x15,%eax
 68d:	cd 40                	int    $0x40
 68f:	c3                   	ret    

00000690 <kill>:
SYSCALL(kill)
 690:	b8 06 00 00 00       	mov    $0x6,%eax
 695:	cd 40                	int    $0x40
 697:	c3                   	ret    

00000698 <exec>:
SYSCALL(exec)
 698:	b8 07 00 00 00       	mov    $0x7,%eax
 69d:	cd 40                	int    $0x40
 69f:	c3                   	ret    

000006a0 <open>:
SYSCALL(open)
 6a0:	b8 0f 00 00 00       	mov    $0xf,%eax
 6a5:	cd 40                	int    $0x40
 6a7:	c3                   	ret    

000006a8 <mknod>:
SYSCALL(mknod)
 6a8:	b8 11 00 00 00       	mov    $0x11,%eax
 6ad:	cd 40                	int    $0x40
 6af:	c3                   	ret    

000006b0 <unlink>:
SYSCALL(unlink)
 6b0:	b8 12 00 00 00       	mov    $0x12,%eax
 6b5:	cd 40                	int    $0x40
 6b7:	c3                   	ret    

000006b8 <fstat>:
SYSCALL(fstat)
 6b8:	b8 08 00 00 00       	mov    $0x8,%eax
 6bd:	cd 40                	int    $0x40
 6bf:	c3                   	ret    

000006c0 <link>:
SYSCALL(link)
 6c0:	b8 13 00 00 00       	mov    $0x13,%eax
 6c5:	cd 40                	int    $0x40
 6c7:	c3                   	ret    

000006c8 <mkdir>:
SYSCALL(mkdir)
 6c8:	b8 14 00 00 00       	mov    $0x14,%eax
 6cd:	cd 40                	int    $0x40
 6cf:	c3                   	ret    

000006d0 <chdir>:
SYSCALL(chdir)
 6d0:	b8 09 00 00 00       	mov    $0x9,%eax
 6d5:	cd 40                	int    $0x40
 6d7:	c3                   	ret    

000006d8 <dup>:
SYSCALL(dup)
 6d8:	b8 0a 00 00 00       	mov    $0xa,%eax
 6dd:	cd 40                	int    $0x40
 6df:	c3                   	ret    

000006e0 <getpid>:
SYSCALL(getpid)
 6e0:	b8 0b 00 00 00       	mov    $0xb,%eax
 6e5:	cd 40                	int    $0x40
 6e7:	c3                   	ret    

000006e8 <sbrk>:
SYSCALL(sbrk)
 6e8:	b8 0c 00 00 00       	mov    $0xc,%eax
 6ed:	cd 40                	int    $0x40
 6ef:	c3                   	ret    

000006f0 <sleep>:
SYSCALL(sleep)
 6f0:	b8 0d 00 00 00       	mov    $0xd,%eax
 6f5:	cd 40                	int    $0x40
 6f7:	c3                   	ret    

000006f8 <uptime>:
SYSCALL(uptime)
 6f8:	b8 0e 00 00 00       	mov    $0xe,%eax
 6fd:	cd 40                	int    $0x40
 6ff:	c3                   	ret    

00000700 <halt>:
SYSCALL(halt)
 700:	b8 16 00 00 00       	mov    $0x16,%eax
 705:	cd 40                	int    $0x40
 707:	c3                   	ret    

00000708 <date>:
SYSCALL(date)
 708:	b8 17 00 00 00       	mov    $0x17,%eax
 70d:	cd 40                	int    $0x40
 70f:	c3                   	ret    

00000710 <getuid>:
SYSCALL(getuid)
 710:	b8 18 00 00 00       	mov    $0x18,%eax
 715:	cd 40                	int    $0x40
 717:	c3                   	ret    

00000718 <getgid>:
SYSCALL(getgid)
 718:	b8 19 00 00 00       	mov    $0x19,%eax
 71d:	cd 40                	int    $0x40
 71f:	c3                   	ret    

00000720 <getppid>:
SYSCALL(getppid)
 720:	b8 1a 00 00 00       	mov    $0x1a,%eax
 725:	cd 40                	int    $0x40
 727:	c3                   	ret    

00000728 <setuid>:
SYSCALL(setuid)
 728:	b8 1b 00 00 00       	mov    $0x1b,%eax
 72d:	cd 40                	int    $0x40
 72f:	c3                   	ret    

00000730 <setgid>:
SYSCALL(setgid)
 730:	b8 1c 00 00 00       	mov    $0x1c,%eax
 735:	cd 40                	int    $0x40
 737:	c3                   	ret    

00000738 <getprocs>:
SYSCALL(getprocs)
 738:	b8 1d 00 00 00       	mov    $0x1d,%eax
 73d:	cd 40                	int    $0x40
 73f:	c3                   	ret    

00000740 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 740:	55                   	push   %ebp
 741:	89 e5                	mov    %esp,%ebp
 743:	83 ec 18             	sub    $0x18,%esp
 746:	8b 45 0c             	mov    0xc(%ebp),%eax
 749:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 74c:	83 ec 04             	sub    $0x4,%esp
 74f:	6a 01                	push   $0x1
 751:	8d 45 f4             	lea    -0xc(%ebp),%eax
 754:	50                   	push   %eax
 755:	ff 75 08             	pushl  0x8(%ebp)
 758:	e8 23 ff ff ff       	call   680 <write>
 75d:	83 c4 10             	add    $0x10,%esp
}
 760:	90                   	nop
 761:	c9                   	leave  
 762:	c3                   	ret    

00000763 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 763:	55                   	push   %ebp
 764:	89 e5                	mov    %esp,%ebp
 766:	53                   	push   %ebx
 767:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 76a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 771:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 775:	74 17                	je     78e <printint+0x2b>
 777:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 77b:	79 11                	jns    78e <printint+0x2b>
    neg = 1;
 77d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 784:	8b 45 0c             	mov    0xc(%ebp),%eax
 787:	f7 d8                	neg    %eax
 789:	89 45 ec             	mov    %eax,-0x14(%ebp)
 78c:	eb 06                	jmp    794 <printint+0x31>
  } else {
    x = xx;
 78e:	8b 45 0c             	mov    0xc(%ebp),%eax
 791:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 794:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 79b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 79e:	8d 41 01             	lea    0x1(%ecx),%eax
 7a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7aa:	ba 00 00 00 00       	mov    $0x0,%edx
 7af:	f7 f3                	div    %ebx
 7b1:	89 d0                	mov    %edx,%eax
 7b3:	0f b6 80 fc 0e 00 00 	movzbl 0xefc(%eax),%eax
 7ba:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 7be:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7c4:	ba 00 00 00 00       	mov    $0x0,%edx
 7c9:	f7 f3                	div    %ebx
 7cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7ce:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7d2:	75 c7                	jne    79b <printint+0x38>
  if(neg)
 7d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7d8:	74 2d                	je     807 <printint+0xa4>
    buf[i++] = '-';
 7da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7dd:	8d 50 01             	lea    0x1(%eax),%edx
 7e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
 7e3:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 7e8:	eb 1d                	jmp    807 <printint+0xa4>
    putc(fd, buf[i]);
 7ea:	8d 55 dc             	lea    -0x24(%ebp),%edx
 7ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f0:	01 d0                	add    %edx,%eax
 7f2:	0f b6 00             	movzbl (%eax),%eax
 7f5:	0f be c0             	movsbl %al,%eax
 7f8:	83 ec 08             	sub    $0x8,%esp
 7fb:	50                   	push   %eax
 7fc:	ff 75 08             	pushl  0x8(%ebp)
 7ff:	e8 3c ff ff ff       	call   740 <putc>
 804:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 807:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 80b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 80f:	79 d9                	jns    7ea <printint+0x87>
    putc(fd, buf[i]);
}
 811:	90                   	nop
 812:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 815:	c9                   	leave  
 816:	c3                   	ret    

00000817 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 817:	55                   	push   %ebp
 818:	89 e5                	mov    %esp,%ebp
 81a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 81d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 824:	8d 45 0c             	lea    0xc(%ebp),%eax
 827:	83 c0 04             	add    $0x4,%eax
 82a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 82d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 834:	e9 59 01 00 00       	jmp    992 <printf+0x17b>
    c = fmt[i] & 0xff;
 839:	8b 55 0c             	mov    0xc(%ebp),%edx
 83c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83f:	01 d0                	add    %edx,%eax
 841:	0f b6 00             	movzbl (%eax),%eax
 844:	0f be c0             	movsbl %al,%eax
 847:	25 ff 00 00 00       	and    $0xff,%eax
 84c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 84f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 853:	75 2c                	jne    881 <printf+0x6a>
      if(c == '%'){
 855:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 859:	75 0c                	jne    867 <printf+0x50>
        state = '%';
 85b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 862:	e9 27 01 00 00       	jmp    98e <printf+0x177>
      } else {
        putc(fd, c);
 867:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 86a:	0f be c0             	movsbl %al,%eax
 86d:	83 ec 08             	sub    $0x8,%esp
 870:	50                   	push   %eax
 871:	ff 75 08             	pushl  0x8(%ebp)
 874:	e8 c7 fe ff ff       	call   740 <putc>
 879:	83 c4 10             	add    $0x10,%esp
 87c:	e9 0d 01 00 00       	jmp    98e <printf+0x177>
      }
    } else if(state == '%'){
 881:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 885:	0f 85 03 01 00 00    	jne    98e <printf+0x177>
      if(c == 'd'){
 88b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 88f:	75 1e                	jne    8af <printf+0x98>
        printint(fd, *ap, 10, 1);
 891:	8b 45 e8             	mov    -0x18(%ebp),%eax
 894:	8b 00                	mov    (%eax),%eax
 896:	6a 01                	push   $0x1
 898:	6a 0a                	push   $0xa
 89a:	50                   	push   %eax
 89b:	ff 75 08             	pushl  0x8(%ebp)
 89e:	e8 c0 fe ff ff       	call   763 <printint>
 8a3:	83 c4 10             	add    $0x10,%esp
        ap++;
 8a6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8aa:	e9 d8 00 00 00       	jmp    987 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 8af:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 8b3:	74 06                	je     8bb <printf+0xa4>
 8b5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 8b9:	75 1e                	jne    8d9 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 8bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8be:	8b 00                	mov    (%eax),%eax
 8c0:	6a 00                	push   $0x0
 8c2:	6a 10                	push   $0x10
 8c4:	50                   	push   %eax
 8c5:	ff 75 08             	pushl  0x8(%ebp)
 8c8:	e8 96 fe ff ff       	call   763 <printint>
 8cd:	83 c4 10             	add    $0x10,%esp
        ap++;
 8d0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8d4:	e9 ae 00 00 00       	jmp    987 <printf+0x170>
      } else if(c == 's'){
 8d9:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 8dd:	75 43                	jne    922 <printf+0x10b>
        s = (char*)*ap;
 8df:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8e2:	8b 00                	mov    (%eax),%eax
 8e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 8e7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 8eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8ef:	75 25                	jne    916 <printf+0xff>
          s = "(null)";
 8f1:	c7 45 f4 06 0c 00 00 	movl   $0xc06,-0xc(%ebp)
        while(*s != 0){
 8f8:	eb 1c                	jmp    916 <printf+0xff>
          putc(fd, *s);
 8fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fd:	0f b6 00             	movzbl (%eax),%eax
 900:	0f be c0             	movsbl %al,%eax
 903:	83 ec 08             	sub    $0x8,%esp
 906:	50                   	push   %eax
 907:	ff 75 08             	pushl  0x8(%ebp)
 90a:	e8 31 fe ff ff       	call   740 <putc>
 90f:	83 c4 10             	add    $0x10,%esp
          s++;
 912:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 916:	8b 45 f4             	mov    -0xc(%ebp),%eax
 919:	0f b6 00             	movzbl (%eax),%eax
 91c:	84 c0                	test   %al,%al
 91e:	75 da                	jne    8fa <printf+0xe3>
 920:	eb 65                	jmp    987 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 922:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 926:	75 1d                	jne    945 <printf+0x12e>
        putc(fd, *ap);
 928:	8b 45 e8             	mov    -0x18(%ebp),%eax
 92b:	8b 00                	mov    (%eax),%eax
 92d:	0f be c0             	movsbl %al,%eax
 930:	83 ec 08             	sub    $0x8,%esp
 933:	50                   	push   %eax
 934:	ff 75 08             	pushl  0x8(%ebp)
 937:	e8 04 fe ff ff       	call   740 <putc>
 93c:	83 c4 10             	add    $0x10,%esp
        ap++;
 93f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 943:	eb 42                	jmp    987 <printf+0x170>
      } else if(c == '%'){
 945:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 949:	75 17                	jne    962 <printf+0x14b>
        putc(fd, c);
 94b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 94e:	0f be c0             	movsbl %al,%eax
 951:	83 ec 08             	sub    $0x8,%esp
 954:	50                   	push   %eax
 955:	ff 75 08             	pushl  0x8(%ebp)
 958:	e8 e3 fd ff ff       	call   740 <putc>
 95d:	83 c4 10             	add    $0x10,%esp
 960:	eb 25                	jmp    987 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 962:	83 ec 08             	sub    $0x8,%esp
 965:	6a 25                	push   $0x25
 967:	ff 75 08             	pushl  0x8(%ebp)
 96a:	e8 d1 fd ff ff       	call   740 <putc>
 96f:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 972:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 975:	0f be c0             	movsbl %al,%eax
 978:	83 ec 08             	sub    $0x8,%esp
 97b:	50                   	push   %eax
 97c:	ff 75 08             	pushl  0x8(%ebp)
 97f:	e8 bc fd ff ff       	call   740 <putc>
 984:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 987:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 98e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 992:	8b 55 0c             	mov    0xc(%ebp),%edx
 995:	8b 45 f0             	mov    -0x10(%ebp),%eax
 998:	01 d0                	add    %edx,%eax
 99a:	0f b6 00             	movzbl (%eax),%eax
 99d:	84 c0                	test   %al,%al
 99f:	0f 85 94 fe ff ff    	jne    839 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 9a5:	90                   	nop
 9a6:	c9                   	leave  
 9a7:	c3                   	ret    

000009a8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9a8:	55                   	push   %ebp
 9a9:	89 e5                	mov    %esp,%ebp
 9ab:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9ae:	8b 45 08             	mov    0x8(%ebp),%eax
 9b1:	83 e8 08             	sub    $0x8,%eax
 9b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b7:	a1 28 0f 00 00       	mov    0xf28,%eax
 9bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9bf:	eb 24                	jmp    9e5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c4:	8b 00                	mov    (%eax),%eax
 9c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9c9:	77 12                	ja     9dd <free+0x35>
 9cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ce:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9d1:	77 24                	ja     9f7 <free+0x4f>
 9d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d6:	8b 00                	mov    (%eax),%eax
 9d8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9db:	77 1a                	ja     9f7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e0:	8b 00                	mov    (%eax),%eax
 9e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9eb:	76 d4                	jbe    9c1 <free+0x19>
 9ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f0:	8b 00                	mov    (%eax),%eax
 9f2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9f5:	76 ca                	jbe    9c1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 9f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9fa:	8b 40 04             	mov    0x4(%eax),%eax
 9fd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a04:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a07:	01 c2                	add    %eax,%edx
 a09:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a0c:	8b 00                	mov    (%eax),%eax
 a0e:	39 c2                	cmp    %eax,%edx
 a10:	75 24                	jne    a36 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a12:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a15:	8b 50 04             	mov    0x4(%eax),%edx
 a18:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a1b:	8b 00                	mov    (%eax),%eax
 a1d:	8b 40 04             	mov    0x4(%eax),%eax
 a20:	01 c2                	add    %eax,%edx
 a22:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a25:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a28:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a2b:	8b 00                	mov    (%eax),%eax
 a2d:	8b 10                	mov    (%eax),%edx
 a2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a32:	89 10                	mov    %edx,(%eax)
 a34:	eb 0a                	jmp    a40 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a36:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a39:	8b 10                	mov    (%eax),%edx
 a3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a3e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a40:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a43:	8b 40 04             	mov    0x4(%eax),%eax
 a46:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a50:	01 d0                	add    %edx,%eax
 a52:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a55:	75 20                	jne    a77 <free+0xcf>
    p->s.size += bp->s.size;
 a57:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a5a:	8b 50 04             	mov    0x4(%eax),%edx
 a5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a60:	8b 40 04             	mov    0x4(%eax),%eax
 a63:	01 c2                	add    %eax,%edx
 a65:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a68:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a6e:	8b 10                	mov    (%eax),%edx
 a70:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a73:	89 10                	mov    %edx,(%eax)
 a75:	eb 08                	jmp    a7f <free+0xd7>
  } else
    p->s.ptr = bp;
 a77:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a7a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a7d:	89 10                	mov    %edx,(%eax)
  freep = p;
 a7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a82:	a3 28 0f 00 00       	mov    %eax,0xf28
}
 a87:	90                   	nop
 a88:	c9                   	leave  
 a89:	c3                   	ret    

00000a8a <morecore>:

static Header*
morecore(uint nu)
{
 a8a:	55                   	push   %ebp
 a8b:	89 e5                	mov    %esp,%ebp
 a8d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a90:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a97:	77 07                	ja     aa0 <morecore+0x16>
    nu = 4096;
 a99:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 aa0:	8b 45 08             	mov    0x8(%ebp),%eax
 aa3:	c1 e0 03             	shl    $0x3,%eax
 aa6:	83 ec 0c             	sub    $0xc,%esp
 aa9:	50                   	push   %eax
 aaa:	e8 39 fc ff ff       	call   6e8 <sbrk>
 aaf:	83 c4 10             	add    $0x10,%esp
 ab2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 ab5:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 ab9:	75 07                	jne    ac2 <morecore+0x38>
    return 0;
 abb:	b8 00 00 00 00       	mov    $0x0,%eax
 ac0:	eb 26                	jmp    ae8 <morecore+0x5e>
  hp = (Header*)p;
 ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 acb:	8b 55 08             	mov    0x8(%ebp),%edx
 ace:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 ad1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ad4:	83 c0 08             	add    $0x8,%eax
 ad7:	83 ec 0c             	sub    $0xc,%esp
 ada:	50                   	push   %eax
 adb:	e8 c8 fe ff ff       	call   9a8 <free>
 ae0:	83 c4 10             	add    $0x10,%esp
  return freep;
 ae3:	a1 28 0f 00 00       	mov    0xf28,%eax
}
 ae8:	c9                   	leave  
 ae9:	c3                   	ret    

00000aea <malloc>:

void*
malloc(uint nbytes)
{
 aea:	55                   	push   %ebp
 aeb:	89 e5                	mov    %esp,%ebp
 aed:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 af0:	8b 45 08             	mov    0x8(%ebp),%eax
 af3:	83 c0 07             	add    $0x7,%eax
 af6:	c1 e8 03             	shr    $0x3,%eax
 af9:	83 c0 01             	add    $0x1,%eax
 afc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 aff:	a1 28 0f 00 00       	mov    0xf28,%eax
 b04:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b0b:	75 23                	jne    b30 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 b0d:	c7 45 f0 20 0f 00 00 	movl   $0xf20,-0x10(%ebp)
 b14:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b17:	a3 28 0f 00 00       	mov    %eax,0xf28
 b1c:	a1 28 0f 00 00       	mov    0xf28,%eax
 b21:	a3 20 0f 00 00       	mov    %eax,0xf20
    base.s.size = 0;
 b26:	c7 05 24 0f 00 00 00 	movl   $0x0,0xf24
 b2d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b33:	8b 00                	mov    (%eax),%eax
 b35:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b3b:	8b 40 04             	mov    0x4(%eax),%eax
 b3e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b41:	72 4d                	jb     b90 <malloc+0xa6>
      if(p->s.size == nunits)
 b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b46:	8b 40 04             	mov    0x4(%eax),%eax
 b49:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b4c:	75 0c                	jne    b5a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b51:	8b 10                	mov    (%eax),%edx
 b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b56:	89 10                	mov    %edx,(%eax)
 b58:	eb 26                	jmp    b80 <malloc+0x96>
      else {
        p->s.size -= nunits;
 b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b5d:	8b 40 04             	mov    0x4(%eax),%eax
 b60:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b63:	89 c2                	mov    %eax,%edx
 b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b68:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b6e:	8b 40 04             	mov    0x4(%eax),%eax
 b71:	c1 e0 03             	shl    $0x3,%eax
 b74:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b7a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b7d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b80:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b83:	a3 28 0f 00 00       	mov    %eax,0xf28
      return (void*)(p + 1);
 b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b8b:	83 c0 08             	add    $0x8,%eax
 b8e:	eb 3b                	jmp    bcb <malloc+0xe1>
    }
    if(p == freep)
 b90:	a1 28 0f 00 00       	mov    0xf28,%eax
 b95:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b98:	75 1e                	jne    bb8 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b9a:	83 ec 0c             	sub    $0xc,%esp
 b9d:	ff 75 ec             	pushl  -0x14(%ebp)
 ba0:	e8 e5 fe ff ff       	call   a8a <morecore>
 ba5:	83 c4 10             	add    $0x10,%esp
 ba8:	89 45 f4             	mov    %eax,-0xc(%ebp)
 bab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 baf:	75 07                	jne    bb8 <malloc+0xce>
        return 0;
 bb1:	b8 00 00 00 00       	mov    $0x0,%eax
 bb6:	eb 13                	jmp    bcb <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bc1:	8b 00                	mov    (%eax),%eax
 bc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 bc6:	e9 6d ff ff ff       	jmp    b38 <malloc+0x4e>
}
 bcb:	c9                   	leave  
 bcc:	c3                   	ret    
