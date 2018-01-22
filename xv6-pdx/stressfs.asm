
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	81 ec 24 02 00 00    	sub    $0x224,%esp
  int fd, i;
  char path[] = "stressfs0";
  14:	c7 45 e6 73 74 72 65 	movl   $0x65727473,-0x1a(%ebp)
  1b:	c7 45 ea 73 73 66 73 	movl   $0x73667373,-0x16(%ebp)
  22:	66 c7 45 ee 30 00    	movw   $0x30,-0x12(%ebp)
  char data[512];

  printf(1, "stressfs starting\n");
  28:	83 ec 08             	sub    $0x8,%esp
  2b:	68 e1 09 00 00       	push   $0x9e1
  30:	6a 01                	push   $0x1
  32:	e8 f4 05 00 00       	call   62b <printf>
  37:	83 c4 10             	add    $0x10,%esp
  memset(data, 'a', sizeof(data));
  3a:	83 ec 04             	sub    $0x4,%esp
  3d:	68 00 02 00 00       	push   $0x200
  42:	6a 61                	push   $0x61
  44:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  4a:	50                   	push   %eax
  4b:	e8 be 01 00 00       	call   20e <memset>
  50:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 4; i++)
  53:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  5a:	eb 0d                	jmp    69 <main+0x69>
    if(fork() > 0)
  5c:	e8 13 04 00 00       	call   474 <fork>
  61:	85 c0                	test   %eax,%eax
  63:	7f 0c                	jg     71 <main+0x71>
  char data[512];

  printf(1, "stressfs starting\n");
  memset(data, 'a', sizeof(data));

  for(i = 0; i < 4; i++)
  65:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  69:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
  6d:	7e ed                	jle    5c <main+0x5c>
  6f:	eb 01                	jmp    72 <main+0x72>
    if(fork() > 0)
      break;
  71:	90                   	nop

  printf(1, "write %d\n", i);
  72:	83 ec 04             	sub    $0x4,%esp
  75:	ff 75 f4             	pushl  -0xc(%ebp)
  78:	68 f4 09 00 00       	push   $0x9f4
  7d:	6a 01                	push   $0x1
  7f:	e8 a7 05 00 00       	call   62b <printf>
  84:	83 c4 10             	add    $0x10,%esp

  path[8] += i;
  87:	0f b6 45 ee          	movzbl -0x12(%ebp),%eax
  8b:	89 c2                	mov    %eax,%edx
  8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  90:	01 d0                	add    %edx,%eax
  92:	88 45 ee             	mov    %al,-0x12(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  95:	83 ec 08             	sub    $0x8,%esp
  98:	68 02 02 00 00       	push   $0x202
  9d:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  a0:	50                   	push   %eax
  a1:	e8 16 04 00 00       	call   4bc <open>
  a6:	83 c4 10             	add    $0x10,%esp
  a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; i < 20; i++)
  ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  b3:	eb 1e                	jmp    d3 <main+0xd3>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  b5:	83 ec 04             	sub    $0x4,%esp
  b8:	68 00 02 00 00       	push   $0x200
  bd:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
  c3:	50                   	push   %eax
  c4:	ff 75 f0             	pushl  -0x10(%ebp)
  c7:	e8 d0 03 00 00       	call   49c <write>
  cc:	83 c4 10             	add    $0x10,%esp

  printf(1, "write %d\n", i);

  path[8] += i;
  fd = open(path, O_CREATE | O_RDWR);
  for(i = 0; i < 20; i++)
  cf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  d3:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
  d7:	7e dc                	jle    b5 <main+0xb5>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  close(fd);
  d9:	83 ec 0c             	sub    $0xc,%esp
  dc:	ff 75 f0             	pushl  -0x10(%ebp)
  df:	e8 c0 03 00 00       	call   4a4 <close>
  e4:	83 c4 10             	add    $0x10,%esp

  printf(1, "read\n");
  e7:	83 ec 08             	sub    $0x8,%esp
  ea:	68 fe 09 00 00       	push   $0x9fe
  ef:	6a 01                	push   $0x1
  f1:	e8 35 05 00 00       	call   62b <printf>
  f6:	83 c4 10             	add    $0x10,%esp

  fd = open(path, O_RDONLY);
  f9:	83 ec 08             	sub    $0x8,%esp
  fc:	6a 00                	push   $0x0
  fe:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 101:	50                   	push   %eax
 102:	e8 b5 03 00 00       	call   4bc <open>
 107:	83 c4 10             	add    $0x10,%esp
 10a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for (i = 0; i < 20; i++)
 10d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 114:	eb 1e                	jmp    134 <main+0x134>
    read(fd, data, sizeof(data));
 116:	83 ec 04             	sub    $0x4,%esp
 119:	68 00 02 00 00       	push   $0x200
 11e:	8d 85 e6 fd ff ff    	lea    -0x21a(%ebp),%eax
 124:	50                   	push   %eax
 125:	ff 75 f0             	pushl  -0x10(%ebp)
 128:	e8 67 03 00 00       	call   494 <read>
 12d:	83 c4 10             	add    $0x10,%esp
  close(fd);

  printf(1, "read\n");

  fd = open(path, O_RDONLY);
  for (i = 0; i < 20; i++)
 130:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 134:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
 138:	7e dc                	jle    116 <main+0x116>
    read(fd, data, sizeof(data));
  close(fd);
 13a:	83 ec 0c             	sub    $0xc,%esp
 13d:	ff 75 f0             	pushl  -0x10(%ebp)
 140:	e8 5f 03 00 00       	call   4a4 <close>
 145:	83 c4 10             	add    $0x10,%esp

  wait();
 148:	e8 37 03 00 00       	call   484 <wait>
  
  exit();
 14d:	e8 2a 03 00 00       	call   47c <exit>

