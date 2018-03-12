
_chmod:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
// FLIPS the order of the system calls
// syscall - chmod(TARGET, MODE);
// usercmd - chmod MODE TARGET

int
main(int argc, char **argv) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  if (argc != 3) {
  14:	83 3b 03             	cmpl   $0x3,(%ebx)
  17:	74 17                	je     30 <main+0x30>
      printf(1, "Invalid arguments.\n"); // needs to have 2 arguments, along with implicit 1st (3 total)
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 25 0a 00 00       	push   $0xa25
  21:	6a 01                	push   $0x1
  23:	e8 47 06 00 00       	call   66f <printf>
  28:	83 c4 10             	add    $0x10,%esp
      exit();
  2b:	e8 68 04 00 00       	call   498 <exit>
  }
  int mode, rc, valid = 0;
  30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char *path;
  if ((argv[1][0] == '0') || (argv[1][0] == '1')) {
  37:	8b 43 04             	mov    0x4(%ebx),%eax
  3a:	83 c0 04             	add    $0x4,%eax
  3d:	8b 00                	mov    (%eax),%eax
  3f:	0f b6 00             	movzbl (%eax),%eax
  42:	3c 30                	cmp    $0x30,%al
  44:	74 13                	je     59 <main+0x59>
  46:	8b 43 04             	mov    0x4(%ebx),%eax
  49:	83 c0 04             	add    $0x4,%eax
  4c:	8b 00                	mov    (%eax),%eax
  4e:	0f b6 00             	movzbl (%eax),%eax
  51:	3c 31                	cmp    $0x31,%al
  53:	0f 85 85 00 00 00    	jne    de <main+0xde>
      if ((argv[1][1] >= '0') && (argv[1][1] <= '7')) {
  59:	8b 43 04             	mov    0x4(%ebx),%eax
  5c:	83 c0 04             	add    $0x4,%eax
  5f:	8b 00                	mov    (%eax),%eax
  61:	83 c0 01             	add    $0x1,%eax
  64:	0f b6 00             	movzbl (%eax),%eax
  67:	3c 2f                	cmp    $0x2f,%al
  69:	7e 73                	jle    de <main+0xde>
  6b:	8b 43 04             	mov    0x4(%ebx),%eax
  6e:	83 c0 04             	add    $0x4,%eax
  71:	8b 00                	mov    (%eax),%eax
  73:	83 c0 01             	add    $0x1,%eax
  76:	0f b6 00             	movzbl (%eax),%eax
  79:	3c 37                	cmp    $0x37,%al
  7b:	7f 61                	jg     de <main+0xde>
          if ((argv[1][2] >= '0') && (argv[1][2] <= '7')) {
  7d:	8b 43 04             	mov    0x4(%ebx),%eax
  80:	83 c0 04             	add    $0x4,%eax
  83:	8b 00                	mov    (%eax),%eax
  85:	83 c0 02             	add    $0x2,%eax
  88:	0f b6 00             	movzbl (%eax),%eax
  8b:	3c 2f                	cmp    $0x2f,%al
  8d:	7e 4f                	jle    de <main+0xde>
  8f:	8b 43 04             	mov    0x4(%ebx),%eax
  92:	83 c0 04             	add    $0x4,%eax
  95:	8b 00                	mov    (%eax),%eax
  97:	83 c0 02             	add    $0x2,%eax
  9a:	0f b6 00             	movzbl (%eax),%eax
  9d:	3c 37                	cmp    $0x37,%al
  9f:	7f 3d                	jg     de <main+0xde>
              if ((argv[1][3] >= '0') && (argv[1][3] <= '7')) {
  a1:	8b 43 04             	mov    0x4(%ebx),%eax
  a4:	83 c0 04             	add    $0x4,%eax
  a7:	8b 00                	mov    (%eax),%eax
  a9:	83 c0 03             	add    $0x3,%eax
  ac:	0f b6 00             	movzbl (%eax),%eax
  af:	3c 2f                	cmp    $0x2f,%al
  b1:	7e 2b                	jle    de <main+0xde>
  b3:	8b 43 04             	mov    0x4(%ebx),%eax
  b6:	83 c0 04             	add    $0x4,%eax
  b9:	8b 00                	mov    (%eax),%eax
  bb:	83 c0 03             	add    $0x3,%eax
  be:	0f b6 00             	movzbl (%eax),%eax
  c1:	3c 37                	cmp    $0x37,%al
  c3:	7f 19                	jg     de <main+0xde>
                  if (!argv[1][4]) {
  c5:	8b 43 04             	mov    0x4(%ebx),%eax
  c8:	83 c0 04             	add    $0x4,%eax
  cb:	8b 00                	mov    (%eax),%eax
  cd:	83 c0 04             	add    $0x4,%eax
  d0:	0f b6 00             	movzbl (%eax),%eax
  d3:	84 c0                	test   %al,%al
  d5:	75 07                	jne    de <main+0xde>
                      valid = 1; // number is at least 0000 and at most 1777
  d7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
              }
          }
      }
  }
  // check validity of argument (could have been 888888)
  if (valid) {
  de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  e2:	74 3c                	je     120 <main+0x120>
      mode = atoo(argv[1]); // convert octal int
  e4:	8b 43 04             	mov    0x4(%ebx),%eax
  e7:	83 c0 04             	add    $0x4,%eax
  ea:	8b 00                	mov    (%eax),%eax
  ec:	83 ec 0c             	sub    $0xc,%esp
  ef:	50                   	push   %eax
  f0:	e8 d0 02 00 00       	call   3c5 <atoo>
  f5:	83 c4 10             	add    $0x10,%esp
  f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  } else {
      printf(1, "Invalid mode.\n"); // needs to have 2 arguments, along with implicit 1st (3 total)
      exit();
  }
  path = argv[2];
  fb:	8b 43 04             	mov    0x4(%ebx),%eax
  fe:	8b 40 08             	mov    0x8(%eax),%eax
 101:	89 45 ec             	mov    %eax,-0x14(%ebp)
  rc = chmod(path, mode); // order is reversed for user cmd - system call
 104:	83 ec 08             	sub    $0x8,%esp
 107:	ff 75 f0             	pushl  -0x10(%ebp)
 10a:	ff 75 ec             	pushl  -0x14(%ebp)
 10d:	e8 6e 04 00 00       	call   580 <chmod>
 112:	83 c4 10             	add    $0x10,%esp
 115:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if (rc < 0) {
 118:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 11c:	79 4b                	jns    169 <main+0x169>
 11e:	eb 17                	jmp    137 <main+0x137>
  }
  // check validity of argument (could have been 888888)
  if (valid) {
      mode = atoo(argv[1]); // convert octal int
  } else {
      printf(1, "Invalid mode.\n"); // needs to have 2 arguments, along with implicit 1st (3 total)
 120:	83 ec 08             	sub    $0x8,%esp
 123:	68 39 0a 00 00       	push   $0xa39
 128:	6a 01                	push   $0x1
 12a:	e8 40 05 00 00       	call   66f <printf>
 12f:	83 c4 10             	add    $0x10,%esp
      exit();
 132:	e8 61 03 00 00       	call   498 <exit>
  }
  path = argv[2];
  rc = chmod(path, mode); // order is reversed for user cmd - system call
  if (rc < 0) {
      if (rc == -1) {
 137:	83 7d e8 ff          	cmpl   $0xffffffff,-0x18(%ebp)
 13b:	75 14                	jne    151 <main+0x151>
          printf(1, "chmod: Invalid pathname.\n");
 13d:	83 ec 08             	sub    $0x8,%esp
 140:	68 48 0a 00 00       	push   $0xa48
 145:	6a 01                	push   $0x1
 147:	e8 23 05 00 00       	call   66f <printf>
 14c:	83 c4 10             	add    $0x10,%esp
 14f:	eb 18                	jmp    169 <main+0x169>
      }
      else if (rc == -2) {
 151:	83 7d e8 fe          	cmpl   $0xfffffffe,-0x18(%ebp)
 155:	75 12                	jne    169 <main+0x169>
          printf(1, "chmod: Invalid mode.\n");
 157:	83 ec 08             	sub    $0x8,%esp
 15a:	68 62 0a 00 00       	push   $0xa62
 15f:	6a 01                	push   $0x1
 161:	e8 09 05 00 00       	call   66f <printf>
 166:	83 c4 10             	add    $0x10,%esp
      }
  }
  exit();
 169:	e8 2a 03 00 00       	call   498 <exit>

0000016e <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	57                   	push   %edi
 172:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 173:	8b 4d 08             	mov    0x8(%ebp),%ecx
 176:	8b 55 10             	mov    0x10(%ebp),%edx
 179:	8b 45 0c             	mov    0xc(%ebp),%eax
 17c:	89 cb                	mov    %ecx,%ebx
 17e:	89 df                	mov    %ebx,%edi
 180:	89 d1                	mov    %edx,%ecx
 182:	fc                   	cld    
 183:	f3 aa                	rep stos %al,%es:(%edi)
 185:	89 ca                	mov    %ecx,%edx
 187:	89 fb                	mov    %edi,%ebx
 189:	89 5d 08             	mov    %ebx,0x8(%ebp)
 18c:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 18f:	90                   	nop
 190:	5b                   	pop    %ebx
 191:	5f                   	pop    %edi
 192:	5d                   	pop    %ebp
 193:	c3                   	ret    

00000194 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 19a:	8b 45 08             	mov    0x8(%ebp),%eax
 19d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1a0:	90                   	nop
 1a1:	8b 45 08             	mov    0x8(%ebp),%eax
 1a4:	8d 50 01             	lea    0x1(%eax),%edx
 1a7:	89 55 08             	mov    %edx,0x8(%ebp)
 1aa:	8b 55 0c             	mov    0xc(%ebp),%edx
 1ad:	8d 4a 01             	lea    0x1(%edx),%ecx
 1b0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1b3:	0f b6 12             	movzbl (%edx),%edx
 1b6:	88 10                	mov    %dl,(%eax)
 1b8:	0f b6 00             	movzbl (%eax),%eax
 1bb:	84 c0                	test   %al,%al
 1bd:	75 e2                	jne    1a1 <strcpy+0xd>
    ;
  return os;
 1bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c2:	c9                   	leave  
 1c3:	c3                   	ret    

000001c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1c7:	eb 08                	jmp    1d1 <strcmp+0xd>
    p++, q++;
 1c9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1cd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1d1:	8b 45 08             	mov    0x8(%ebp),%eax
 1d4:	0f b6 00             	movzbl (%eax),%eax
 1d7:	84 c0                	test   %al,%al
 1d9:	74 10                	je     1eb <strcmp+0x27>
 1db:	8b 45 08             	mov    0x8(%ebp),%eax
 1de:	0f b6 10             	movzbl (%eax),%edx
 1e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e4:	0f b6 00             	movzbl (%eax),%eax
 1e7:	38 c2                	cmp    %al,%dl
 1e9:	74 de                	je     1c9 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1eb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ee:	0f b6 00             	movzbl (%eax),%eax
 1f1:	0f b6 d0             	movzbl %al,%edx
 1f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f7:	0f b6 00             	movzbl (%eax),%eax
 1fa:	0f b6 c0             	movzbl %al,%eax
 1fd:	29 c2                	sub    %eax,%edx
 1ff:	89 d0                	mov    %edx,%eax
}
 201:	5d                   	pop    %ebp
 202:	c3                   	ret    

