
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
  d2:	68 c5 0a 00 00       	push   $0xac5
  d7:	68 cc 0a 00 00       	push   $0xacc
  dc:	6a 02                	push   $0x2
  de:	e8 db 05 00 00       	call   6be <printf>
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
 10f:	8b 14 85 c0 0d 00 00 	mov    0xdc0(,%eax,4),%edx
 116:	8b 45 f4             	mov    -0xc(%ebp),%eax
 119:	8b 04 85 f4 0d 00 00 	mov    0xdf4(,%eax,4),%eax
 120:	83 ec 0c             	sub    $0xc,%esp
 123:	51                   	push   %ecx
 124:	52                   	push   %edx
 125:	50                   	push   %eax
 126:	68 f4 0a 00 00       	push   $0xaf4
 12b:	6a 01                	push   $0x1
 12d:	e8 8c 05 00 00       	call   6be <printf>
 132:	83 c4 20             	add    $0x20,%esp
  printf(1, " ");
 135:	83 ec 08             	sub    $0x8,%esp
 138:	68 fd 0a 00 00       	push   $0xafd
 13d:	6a 01                	push   $0x1
 13f:	e8 7a 05 00 00       	call   6be <printf>
 144:	83 c4 10             	add    $0x10,%esp
  if (r.hour < 10) printf(1, "0");
 147:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 14a:	83 f8 09             	cmp    $0x9,%eax
 14d:	77 12                	ja     161 <main+0xb5>
 14f:	83 ec 08             	sub    $0x8,%esp
 152:	68 ff 0a 00 00       	push   $0xaff
 157:	6a 01                	push   $0x1
 159:	e8 60 05 00 00       	call   6be <printf>
 15e:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d:", r.hour);
 161:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 164:	83 ec 04             	sub    $0x4,%esp
 167:	50                   	push   %eax
 168:	68 01 0b 00 00       	push   $0xb01
 16d:	6a 01                	push   $0x1
 16f:	e8 4a 05 00 00       	call   6be <printf>
 174:	83 c4 10             	add    $0x10,%esp
  if (r.minute < 10) printf(1, "0");
 177:	8b 45 e0             	mov    -0x20(%ebp),%eax
 17a:	83 f8 09             	cmp    $0x9,%eax
 17d:	77 12                	ja     191 <main+0xe5>
 17f:	83 ec 08             	sub    $0x8,%esp
 182:	68 ff 0a 00 00       	push   $0xaff
 187:	6a 01                	push   $0x1
 189:	e8 30 05 00 00       	call   6be <printf>
 18e:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d:", r.minute);
 191:	8b 45 e0             	mov    -0x20(%ebp),%eax
 194:	83 ec 04             	sub    $0x4,%esp
 197:	50                   	push   %eax
 198:	68 01 0b 00 00       	push   $0xb01
 19d:	6a 01                	push   $0x1
 19f:	e8 1a 05 00 00       	call   6be <printf>
 1a4:	83 c4 10             	add    $0x10,%esp
  if (r.second < 10) printf(1, "0");
 1a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
 1aa:	83 f8 09             	cmp    $0x9,%eax
 1ad:	77 12                	ja     1c1 <main+0x115>
 1af:	83 ec 08             	sub    $0x8,%esp
 1b2:	68 ff 0a 00 00       	push   $0xaff
 1b7:	6a 01                	push   $0x1
 1b9:	e8 00 05 00 00       	call   6be <printf>
 1be:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d UTC %d\n", r.second, r.year);
 1c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
 1c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
 1c7:	52                   	push   %edx
 1c8:	50                   	push   %eax
 1c9:	68 05 0b 00 00       	push   $0xb05
 1ce:	6a 01                	push   $0x1
 1d0:	e8 e9 04 00 00       	call   6be <printf>
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
 5ff:	e8 23 ff ff ff       	call   527 <write>
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
 65a:	0f b6 80 10 0e 00 00 	movzbl 0xe10(%eax),%eax
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
 798:	c7 45 f4 10 0b 00 00 	movl   $0xb10,-0xc(%ebp)
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
 85e:	a1 2c 0e 00 00       	mov    0xe2c,%eax
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
 929:	a3 2c 0e 00 00       	mov    %eax,0xe2c
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
 951:	e8 39 fc ff ff       	call   58f <sbrk>
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
 98a:	a1 2c 0e 00 00       	mov    0xe2c,%eax
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
 9a6:	a1 2c 0e 00 00       	mov    0xe2c,%eax
 9ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9b2:	75 23                	jne    9d7 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9b4:	c7 45 f0 24 0e 00 00 	movl   $0xe24,-0x10(%ebp)
 9bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9be:	a3 2c 0e 00 00       	mov    %eax,0xe2c
 9c3:	a1 2c 0e 00 00       	mov    0xe2c,%eax
 9c8:	a3 24 0e 00 00       	mov    %eax,0xe24
    base.s.size = 0;
 9cd:	c7 05 28 0e 00 00 00 	movl   $0x0,0xe28
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
 a2a:	a3 2c 0e 00 00       	mov    %eax,0xe2c
      return (void*)(p + 1);
 a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a32:	83 c0 08             	add    $0x8,%eax
 a35:	eb 3b                	jmp    a72 <malloc+0xe1>
    }
    if(p == freep)
 a37:	a1 2c 0e 00 00       	mov    0xe2c,%eax
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