00000152 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 152:	55                   	push   %ebp
 153:	89 e5                	mov    %esp,%ebp
 155:	57                   	push   %edi
 156:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 157:	8b 4d 08             	mov    0x8(%ebp),%ecx
 15a:	8b 55 10             	mov    0x10(%ebp),%edx
 15d:	8b 45 0c             	mov    0xc(%ebp),%eax
 160:	89 cb                	mov    %ecx,%ebx
 162:	89 df                	mov    %ebx,%edi
 164:	89 d1                	mov    %edx,%ecx
 166:	fc                   	cld    
 167:	f3 aa                	rep stos %al,%es:(%edi)
 169:	89 ca                	mov    %ecx,%edx
 16b:	89 fb                	mov    %edi,%ebx
 16d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 170:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 173:	90                   	nop
 174:	5b                   	pop    %ebx
 175:	5f                   	pop    %edi
 176:	5d                   	pop    %ebp
 177:	c3                   	ret    

00000178 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 184:	90                   	nop
 185:	8b 45 08             	mov    0x8(%ebp),%eax
 188:	8d 50 01             	lea    0x1(%eax),%edx
 18b:	89 55 08             	mov    %edx,0x8(%ebp)
 18e:	8b 55 0c             	mov    0xc(%ebp),%edx
 191:	8d 4a 01             	lea    0x1(%edx),%ecx
 194:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 197:	0f b6 12             	movzbl (%edx),%edx
 19a:	88 10                	mov    %dl,(%eax)
 19c:	0f b6 00             	movzbl (%eax),%eax
 19f:	84 c0                	test   %al,%al
 1a1:	75 e2                	jne    185 <strcpy+0xd>
    ;
  return os;
 1a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1a6:	c9                   	leave  
 1a7:	c3                   	ret    

000001a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a8:	55                   	push   %ebp
 1a9:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1ab:	eb 08                	jmp    1b5 <strcmp+0xd>
    p++, q++;
 1ad:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1b1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1b5:	8b 45 08             	mov    0x8(%ebp),%eax
 1b8:	0f b6 00             	movzbl (%eax),%eax
 1bb:	84 c0                	test   %al,%al
 1bd:	74 10                	je     1cf <strcmp+0x27>
 1bf:	8b 45 08             	mov    0x8(%ebp),%eax
 1c2:	0f b6 10             	movzbl (%eax),%edx
 1c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c8:	0f b6 00             	movzbl (%eax),%eax
 1cb:	38 c2                	cmp    %al,%dl
 1cd:	74 de                	je     1ad <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	0f b6 00             	movzbl (%eax),%eax
 1d5:	0f b6 d0             	movzbl %al,%edx
 1d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1db:	0f b6 00             	movzbl (%eax),%eax
 1de:	0f b6 c0             	movzbl %al,%eax
 1e1:	29 c2                	sub    %eax,%edx
 1e3:	89 d0                	mov    %edx,%eax
}
 1e5:	5d                   	pop    %ebp
 1e6:	c3                   	ret    

000001e7 <strlen>:

uint
strlen(char *s)
{
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
 1ea:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1f4:	eb 04                	jmp    1fa <strlen+0x13>
 1f6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1fd:	8b 45 08             	mov    0x8(%ebp),%eax
 200:	01 d0                	add    %edx,%eax
 202:	0f b6 00             	movzbl (%eax),%eax
 205:	84 c0                	test   %al,%al
 207:	75 ed                	jne    1f6 <strlen+0xf>
    ;
  return n;
 209:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 20c:	c9                   	leave  
 20d:	c3                   	ret    

0000020e <memset>:

void*
memset(void *dst, int c, uint n)
{
 20e:	55                   	push   %ebp
 20f:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 211:	8b 45 10             	mov    0x10(%ebp),%eax
 214:	50                   	push   %eax
 215:	ff 75 0c             	pushl  0xc(%ebp)
 218:	ff 75 08             	pushl  0x8(%ebp)
 21b:	e8 32 ff ff ff       	call   152 <stosb>
 220:	83 c4 0c             	add    $0xc,%esp
  return dst;
 223:	8b 45 08             	mov    0x8(%ebp),%eax
}
 226:	c9                   	leave  
 227:	c3                   	ret    

00000228 <strchr>:

char*
strchr(const char *s, char c)
{
 228:	55                   	push   %ebp
 229:	89 e5                	mov    %esp,%ebp
 22b:	83 ec 04             	sub    $0x4,%esp
 22e:	8b 45 0c             	mov    0xc(%ebp),%eax
 231:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 234:	eb 14                	jmp    24a <strchr+0x22>
    if(*s == c)
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	0f b6 00             	movzbl (%eax),%eax
 23c:	3a 45 fc             	cmp    -0x4(%ebp),%al
 23f:	75 05                	jne    246 <strchr+0x1e>
      return (char*)s;
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	eb 13                	jmp    259 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 246:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	84 c0                	test   %al,%al
 252:	75 e2                	jne    236 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 254:	b8 00 00 00 00       	mov    $0x0,%eax
}
 259:	c9                   	leave  
 25a:	c3                   	ret    

0000025b <gets>:

char*
gets(char *buf, int max)
{
 25b:	55                   	push   %ebp
 25c:	89 e5                	mov    %esp,%ebp
 25e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 261:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 268:	eb 42                	jmp    2ac <gets+0x51>
    cc = read(0, &c, 1);
 26a:	83 ec 04             	sub    $0x4,%esp
 26d:	6a 01                	push   $0x1
 26f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 272:	50                   	push   %eax
 273:	6a 00                	push   $0x0
 275:	e8 1a 02 00 00       	call   494 <read>
 27a:	83 c4 10             	add    $0x10,%esp
 27d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 280:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 284:	7e 33                	jle    2b9 <gets+0x5e>
      break;
    buf[i++] = c;
 286:	8b 45 f4             	mov    -0xc(%ebp),%eax
 289:	8d 50 01             	lea    0x1(%eax),%edx
 28c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 28f:	89 c2                	mov    %eax,%edx
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	01 c2                	add    %eax,%edx
 296:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 29a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 29c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a0:	3c 0a                	cmp    $0xa,%al
 2a2:	74 16                	je     2ba <gets+0x5f>
 2a4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a8:	3c 0d                	cmp    $0xd,%al
 2aa:	74 0e                	je     2ba <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2af:	83 c0 01             	add    $0x1,%eax
 2b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2b5:	7c b3                	jl     26a <gets+0xf>
 2b7:	eb 01                	jmp    2ba <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2b9:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
 2c0:	01 d0                	add    %edx,%eax
 2c2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c8:	c9                   	leave  
 2c9:	c3                   	ret    

000002ca <stat>:

int
stat(char *n, struct stat *st)
{
 2ca:	55                   	push   %ebp
 2cb:	89 e5                	mov    %esp,%ebp
 2cd:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d0:	83 ec 08             	sub    $0x8,%esp
 2d3:	6a 00                	push   $0x0
 2d5:	ff 75 08             	pushl  0x8(%ebp)
 2d8:	e8 df 01 00 00       	call   4bc <open>
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e7:	79 07                	jns    2f0 <stat+0x26>
    return -1;
 2e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ee:	eb 25                	jmp    315 <stat+0x4b>
  r = fstat(fd, st);
 2f0:	83 ec 08             	sub    $0x8,%esp
 2f3:	ff 75 0c             	pushl  0xc(%ebp)
 2f6:	ff 75 f4             	pushl  -0xc(%ebp)
 2f9:	e8 d6 01 00 00       	call   4d4 <fstat>
 2fe:	83 c4 10             	add    $0x10,%esp
 301:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 304:	83 ec 0c             	sub    $0xc,%esp
 307:	ff 75 f4             	pushl  -0xc(%ebp)
 30a:	e8 95 01 00 00       	call   4a4 <close>
 30f:	83 c4 10             	add    $0x10,%esp
  return r;
 312:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 315:	c9                   	leave  
 316:	c3                   	ret    

00000317 <atoi>:

int
atoi(const char *s)
{
 317:	55                   	push   %ebp
 318:	89 e5                	mov    %esp,%ebp
 31a:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 31d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 324:	eb 04                	jmp    32a <atoi+0x13>
 326:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 32a:	8b 45 08             	mov    0x8(%ebp),%eax
 32d:	0f b6 00             	movzbl (%eax),%eax
 330:	3c 20                	cmp    $0x20,%al
 332:	74 f2                	je     326 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	0f b6 00             	movzbl (%eax),%eax
 33a:	3c 2d                	cmp    $0x2d,%al
 33c:	75 07                	jne    345 <atoi+0x2e>
 33e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 343:	eb 05                	jmp    34a <atoi+0x33>
 345:	b8 01 00 00 00       	mov    $0x1,%eax
 34a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 34d:	8b 45 08             	mov    0x8(%ebp),%eax
 350:	0f b6 00             	movzbl (%eax),%eax
 353:	3c 2b                	cmp    $0x2b,%al
 355:	74 0a                	je     361 <atoi+0x4a>
 357:	8b 45 08             	mov    0x8(%ebp),%eax
 35a:	0f b6 00             	movzbl (%eax),%eax
 35d:	3c 2d                	cmp    $0x2d,%al
 35f:	75 2b                	jne    38c <atoi+0x75>
    s++;
 361:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 365:	eb 25                	jmp    38c <atoi+0x75>
    n = n*10 + *s++ - '0';
 367:	8b 55 fc             	mov    -0x4(%ebp),%edx
 36a:	89 d0                	mov    %edx,%eax
 36c:	c1 e0 02             	shl    $0x2,%eax
 36f:	01 d0                	add    %edx,%eax
 371:	01 c0                	add    %eax,%eax
 373:	89 c1                	mov    %eax,%ecx
 375:	8b 45 08             	mov    0x8(%ebp),%eax
 378:	8d 50 01             	lea    0x1(%eax),%edx
 37b:	89 55 08             	mov    %edx,0x8(%ebp)
 37e:	0f b6 00             	movzbl (%eax),%eax
 381:	0f be c0             	movsbl %al,%eax
 384:	01 c8                	add    %ecx,%eax
 386:	83 e8 30             	sub    $0x30,%eax
 389:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 38c:	8b 45 08             	mov    0x8(%ebp),%eax
 38f:	0f b6 00             	movzbl (%eax),%eax
 392:	3c 2f                	cmp    $0x2f,%al
 394:	7e 0a                	jle    3a0 <atoi+0x89>
 396:	8b 45 08             	mov    0x8(%ebp),%eax
 399:	0f b6 00             	movzbl (%eax),%eax
 39c:	3c 39                	cmp    $0x39,%al
 39e:	7e c7                	jle    367 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 3a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3a3:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3a7:	c9                   	leave  
 3a8:	c3                   	ret    

000003a9 <atoo>:

int
atoo(const char *s)
{
 3a9:	55                   	push   %ebp
 3aa:	89 e5                	mov    %esp,%ebp
 3ac:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3af:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 3b6:	eb 04                	jmp    3bc <atoo+0x13>
 3b8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3bc:	8b 45 08             	mov    0x8(%ebp),%eax
 3bf:	0f b6 00             	movzbl (%eax),%eax
 3c2:	3c 20                	cmp    $0x20,%al
 3c4:	74 f2                	je     3b8 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 3c6:	8b 45 08             	mov    0x8(%ebp),%eax
 3c9:	0f b6 00             	movzbl (%eax),%eax
 3cc:	3c 2d                	cmp    $0x2d,%al
 3ce:	75 07                	jne    3d7 <atoo+0x2e>
 3d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3d5:	eb 05                	jmp    3dc <atoo+0x33>
 3d7:	b8 01 00 00 00       	mov    $0x1,%eax
 3dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3df:	8b 45 08             	mov    0x8(%ebp),%eax
 3e2:	0f b6 00             	movzbl (%eax),%eax
 3e5:	3c 2b                	cmp    $0x2b,%al
 3e7:	74 0a                	je     3f3 <atoo+0x4a>
 3e9:	8b 45 08             	mov    0x8(%ebp),%eax
 3ec:	0f b6 00             	movzbl (%eax),%eax
 3ef:	3c 2d                	cmp    $0x2d,%al
 3f1:	75 27                	jne    41a <atoo+0x71>
    s++;
 3f3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 3f7:	eb 21                	jmp    41a <atoo+0x71>
    n = n*8 + *s++ - '0';
 3f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3fc:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 403:	8b 45 08             	mov    0x8(%ebp),%eax
 406:	8d 50 01             	lea    0x1(%eax),%edx
 409:	89 55 08             	mov    %edx,0x8(%ebp)
 40c:	0f b6 00             	movzbl (%eax),%eax
 40f:	0f be c0             	movsbl %al,%eax
 412:	01 c8                	add    %ecx,%eax
 414:	83 e8 30             	sub    $0x30,%eax
 417:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	0f b6 00             	movzbl (%eax),%eax
 420:	3c 2f                	cmp    $0x2f,%al
 422:	7e 0a                	jle    42e <atoo+0x85>
 424:	8b 45 08             	mov    0x8(%ebp),%eax
 427:	0f b6 00             	movzbl (%eax),%eax
 42a:	3c 37                	cmp    $0x37,%al
 42c:	7e cb                	jle    3f9 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 42e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 431:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 435:	c9                   	leave  
 436:	c3                   	ret    

00000437 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 437:	55                   	push   %ebp
 438:	89 e5                	mov    %esp,%ebp
 43a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 43d:	8b 45 08             	mov    0x8(%ebp),%eax
 440:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 443:	8b 45 0c             	mov    0xc(%ebp),%eax
 446:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 449:	eb 17                	jmp    462 <memmove+0x2b>
    *dst++ = *src++;
 44b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 44e:	8d 50 01             	lea    0x1(%eax),%edx
 451:	89 55 fc             	mov    %edx,-0x4(%ebp)
 454:	8b 55 f8             	mov    -0x8(%ebp),%edx
 457:	8d 4a 01             	lea    0x1(%edx),%ecx
 45a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 45d:	0f b6 12             	movzbl (%edx),%edx
 460:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 462:	8b 45 10             	mov    0x10(%ebp),%eax
 465:	8d 50 ff             	lea    -0x1(%eax),%edx
 468:	89 55 10             	mov    %edx,0x10(%ebp)
 46b:	85 c0                	test   %eax,%eax
 46d:	7f dc                	jg     44b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 46f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 472:	c9                   	leave  
 473:	c3                   	ret    

00000474 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 474:	b8 01 00 00 00       	mov    $0x1,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <exit>:
SYSCALL(exit)
 47c:	b8 02 00 00 00       	mov    $0x2,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <wait>:
SYSCALL(wait)
 484:	b8 03 00 00 00       	mov    $0x3,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <pipe>:
SYSCALL(pipe)
 48c:	b8 04 00 00 00       	mov    $0x4,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <read>:
SYSCALL(read)
 494:	b8 05 00 00 00       	mov    $0x5,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <write>:
SYSCALL(write)
 49c:	b8 10 00 00 00       	mov    $0x10,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <close>:
SYSCALL(close)
 4a4:	b8 15 00 00 00       	mov    $0x15,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <kill>:
SYSCALL(kill)
 4ac:	b8 06 00 00 00       	mov    $0x6,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <exec>:
SYSCALL(exec)
 4b4:	b8 07 00 00 00       	mov    $0x7,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <open>:
SYSCALL(open)
 4bc:	b8 0f 00 00 00       	mov    $0xf,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <mknod>:
SYSCALL(mknod)
 4c4:	b8 11 00 00 00       	mov    $0x11,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <unlink>:
SYSCALL(unlink)
 4cc:	b8 12 00 00 00       	mov    $0x12,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <fstat>:
SYSCALL(fstat)
 4d4:	b8 08 00 00 00       	mov    $0x8,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret    

000004dc <link>:
SYSCALL(link)
 4dc:	b8 13 00 00 00       	mov    $0x13,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret    

000004e4 <mkdir>:
SYSCALL(mkdir)
 4e4:	b8 14 00 00 00       	mov    $0x14,%eax
 4e9:	cd 40                	int    $0x40
 4eb:	c3                   	ret    

000004ec <chdir>:
SYSCALL(chdir)
 4ec:	b8 09 00 00 00       	mov    $0x9,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret    

000004f4 <dup>:
SYSCALL(dup)
 4f4:	b8 0a 00 00 00       	mov    $0xa,%eax
 4f9:	cd 40                	int    $0x40
 4fb:	c3                   	ret    

000004fc <getpid>:
SYSCALL(getpid)
 4fc:	b8 0b 00 00 00       	mov    $0xb,%eax
 501:	cd 40                	int    $0x40
 503:	c3                   	ret    

00000504 <sbrk>:
SYSCALL(sbrk)
 504:	b8 0c 00 00 00       	mov    $0xc,%eax
 509:	cd 40                	int    $0x40
 50b:	c3                   	ret    

0000050c <sleep>:
SYSCALL(sleep)
 50c:	b8 0d 00 00 00       	mov    $0xd,%eax
 511:	cd 40                	int    $0x40
 513:	c3                   	ret    

00000514 <uptime>:
SYSCALL(uptime)
 514:	b8 0e 00 00 00       	mov    $0xe,%eax
 519:	cd 40                	int    $0x40
 51b:	c3                   	ret    

0000051c <halt>:
SYSCALL(halt)
 51c:	b8 16 00 00 00       	mov    $0x16,%eax
 521:	cd 40                	int    $0x40
 523:	c3                   	ret    

00000524 <date>:
SYSCALL(date)
 524:	b8 17 00 00 00       	mov    $0x17,%eax
 529:	cd 40                	int    $0x40
 52b:	c3                   	ret    

0000052c <getuid>:
SYSCALL(getuid)
 52c:	b8 18 00 00 00       	mov    $0x18,%eax
 531:	cd 40                	int    $0x40
 533:	c3                   	ret    

00000534 <getgid>:
SYSCALL(getgid)
 534:	b8 19 00 00 00       	mov    $0x19,%eax
 539:	cd 40                	int    $0x40
 53b:	c3                   	ret    

0000053c <getppid>:
SYSCALL(getppid)
 53c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 541:	cd 40                	int    $0x40
 543:	c3                   	ret    

00000544 <setuid>:
SYSCALL(setuid)
 544:	b8 1b 00 00 00       	mov    $0x1b,%eax
 549:	cd 40                	int    $0x40
 54b:	c3                   	ret    

0000054c <setgid>:
SYSCALL(setgid)
 54c:	b8 1c 00 00 00       	mov    $0x1c,%eax
 551:	cd 40                	int    $0x40
 553:	c3                   	ret    

00000554 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 554:	55                   	push   %ebp
 555:	89 e5                	mov    %esp,%ebp
 557:	83 ec 18             	sub    $0x18,%esp
 55a:	8b 45 0c             	mov    0xc(%ebp),%eax
 55d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 560:	83 ec 04             	sub    $0x4,%esp
 563:	6a 01                	push   $0x1
 565:	8d 45 f4             	lea    -0xc(%ebp),%eax
 568:	50                   	push   %eax
 569:	ff 75 08             	pushl  0x8(%ebp)
 56c:	e8 2b ff ff ff       	call   49c <write>
 571:	83 c4 10             	add    $0x10,%esp
}
 574:	90                   	nop
 575:	c9                   	leave  
 576:	c3                   	ret    

00000577 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 577:	55                   	push   %ebp
 578:	89 e5                	mov    %esp,%ebp
 57a:	53                   	push   %ebx
 57b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 57e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 585:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 589:	74 17                	je     5a2 <printint+0x2b>
 58b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 58f:	79 11                	jns    5a2 <printint+0x2b>
    neg = 1;
 591:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 598:	8b 45 0c             	mov    0xc(%ebp),%eax
 59b:	f7 d8                	neg    %eax
 59d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5a0:	eb 06                	jmp    5a8 <printint+0x31>
  } else {
    x = xx;
 5a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 5a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5af:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5b2:	8d 41 01             	lea    0x1(%ecx),%eax
 5b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5be:	ba 00 00 00 00       	mov    $0x0,%edx
 5c3:	f7 f3                	div    %ebx
 5c5:	89 d0                	mov    %edx,%eax
 5c7:	0f b6 80 74 0c 00 00 	movzbl 0xc74(%eax),%eax
 5ce:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5d8:	ba 00 00 00 00       	mov    $0x0,%edx
 5dd:	f7 f3                	div    %ebx
 5df:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5e2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5e6:	75 c7                	jne    5af <printint+0x38>
  if(neg)
 5e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5ec:	74 2d                	je     61b <printint+0xa4>
    buf[i++] = '-';
 5ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5f1:	8d 50 01             	lea    0x1(%eax),%edx
 5f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5f7:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5fc:	eb 1d                	jmp    61b <printint+0xa4>
    putc(fd, buf[i]);
 5fe:	8d 55 dc             	lea    -0x24(%ebp),%edx
 601:	8b 45 f4             	mov    -0xc(%ebp),%eax
 604:	01 d0                	add    %edx,%eax
 606:	0f b6 00             	movzbl (%eax),%eax
 609:	0f be c0             	movsbl %al,%eax
 60c:	83 ec 08             	sub    $0x8,%esp
 60f:	50                   	push   %eax
 610:	ff 75 08             	pushl  0x8(%ebp)
 613:	e8 3c ff ff ff       	call   554 <putc>
 618:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 61b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 61f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 623:	79 d9                	jns    5fe <printint+0x87>
    putc(fd, buf[i]);
}
 625:	90                   	nop
 626:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 629:	c9                   	leave  
 62a:	c3                   	ret    

0000062b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 62b:	55                   	push   %ebp
 62c:	89 e5                	mov    %esp,%ebp
 62e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 631:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 638:	8d 45 0c             	lea    0xc(%ebp),%eax
 63b:	83 c0 04             	add    $0x4,%eax
 63e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 641:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 648:	e9 59 01 00 00       	jmp    7a6 <printf+0x17b>
    c = fmt[i] & 0xff;
 64d:	8b 55 0c             	mov    0xc(%ebp),%edx
 650:	8b 45 f0             	mov    -0x10(%ebp),%eax
 653:	01 d0                	add    %edx,%eax
 655:	0f b6 00             	movzbl (%eax),%eax
 658:	0f be c0             	movsbl %al,%eax
 65b:	25 ff 00 00 00       	and    $0xff,%eax
 660:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 663:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 667:	75 2c                	jne    695 <printf+0x6a>
      if(c == '%'){
 669:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 66d:	75 0c                	jne    67b <printf+0x50>
        state = '%';
 66f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 676:	e9 27 01 00 00       	jmp    7a2 <printf+0x177>
      } else {
        putc(fd, c);
 67b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 67e:	0f be c0             	movsbl %al,%eax
 681:	83 ec 08             	sub    $0x8,%esp
 684:	50                   	push   %eax
 685:	ff 75 08             	pushl  0x8(%ebp)
 688:	e8 c7 fe ff ff       	call   554 <putc>
 68d:	83 c4 10             	add    $0x10,%esp
 690:	e9 0d 01 00 00       	jmp    7a2 <printf+0x177>
      }
    } else if(state == '%'){
 695:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 699:	0f 85 03 01 00 00    	jne    7a2 <printf+0x177>
      if(c == 'd'){
 69f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6a3:	75 1e                	jne    6c3 <printf+0x98>
        printint(fd, *ap, 10, 1);
 6a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a8:	8b 00                	mov    (%eax),%eax
 6aa:	6a 01                	push   $0x1
 6ac:	6a 0a                	push   $0xa
 6ae:	50                   	push   %eax
 6af:	ff 75 08             	pushl  0x8(%ebp)
 6b2:	e8 c0 fe ff ff       	call   577 <printint>
 6b7:	83 c4 10             	add    $0x10,%esp
        ap++;
 6ba:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6be:	e9 d8 00 00 00       	jmp    79b <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6c3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6c7:	74 06                	je     6cf <printf+0xa4>
 6c9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6cd:	75 1e                	jne    6ed <printf+0xc2>
        printint(fd, *ap, 16, 0);
 6cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d2:	8b 00                	mov    (%eax),%eax
 6d4:	6a 00                	push   $0x0
 6d6:	6a 10                	push   $0x10
 6d8:	50                   	push   %eax
 6d9:	ff 75 08             	pushl  0x8(%ebp)
 6dc:	e8 96 fe ff ff       	call   577 <printint>
 6e1:	83 c4 10             	add    $0x10,%esp
        ap++;
 6e4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6e8:	e9 ae 00 00 00       	jmp    79b <printf+0x170>
      } else if(c == 's'){
 6ed:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 6f1:	75 43                	jne    736 <printf+0x10b>
        s = (char*)*ap;
 6f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6f6:	8b 00                	mov    (%eax),%eax
 6f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 6fb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 6ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 703:	75 25                	jne    72a <printf+0xff>
          s = "(null)";
 705:	c7 45 f4 04 0a 00 00 	movl   $0xa04,-0xc(%ebp)
        while(*s != 0){
 70c:	eb 1c                	jmp    72a <printf+0xff>
          putc(fd, *s);
 70e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 711:	0f b6 00             	movzbl (%eax),%eax
 714:	0f be c0             	movsbl %al,%eax
 717:	83 ec 08             	sub    $0x8,%esp
 71a:	50                   	push   %eax
 71b:	ff 75 08             	pushl  0x8(%ebp)
 71e:	e8 31 fe ff ff       	call   554 <putc>
 723:	83 c4 10             	add    $0x10,%esp
          s++;
 726:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 72a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72d:	0f b6 00             	movzbl (%eax),%eax
 730:	84 c0                	test   %al,%al
 732:	75 da                	jne    70e <printf+0xe3>
 734:	eb 65                	jmp    79b <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 736:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 73a:	75 1d                	jne    759 <printf+0x12e>
        putc(fd, *ap);
 73c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 73f:	8b 00                	mov    (%eax),%eax
 741:	0f be c0             	movsbl %al,%eax
 744:	83 ec 08             	sub    $0x8,%esp
 747:	50                   	push   %eax
 748:	ff 75 08             	pushl  0x8(%ebp)
 74b:	e8 04 fe ff ff       	call   554 <putc>
 750:	83 c4 10             	add    $0x10,%esp
        ap++;
 753:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 757:	eb 42                	jmp    79b <printf+0x170>
      } else if(c == '%'){
 759:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 75d:	75 17                	jne    776 <printf+0x14b>
        putc(fd, c);
 75f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 762:	0f be c0             	movsbl %al,%eax
 765:	83 ec 08             	sub    $0x8,%esp
 768:	50                   	push   %eax
 769:	ff 75 08             	pushl  0x8(%ebp)
 76c:	e8 e3 fd ff ff       	call   554 <putc>
 771:	83 c4 10             	add    $0x10,%esp
 774:	eb 25                	jmp    79b <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 776:	83 ec 08             	sub    $0x8,%esp
 779:	6a 25                	push   $0x25
 77b:	ff 75 08             	pushl  0x8(%ebp)
 77e:	e8 d1 fd ff ff       	call   554 <putc>
 783:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 786:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 789:	0f be c0             	movsbl %al,%eax
 78c:	83 ec 08             	sub    $0x8,%esp
 78f:	50                   	push   %eax
 790:	ff 75 08             	pushl  0x8(%ebp)
 793:	e8 bc fd ff ff       	call   554 <putc>
 798:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 79b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7a2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7a6:	8b 55 0c             	mov    0xc(%ebp),%edx
 7a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7ac:	01 d0                	add    %edx,%eax
 7ae:	0f b6 00             	movzbl (%eax),%eax
 7b1:	84 c0                	test   %al,%al
 7b3:	0f 85 94 fe ff ff    	jne    64d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7b9:	90                   	nop
 7ba:	c9                   	leave  
 7bb:	c3                   	ret    

000007bc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7bc:	55                   	push   %ebp
 7bd:	89 e5                	mov    %esp,%ebp
 7bf:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7c2:	8b 45 08             	mov    0x8(%ebp),%eax
 7c5:	83 e8 08             	sub    $0x8,%eax
 7c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7cb:	a1 90 0c 00 00       	mov    0xc90,%eax
 7d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7d3:	eb 24                	jmp    7f9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d8:	8b 00                	mov    (%eax),%eax
 7da:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7dd:	77 12                	ja     7f1 <free+0x35>
 7df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7e5:	77 24                	ja     80b <free+0x4f>
 7e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ea:	8b 00                	mov    (%eax),%eax
 7ec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7ef:	77 1a                	ja     80b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f4:	8b 00                	mov    (%eax),%eax
 7f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7ff:	76 d4                	jbe    7d5 <free+0x19>
 801:	8b 45 fc             	mov    -0x4(%ebp),%eax
 804:	8b 00                	mov    (%eax),%eax
 806:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 809:	76 ca                	jbe    7d5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 80b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80e:	8b 40 04             	mov    0x4(%eax),%eax
 811:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 818:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81b:	01 c2                	add    %eax,%edx
 81d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 820:	8b 00                	mov    (%eax),%eax
 822:	39 c2                	cmp    %eax,%edx
 824:	75 24                	jne    84a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 826:	8b 45 f8             	mov    -0x8(%ebp),%eax
 829:	8b 50 04             	mov    0x4(%eax),%edx
 82c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82f:	8b 00                	mov    (%eax),%eax
 831:	8b 40 04             	mov    0x4(%eax),%eax
 834:	01 c2                	add    %eax,%edx
 836:	8b 45 f8             	mov    -0x8(%ebp),%eax
 839:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 83c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83f:	8b 00                	mov    (%eax),%eax
 841:	8b 10                	mov    (%eax),%edx
 843:	8b 45 f8             	mov    -0x8(%ebp),%eax
 846:	89 10                	mov    %edx,(%eax)
 848:	eb 0a                	jmp    854 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 84a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84d:	8b 10                	mov    (%eax),%edx
 84f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 852:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 854:	8b 45 fc             	mov    -0x4(%ebp),%eax
 857:	8b 40 04             	mov    0x4(%eax),%eax
 85a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 861:	8b 45 fc             	mov    -0x4(%ebp),%eax
 864:	01 d0                	add    %edx,%eax
 866:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 869:	75 20                	jne    88b <free+0xcf>
    p->s.size += bp->s.size;
 86b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 86e:	8b 50 04             	mov    0x4(%eax),%edx
 871:	8b 45 f8             	mov    -0x8(%ebp),%eax
 874:	8b 40 04             	mov    0x4(%eax),%eax
 877:	01 c2                	add    %eax,%edx
 879:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 87f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 882:	8b 10                	mov    (%eax),%edx
 884:	8b 45 fc             	mov    -0x4(%ebp),%eax
 887:	89 10                	mov    %edx,(%eax)
 889:	eb 08                	jmp    893 <free+0xd7>
  } else
    p->s.ptr = bp;
 88b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 891:	89 10                	mov    %edx,(%eax)
  freep = p;
 893:	8b 45 fc             	mov    -0x4(%ebp),%eax
 896:	a3 90 0c 00 00       	mov    %eax,0xc90
}
 89b:	90                   	nop
 89c:	c9                   	leave  
 89d:	c3                   	ret    

0000089e <morecore>:

static Header*
morecore(uint nu)
{
 89e:	55                   	push   %ebp
 89f:	89 e5                	mov    %esp,%ebp
 8a1:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8a4:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8ab:	77 07                	ja     8b4 <morecore+0x16>
    nu = 4096;
 8ad:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8b4:	8b 45 08             	mov    0x8(%ebp),%eax
 8b7:	c1 e0 03             	shl    $0x3,%eax
 8ba:	83 ec 0c             	sub    $0xc,%esp
 8bd:	50                   	push   %eax
 8be:	e8 41 fc ff ff       	call   504 <sbrk>
 8c3:	83 c4 10             	add    $0x10,%esp
 8c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8c9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8cd:	75 07                	jne    8d6 <morecore+0x38>
    return 0;
 8cf:	b8 00 00 00 00       	mov    $0x0,%eax
 8d4:	eb 26                	jmp    8fc <morecore+0x5e>
  hp = (Header*)p;
 8d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8df:	8b 55 08             	mov    0x8(%ebp),%edx
 8e2:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e8:	83 c0 08             	add    $0x8,%eax
 8eb:	83 ec 0c             	sub    $0xc,%esp
 8ee:	50                   	push   %eax
 8ef:	e8 c8 fe ff ff       	call   7bc <free>
 8f4:	83 c4 10             	add    $0x10,%esp
  return freep;
 8f7:	a1 90 0c 00 00       	mov    0xc90,%eax
}
 8fc:	c9                   	leave  
 8fd:	c3                   	ret    

000008fe <malloc>:

void*
malloc(uint nbytes)
{
 8fe:	55                   	push   %ebp
 8ff:	89 e5                	mov    %esp,%ebp
 901:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 904:	8b 45 08             	mov    0x8(%ebp),%eax
 907:	83 c0 07             	add    $0x7,%eax
 90a:	c1 e8 03             	shr    $0x3,%eax
 90d:	83 c0 01             	add    $0x1,%eax
 910:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 913:	a1 90 0c 00 00       	mov    0xc90,%eax
 918:	89 45 f0             	mov    %eax,-0x10(%ebp)
 91b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 91f:	75 23                	jne    944 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 921:	c7 45 f0 88 0c 00 00 	movl   $0xc88,-0x10(%ebp)
 928:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92b:	a3 90 0c 00 00       	mov    %eax,0xc90
 930:	a1 90 0c 00 00       	mov    0xc90,%eax
 935:	a3 88 0c 00 00       	mov    %eax,0xc88
    base.s.size = 0;
 93a:	c7 05 8c 0c 00 00 00 	movl   $0x0,0xc8c
 941:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 944:	8b 45 f0             	mov    -0x10(%ebp),%eax
 947:	8b 00                	mov    (%eax),%eax
 949:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 94c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94f:	8b 40 04             	mov    0x4(%eax),%eax
 952:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 955:	72 4d                	jb     9a4 <malloc+0xa6>
      if(p->s.size == nunits)
 957:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95a:	8b 40 04             	mov    0x4(%eax),%eax
 95d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 960:	75 0c                	jne    96e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 962:	8b 45 f4             	mov    -0xc(%ebp),%eax
 965:	8b 10                	mov    (%eax),%edx
 967:	8b 45 f0             	mov    -0x10(%ebp),%eax
 96a:	89 10                	mov    %edx,(%eax)
 96c:	eb 26                	jmp    994 <malloc+0x96>
      else {
        p->s.size -= nunits;
 96e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 971:	8b 40 04             	mov    0x4(%eax),%eax
 974:	2b 45 ec             	sub    -0x14(%ebp),%eax
 977:	89 c2                	mov    %eax,%edx
 979:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 97f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 982:	8b 40 04             	mov    0x4(%eax),%eax
 985:	c1 e0 03             	shl    $0x3,%eax
 988:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 98b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 991:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 994:	8b 45 f0             	mov    -0x10(%ebp),%eax
 997:	a3 90 0c 00 00       	mov    %eax,0xc90
      return (void*)(p + 1);
 99c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99f:	83 c0 08             	add    $0x8,%eax
 9a2:	eb 3b                	jmp    9df <malloc+0xe1>
    }
    if(p == freep)
 9a4:	a1 90 0c 00 00       	mov    0xc90,%eax
 9a9:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9ac:	75 1e                	jne    9cc <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 9ae:	83 ec 0c             	sub    $0xc,%esp
 9b1:	ff 75 ec             	pushl  -0x14(%ebp)
 9b4:	e8 e5 fe ff ff       	call   89e <morecore>
 9b9:	83 c4 10             	add    $0x10,%esp
 9bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9c3:	75 07                	jne    9cc <malloc+0xce>
        return 0;
 9c5:	b8 00 00 00 00       	mov    $0x0,%eax
 9ca:	eb 13                	jmp    9df <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d5:	8b 00                	mov    (%eax),%eax
 9d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 9da:	e9 6d ff ff ff       	jmp    94c <malloc+0x4e>
}
 9df:	c9                   	leave  
 9e0:	c3                   	ret    