00000203 <strlen>:

uint
strlen(char *s)
{
 203:	55                   	push   %ebp
 204:	89 e5                	mov    %esp,%ebp
 206:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 209:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 210:	eb 04                	jmp    216 <strlen+0x13>
 212:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 216:	8b 55 fc             	mov    -0x4(%ebp),%edx
 219:	8b 45 08             	mov    0x8(%ebp),%eax
 21c:	01 d0                	add    %edx,%eax
 21e:	0f b6 00             	movzbl (%eax),%eax
 221:	84 c0                	test   %al,%al
 223:	75 ed                	jne    212 <strlen+0xf>
    ;
  return n;
 225:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 228:	c9                   	leave  
 229:	c3                   	ret    

0000022a <memset>:

void*
memset(void *dst, int c, uint n)
{
 22a:	55                   	push   %ebp
 22b:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 22d:	8b 45 10             	mov    0x10(%ebp),%eax
 230:	50                   	push   %eax
 231:	ff 75 0c             	pushl  0xc(%ebp)
 234:	ff 75 08             	pushl  0x8(%ebp)
 237:	e8 32 ff ff ff       	call   16e <stosb>
 23c:	83 c4 0c             	add    $0xc,%esp
  return dst;
 23f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 242:	c9                   	leave  
 243:	c3                   	ret    

00000244 <strchr>:

char*
strchr(const char *s, char c)
{
 244:	55                   	push   %ebp
 245:	89 e5                	mov    %esp,%ebp
 247:	83 ec 04             	sub    $0x4,%esp
 24a:	8b 45 0c             	mov    0xc(%ebp),%eax
 24d:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 250:	eb 14                	jmp    266 <strchr+0x22>
    if(*s == c)
 252:	8b 45 08             	mov    0x8(%ebp),%eax
 255:	0f b6 00             	movzbl (%eax),%eax
 258:	3a 45 fc             	cmp    -0x4(%ebp),%al
 25b:	75 05                	jne    262 <strchr+0x1e>
      return (char*)s;
 25d:	8b 45 08             	mov    0x8(%ebp),%eax
 260:	eb 13                	jmp    275 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 262:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 266:	8b 45 08             	mov    0x8(%ebp),%eax
 269:	0f b6 00             	movzbl (%eax),%eax
 26c:	84 c0                	test   %al,%al
 26e:	75 e2                	jne    252 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 270:	b8 00 00 00 00       	mov    $0x0,%eax
}
 275:	c9                   	leave  
 276:	c3                   	ret    

00000277 <gets>:

char*
gets(char *buf, int max)
{
 277:	55                   	push   %ebp
 278:	89 e5                	mov    %esp,%ebp
 27a:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 284:	eb 42                	jmp    2c8 <gets+0x51>
    cc = read(0, &c, 1);
 286:	83 ec 04             	sub    $0x4,%esp
 289:	6a 01                	push   $0x1
 28b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 28e:	50                   	push   %eax
 28f:	6a 00                	push   $0x0
 291:	e8 1a 02 00 00       	call   4b0 <read>
 296:	83 c4 10             	add    $0x10,%esp
 299:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 29c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2a0:	7e 33                	jle    2d5 <gets+0x5e>
      break;
    buf[i++] = c;
 2a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a5:	8d 50 01             	lea    0x1(%eax),%edx
 2a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 2ab:	89 c2                	mov    %eax,%edx
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	01 c2                	add    %eax,%edx
 2b2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2b6:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 2b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2bc:	3c 0a                	cmp    $0xa,%al
 2be:	74 16                	je     2d6 <gets+0x5f>
 2c0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2c4:	3c 0d                	cmp    $0xd,%al
 2c6:	74 0e                	je     2d6 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2cb:	83 c0 01             	add    $0x1,%eax
 2ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2d1:	7c b3                	jl     286 <gets+0xf>
 2d3:	eb 01                	jmp    2d6 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2d5:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	01 d0                	add    %edx,%eax
 2de:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2e4:	c9                   	leave  
 2e5:	c3                   	ret    

000002e6 <stat>:

int
stat(char *n, struct stat *st)
{
 2e6:	55                   	push   %ebp
 2e7:	89 e5                	mov    %esp,%ebp
 2e9:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ec:	83 ec 08             	sub    $0x8,%esp
 2ef:	6a 00                	push   $0x0
 2f1:	ff 75 08             	pushl  0x8(%ebp)
 2f4:	e8 df 01 00 00       	call   4d8 <open>
 2f9:	83 c4 10             	add    $0x10,%esp
 2fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 303:	79 07                	jns    30c <stat+0x26>
    return -1;
 305:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 30a:	eb 25                	jmp    331 <stat+0x4b>
  r = fstat(fd, st);
 30c:	83 ec 08             	sub    $0x8,%esp
 30f:	ff 75 0c             	pushl  0xc(%ebp)
 312:	ff 75 f4             	pushl  -0xc(%ebp)
 315:	e8 d6 01 00 00       	call   4f0 <fstat>
 31a:	83 c4 10             	add    $0x10,%esp
 31d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 320:	83 ec 0c             	sub    $0xc,%esp
 323:	ff 75 f4             	pushl  -0xc(%ebp)
 326:	e8 95 01 00 00       	call   4c0 <close>
 32b:	83 c4 10             	add    $0x10,%esp
  return r;
 32e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 331:	c9                   	leave  
 332:	c3                   	ret    

00000333 <atoi>:

int
atoi(const char *s)
{
 333:	55                   	push   %ebp
 334:	89 e5                	mov    %esp,%ebp
 336:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 339:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 340:	eb 04                	jmp    346 <atoi+0x13>
 342:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 346:	8b 45 08             	mov    0x8(%ebp),%eax
 349:	0f b6 00             	movzbl (%eax),%eax
 34c:	3c 20                	cmp    $0x20,%al
 34e:	74 f2                	je     342 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 350:	8b 45 08             	mov    0x8(%ebp),%eax
 353:	0f b6 00             	movzbl (%eax),%eax
 356:	3c 2d                	cmp    $0x2d,%al
 358:	75 07                	jne    361 <atoi+0x2e>
 35a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 35f:	eb 05                	jmp    366 <atoi+0x33>
 361:	b8 01 00 00 00       	mov    $0x1,%eax
 366:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 369:	8b 45 08             	mov    0x8(%ebp),%eax
 36c:	0f b6 00             	movzbl (%eax),%eax
 36f:	3c 2b                	cmp    $0x2b,%al
 371:	74 0a                	je     37d <atoi+0x4a>
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	0f b6 00             	movzbl (%eax),%eax
 379:	3c 2d                	cmp    $0x2d,%al
 37b:	75 2b                	jne    3a8 <atoi+0x75>
    s++;
 37d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 381:	eb 25                	jmp    3a8 <atoi+0x75>
    n = n*10 + *s++ - '0';
 383:	8b 55 fc             	mov    -0x4(%ebp),%edx
 386:	89 d0                	mov    %edx,%eax
 388:	c1 e0 02             	shl    $0x2,%eax
 38b:	01 d0                	add    %edx,%eax
 38d:	01 c0                	add    %eax,%eax
 38f:	89 c1                	mov    %eax,%ecx
 391:	8b 45 08             	mov    0x8(%ebp),%eax
 394:	8d 50 01             	lea    0x1(%eax),%edx
 397:	89 55 08             	mov    %edx,0x8(%ebp)
 39a:	0f b6 00             	movzbl (%eax),%eax
 39d:	0f be c0             	movsbl %al,%eax
 3a0:	01 c8                	add    %ecx,%eax
 3a2:	83 e8 30             	sub    $0x30,%eax
 3a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 3a8:	8b 45 08             	mov    0x8(%ebp),%eax
 3ab:	0f b6 00             	movzbl (%eax),%eax
 3ae:	3c 2f                	cmp    $0x2f,%al
 3b0:	7e 0a                	jle    3bc <atoi+0x89>
 3b2:	8b 45 08             	mov    0x8(%ebp),%eax
 3b5:	0f b6 00             	movzbl (%eax),%eax
 3b8:	3c 39                	cmp    $0x39,%al
 3ba:	7e c7                	jle    383 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 3bc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3bf:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 3c3:	c9                   	leave  
 3c4:	c3                   	ret    

000003c5 <atoo>:

int
atoo(const char *s)
{
 3c5:	55                   	push   %ebp
 3c6:	89 e5                	mov    %esp,%ebp
 3c8:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 3d2:	eb 04                	jmp    3d8 <atoo+0x13>
 3d4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3d8:	8b 45 08             	mov    0x8(%ebp),%eax
 3db:	0f b6 00             	movzbl (%eax),%eax
 3de:	3c 20                	cmp    $0x20,%al
 3e0:	74 f2                	je     3d4 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 3e2:	8b 45 08             	mov    0x8(%ebp),%eax
 3e5:	0f b6 00             	movzbl (%eax),%eax
 3e8:	3c 2d                	cmp    $0x2d,%al
 3ea:	75 07                	jne    3f3 <atoo+0x2e>
 3ec:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3f1:	eb 05                	jmp    3f8 <atoo+0x33>
 3f3:	b8 01 00 00 00       	mov    $0x1,%eax
 3f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3fb:	8b 45 08             	mov    0x8(%ebp),%eax
 3fe:	0f b6 00             	movzbl (%eax),%eax
 401:	3c 2b                	cmp    $0x2b,%al
 403:	74 0a                	je     40f <atoo+0x4a>
 405:	8b 45 08             	mov    0x8(%ebp),%eax
 408:	0f b6 00             	movzbl (%eax),%eax
 40b:	3c 2d                	cmp    $0x2d,%al
 40d:	75 27                	jne    436 <atoo+0x71>
    s++;
 40f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 413:	eb 21                	jmp    436 <atoo+0x71>
    n = n*8 + *s++ - '0';
 415:	8b 45 fc             	mov    -0x4(%ebp),%eax
 418:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 41f:	8b 45 08             	mov    0x8(%ebp),%eax
 422:	8d 50 01             	lea    0x1(%eax),%edx
 425:	89 55 08             	mov    %edx,0x8(%ebp)
 428:	0f b6 00             	movzbl (%eax),%eax
 42b:	0f be c0             	movsbl %al,%eax
 42e:	01 c8                	add    %ecx,%eax
 430:	83 e8 30             	sub    $0x30,%eax
 433:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 436:	8b 45 08             	mov    0x8(%ebp),%eax
 439:	0f b6 00             	movzbl (%eax),%eax
 43c:	3c 2f                	cmp    $0x2f,%al
 43e:	7e 0a                	jle    44a <atoo+0x85>
 440:	8b 45 08             	mov    0x8(%ebp),%eax
 443:	0f b6 00             	movzbl (%eax),%eax
 446:	3c 37                	cmp    $0x37,%al
 448:	7e cb                	jle    415 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 44a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 44d:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 451:	c9                   	leave  
 452:	c3                   	ret    

00000453 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 453:	55                   	push   %ebp
 454:	89 e5                	mov    %esp,%ebp
 456:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 459:	8b 45 08             	mov    0x8(%ebp),%eax
 45c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 45f:	8b 45 0c             	mov    0xc(%ebp),%eax
 462:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 465:	eb 17                	jmp    47e <memmove+0x2b>
    *dst++ = *src++;
 467:	8b 45 fc             	mov    -0x4(%ebp),%eax
 46a:	8d 50 01             	lea    0x1(%eax),%edx
 46d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 470:	8b 55 f8             	mov    -0x8(%ebp),%edx
 473:	8d 4a 01             	lea    0x1(%edx),%ecx
 476:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 479:	0f b6 12             	movzbl (%edx),%edx
 47c:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 47e:	8b 45 10             	mov    0x10(%ebp),%eax
 481:	8d 50 ff             	lea    -0x1(%eax),%edx
 484:	89 55 10             	mov    %edx,0x10(%ebp)
 487:	85 c0                	test   %eax,%eax
 489:	7f dc                	jg     467 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 48b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 48e:	c9                   	leave  
 48f:	c3                   	ret    

00000490 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 490:	b8 01 00 00 00       	mov    $0x1,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <exit>:
SYSCALL(exit)
 498:	b8 02 00 00 00       	mov    $0x2,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <wait>:
SYSCALL(wait)
 4a0:	b8 03 00 00 00       	mov    $0x3,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <pipe>:
SYSCALL(pipe)
 4a8:	b8 04 00 00 00       	mov    $0x4,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <read>:
SYSCALL(read)
 4b0:	b8 05 00 00 00       	mov    $0x5,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <write>:
SYSCALL(write)
 4b8:	b8 10 00 00 00       	mov    $0x10,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <close>:
SYSCALL(close)
 4c0:	b8 15 00 00 00       	mov    $0x15,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <kill>:
SYSCALL(kill)
 4c8:	b8 06 00 00 00       	mov    $0x6,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <exec>:
SYSCALL(exec)
 4d0:	b8 07 00 00 00       	mov    $0x7,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <open>:
SYSCALL(open)
 4d8:	b8 0f 00 00 00       	mov    $0xf,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <mknod>:
SYSCALL(mknod)
 4e0:	b8 11 00 00 00       	mov    $0x11,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <unlink>:
SYSCALL(unlink)
 4e8:	b8 12 00 00 00       	mov    $0x12,%eax
 4ed:	cd 40                	int    $0x40
 4ef:	c3                   	ret    

000004f0 <fstat>:
SYSCALL(fstat)
 4f0:	b8 08 00 00 00       	mov    $0x8,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <link>:
SYSCALL(link)
 4f8:	b8 13 00 00 00       	mov    $0x13,%eax
 4fd:	cd 40                	int    $0x40
 4ff:	c3                   	ret    

00000500 <mkdir>:
SYSCALL(mkdir)
 500:	b8 14 00 00 00       	mov    $0x14,%eax
 505:	cd 40                	int    $0x40
 507:	c3                   	ret    

00000508 <chdir>:
SYSCALL(chdir)
 508:	b8 09 00 00 00       	mov    $0x9,%eax
 50d:	cd 40                	int    $0x40
 50f:	c3                   	ret    

00000510 <dup>:
SYSCALL(dup)
 510:	b8 0a 00 00 00       	mov    $0xa,%eax
 515:	cd 40                	int    $0x40
 517:	c3                   	ret    

00000518 <getpid>:
SYSCALL(getpid)
 518:	b8 0b 00 00 00       	mov    $0xb,%eax
 51d:	cd 40                	int    $0x40
 51f:	c3                   	ret    

00000520 <sbrk>:
SYSCALL(sbrk)
 520:	b8 0c 00 00 00       	mov    $0xc,%eax
 525:	cd 40                	int    $0x40
 527:	c3                   	ret    

00000528 <sleep>:
SYSCALL(sleep)
 528:	b8 0d 00 00 00       	mov    $0xd,%eax
 52d:	cd 40                	int    $0x40
 52f:	c3                   	ret    

00000530 <uptime>:
SYSCALL(uptime)
 530:	b8 0e 00 00 00       	mov    $0xe,%eax
 535:	cd 40                	int    $0x40
 537:	c3                   	ret    

00000538 <halt>:
SYSCALL(halt)
 538:	b8 16 00 00 00       	mov    $0x16,%eax
 53d:	cd 40                	int    $0x40
 53f:	c3                   	ret    

00000540 <date>:
SYSCALL(date)
 540:	b8 17 00 00 00       	mov    $0x17,%eax
 545:	cd 40                	int    $0x40
 547:	c3                   	ret    

00000548 <getuid>:
SYSCALL(getuid)
 548:	b8 18 00 00 00       	mov    $0x18,%eax
 54d:	cd 40                	int    $0x40
 54f:	c3                   	ret    

00000550 <getgid>:
SYSCALL(getgid)
 550:	b8 19 00 00 00       	mov    $0x19,%eax
 555:	cd 40                	int    $0x40
 557:	c3                   	ret    

00000558 <getppid>:
SYSCALL(getppid)
 558:	b8 1a 00 00 00       	mov    $0x1a,%eax
 55d:	cd 40                	int    $0x40
 55f:	c3                   	ret    

00000560 <setuid>:
SYSCALL(setuid)
 560:	b8 1b 00 00 00       	mov    $0x1b,%eax
 565:	cd 40                	int    $0x40
 567:	c3                   	ret    

00000568 <setgid>:
SYSCALL(setgid)
 568:	b8 1c 00 00 00       	mov    $0x1c,%eax
 56d:	cd 40                	int    $0x40
 56f:	c3                   	ret    

00000570 <getprocs>:
SYSCALL(getprocs)
 570:	b8 1d 00 00 00       	mov    $0x1d,%eax
 575:	cd 40                	int    $0x40
 577:	c3                   	ret    

00000578 <setpriority>:
SYSCALL(setpriority)
 578:	b8 1e 00 00 00       	mov    $0x1e,%eax
 57d:	cd 40                	int    $0x40
 57f:	c3                   	ret    

00000580 <chmod>:
SYSCALL(chmod)
 580:	b8 1f 00 00 00       	mov    $0x1f,%eax
 585:	cd 40                	int    $0x40
 587:	c3                   	ret    

00000588 <chown>:
SYSCALL(chown)
 588:	b8 20 00 00 00       	mov    $0x20,%eax
 58d:	cd 40                	int    $0x40
 58f:	c3                   	ret    

00000590 <chgrp>:
SYSCALL(chgrp)
 590:	b8 21 00 00 00       	mov    $0x21,%eax
 595:	cd 40                	int    $0x40
 597:	c3                   	ret    

00000598 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 598:	55                   	push   %ebp
 599:	89 e5                	mov    %esp,%ebp
 59b:	83 ec 18             	sub    $0x18,%esp
 59e:	8b 45 0c             	mov    0xc(%ebp),%eax
 5a1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5a4:	83 ec 04             	sub    $0x4,%esp
 5a7:	6a 01                	push   $0x1
 5a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5ac:	50                   	push   %eax
 5ad:	ff 75 08             	pushl  0x8(%ebp)
 5b0:	e8 03 ff ff ff       	call   4b8 <write>
 5b5:	83 c4 10             	add    $0x10,%esp
}
 5b8:	90                   	nop
 5b9:	c9                   	leave  
 5ba:	c3                   	ret    

000005bb <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5bb:	55                   	push   %ebp
 5bc:	89 e5                	mov    %esp,%ebp
 5be:	53                   	push   %ebx
 5bf:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5c2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5c9:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5cd:	74 17                	je     5e6 <printint+0x2b>
 5cf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5d3:	79 11                	jns    5e6 <printint+0x2b>
    neg = 1;
 5d5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 5df:	f7 d8                	neg    %eax
 5e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5e4:	eb 06                	jmp    5ec <printint+0x31>
  } else {
    x = xx;
 5e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 5e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5f3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5f6:	8d 41 01             	lea    0x1(%ecx),%eax
 5f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
 602:	ba 00 00 00 00       	mov    $0x0,%edx
 607:	f7 f3                	div    %ebx
 609:	89 d0                	mov    %edx,%eax
 60b:	0f b6 80 ec 0c 00 00 	movzbl 0xcec(%eax),%eax
 612:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 616:	8b 5d 10             	mov    0x10(%ebp),%ebx
 619:	8b 45 ec             	mov    -0x14(%ebp),%eax
 61c:	ba 00 00 00 00       	mov    $0x0,%edx
 621:	f7 f3                	div    %ebx
 623:	89 45 ec             	mov    %eax,-0x14(%ebp)
 626:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 62a:	75 c7                	jne    5f3 <printint+0x38>
  if(neg)
 62c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 630:	74 2d                	je     65f <printint+0xa4>
    buf[i++] = '-';
 632:	8b 45 f4             	mov    -0xc(%ebp),%eax
 635:	8d 50 01             	lea    0x1(%eax),%edx
 638:	89 55 f4             	mov    %edx,-0xc(%ebp)
 63b:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 640:	eb 1d                	jmp    65f <printint+0xa4>
    putc(fd, buf[i]);
 642:	8d 55 dc             	lea    -0x24(%ebp),%edx
 645:	8b 45 f4             	mov    -0xc(%ebp),%eax
 648:	01 d0                	add    %edx,%eax
 64a:	0f b6 00             	movzbl (%eax),%eax
 64d:	0f be c0             	movsbl %al,%eax
 650:	83 ec 08             	sub    $0x8,%esp
 653:	50                   	push   %eax
 654:	ff 75 08             	pushl  0x8(%ebp)
 657:	e8 3c ff ff ff       	call   598 <putc>
 65c:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 65f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 663:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 667:	79 d9                	jns    642 <printint+0x87>
    putc(fd, buf[i]);
}
 669:	90                   	nop
 66a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 66d:	c9                   	leave  
 66e:	c3                   	ret    

0000066f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 66f:	55                   	push   %ebp
 670:	89 e5                	mov    %esp,%ebp
 672:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 675:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 67c:	8d 45 0c             	lea    0xc(%ebp),%eax
 67f:	83 c0 04             	add    $0x4,%eax
 682:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 685:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 68c:	e9 59 01 00 00       	jmp    7ea <printf+0x17b>
    c = fmt[i] & 0xff;
 691:	8b 55 0c             	mov    0xc(%ebp),%edx
 694:	8b 45 f0             	mov    -0x10(%ebp),%eax
 697:	01 d0                	add    %edx,%eax
 699:	0f b6 00             	movzbl (%eax),%eax
 69c:	0f be c0             	movsbl %al,%eax
 69f:	25 ff 00 00 00       	and    $0xff,%eax
 6a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 6a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6ab:	75 2c                	jne    6d9 <printf+0x6a>
      if(c == '%'){
 6ad:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6b1:	75 0c                	jne    6bf <printf+0x50>
        state = '%';
 6b3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6ba:	e9 27 01 00 00       	jmp    7e6 <printf+0x177>
      } else {
        putc(fd, c);
 6bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c2:	0f be c0             	movsbl %al,%eax
 6c5:	83 ec 08             	sub    $0x8,%esp
 6c8:	50                   	push   %eax
 6c9:	ff 75 08             	pushl  0x8(%ebp)
 6cc:	e8 c7 fe ff ff       	call   598 <putc>
 6d1:	83 c4 10             	add    $0x10,%esp
 6d4:	e9 0d 01 00 00       	jmp    7e6 <printf+0x177>
      }
    } else if(state == '%'){
 6d9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6dd:	0f 85 03 01 00 00    	jne    7e6 <printf+0x177>
      if(c == 'd'){
 6e3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6e7:	75 1e                	jne    707 <printf+0x98>
        printint(fd, *ap, 10, 1);
 6e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ec:	8b 00                	mov    (%eax),%eax
 6ee:	6a 01                	push   $0x1
 6f0:	6a 0a                	push   $0xa
 6f2:	50                   	push   %eax
 6f3:	ff 75 08             	pushl  0x8(%ebp)
 6f6:	e8 c0 fe ff ff       	call   5bb <printint>
 6fb:	83 c4 10             	add    $0x10,%esp
        ap++;
 6fe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 702:	e9 d8 00 00 00       	jmp    7df <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 707:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 70b:	74 06                	je     713 <printf+0xa4>
 70d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 711:	75 1e                	jne    731 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 713:	8b 45 e8             	mov    -0x18(%ebp),%eax
 716:	8b 00                	mov    (%eax),%eax
 718:	6a 00                	push   $0x0
 71a:	6a 10                	push   $0x10
 71c:	50                   	push   %eax
 71d:	ff 75 08             	pushl  0x8(%ebp)
 720:	e8 96 fe ff ff       	call   5bb <printint>
 725:	83 c4 10             	add    $0x10,%esp
        ap++;
 728:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 72c:	e9 ae 00 00 00       	jmp    7df <printf+0x170>
      } else if(c == 's'){
 731:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 735:	75 43                	jne    77a <printf+0x10b>
        s = (char*)*ap;
 737:	8b 45 e8             	mov    -0x18(%ebp),%eax
 73a:	8b 00                	mov    (%eax),%eax
 73c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 73f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 743:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 747:	75 25                	jne    76e <printf+0xff>
          s = "(null)";
 749:	c7 45 f4 78 0a 00 00 	movl   $0xa78,-0xc(%ebp)
        while(*s != 0){
 750:	eb 1c                	jmp    76e <printf+0xff>
          putc(fd, *s);
 752:	8b 45 f4             	mov    -0xc(%ebp),%eax
 755:	0f b6 00             	movzbl (%eax),%eax
 758:	0f be c0             	movsbl %al,%eax
 75b:	83 ec 08             	sub    $0x8,%esp
 75e:	50                   	push   %eax
 75f:	ff 75 08             	pushl  0x8(%ebp)
 762:	e8 31 fe ff ff       	call   598 <putc>
 767:	83 c4 10             	add    $0x10,%esp
          s++;
 76a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 76e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 771:	0f b6 00             	movzbl (%eax),%eax
 774:	84 c0                	test   %al,%al
 776:	75 da                	jne    752 <printf+0xe3>
 778:	eb 65                	jmp    7df <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 77a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 77e:	75 1d                	jne    79d <printf+0x12e>
        putc(fd, *ap);
 780:	8b 45 e8             	mov    -0x18(%ebp),%eax
 783:	8b 00                	mov    (%eax),%eax
 785:	0f be c0             	movsbl %al,%eax
 788:	83 ec 08             	sub    $0x8,%esp
 78b:	50                   	push   %eax
 78c:	ff 75 08             	pushl  0x8(%ebp)
 78f:	e8 04 fe ff ff       	call   598 <putc>
 794:	83 c4 10             	add    $0x10,%esp
        ap++;
 797:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 79b:	eb 42                	jmp    7df <printf+0x170>
      } else if(c == '%'){
 79d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7a1:	75 17                	jne    7ba <printf+0x14b>
        putc(fd, c);
 7a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7a6:	0f be c0             	movsbl %al,%eax
 7a9:	83 ec 08             	sub    $0x8,%esp
 7ac:	50                   	push   %eax
 7ad:	ff 75 08             	pushl  0x8(%ebp)
 7b0:	e8 e3 fd ff ff       	call   598 <putc>
 7b5:	83 c4 10             	add    $0x10,%esp
 7b8:	eb 25                	jmp    7df <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7ba:	83 ec 08             	sub    $0x8,%esp
 7bd:	6a 25                	push   $0x25
 7bf:	ff 75 08             	pushl  0x8(%ebp)
 7c2:	e8 d1 fd ff ff       	call   598 <putc>
 7c7:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 7ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7cd:	0f be c0             	movsbl %al,%eax
 7d0:	83 ec 08             	sub    $0x8,%esp
 7d3:	50                   	push   %eax
 7d4:	ff 75 08             	pushl  0x8(%ebp)
 7d7:	e8 bc fd ff ff       	call   598 <putc>
 7dc:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7e6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7ea:	8b 55 0c             	mov    0xc(%ebp),%edx
 7ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f0:	01 d0                	add    %edx,%eax
 7f2:	0f b6 00             	movzbl (%eax),%eax
 7f5:	84 c0                	test   %al,%al
 7f7:	0f 85 94 fe ff ff    	jne    691 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7fd:	90                   	nop
 7fe:	c9                   	leave  
 7ff:	c3                   	ret    

00000800 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 800:	55                   	push   %ebp
 801:	89 e5                	mov    %esp,%ebp
 803:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 806:	8b 45 08             	mov    0x8(%ebp),%eax
 809:	83 e8 08             	sub    $0x8,%eax
 80c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80f:	a1 08 0d 00 00       	mov    0xd08,%eax
 814:	89 45 fc             	mov    %eax,-0x4(%ebp)
 817:	eb 24                	jmp    83d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 819:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81c:	8b 00                	mov    (%eax),%eax
 81e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 821:	77 12                	ja     835 <free+0x35>
 823:	8b 45 f8             	mov    -0x8(%ebp),%eax
 826:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 829:	77 24                	ja     84f <free+0x4f>
 82b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82e:	8b 00                	mov    (%eax),%eax
 830:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 833:	77 1a                	ja     84f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 835:	8b 45 fc             	mov    -0x4(%ebp),%eax
 838:	8b 00                	mov    (%eax),%eax
 83a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 83d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 840:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 843:	76 d4                	jbe    819 <free+0x19>
 845:	8b 45 fc             	mov    -0x4(%ebp),%eax
 848:	8b 00                	mov    (%eax),%eax
 84a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 84d:	76 ca                	jbe    819 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 84f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 852:	8b 40 04             	mov    0x4(%eax),%eax
 855:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 85c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85f:	01 c2                	add    %eax,%edx
 861:	8b 45 fc             	mov    -0x4(%ebp),%eax
 864:	8b 00                	mov    (%eax),%eax
 866:	39 c2                	cmp    %eax,%edx
 868:	75 24                	jne    88e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 86a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86d:	8b 50 04             	mov    0x4(%eax),%edx
 870:	8b 45 fc             	mov    -0x4(%ebp),%eax
 873:	8b 00                	mov    (%eax),%eax
 875:	8b 40 04             	mov    0x4(%eax),%eax
 878:	01 c2                	add    %eax,%edx
 87a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 880:	8b 45 fc             	mov    -0x4(%ebp),%eax
 883:	8b 00                	mov    (%eax),%eax
 885:	8b 10                	mov    (%eax),%edx
 887:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88a:	89 10                	mov    %edx,(%eax)
 88c:	eb 0a                	jmp    898 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 88e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 891:	8b 10                	mov    (%eax),%edx
 893:	8b 45 f8             	mov    -0x8(%ebp),%eax
 896:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 898:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89b:	8b 40 04             	mov    0x4(%eax),%eax
 89e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a8:	01 d0                	add    %edx,%eax
 8aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8ad:	75 20                	jne    8cf <free+0xcf>
    p->s.size += bp->s.size;
 8af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b2:	8b 50 04             	mov    0x4(%eax),%edx
 8b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b8:	8b 40 04             	mov    0x4(%eax),%eax
 8bb:	01 c2                	add    %eax,%edx
 8bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c6:	8b 10                	mov    (%eax),%edx
 8c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cb:	89 10                	mov    %edx,(%eax)
 8cd:	eb 08                	jmp    8d7 <free+0xd7>
  } else
    p->s.ptr = bp;
 8cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8d5:	89 10                	mov    %edx,(%eax)
  freep = p;
 8d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8da:	a3 08 0d 00 00       	mov    %eax,0xd08
}
 8df:	90                   	nop
 8e0:	c9                   	leave  
 8e1:	c3                   	ret    

000008e2 <morecore>:

static Header*
morecore(uint nu)
{
 8e2:	55                   	push   %ebp
 8e3:	89 e5                	mov    %esp,%ebp
 8e5:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8e8:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8ef:	77 07                	ja     8f8 <morecore+0x16>
    nu = 4096;
 8f1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8f8:	8b 45 08             	mov    0x8(%ebp),%eax
 8fb:	c1 e0 03             	shl    $0x3,%eax
 8fe:	83 ec 0c             	sub    $0xc,%esp
 901:	50                   	push   %eax
 902:	e8 19 fc ff ff       	call   520 <sbrk>
 907:	83 c4 10             	add    $0x10,%esp
 90a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 90d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 911:	75 07                	jne    91a <morecore+0x38>
    return 0;
 913:	b8 00 00 00 00       	mov    $0x0,%eax
 918:	eb 26                	jmp    940 <morecore+0x5e>
  hp = (Header*)p;
 91a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 920:	8b 45 f0             	mov    -0x10(%ebp),%eax
 923:	8b 55 08             	mov    0x8(%ebp),%edx
 926:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 929:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92c:	83 c0 08             	add    $0x8,%eax
 92f:	83 ec 0c             	sub    $0xc,%esp
 932:	50                   	push   %eax
 933:	e8 c8 fe ff ff       	call   800 <free>
 938:	83 c4 10             	add    $0x10,%esp
  return freep;
 93b:	a1 08 0d 00 00       	mov    0xd08,%eax
}
 940:	c9                   	leave  
 941:	c3                   	ret    

00000942 <malloc>:

void*
malloc(uint nbytes)
{
 942:	55                   	push   %ebp
 943:	89 e5                	mov    %esp,%ebp
 945:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 948:	8b 45 08             	mov    0x8(%ebp),%eax
 94b:	83 c0 07             	add    $0x7,%eax
 94e:	c1 e8 03             	shr    $0x3,%eax
 951:	83 c0 01             	add    $0x1,%eax
 954:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 957:	a1 08 0d 00 00       	mov    0xd08,%eax
 95c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 95f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 963:	75 23                	jne    988 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 965:	c7 45 f0 00 0d 00 00 	movl   $0xd00,-0x10(%ebp)
 96c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 96f:	a3 08 0d 00 00       	mov    %eax,0xd08
 974:	a1 08 0d 00 00       	mov    0xd08,%eax
 979:	a3 00 0d 00 00       	mov    %eax,0xd00
    base.s.size = 0;
 97e:	c7 05 04 0d 00 00 00 	movl   $0x0,0xd04
 985:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 988:	8b 45 f0             	mov    -0x10(%ebp),%eax
 98b:	8b 00                	mov    (%eax),%eax
 98d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 990:	8b 45 f4             	mov    -0xc(%ebp),%eax
 993:	8b 40 04             	mov    0x4(%eax),%eax
 996:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 999:	72 4d                	jb     9e8 <malloc+0xa6>
      if(p->s.size == nunits)
 99b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99e:	8b 40 04             	mov    0x4(%eax),%eax
 9a1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 9a4:	75 0c                	jne    9b2 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a9:	8b 10                	mov    (%eax),%edx
 9ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ae:	89 10                	mov    %edx,(%eax)
 9b0:	eb 26                	jmp    9d8 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b5:	8b 40 04             	mov    0x4(%eax),%eax
 9b8:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9bb:	89 c2                	mov    %eax,%edx
 9bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c0:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c6:	8b 40 04             	mov    0x4(%eax),%eax
 9c9:	c1 e0 03             	shl    $0x3,%eax
 9cc:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d2:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9d5:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9db:	a3 08 0d 00 00       	mov    %eax,0xd08
      return (void*)(p + 1);
 9e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e3:	83 c0 08             	add    $0x8,%eax
 9e6:	eb 3b                	jmp    a23 <malloc+0xe1>
    }
    if(p == freep)
 9e8:	a1 08 0d 00 00       	mov    0xd08,%eax
 9ed:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9f0:	75 1e                	jne    a10 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 9f2:	83 ec 0c             	sub    $0xc,%esp
 9f5:	ff 75 ec             	pushl  -0x14(%ebp)
 9f8:	e8 e5 fe ff ff       	call   8e2 <morecore>
 9fd:	83 c4 10             	add    $0x10,%esp
 a00:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a03:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a07:	75 07                	jne    a10 <malloc+0xce>
        return 0;
 a09:	b8 00 00 00 00       	mov    $0x0,%eax
 a0e:	eb 13                	jmp    a23 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a10:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a13:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a19:	8b 00                	mov    (%eax),%eax
 a1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a1e:	e9 6d ff ff ff       	jmp    990 <malloc+0x4e>
}
 a23:	c9                   	leave  
 a24:	c3                   	ret    
