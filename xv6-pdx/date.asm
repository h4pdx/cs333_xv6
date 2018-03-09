
_date:     file format elf32-i386


Disassembly of section .text:

00000000 <dayofweek>:
static char *days[] = {"Sun", "Mon", "Tue", "Wed",
  "Thu", "Fri", "Sat"};

int
dayofweek(int y, int m, int d)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
  return (d+=m<3?y--:y-2,23*m/9+d+4+y/4-y/100+y/400)%7;
   4:	83 7d 0c 02          	cmpl   $0x2,0xc(%ebp)
   8:	7f 0b                	jg     15 <dayofweek+0x15>
   a:	8b 45 08             	mov    0x8(%ebp),%eax
   d:	8d 50 ff             	lea    -0x1(%eax),%edx
  10:	89 55 08             	mov    %edx,0x8(%ebp)
  13:	eb 06                	jmp    1b <dayofweek+0x1b>
  15:	8b 45 08             	mov    0x8(%ebp),%eax
  18:	83 e8 02             	sub    $0x2,%eax
  1b:	01 45 10             	add    %eax,0x10(%ebp)
  1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  21:	6b c8 17             	imul   $0x17,%eax,%ecx
  24:	ba 39 8e e3 38       	mov    $0x38e38e39,%edx
  29:	89 c8                	mov    %ecx,%eax
  2b:	f7 ea                	imul   %edx
  2d:	d1 fa                	sar    %edx
  2f:	89 c8                	mov    %ecx,%eax
  31:	c1 f8 1f             	sar    $0x1f,%eax
  34:	29 c2                	sub    %eax,%edx
  36:	8b 45 10             	mov    0x10(%ebp),%eax
  39:	01 d0                	add    %edx,%eax
  3b:	8d 48 04             	lea    0x4(%eax),%ecx
  3e:	8b 45 08             	mov    0x8(%ebp),%eax
  41:	8d 50 03             	lea    0x3(%eax),%edx
  44:	85 c0                	test   %eax,%eax
  46:	0f 48 c2             	cmovs  %edx,%eax
  49:	c1 f8 02             	sar    $0x2,%eax
  4c:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
  4f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  52:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  57:	89 c8                	mov    %ecx,%eax
  59:	f7 ea                	imul   %edx
  5b:	c1 fa 05             	sar    $0x5,%edx
  5e:	89 c8                	mov    %ecx,%eax
  60:	c1 f8 1f             	sar    $0x1f,%eax
  63:	29 c2                	sub    %eax,%edx
  65:	89 d0                	mov    %edx,%eax
  67:	29 c3                	sub    %eax,%ebx
  69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  6c:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  71:	89 c8                	mov    %ecx,%eax
  73:	f7 ea                	imul   %edx
  75:	c1 fa 07             	sar    $0x7,%edx
  78:	89 c8                	mov    %ecx,%eax
  7a:	c1 f8 1f             	sar    $0x1f,%eax
  7d:	29 c2                	sub    %eax,%edx
  7f:	89 d0                	mov    %edx,%eax
  81:	8d 0c 03             	lea    (%ebx,%eax,1),%ecx
  84:	ba 93 24 49 92       	mov    $0x92492493,%edx
  89:	89 c8                	mov    %ecx,%eax
  8b:	f7 ea                	imul   %edx
  8d:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
  90:	c1 f8 02             	sar    $0x2,%eax
  93:	89 c2                	mov    %eax,%edx
  95:	89 c8                	mov    %ecx,%eax
  97:	c1 f8 1f             	sar    $0x1f,%eax
  9a:	29 c2                	sub    %eax,%edx
  9c:	89 d0                	mov    %edx,%eax
  9e:	89 c2                	mov    %eax,%edx
  a0:	c1 e2 03             	shl    $0x3,%edx
  a3:	29 c2                	sub    %eax,%edx
  a5:	89 c8                	mov    %ecx,%eax
  a7:	29 d0                	sub    %edx,%eax
}
  a9:	5b                   	pop    %ebx
  aa:	5d                   	pop    %ebp
  ab:	c3                   	ret    

000000ac <main>:

int
main(int argc, char *argv[])
{
  ac:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  b0:	83 e4 f0             	and    $0xfffffff0,%esp
  b3:	ff 71 fc             	pushl  -0x4(%ecx)
  b6:	55                   	push   %ebp
  b7:	89 e5                	mov    %esp,%ebp
  b9:	51                   	push   %ecx
  ba:	83 ec 24             	sub    $0x24,%esp
  int day;
  struct rtcdate r;

  if (date(&r)) {
  bd:	83 ec 0c             	sub    $0xc,%esp
  c0:	8d 45 dc             	lea    -0x24(%ebp),%eax
  c3:	50                   	push   %eax
  c4:	e8 e6 04 00 00       	call   5af <date>
  c9:	83 c4 10             	add    $0x10,%esp
  cc:	85 c0                	test   %eax,%eax
  ce:	74 1b                	je     eb <main+0x3f>
    printf(2,"Error: date call failed. %s at line %d\n",
  d0:	6a 1c                	push   $0x1c
  d2:	68 e5 0a 00 00       	push   $0xae5
  d7:	68 ec 0a 00 00       	push   $0xaec
  dc:	6a 02                	push   $0x2
  de:	e8 fb 05 00 00       	call   6de <printf>
  e3:	83 c4 10             	add    $0x10,%esp
	__FILE__, __LINE__);
    exit();
  e6:	e8 1c 04 00 00       	call   507 <exit>
  }

  day = dayofweek(r.year, r.month, r.day);
  eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  ee:	89 c1                	mov    %eax,%ecx
  f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  f3:	89 c2                	mov    %eax,%edx
  f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  f8:	83 ec 04             	sub    $0x4,%esp
  fb:	51                   	push   %ecx
  fc:	52                   	push   %edx
  fd:	50                   	push   %eax
  fe:	e8 fd fe ff ff       	call   0 <dayofweek>
 103:	83 c4 10             	add    $0x10,%esp
 106:	89 45 f4             	mov    %eax,-0xc(%ebp)

  printf(1, "%s %s %d", days[day], months[r.month], r.day);
 109:	8b 4d e8             	mov    -0x18(%ebp),%ecx
 10c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 10f:	8b 14 85 e0 0d 00 00 	mov    0xde0(,%eax,4),%edx
 116:	8b 45 f4             	mov    -0xc(%ebp),%eax
 119:	8b 04 85 14 0e 00 00 	mov    0xe14(,%eax,4),%eax
 120:	83 ec 0c             	sub    $0xc,%esp
 123:	51                   	push   %ecx
 124:	52                   	push   %edx
 125:	50                   	push   %eax
 126:	68 14 0b 00 00       	push   $0xb14
 12b:	6a 01                	push   $0x1
 12d:	e8 ac 05 00 00       	call   6de <printf>
 132:	83 c4 20             	add    $0x20,%esp
  printf(1, " ");
 135:	83 ec 08             	sub    $0x8,%esp
 138:	68 1d 0b 00 00       	push   $0xb1d
 13d:	6a 01                	push   $0x1
 13f:	e8 9a 05 00 00       	call   6de <printf>
 144:	83 c4 10             	add    $0x10,%esp
  if (r.hour < 10) printf(1, "0");
 147:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 14a:	83 f8 09             	cmp    $0x9,%eax
 14d:	77 12                	ja     161 <main+0xb5>
 14f:	83 ec 08             	sub    $0x8,%esp
 152:	68 1f 0b 00 00       	push   $0xb1f
 157:	6a 01                	push   $0x1
 159:	e8 80 05 00 00       	call   6de <printf>
 15e:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d:", r.hour);
 161:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 164:	83 ec 04             	sub    $0x4,%esp
 167:	50                   	push   %eax
 168:	68 21 0b 00 00       	push   $0xb21
 16d:	6a 01                	push   $0x1
 16f:	e8 6a 05 00 00       	call   6de <printf>
 174:	83 c4 10             	add    $0x10,%esp
  if (r.minute < 10) printf(1, "0");
 177:	8b 45 e0             	mov    -0x20(%ebp),%eax
 17a:	83 f8 09             	cmp    $0x9,%eax
 17d:	77 12                	ja     191 <main+0xe5>
 17f:	83 ec 08             	sub    $0x8,%esp
 182:	68 1f 0b 00 00       	push   $0xb1f
 187:	6a 01                	push   $0x1
 189:	e8 50 05 00 00       	call   6de <printf>
 18e:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d:", r.minute);
 191:	8b 45 e0             	mov    -0x20(%ebp),%eax
 194:	83 ec 04             	sub    $0x4,%esp
 197:	50                   	push   %eax
 198:	68 21 0b 00 00       	push   $0xb21
 19d:	6a 01                	push   $0x1
 19f:	e8 3a 05 00 00       	call   6de <printf>
 1a4:	83 c4 10             	add    $0x10,%esp
  if (r.second < 10) printf(1, "0");
 1a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
 1aa:	83 f8 09             	cmp    $0x9,%eax
 1ad:	77 12                	ja     1c1 <main+0x115>
 1af:	83 ec 08             	sub    $0x8,%esp
 1b2:	68 1f 0b 00 00       	push   $0xb1f
 1b7:	6a 01                	push   $0x1
 1b9:	e8 20 05 00 00       	call   6de <printf>
 1be:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d UTC %d\n", r.second, r.year);
 1c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
 1c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
 1c7:	52                   	push   %edx
 1c8:	50                   	push   %eax
 1c9:	68 25 0b 00 00       	push   $0xb25
 1ce:	6a 01                	push   $0x1
 1d0:	e8 09 05 00 00       	call   6de <printf>
 1d5:	83 c4 10             	add    $0x10,%esp

  exit();
 1d8:	e8 2a 03 00 00       	call   507 <exit>

000001dd <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	57                   	push   %edi
 1e1:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1e5:	8b 55 10             	mov    0x10(%ebp),%edx
 1e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1eb:	89 cb                	mov    %ecx,%ebx
 1ed:	89 df                	mov    %ebx,%edi
 1ef:	89 d1                	mov    %edx,%ecx
 1f1:	fc                   	cld    
 1f2:	f3 aa                	rep stos %al,%es:(%edi)
 1f4:	89 ca                	mov    %ecx,%edx
 1f6:	89 fb                	mov    %edi,%ebx
 1f8:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1fb:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1fe:	90                   	nop
 1ff:	5b                   	pop    %ebx
 200:	5f                   	pop    %edi
 201:	5d                   	pop    %ebp
 202:	c3                   	ret    

00000203 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 203:	55                   	push   %ebp
 204:	89 e5                	mov    %esp,%ebp
 206:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 209:	8b 45 08             	mov    0x8(%ebp),%eax
 20c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 20f:	90                   	nop
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	8d 50 01             	lea    0x1(%eax),%edx
 216:	89 55 08             	mov    %edx,0x8(%ebp)
 219:	8b 55 0c             	mov    0xc(%ebp),%edx
 21c:	8d 4a 01             	lea    0x1(%edx),%ecx
 21f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 222:	0f b6 12             	movzbl (%edx),%edx
 225:	88 10                	mov    %dl,(%eax)
 227:	0f b6 00             	movzbl (%eax),%eax
 22a:	84 c0                	test   %al,%al
 22c:	75 e2                	jne    210 <strcpy+0xd>
    ;
  return os;
 22e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 231:	c9                   	leave  
 232:	c3                   	ret    

00000233 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 233:	55                   	push   %ebp
 234:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 236:	eb 08                	jmp    240 <strcmp+0xd>
    p++, q++;
 238:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 23c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	0f b6 00             	movzbl (%eax),%eax
 246:	84 c0                	test   %al,%al
 248:	74 10                	je     25a <strcmp+0x27>
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	0f b6 10             	movzbl (%eax),%edx
 250:	8b 45 0c             	mov    0xc(%ebp),%eax
 253:	0f b6 00             	movzbl (%eax),%eax
 256:	38 c2                	cmp    %al,%dl
 258:	74 de                	je     238 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
 25d:	0f b6 00             	movzbl (%eax),%eax
 260:	0f b6 d0             	movzbl %al,%edx
 263:	8b 45 0c             	mov    0xc(%ebp),%eax
 266:	0f b6 00             	movzbl (%eax),%eax
 269:	0f b6 c0             	movzbl %al,%eax
 26c:	29 c2                	sub    %eax,%edx
 26e:	89 d0                	mov    %edx,%eax
}
 270:	5d                   	pop    %ebp
 271:	c3                   	ret    

00000272 <strlen>:

uint
strlen(char *s)
{
 272:	55                   	push   %ebp
 273:	89 e5                	mov    %esp,%ebp
 275:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 278:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 27f:	eb 04                	jmp    285 <strlen+0x13>
 281:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 285:	8b 55 fc             	mov    -0x4(%ebp),%edx
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	01 d0                	add    %edx,%eax
 28d:	0f b6 00             	movzbl (%eax),%eax
 290:	84 c0                	test   %al,%al
 292:	75 ed                	jne    281 <strlen+0xf>
    ;
  return n;
 294:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 297:	c9                   	leave  
 298:	c3                   	ret    

00000299 <memset>:

void*
memset(void *dst, int c, uint n)
{
 299:	55                   	push   %ebp
 29a:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 29c:	8b 45 10             	mov    0x10(%ebp),%eax
 29f:	50                   	push   %eax
 2a0:	ff 75 0c             	pushl  0xc(%ebp)
 2a3:	ff 75 08             	pushl  0x8(%ebp)
 2a6:	e8 32 ff ff ff       	call   1dd <stosb>
 2ab:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2ae:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b1:	c9                   	leave  
 2b2:	c3                   	ret    

000002b3 <strchr>:

char*
strchr(const char *s, char c)
{
 2b3:	55                   	push   %ebp
 2b4:	89 e5                	mov    %esp,%ebp
 2b6:	83 ec 04             	sub    $0x4,%esp
 2b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bc:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2bf:	eb 14                	jmp    2d5 <strchr+0x22>
    if(*s == c)
 2c1:	8b 45 08             	mov    0x8(%ebp),%eax
 2c4:	0f b6 00             	movzbl (%eax),%eax
 2c7:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2ca:	75 05                	jne    2d1 <strchr+0x1e>
      return (char*)s;
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	eb 13                	jmp    2e4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2d1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 2d8:	0f b6 00             	movzbl (%eax),%eax
 2db:	84 c0                	test   %al,%al
 2dd:	75 e2                	jne    2c1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2df:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2e4:	c9                   	leave  
 2e5:	c3                   	ret    

000002e6 <gets>:

char*
gets(char *buf, int max)
{
 2e6:	55                   	push   %ebp
 2e7:	89 e5                	mov    %esp,%ebp
 2e9:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2f3:	eb 42                	jmp    337 <gets+0x51>
    cc = read(0, &c, 1);
 2f5:	83 ec 04             	sub    $0x4,%esp
 2f8:	6a 01                	push   $0x1
 2fa:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2fd:	50                   	push   %eax
 2fe:	6a 00                	push   $0x0
 300:	e8 1a 02 00 00       	call   51f <read>
 305:	83 c4 10             	add    $0x10,%esp
 308:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 30b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 30f:	7e 33                	jle    344 <gets+0x5e>
      break;
    buf[i++] = c;
 311:	8b 45 f4             	mov    -0xc(%ebp),%eax
 314:	8d 50 01             	lea    0x1(%eax),%edx
 317:	89 55 f4             	mov    %edx,-0xc(%ebp)
 31a:	89 c2                	mov    %eax,%edx
 31c:	8b 45 08             	mov    0x8(%ebp),%eax
 31f:	01 c2                	add    %eax,%edx
 321:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 325:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 327:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 32b:	3c 0a                	cmp    $0xa,%al
 32d:	74 16                	je     345 <gets+0x5f>
 32f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 333:	3c 0d                	cmp    $0xd,%al
 335:	74 0e                	je     345 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 337:	8b 45 f4             	mov    -0xc(%ebp),%eax
 33a:	83 c0 01             	add    $0x1,%eax
 33d:	3b 45 0c             	cmp    0xc(%ebp),%eax
 340:	7c b3                	jl     2f5 <gets+0xf>
 342:	eb 01                	jmp    345 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 344:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 345:	8b 55 f4             	mov    -0xc(%ebp),%edx
 348:	8b 45 08             	mov    0x8(%ebp),%eax
 34b:	01 d0                	add    %edx,%eax
 34d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 350:	8b 45 08             	mov    0x8(%ebp),%eax
}
 353:	c9                   	leave  
 354:	c3                   	ret    

00000355 <stat>:

int
stat(char *n, struct stat *st)
{
 355:	55                   	push   %ebp
 356:	89 e5                	mov    %esp,%ebp
 358:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 35b:	83 ec 08             	sub    $0x8,%esp
 35e:	6a 00                	push   $0x0
 360:	ff 75 08             	pushl  0x8(%ebp)
 363:	e8 df 01 00 00       	call   547 <open>
 368:	83 c4 10             	add    $0x10,%esp
 36b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 36e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 372:	79 07                	jns    37b <stat+0x26>
    return -1;
 374:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 379:	eb 25                	jmp    3a0 <stat+0x4b>
  r = fstat(fd, st);
 37b:	83 ec 08             	sub    $0x8,%esp
 37e:	ff 75 0c             	pushl  0xc(%ebp)
 381:	ff 75 f4             	pushl  -0xc(%ebp)
 384:	e8 d6 01 00 00       	call   55f <fstat>
 389:	83 c4 10             	add    $0x10,%esp
 38c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 38f:	83 ec 0c             	sub    $0xc,%esp
 392:	ff 75 f4             	pushl  -0xc(%ebp)
 395:	e8 95 01 00 00       	call   52f <close>
 39a:	83 c4 10             	add    $0x10,%esp
  return r;
 39d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3a0:	c9                   	leave  
 3a1:	c3                   	ret    

000003a2 <atoi>:

int
atoi(const char *s)
{
 3a2:	55                   	push   %ebp
 3a3:	89 e5                	mov    %esp,%ebp
 3a5:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 3af:	eb 04                	jmp    3b5 <atoi+0x13>
 3b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3b5:	8b 45 08             	mov    0x8(%ebp),%eax
 3b8:	0f b6 00             	movzbl (%eax),%eax
 3bb:	3c 20                	cmp    $0x20,%al
 3bd:	74 f2                	je     3b1 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 3bf:	8b 45 08             	mov    0x8(%ebp),%eax
 3c2:	0f b6 00             	movzbl (%eax),%eax
 3c5:	3c 2d                	cmp    $0x2d,%al
 3c7:	75 07                	jne    3d0 <atoi+0x2e>
 3c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3ce:	eb 05                	jmp    3d5 <atoi+0x33>
 3d0:	b8 01 00 00 00       	mov    $0x1,%eax
 3d5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3d8:	8b 45 08             	mov    0x8(%ebp),%eax
 3db:	0f b6 00             	movzbl (%eax),%eax
 3de:	3c 2b                	cmp    $0x2b,%al
 3e0:	74 0a                	je     3ec <atoi+0x4a>
 3e2:	8b 45 08             	mov    0x8(%ebp),%eax
 3e5:	0f b6 00             	movzbl (%eax),%eax
 3e8:	3c 2d                	cmp    $0x2d,%al
 3ea:	75 2b                	jne    417 <atoi+0x75>
    s++;
 3ec:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 3f0:	eb 25                	jmp    417 <atoi+0x75>
    n = n*10 + *s++ - '0';
 3f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3f5:	89 d0                	mov    %edx,%eax
 3f7:	c1 e0 02             	shl    $0x2,%eax
 3fa:	01 d0                	add    %edx,%eax
 3fc:	01 c0                	add    %eax,%eax
 3fe:	89 c1                	mov    %eax,%ecx
 400:	8b 45 08             	mov    0x8(%ebp),%eax
 403:	8d 50 01             	lea    0x1(%eax),%edx
 406:	89 55 08             	mov    %edx,0x8(%ebp)
 409:	0f b6 00             	movzbl (%eax),%eax
 40c:	0f be c0             	movsbl %al,%eax
 40f:	01 c8                	add    %ecx,%eax
 411:	83 e8 30             	sub    $0x30,%eax
 414:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 417:	8b 45 08             	mov    0x8(%ebp),%eax
 41a:	0f b6 00             	movzbl (%eax),%eax
 41d:	3c 2f                	cmp    $0x2f,%al
 41f:	7e 0a                	jle    42b <atoi+0x89>
 421:	8b 45 08             	mov    0x8(%ebp),%eax
 424:	0f b6 00             	movzbl (%eax),%eax
 427:	3c 39                	cmp    $0x39,%al
 429:	7e c7                	jle    3f2 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 42b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 42e:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 432:	c9                   	leave  
 433:	c3                   	ret    

00000434 <atoo>:

int
atoo(const char *s)
{
 434:	55                   	push   %ebp
 435:	89 e5                	mov    %esp,%ebp
 437:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 43a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 441:	eb 04                	jmp    447 <atoo+0x13>
 443:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 447:	8b 45 08             	mov    0x8(%ebp),%eax
 44a:	0f b6 00             	movzbl (%eax),%eax
 44d:	3c 20                	cmp    $0x20,%al
 44f:	74 f2                	je     443 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 451:	8b 45 08             	mov    0x8(%ebp),%eax
 454:	0f b6 00             	movzbl (%eax),%eax
 457:	3c 2d                	cmp    $0x2d,%al
 459:	75 07                	jne    462 <atoo+0x2e>
 45b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 460:	eb 05                	jmp    467 <atoo+0x33>
 462:	b8 01 00 00 00       	mov    $0x1,%eax
 467:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 46a:	8b 45 08             	mov    0x8(%ebp),%eax
 46d:	0f b6 00             	movzbl (%eax),%eax
 470:	3c 2b                	cmp    $0x2b,%al
 472:	74 0a                	je     47e <atoo+0x4a>
 474:	8b 45 08             	mov    0x8(%ebp),%eax
 477:	0f b6 00             	movzbl (%eax),%eax
 47a:	3c 2d                	cmp    $0x2d,%al
 47c:	75 27                	jne    4a5 <atoo+0x71>
    s++;
 47e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 482:	eb 21                	jmp    4a5 <atoo+0x71>
    n = n*8 + *s++ - '0';
 484:	8b 45 fc             	mov    -0x4(%ebp),%eax
 487:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 48e:	8b 45 08             	mov    0x8(%ebp),%eax
 491:	8d 50 01             	lea    0x1(%eax),%edx
 494:	89 55 08             	mov    %edx,0x8(%ebp)
 497:	0f b6 00             	movzbl (%eax),%eax
 49a:	0f be c0             	movsbl %al,%eax
 49d:	01 c8                	add    %ecx,%eax
 49f:	83 e8 30             	sub    $0x30,%eax
 4a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 4a5:	8b 45 08             	mov    0x8(%ebp),%eax
 4a8:	0f b6 00             	movzbl (%eax),%eax
 4ab:	3c 2f                	cmp    $0x2f,%al
 4ad:	7e 0a                	jle    4b9 <atoo+0x85>
 4af:	8b 45 08             	mov    0x8(%ebp),%eax
 4b2:	0f b6 00             	movzbl (%eax),%eax
 4b5:	3c 37                	cmp    $0x37,%al
 4b7:	7e cb                	jle    484 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 4b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4bc:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 4c0:	c9                   	leave  
 4c1:	c3                   	ret    

000004c2 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 4c2:	55                   	push   %ebp
 4c3:	89 e5                	mov    %esp,%ebp
 4c5:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4c8:	8b 45 08             	mov    0x8(%ebp),%eax
 4cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4d4:	eb 17                	jmp    4ed <memmove+0x2b>
    *dst++ = *src++;
 4d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4d9:	8d 50 01             	lea    0x1(%eax),%edx
 4dc:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4df:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4e2:	8d 4a 01             	lea    0x1(%edx),%ecx
 4e5:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4e8:	0f b6 12             	movzbl (%edx),%edx
 4eb:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4ed:	8b 45 10             	mov    0x10(%ebp),%eax
 4f0:	8d 50 ff             	lea    -0x1(%eax),%edx
 4f3:	89 55 10             	mov    %edx,0x10(%ebp)
 4f6:	85 c0                	test   %eax,%eax
 4f8:	7f dc                	jg     4d6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 4fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4fd:	c9                   	leave  
 4fe:	c3                   	ret    

000004ff <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4ff:	b8 01 00 00 00       	mov    $0x1,%eax
 504:	cd 40                	int    $0x40
 506:	c3                   	ret    

00000507 <exit>:
SYSCALL(exit)
 507:	b8 02 00 00 00       	mov    $0x2,%eax
 50c:	cd 40                	int    $0x40
 50e:	c3                   	ret    

0000050f <wait>:
SYSCALL(wait)
 50f:	b8 03 00 00 00       	mov    $0x3,%eax
 514:	cd 40                	int    $0x40
 516:	c3                   	ret    

00000517 <pipe>:
SYSCALL(pipe)
 517:	b8 04 00 00 00       	mov    $0x4,%eax
 51c:	cd 40                	int    $0x40
 51e:	c3                   	ret    

0000051f <read>:
SYSCALL(read)
 51f:	b8 05 00 00 00       	mov    $0x5,%eax
 524:	cd 40                	int    $0x40
 526:	c3                   	ret    

00000527 <write>:
SYSCALL(write)
 527:	b8 10 00 00 00       	mov    $0x10,%eax
 52c:	cd 40                	int    $0x40
 52e:	c3                   	ret    

0000052f <close>:
SYSCALL(close)
 52f:	b8 15 00 00 00       	mov    $0x15,%eax
 534:	cd 40                	int    $0x40
 536:	c3                   	ret    

00000537 <kill>:
SYSCALL(kill)
 537:	b8 06 00 00 00       	mov    $0x6,%eax
 53c:	cd 40                	int    $0x40
 53e:	c3                   	ret    

0000053f <exec>:
SYSCALL(exec)
 53f:	b8 07 00 00 00       	mov    $0x7,%eax
 544:	cd 40                	int    $0x40
 546:	c3                   	ret    

00000547 <open>:
SYSCALL(open)
 547:	b8 0f 00 00 00       	mov    $0xf,%eax
 54c:	cd 40                	int    $0x40
 54e:	c3                   	ret    

0000054f <mknod>:
SYSCALL(mknod)
 54f:	b8 11 00 00 00       	mov    $0x11,%eax
 554:	cd 40                	int    $0x40
 556:	c3                   	ret    

00000557 <unlink>:
SYSCALL(unlink)
 557:	b8 12 00 00 00       	mov    $0x12,%eax
 55c:	cd 40                	int    $0x40
 55e:	c3                   	ret    

0000055f <fstat>:
SYSCALL(fstat)
 55f:	b8 08 00 00 00       	mov    $0x8,%eax
 564:	cd 40                	int    $0x40
 566:	c3                   	ret    

00000567 <link>:
SYSCALL(link)
 567:	b8 13 00 00 00       	mov    $0x13,%eax
 56c:	cd 40                	int    $0x40
 56e:	c3                   	ret    

0000056f <mkdir>:
SYSCALL(mkdir)
 56f:	b8 14 00 00 00       	mov    $0x14,%eax
 574:	cd 40                	int    $0x40
 576:	c3                   	ret    

00000577 <chdir>:
SYSCALL(chdir)
 577:	b8 09 00 00 00       	mov    $0x9,%eax
 57c:	cd 40                	int    $0x40
 57e:	c3                   	ret    

0000057f <dup>:
SYSCALL(dup)
 57f:	b8 0a 00 00 00       	mov    $0xa,%eax
 584:	cd 40                	int    $0x40
 586:	c3                   	ret    

00000587 <getpid>:
SYSCALL(getpid)
 587:	b8 0b 00 00 00       	mov    $0xb,%eax
 58c:	cd 40                	int    $0x40
 58e:	c3                   	ret    

0000058f <sbrk>:
SYSCALL(sbrk)
 58f:	b8 0c 00 00 00       	mov    $0xc,%eax
 594:	cd 40                	int    $0x40
 596:	c3                   	ret    

00000597 <sleep>:
SYSCALL(sleep)
 597:	b8 0d 00 00 00       	mov    $0xd,%eax
 59c:	cd 40                	int    $0x40
 59e:	c3                   	ret    

0000059f <uptime>:
SYSCALL(uptime)
 59f:	b8 0e 00 00 00       	mov    $0xe,%eax
 5a4:	cd 40                	int    $0x40
 5a6:	c3                   	ret    

000005a7 <halt>:
SYSCALL(halt)
 5a7:	b8 16 00 00 00       	mov    $0x16,%eax
 5ac:	cd 40                	int    $0x40
 5ae:	c3                   	ret    

000005af <date>:
SYSCALL(date)
 5af:	b8 17 00 00 00       	mov    $0x17,%eax
 5b4:	cd 40                	int    $0x40
 5b6:	c3                   	ret    

000005b7 <getuid>:
SYSCALL(getuid)
 5b7:	b8 18 00 00 00       	mov    $0x18,%eax
 5bc:	cd 40                	int    $0x40
 5be:	c3                   	ret    

000005bf <getgid>:
SYSCALL(getgid)
 5bf:	b8 19 00 00 00       	mov    $0x19,%eax
 5c4:	cd 40                	int    $0x40
 5c6:	c3                   	ret    

000005c7 <getppid>:
SYSCALL(getppid)
 5c7:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5cc:	cd 40                	int    $0x40
 5ce:	c3                   	ret    

000005cf <setuid>:
SYSCALL(setuid)
 5cf:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5d4:	cd 40                	int    $0x40
 5d6:	c3                   	ret    

000005d7 <setgid>:
SYSCALL(setgid)
 5d7:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5dc:	cd 40                	int    $0x40
 5de:	c3                   	ret    

000005df <getprocs>:
SYSCALL(getprocs)
 5df:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5e4:	cd 40                	int    $0x40
 5e6:	c3                   	ret    

000005e7 <setpriority>:
SYSCALL(setpriority)
 5e7:	b8 1e 00 00 00       	mov    $0x1e,%eax
 5ec:	cd 40                	int    $0x40
 5ee:	c3                   	ret    

000005ef <chmod>:
SYSCALL(chmod)
 5ef:	b8 1f 00 00 00       	mov    $0x1f,%eax
 5f4:	cd 40                	int    $0x40
 5f6:	c3                   	ret    

000005f7 <chown>:
SYSCALL(chown)
 5f7:	b8 20 00 00 00       	mov    $0x20,%eax
 5fc:	cd 40                	int    $0x40
 5fe:	c3                   	ret    

000005ff <chgrp>:
SYSCALL(chgrp)
 5ff:	b8 21 00 00 00       	mov    $0x21,%eax
 604:	cd 40                	int    $0x40
 606:	c3                   	ret    

00000607 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 607:	55                   	push   %ebp
 608:	89 e5                	mov    %esp,%ebp
 60a:	83 ec 18             	sub    $0x18,%esp
 60d:	8b 45 0c             	mov    0xc(%ebp),%eax
 610:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 613:	83 ec 04             	sub    $0x4,%esp
 616:	6a 01                	push   $0x1
 618:	8d 45 f4             	lea    -0xc(%ebp),%eax
 61b:	50                   	push   %eax
 61c:	ff 75 08             	pushl  0x8(%ebp)
 61f:	e8 03 ff ff ff       	call   527 <write>
 624:	83 c4 10             	add    $0x10,%esp
}
 627:	90                   	nop
 628:	c9                   	leave  
 629:	c3                   	ret    

0000062a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 62a:	55                   	push   %ebp
 62b:	89 e5                	mov    %esp,%ebp
 62d:	53                   	push   %ebx
 62e:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 631:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 638:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 63c:	74 17                	je     655 <printint+0x2b>
 63e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 642:	79 11                	jns    655 <printint+0x2b>
    neg = 1;
 644:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 64b:	8b 45 0c             	mov    0xc(%ebp),%eax
 64e:	f7 d8                	neg    %eax
 650:	89 45 ec             	mov    %eax,-0x14(%ebp)
 653:	eb 06                	jmp    65b <printint+0x31>
  } else {
    x = xx;
 655:	8b 45 0c             	mov    0xc(%ebp),%eax
 658:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 65b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 662:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 665:	8d 41 01             	lea    0x1(%ecx),%eax
 668:	89 45 f4             	mov    %eax,-0xc(%ebp)
 66b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 66e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 671:	ba 00 00 00 00       	mov    $0x0,%edx
 676:	f7 f3                	div    %ebx
 678:	89 d0                	mov    %edx,%eax
 67a:	0f b6 80 30 0e 00 00 	movzbl 0xe30(%eax),%eax
 681:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 685:	8b 5d 10             	mov    0x10(%ebp),%ebx
 688:	8b 45 ec             	mov    -0x14(%ebp),%eax
 68b:	ba 00 00 00 00       	mov    $0x0,%edx
 690:	f7 f3                	div    %ebx
 692:	89 45 ec             	mov    %eax,-0x14(%ebp)
 695:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 699:	75 c7                	jne    662 <printint+0x38>
  if(neg)
 69b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 69f:	74 2d                	je     6ce <printint+0xa4>
    buf[i++] = '-';
 6a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a4:	8d 50 01             	lea    0x1(%eax),%edx
 6a7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6aa:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6af:	eb 1d                	jmp    6ce <printint+0xa4>
    putc(fd, buf[i]);
 6b1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b7:	01 d0                	add    %edx,%eax
 6b9:	0f b6 00             	movzbl (%eax),%eax
 6bc:	0f be c0             	movsbl %al,%eax
 6bf:	83 ec 08             	sub    $0x8,%esp
 6c2:	50                   	push   %eax
 6c3:	ff 75 08             	pushl  0x8(%ebp)
 6c6:	e8 3c ff ff ff       	call   607 <putc>
 6cb:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6ce:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6d6:	79 d9                	jns    6b1 <printint+0x87>
    putc(fd, buf[i]);
}
 6d8:	90                   	nop
 6d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6dc:	c9                   	leave  
 6dd:	c3                   	ret    

000006de <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6de:	55                   	push   %ebp
 6df:	89 e5                	mov    %esp,%ebp
 6e1:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6e4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6eb:	8d 45 0c             	lea    0xc(%ebp),%eax
 6ee:	83 c0 04             	add    $0x4,%eax
 6f1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6fb:	e9 59 01 00 00       	jmp    859 <printf+0x17b>
    c = fmt[i] & 0xff;
 700:	8b 55 0c             	mov    0xc(%ebp),%edx
 703:	8b 45 f0             	mov    -0x10(%ebp),%eax
 706:	01 d0                	add    %edx,%eax
 708:	0f b6 00             	movzbl (%eax),%eax
 70b:	0f be c0             	movsbl %al,%eax
 70e:	25 ff 00 00 00       	and    $0xff,%eax
 713:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 716:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 71a:	75 2c                	jne    748 <printf+0x6a>
      if(c == '%'){
 71c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 720:	75 0c                	jne    72e <printf+0x50>
        state = '%';
 722:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 729:	e9 27 01 00 00       	jmp    855 <printf+0x177>
      } else {
        putc(fd, c);
 72e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 731:	0f be c0             	movsbl %al,%eax
 734:	83 ec 08             	sub    $0x8,%esp
 737:	50                   	push   %eax
 738:	ff 75 08             	pushl  0x8(%ebp)
 73b:	e8 c7 fe ff ff       	call   607 <putc>
 740:	83 c4 10             	add    $0x10,%esp
 743:	e9 0d 01 00 00       	jmp    855 <printf+0x177>
      }
    } else if(state == '%'){
 748:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 74c:	0f 85 03 01 00 00    	jne    855 <printf+0x177>
      if(c == 'd'){
 752:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 756:	75 1e                	jne    776 <printf+0x98>
        printint(fd, *ap, 10, 1);
 758:	8b 45 e8             	mov    -0x18(%ebp),%eax
 75b:	8b 00                	mov    (%eax),%eax
 75d:	6a 01                	push   $0x1
 75f:	6a 0a                	push   $0xa
 761:	50                   	push   %eax
 762:	ff 75 08             	pushl  0x8(%ebp)
 765:	e8 c0 fe ff ff       	call   62a <printint>
 76a:	83 c4 10             	add    $0x10,%esp
        ap++;
 76d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 771:	e9 d8 00 00 00       	jmp    84e <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 776:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 77a:	74 06                	je     782 <printf+0xa4>
 77c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 780:	75 1e                	jne    7a0 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 782:	8b 45 e8             	mov    -0x18(%ebp),%eax
 785:	8b 00                	mov    (%eax),%eax
 787:	6a 00                	push   $0x0
 789:	6a 10                	push   $0x10
 78b:	50                   	push   %eax
 78c:	ff 75 08             	pushl  0x8(%ebp)
 78f:	e8 96 fe ff ff       	call   62a <printint>
 794:	83 c4 10             	add    $0x10,%esp
        ap++;
 797:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 79b:	e9 ae 00 00 00       	jmp    84e <printf+0x170>
      } else if(c == 's'){
 7a0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7a4:	75 43                	jne    7e9 <printf+0x10b>
        s = (char*)*ap;
 7a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7a9:	8b 00                	mov    (%eax),%eax
 7ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7ae:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7b6:	75 25                	jne    7dd <printf+0xff>
          s = "(null)";
 7b8:	c7 45 f4 30 0b 00 00 	movl   $0xb30,-0xc(%ebp)
        while(*s != 0){
 7bf:	eb 1c                	jmp    7dd <printf+0xff>
          putc(fd, *s);
 7c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c4:	0f b6 00             	movzbl (%eax),%eax
 7c7:	0f be c0             	movsbl %al,%eax
 7ca:	83 ec 08             	sub    $0x8,%esp
 7cd:	50                   	push   %eax
 7ce:	ff 75 08             	pushl  0x8(%ebp)
 7d1:	e8 31 fe ff ff       	call   607 <putc>
 7d6:	83 c4 10             	add    $0x10,%esp
          s++;
 7d9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e0:	0f b6 00             	movzbl (%eax),%eax
 7e3:	84 c0                	test   %al,%al
 7e5:	75 da                	jne    7c1 <printf+0xe3>
 7e7:	eb 65                	jmp    84e <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7e9:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7ed:	75 1d                	jne    80c <printf+0x12e>
        putc(fd, *ap);
 7ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7f2:	8b 00                	mov    (%eax),%eax
 7f4:	0f be c0             	movsbl %al,%eax
 7f7:	83 ec 08             	sub    $0x8,%esp
 7fa:	50                   	push   %eax
 7fb:	ff 75 08             	pushl  0x8(%ebp)
 7fe:	e8 04 fe ff ff       	call   607 <putc>
 803:	83 c4 10             	add    $0x10,%esp
        ap++;
 806:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 80a:	eb 42                	jmp    84e <printf+0x170>
      } else if(c == '%'){
 80c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 810:	75 17                	jne    829 <printf+0x14b>
        putc(fd, c);
 812:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 815:	0f be c0             	movsbl %al,%eax
 818:	83 ec 08             	sub    $0x8,%esp
 81b:	50                   	push   %eax
 81c:	ff 75 08             	pushl  0x8(%ebp)
 81f:	e8 e3 fd ff ff       	call   607 <putc>
 824:	83 c4 10             	add    $0x10,%esp
 827:	eb 25                	jmp    84e <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 829:	83 ec 08             	sub    $0x8,%esp
 82c:	6a 25                	push   $0x25
 82e:	ff 75 08             	pushl  0x8(%ebp)
 831:	e8 d1 fd ff ff       	call   607 <putc>
 836:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 839:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 83c:	0f be c0             	movsbl %al,%eax
 83f:	83 ec 08             	sub    $0x8,%esp
 842:	50                   	push   %eax
 843:	ff 75 08             	pushl  0x8(%ebp)
 846:	e8 bc fd ff ff       	call   607 <putc>
 84b:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 84e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 855:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 859:	8b 55 0c             	mov    0xc(%ebp),%edx
 85c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85f:	01 d0                	add    %edx,%eax
 861:	0f b6 00             	movzbl (%eax),%eax
 864:	84 c0                	test   %al,%al
 866:	0f 85 94 fe ff ff    	jne    700 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 86c:	90                   	nop
 86d:	c9                   	leave  
 86e:	c3                   	ret    

0000086f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 86f:	55                   	push   %ebp
 870:	89 e5                	mov    %esp,%ebp
 872:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 875:	8b 45 08             	mov    0x8(%ebp),%eax
 878:	83 e8 08             	sub    $0x8,%eax
 87b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87e:	a1 4c 0e 00 00       	mov    0xe4c,%eax
 883:	89 45 fc             	mov    %eax,-0x4(%ebp)
 886:	eb 24                	jmp    8ac <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 888:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88b:	8b 00                	mov    (%eax),%eax
 88d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 890:	77 12                	ja     8a4 <free+0x35>
 892:	8b 45 f8             	mov    -0x8(%ebp),%eax
 895:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 898:	77 24                	ja     8be <free+0x4f>
 89a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89d:	8b 00                	mov    (%eax),%eax
 89f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8a2:	77 1a                	ja     8be <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a7:	8b 00                	mov    (%eax),%eax
 8a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8af:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8b2:	76 d4                	jbe    888 <free+0x19>
 8b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b7:	8b 00                	mov    (%eax),%eax
 8b9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8bc:	76 ca                	jbe    888 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c1:	8b 40 04             	mov    0x4(%eax),%eax
 8c4:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ce:	01 c2                	add    %eax,%edx
 8d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d3:	8b 00                	mov    (%eax),%eax
 8d5:	39 c2                	cmp    %eax,%edx
 8d7:	75 24                	jne    8fd <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8dc:	8b 50 04             	mov    0x4(%eax),%edx
 8df:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e2:	8b 00                	mov    (%eax),%eax
 8e4:	8b 40 04             	mov    0x4(%eax),%eax
 8e7:	01 c2                	add    %eax,%edx
 8e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ec:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f2:	8b 00                	mov    (%eax),%eax
 8f4:	8b 10                	mov    (%eax),%edx
 8f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f9:	89 10                	mov    %edx,(%eax)
 8fb:	eb 0a                	jmp    907 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 8fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 900:	8b 10                	mov    (%eax),%edx
 902:	8b 45 f8             	mov    -0x8(%ebp),%eax
 905:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 907:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90a:	8b 40 04             	mov    0x4(%eax),%eax
 90d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 914:	8b 45 fc             	mov    -0x4(%ebp),%eax
 917:	01 d0                	add    %edx,%eax
 919:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 91c:	75 20                	jne    93e <free+0xcf>
    p->s.size += bp->s.size;
 91e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 921:	8b 50 04             	mov    0x4(%eax),%edx
 924:	8b 45 f8             	mov    -0x8(%ebp),%eax
 927:	8b 40 04             	mov    0x4(%eax),%eax
 92a:	01 c2                	add    %eax,%edx
 92c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 932:	8b 45 f8             	mov    -0x8(%ebp),%eax
 935:	8b 10                	mov    (%eax),%edx
 937:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93a:	89 10                	mov    %edx,(%eax)
 93c:	eb 08                	jmp    946 <free+0xd7>
  } else
    p->s.ptr = bp;
 93e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 941:	8b 55 f8             	mov    -0x8(%ebp),%edx
 944:	89 10                	mov    %edx,(%eax)
  freep = p;
 946:	8b 45 fc             	mov    -0x4(%ebp),%eax
 949:	a3 4c 0e 00 00       	mov    %eax,0xe4c
}
 94e:	90                   	nop
 94f:	c9                   	leave  
 950:	c3                   	ret    

00000951 <morecore>:

static Header*
morecore(uint nu)
{
 951:	55                   	push   %ebp
 952:	89 e5                	mov    %esp,%ebp
 954:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 957:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 95e:	77 07                	ja     967 <morecore+0x16>
    nu = 4096;
 960:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 967:	8b 45 08             	mov    0x8(%ebp),%eax
 96a:	c1 e0 03             	shl    $0x3,%eax
 96d:	83 ec 0c             	sub    $0xc,%esp
 970:	50                   	push   %eax
 971:	e8 19 fc ff ff       	call   58f <sbrk>
 976:	83 c4 10             	add    $0x10,%esp
 979:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 97c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 980:	75 07                	jne    989 <morecore+0x38>
    return 0;
 982:	b8 00 00 00 00       	mov    $0x0,%eax
 987:	eb 26                	jmp    9af <morecore+0x5e>
  hp = (Header*)p;
 989:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 98f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 992:	8b 55 08             	mov    0x8(%ebp),%edx
 995:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 998:	8b 45 f0             	mov    -0x10(%ebp),%eax
 99b:	83 c0 08             	add    $0x8,%eax
 99e:	83 ec 0c             	sub    $0xc,%esp
 9a1:	50                   	push   %eax
 9a2:	e8 c8 fe ff ff       	call   86f <free>
 9a7:	83 c4 10             	add    $0x10,%esp
  return freep;
 9aa:	a1 4c 0e 00 00       	mov    0xe4c,%eax
}
 9af:	c9                   	leave  
 9b0:	c3                   	ret    

000009b1 <malloc>:

void*
malloc(uint nbytes)
{
 9b1:	55                   	push   %ebp
 9b2:	89 e5                	mov    %esp,%ebp
 9b4:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9b7:	8b 45 08             	mov    0x8(%ebp),%eax
 9ba:	83 c0 07             	add    $0x7,%eax
 9bd:	c1 e8 03             	shr    $0x3,%eax
 9c0:	83 c0 01             	add    $0x1,%eax
 9c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9c6:	a1 4c 0e 00 00       	mov    0xe4c,%eax
 9cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9d2:	75 23                	jne    9f7 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9d4:	c7 45 f0 44 0e 00 00 	movl   $0xe44,-0x10(%ebp)
 9db:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9de:	a3 4c 0e 00 00       	mov    %eax,0xe4c
 9e3:	a1 4c 0e 00 00       	mov    0xe4c,%eax
 9e8:	a3 44 0e 00 00       	mov    %eax,0xe44
    base.s.size = 0;
 9ed:	c7 05 48 0e 00 00 00 	movl   $0x0,0xe48
 9f4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9fa:	8b 00                	mov    (%eax),%eax
 9fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 9ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a02:	8b 40 04             	mov    0x4(%eax),%eax
 a05:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a08:	72 4d                	jb     a57 <malloc+0xa6>
      if(p->s.size == nunits)
 a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0d:	8b 40 04             	mov    0x4(%eax),%eax
 a10:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a13:	75 0c                	jne    a21 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a18:	8b 10                	mov    (%eax),%edx
 a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a1d:	89 10                	mov    %edx,(%eax)
 a1f:	eb 26                	jmp    a47 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a24:	8b 40 04             	mov    0x4(%eax),%eax
 a27:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a2a:	89 c2                	mov    %eax,%edx
 a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a35:	8b 40 04             	mov    0x4(%eax),%eax
 a38:	c1 e0 03             	shl    $0x3,%eax
 a3b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a41:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a44:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a4a:	a3 4c 0e 00 00       	mov    %eax,0xe4c
      return (void*)(p + 1);
 a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a52:	83 c0 08             	add    $0x8,%eax
 a55:	eb 3b                	jmp    a92 <malloc+0xe1>
    }
    if(p == freep)
 a57:	a1 4c 0e 00 00       	mov    0xe4c,%eax
 a5c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a5f:	75 1e                	jne    a7f <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a61:	83 ec 0c             	sub    $0xc,%esp
 a64:	ff 75 ec             	pushl  -0x14(%ebp)
 a67:	e8 e5 fe ff ff       	call   951 <morecore>
 a6c:	83 c4 10             	add    $0x10,%esp
 a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a76:	75 07                	jne    a7f <malloc+0xce>
        return 0;
 a78:	b8 00 00 00 00       	mov    $0x0,%eax
 a7d:	eb 13                	jmp    a92 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a82:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a88:	8b 00                	mov    (%eax),%eax
 a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a8d:	e9 6d ff ff ff       	jmp    9ff <malloc+0x4e>
}
 a92:	c9                   	leave  
 a93:	c3                   	ret    
