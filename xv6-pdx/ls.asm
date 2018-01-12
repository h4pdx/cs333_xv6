
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	83 ec 0c             	sub    $0xc,%esp
   a:	ff 75 08             	pushl  0x8(%ebp)
   d:	e8 c9 03 00 00       	call   3db <strlen>
  12:	83 c4 10             	add    $0x10,%esp
  15:	89 c2                	mov    %eax,%edx
  17:	8b 45 08             	mov    0x8(%ebp),%eax
  1a:	01 d0                	add    %edx,%eax
  1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1f:	eb 04                	jmp    25 <fmtname+0x25>
  21:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  28:	3b 45 08             	cmp    0x8(%ebp),%eax
  2b:	72 0a                	jb     37 <fmtname+0x37>
  2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  30:	0f b6 00             	movzbl (%eax),%eax
  33:	3c 2f                	cmp    $0x2f,%al
  35:	75 ea                	jne    21 <fmtname+0x21>
    ;
  p++;
  37:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  3b:	83 ec 0c             	sub    $0xc,%esp
  3e:	ff 75 f4             	pushl  -0xc(%ebp)
  41:	e8 95 03 00 00       	call   3db <strlen>
  46:	83 c4 10             	add    $0x10,%esp
  49:	83 f8 0d             	cmp    $0xd,%eax
  4c:	76 05                	jbe    53 <fmtname+0x53>
    return p;
  4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  51:	eb 60                	jmp    b3 <fmtname+0xb3>
  memmove(buf, p, strlen(p));
  53:	83 ec 0c             	sub    $0xc,%esp
  56:	ff 75 f4             	pushl  -0xc(%ebp)
  59:	e8 7d 03 00 00       	call   3db <strlen>
  5e:	83 c4 10             	add    $0x10,%esp
  61:	83 ec 04             	sub    $0x4,%esp
  64:	50                   	push   %eax
  65:	ff 75 f4             	pushl  -0xc(%ebp)
  68:	68 cc 0e 00 00       	push   $0xecc
  6d:	e8 b9 05 00 00       	call   62b <memmove>
  72:	83 c4 10             	add    $0x10,%esp
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  75:	83 ec 0c             	sub    $0xc,%esp
  78:	ff 75 f4             	pushl  -0xc(%ebp)
  7b:	e8 5b 03 00 00       	call   3db <strlen>
  80:	83 c4 10             	add    $0x10,%esp
  83:	ba 0e 00 00 00       	mov    $0xe,%edx
  88:	89 d3                	mov    %edx,%ebx
  8a:	29 c3                	sub    %eax,%ebx
  8c:	83 ec 0c             	sub    $0xc,%esp
  8f:	ff 75 f4             	pushl  -0xc(%ebp)
  92:	e8 44 03 00 00       	call   3db <strlen>
  97:	83 c4 10             	add    $0x10,%esp
  9a:	05 cc 0e 00 00       	add    $0xecc,%eax
  9f:	83 ec 04             	sub    $0x4,%esp
  a2:	53                   	push   %ebx
  a3:	6a 20                	push   $0x20
  a5:	50                   	push   %eax
  a6:	e8 57 03 00 00       	call   402 <memset>
  ab:	83 c4 10             	add    $0x10,%esp
  return buf;
  ae:	b8 cc 0e 00 00       	mov    $0xecc,%eax
}
  b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b6:	c9                   	leave  
  b7:	c3                   	ret    

000000b8 <ls>:

void
ls(char *path)
{
  b8:	55                   	push   %ebp
  b9:	89 e5                	mov    %esp,%ebp
  bb:	57                   	push   %edi
  bc:	56                   	push   %esi
  bd:	53                   	push   %ebx
  be:	81 ec 3c 02 00 00    	sub    $0x23c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  c4:	83 ec 08             	sub    $0x8,%esp
  c7:	6a 00                	push   $0x0
  c9:	ff 75 08             	pushl  0x8(%ebp)
  cc:	e8 df 05 00 00       	call   6b0 <open>
  d1:	83 c4 10             	add    $0x10,%esp
  d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  db:	79 1a                	jns    f7 <ls+0x3f>
    printf(2, "ls: cannot open %s\n", path);
  dd:	83 ec 04             	sub    $0x4,%esp
  e0:	ff 75 08             	pushl  0x8(%ebp)
  e3:	68 a5 0b 00 00       	push   $0xba5
  e8:	6a 02                	push   $0x2
  ea:	e8 00 07 00 00       	call   7ef <printf>
  ef:	83 c4 10             	add    $0x10,%esp
    return;
  f2:	e9 e3 01 00 00       	jmp    2da <ls+0x222>
  }
  
  if(fstat(fd, &st) < 0){
  f7:	83 ec 08             	sub    $0x8,%esp
  fa:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 100:	50                   	push   %eax
 101:	ff 75 e4             	pushl  -0x1c(%ebp)
 104:	e8 bf 05 00 00       	call   6c8 <fstat>
 109:	83 c4 10             	add    $0x10,%esp
 10c:	85 c0                	test   %eax,%eax
 10e:	79 28                	jns    138 <ls+0x80>
    printf(2, "ls: cannot stat %s\n", path);
 110:	83 ec 04             	sub    $0x4,%esp
 113:	ff 75 08             	pushl  0x8(%ebp)
 116:	68 b9 0b 00 00       	push   $0xbb9
 11b:	6a 02                	push   $0x2
 11d:	e8 cd 06 00 00       	call   7ef <printf>
 122:	83 c4 10             	add    $0x10,%esp
    close(fd);
 125:	83 ec 0c             	sub    $0xc,%esp
 128:	ff 75 e4             	pushl  -0x1c(%ebp)
 12b:	e8 68 05 00 00       	call   698 <close>
 130:	83 c4 10             	add    $0x10,%esp
    return;
 133:	e9 a2 01 00 00       	jmp    2da <ls+0x222>
  }
  
  switch(st.type){
 138:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 13f:	98                   	cwtl   
 140:	83 f8 01             	cmp    $0x1,%eax
 143:	74 48                	je     18d <ls+0xd5>
 145:	83 f8 02             	cmp    $0x2,%eax
 148:	0f 85 7e 01 00 00    	jne    2cc <ls+0x214>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 14e:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 154:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 15a:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 161:	0f bf d8             	movswl %ax,%ebx
 164:	83 ec 0c             	sub    $0xc,%esp
 167:	ff 75 08             	pushl  0x8(%ebp)
 16a:	e8 91 fe ff ff       	call   0 <fmtname>
 16f:	83 c4 10             	add    $0x10,%esp
 172:	83 ec 08             	sub    $0x8,%esp
 175:	57                   	push   %edi
 176:	56                   	push   %esi
 177:	53                   	push   %ebx
 178:	50                   	push   %eax
 179:	68 cd 0b 00 00       	push   $0xbcd
 17e:	6a 01                	push   $0x1
 180:	e8 6a 06 00 00       	call   7ef <printf>
 185:	83 c4 20             	add    $0x20,%esp
    break;
 188:	e9 3f 01 00 00       	jmp    2cc <ls+0x214>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 18d:	83 ec 0c             	sub    $0xc,%esp
 190:	ff 75 08             	pushl  0x8(%ebp)
 193:	e8 43 02 00 00       	call   3db <strlen>
 198:	83 c4 10             	add    $0x10,%esp
 19b:	83 c0 10             	add    $0x10,%eax
 19e:	3d 00 02 00 00       	cmp    $0x200,%eax
 1a3:	76 17                	jbe    1bc <ls+0x104>
      printf(1, "ls: path too long\n");
 1a5:	83 ec 08             	sub    $0x8,%esp
 1a8:	68 da 0b 00 00       	push   $0xbda
 1ad:	6a 01                	push   $0x1
 1af:	e8 3b 06 00 00       	call   7ef <printf>
 1b4:	83 c4 10             	add    $0x10,%esp
      break;
 1b7:	e9 10 01 00 00       	jmp    2cc <ls+0x214>
    }
    strcpy(buf, path);
 1bc:	83 ec 08             	sub    $0x8,%esp
 1bf:	ff 75 08             	pushl  0x8(%ebp)
 1c2:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1c8:	50                   	push   %eax
 1c9:	e8 9e 01 00 00       	call   36c <strcpy>
 1ce:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 1d1:	83 ec 0c             	sub    $0xc,%esp
 1d4:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1da:	50                   	push   %eax
 1db:	e8 fb 01 00 00       	call   3db <strlen>
 1e0:	83 c4 10             	add    $0x10,%esp
 1e3:	89 c2                	mov    %eax,%edx
 1e5:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1eb:	01 d0                	add    %edx,%eax
 1ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1f3:	8d 50 01             	lea    0x1(%eax),%edx
 1f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
 1f9:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1fc:	e9 aa 00 00 00       	jmp    2ab <ls+0x1f3>
      if(de.inum == 0)
 201:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 208:	66 85 c0             	test   %ax,%ax
 20b:	75 05                	jne    212 <ls+0x15a>
        continue;
 20d:	e9 99 00 00 00       	jmp    2ab <ls+0x1f3>
      memmove(p, de.name, DIRSIZ);
 212:	83 ec 04             	sub    $0x4,%esp
 215:	6a 0e                	push   $0xe
 217:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 21d:	83 c0 02             	add    $0x2,%eax
 220:	50                   	push   %eax
 221:	ff 75 e0             	pushl  -0x20(%ebp)
 224:	e8 02 04 00 00       	call   62b <memmove>
 229:	83 c4 10             	add    $0x10,%esp
      p[DIRSIZ] = 0;
 22c:	8b 45 e0             	mov    -0x20(%ebp),%eax
 22f:	83 c0 0e             	add    $0xe,%eax
 232:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 235:	83 ec 08             	sub    $0x8,%esp
 238:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 23e:	50                   	push   %eax
 23f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 245:	50                   	push   %eax
 246:	e8 73 02 00 00       	call   4be <stat>
 24b:	83 c4 10             	add    $0x10,%esp
 24e:	85 c0                	test   %eax,%eax
 250:	79 1b                	jns    26d <ls+0x1b5>
        printf(1, "ls: cannot stat %s\n", buf);
 252:	83 ec 04             	sub    $0x4,%esp
 255:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 25b:	50                   	push   %eax
 25c:	68 b9 0b 00 00       	push   $0xbb9
 261:	6a 01                	push   $0x1
 263:	e8 87 05 00 00       	call   7ef <printf>
 268:	83 c4 10             	add    $0x10,%esp
        continue;
 26b:	eb 3e                	jmp    2ab <ls+0x1f3>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 26d:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 273:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 279:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 280:	0f bf d8             	movswl %ax,%ebx
 283:	83 ec 0c             	sub    $0xc,%esp
 286:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 28c:	50                   	push   %eax
 28d:	e8 6e fd ff ff       	call   0 <fmtname>
 292:	83 c4 10             	add    $0x10,%esp
 295:	83 ec 08             	sub    $0x8,%esp
 298:	57                   	push   %edi
 299:	56                   	push   %esi
 29a:	53                   	push   %ebx
 29b:	50                   	push   %eax
 29c:	68 cd 0b 00 00       	push   $0xbcd
 2a1:	6a 01                	push   $0x1
 2a3:	e8 47 05 00 00       	call   7ef <printf>
 2a8:	83 c4 20             	add    $0x20,%esp
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2ab:	83 ec 04             	sub    $0x4,%esp
 2ae:	6a 10                	push   $0x10
 2b0:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2b6:	50                   	push   %eax
 2b7:	ff 75 e4             	pushl  -0x1c(%ebp)
 2ba:	e8 c9 03 00 00       	call   688 <read>
 2bf:	83 c4 10             	add    $0x10,%esp
 2c2:	83 f8 10             	cmp    $0x10,%eax
 2c5:	0f 84 36 ff ff ff    	je     201 <ls+0x149>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
 2cb:	90                   	nop
  }
  close(fd);
 2cc:	83 ec 0c             	sub    $0xc,%esp
 2cf:	ff 75 e4             	pushl  -0x1c(%ebp)
 2d2:	e8 c1 03 00 00       	call   698 <close>
 2d7:	83 c4 10             	add    $0x10,%esp
}
 2da:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2dd:	5b                   	pop    %ebx
 2de:	5e                   	pop    %esi
 2df:	5f                   	pop    %edi
 2e0:	5d                   	pop    %ebp
 2e1:	c3                   	ret    

000002e2 <main>:

int
main(int argc, char *argv[])
{
 2e2:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 2e6:	83 e4 f0             	and    $0xfffffff0,%esp
 2e9:	ff 71 fc             	pushl  -0x4(%ecx)
 2ec:	55                   	push   %ebp
 2ed:	89 e5                	mov    %esp,%ebp
 2ef:	53                   	push   %ebx
 2f0:	51                   	push   %ecx
 2f1:	83 ec 10             	sub    $0x10,%esp
 2f4:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
 2f6:	83 3b 01             	cmpl   $0x1,(%ebx)
 2f9:	7f 15                	jg     310 <main+0x2e>
    ls(".");
 2fb:	83 ec 0c             	sub    $0xc,%esp
 2fe:	68 ed 0b 00 00       	push   $0xbed
 303:	e8 b0 fd ff ff       	call   b8 <ls>
 308:	83 c4 10             	add    $0x10,%esp
    exit();
 30b:	e8 60 03 00 00       	call   670 <exit>
  }
  for(i=1; i<argc; i++)
 310:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 317:	eb 21                	jmp    33a <main+0x58>
    ls(argv[i]);
 319:	8b 45 f4             	mov    -0xc(%ebp),%eax
 31c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 323:	8b 43 04             	mov    0x4(%ebx),%eax
 326:	01 d0                	add    %edx,%eax
 328:	8b 00                	mov    (%eax),%eax
 32a:	83 ec 0c             	sub    $0xc,%esp
 32d:	50                   	push   %eax
 32e:	e8 85 fd ff ff       	call   b8 <ls>
 333:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 336:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 33a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 33d:	3b 03                	cmp    (%ebx),%eax
 33f:	7c d8                	jl     319 <main+0x37>
    ls(argv[i]);
  exit();
 341:	e8 2a 03 00 00       	call   670 <exit>

00000346 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 346:	55                   	push   %ebp
 347:	89 e5                	mov    %esp,%ebp
 349:	57                   	push   %edi
 34a:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 34b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 34e:	8b 55 10             	mov    0x10(%ebp),%edx
 351:	8b 45 0c             	mov    0xc(%ebp),%eax
 354:	89 cb                	mov    %ecx,%ebx
 356:	89 df                	mov    %ebx,%edi
 358:	89 d1                	mov    %edx,%ecx
 35a:	fc                   	cld    
 35b:	f3 aa                	rep stos %al,%es:(%edi)
 35d:	89 ca                	mov    %ecx,%edx
 35f:	89 fb                	mov    %edi,%ebx
 361:	89 5d 08             	mov    %ebx,0x8(%ebp)
 364:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 367:	90                   	nop
 368:	5b                   	pop    %ebx
 369:	5f                   	pop    %edi
 36a:	5d                   	pop    %ebp
 36b:	c3                   	ret    

0000036c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 36c:	55                   	push   %ebp
 36d:	89 e5                	mov    %esp,%ebp
 36f:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 372:	8b 45 08             	mov    0x8(%ebp),%eax
 375:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 378:	90                   	nop
 379:	8b 45 08             	mov    0x8(%ebp),%eax
 37c:	8d 50 01             	lea    0x1(%eax),%edx
 37f:	89 55 08             	mov    %edx,0x8(%ebp)
 382:	8b 55 0c             	mov    0xc(%ebp),%edx
 385:	8d 4a 01             	lea    0x1(%edx),%ecx
 388:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 38b:	0f b6 12             	movzbl (%edx),%edx
 38e:	88 10                	mov    %dl,(%eax)
 390:	0f b6 00             	movzbl (%eax),%eax
 393:	84 c0                	test   %al,%al
 395:	75 e2                	jne    379 <strcpy+0xd>
    ;
  return os;
 397:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 39a:	c9                   	leave  
 39b:	c3                   	ret    

0000039c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 39c:	55                   	push   %ebp
 39d:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 39f:	eb 08                	jmp    3a9 <strcmp+0xd>
    p++, q++;
 3a1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3a5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3a9:	8b 45 08             	mov    0x8(%ebp),%eax
 3ac:	0f b6 00             	movzbl (%eax),%eax
 3af:	84 c0                	test   %al,%al
 3b1:	74 10                	je     3c3 <strcmp+0x27>
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	0f b6 10             	movzbl (%eax),%edx
 3b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bc:	0f b6 00             	movzbl (%eax),%eax
 3bf:	38 c2                	cmp    %al,%dl
 3c1:	74 de                	je     3a1 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3c3:	8b 45 08             	mov    0x8(%ebp),%eax
 3c6:	0f b6 00             	movzbl (%eax),%eax
 3c9:	0f b6 d0             	movzbl %al,%edx
 3cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cf:	0f b6 00             	movzbl (%eax),%eax
 3d2:	0f b6 c0             	movzbl %al,%eax
 3d5:	29 c2                	sub    %eax,%edx
 3d7:	89 d0                	mov    %edx,%eax
}
 3d9:	5d                   	pop    %ebp
 3da:	c3                   	ret    

000003db <strlen>:

uint
strlen(char *s)
{
 3db:	55                   	push   %ebp
 3dc:	89 e5                	mov    %esp,%ebp
 3de:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3e8:	eb 04                	jmp    3ee <strlen+0x13>
 3ea:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3f1:	8b 45 08             	mov    0x8(%ebp),%eax
 3f4:	01 d0                	add    %edx,%eax
 3f6:	0f b6 00             	movzbl (%eax),%eax
 3f9:	84 c0                	test   %al,%al
 3fb:	75 ed                	jne    3ea <strlen+0xf>
    ;
  return n;
 3fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 400:	c9                   	leave  
 401:	c3                   	ret    

00000402 <memset>:

void*
memset(void *dst, int c, uint n)
{
 402:	55                   	push   %ebp
 403:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 405:	8b 45 10             	mov    0x10(%ebp),%eax
 408:	50                   	push   %eax
 409:	ff 75 0c             	pushl  0xc(%ebp)
 40c:	ff 75 08             	pushl  0x8(%ebp)
 40f:	e8 32 ff ff ff       	call   346 <stosb>
 414:	83 c4 0c             	add    $0xc,%esp
  return dst;
 417:	8b 45 08             	mov    0x8(%ebp),%eax
}
 41a:	c9                   	leave  
 41b:	c3                   	ret    

0000041c <strchr>:

char*
strchr(const char *s, char c)
{
 41c:	55                   	push   %ebp
 41d:	89 e5                	mov    %esp,%ebp
 41f:	83 ec 04             	sub    $0x4,%esp
 422:	8b 45 0c             	mov    0xc(%ebp),%eax
 425:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 428:	eb 14                	jmp    43e <strchr+0x22>
    if(*s == c)
 42a:	8b 45 08             	mov    0x8(%ebp),%eax
 42d:	0f b6 00             	movzbl (%eax),%eax
 430:	3a 45 fc             	cmp    -0x4(%ebp),%al
 433:	75 05                	jne    43a <strchr+0x1e>
      return (char*)s;
 435:	8b 45 08             	mov    0x8(%ebp),%eax
 438:	eb 13                	jmp    44d <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 43a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 43e:	8b 45 08             	mov    0x8(%ebp),%eax
 441:	0f b6 00             	movzbl (%eax),%eax
 444:	84 c0                	test   %al,%al
 446:	75 e2                	jne    42a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 448:	b8 00 00 00 00       	mov    $0x0,%eax
}
 44d:	c9                   	leave  
 44e:	c3                   	ret    

0000044f <gets>:

char*
gets(char *buf, int max)
{
 44f:	55                   	push   %ebp
 450:	89 e5                	mov    %esp,%ebp
 452:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 455:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 45c:	eb 42                	jmp    4a0 <gets+0x51>
    cc = read(0, &c, 1);
 45e:	83 ec 04             	sub    $0x4,%esp
 461:	6a 01                	push   $0x1
 463:	8d 45 ef             	lea    -0x11(%ebp),%eax
 466:	50                   	push   %eax
 467:	6a 00                	push   $0x0
 469:	e8 1a 02 00 00       	call   688 <read>
 46e:	83 c4 10             	add    $0x10,%esp
 471:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 474:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 478:	7e 33                	jle    4ad <gets+0x5e>
      break;
    buf[i++] = c;
 47a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 47d:	8d 50 01             	lea    0x1(%eax),%edx
 480:	89 55 f4             	mov    %edx,-0xc(%ebp)
 483:	89 c2                	mov    %eax,%edx
 485:	8b 45 08             	mov    0x8(%ebp),%eax
 488:	01 c2                	add    %eax,%edx
 48a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 48e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 490:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 494:	3c 0a                	cmp    $0xa,%al
 496:	74 16                	je     4ae <gets+0x5f>
 498:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 49c:	3c 0d                	cmp    $0xd,%al
 49e:	74 0e                	je     4ae <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a3:	83 c0 01             	add    $0x1,%eax
 4a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4a9:	7c b3                	jl     45e <gets+0xf>
 4ab:	eb 01                	jmp    4ae <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 4ad:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 4ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4b1:	8b 45 08             	mov    0x8(%ebp),%eax
 4b4:	01 d0                	add    %edx,%eax
 4b6:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4bc:	c9                   	leave  
 4bd:	c3                   	ret    

000004be <stat>:

int
stat(char *n, struct stat *st)
{
 4be:	55                   	push   %ebp
 4bf:	89 e5                	mov    %esp,%ebp
 4c1:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4c4:	83 ec 08             	sub    $0x8,%esp
 4c7:	6a 00                	push   $0x0
 4c9:	ff 75 08             	pushl  0x8(%ebp)
 4cc:	e8 df 01 00 00       	call   6b0 <open>
 4d1:	83 c4 10             	add    $0x10,%esp
 4d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4db:	79 07                	jns    4e4 <stat+0x26>
    return -1;
 4dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4e2:	eb 25                	jmp    509 <stat+0x4b>
  r = fstat(fd, st);
 4e4:	83 ec 08             	sub    $0x8,%esp
 4e7:	ff 75 0c             	pushl  0xc(%ebp)
 4ea:	ff 75 f4             	pushl  -0xc(%ebp)
 4ed:	e8 d6 01 00 00       	call   6c8 <fstat>
 4f2:	83 c4 10             	add    $0x10,%esp
 4f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4f8:	83 ec 0c             	sub    $0xc,%esp
 4fb:	ff 75 f4             	pushl  -0xc(%ebp)
 4fe:	e8 95 01 00 00       	call   698 <close>
 503:	83 c4 10             	add    $0x10,%esp
  return r;
 506:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 509:	c9                   	leave  
 50a:	c3                   	ret    

0000050b <atoi>:

int
atoi(const char *s)
{
 50b:	55                   	push   %ebp
 50c:	89 e5                	mov    %esp,%ebp
 50e:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 511:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 518:	eb 04                	jmp    51e <atoi+0x13>
 51a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 51e:	8b 45 08             	mov    0x8(%ebp),%eax
 521:	0f b6 00             	movzbl (%eax),%eax
 524:	3c 20                	cmp    $0x20,%al
 526:	74 f2                	je     51a <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 528:	8b 45 08             	mov    0x8(%ebp),%eax
 52b:	0f b6 00             	movzbl (%eax),%eax
 52e:	3c 2d                	cmp    $0x2d,%al
 530:	75 07                	jne    539 <atoi+0x2e>
 532:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 537:	eb 05                	jmp    53e <atoi+0x33>
 539:	b8 01 00 00 00       	mov    $0x1,%eax
 53e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 541:	8b 45 08             	mov    0x8(%ebp),%eax
 544:	0f b6 00             	movzbl (%eax),%eax
 547:	3c 2b                	cmp    $0x2b,%al
 549:	74 0a                	je     555 <atoi+0x4a>
 54b:	8b 45 08             	mov    0x8(%ebp),%eax
 54e:	0f b6 00             	movzbl (%eax),%eax
 551:	3c 2d                	cmp    $0x2d,%al
 553:	75 2b                	jne    580 <atoi+0x75>
    s++;
 555:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 559:	eb 25                	jmp    580 <atoi+0x75>
    n = n*10 + *s++ - '0';
 55b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 55e:	89 d0                	mov    %edx,%eax
 560:	c1 e0 02             	shl    $0x2,%eax
 563:	01 d0                	add    %edx,%eax
 565:	01 c0                	add    %eax,%eax
 567:	89 c1                	mov    %eax,%ecx
 569:	8b 45 08             	mov    0x8(%ebp),%eax
 56c:	8d 50 01             	lea    0x1(%eax),%edx
 56f:	89 55 08             	mov    %edx,0x8(%ebp)
 572:	0f b6 00             	movzbl (%eax),%eax
 575:	0f be c0             	movsbl %al,%eax
 578:	01 c8                	add    %ecx,%eax
 57a:	83 e8 30             	sub    $0x30,%eax
 57d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 580:	8b 45 08             	mov    0x8(%ebp),%eax
 583:	0f b6 00             	movzbl (%eax),%eax
 586:	3c 2f                	cmp    $0x2f,%al
 588:	7e 0a                	jle    594 <atoi+0x89>
 58a:	8b 45 08             	mov    0x8(%ebp),%eax
 58d:	0f b6 00             	movzbl (%eax),%eax
 590:	3c 39                	cmp    $0x39,%al
 592:	7e c7                	jle    55b <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 594:	8b 45 f8             	mov    -0x8(%ebp),%eax
 597:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 59b:	c9                   	leave  
 59c:	c3                   	ret    

0000059d <atoo>:

int
atoo(const char *s)
{
 59d:	55                   	push   %ebp
 59e:	89 e5                	mov    %esp,%ebp
 5a0:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 5a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 5aa:	eb 04                	jmp    5b0 <atoo+0x13>
 5ac:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 5b0:	8b 45 08             	mov    0x8(%ebp),%eax
 5b3:	0f b6 00             	movzbl (%eax),%eax
 5b6:	3c 20                	cmp    $0x20,%al
 5b8:	74 f2                	je     5ac <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 5ba:	8b 45 08             	mov    0x8(%ebp),%eax
 5bd:	0f b6 00             	movzbl (%eax),%eax
 5c0:	3c 2d                	cmp    $0x2d,%al
 5c2:	75 07                	jne    5cb <atoo+0x2e>
 5c4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 5c9:	eb 05                	jmp    5d0 <atoo+0x33>
 5cb:	b8 01 00 00 00       	mov    $0x1,%eax
 5d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 5d3:	8b 45 08             	mov    0x8(%ebp),%eax
 5d6:	0f b6 00             	movzbl (%eax),%eax
 5d9:	3c 2b                	cmp    $0x2b,%al
 5db:	74 0a                	je     5e7 <atoo+0x4a>
 5dd:	8b 45 08             	mov    0x8(%ebp),%eax
 5e0:	0f b6 00             	movzbl (%eax),%eax
 5e3:	3c 2d                	cmp    $0x2d,%al
 5e5:	75 27                	jne    60e <atoo+0x71>
    s++;
 5e7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 5eb:	eb 21                	jmp    60e <atoo+0x71>
    n = n*8 + *s++ - '0';
 5ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5f0:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 5f7:	8b 45 08             	mov    0x8(%ebp),%eax
 5fa:	8d 50 01             	lea    0x1(%eax),%edx
 5fd:	89 55 08             	mov    %edx,0x8(%ebp)
 600:	0f b6 00             	movzbl (%eax),%eax
 603:	0f be c0             	movsbl %al,%eax
 606:	01 c8                	add    %ecx,%eax
 608:	83 e8 30             	sub    $0x30,%eax
 60b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 60e:	8b 45 08             	mov    0x8(%ebp),%eax
 611:	0f b6 00             	movzbl (%eax),%eax
 614:	3c 2f                	cmp    $0x2f,%al
 616:	7e 0a                	jle    622 <atoo+0x85>
 618:	8b 45 08             	mov    0x8(%ebp),%eax
 61b:	0f b6 00             	movzbl (%eax),%eax
 61e:	3c 37                	cmp    $0x37,%al
 620:	7e cb                	jle    5ed <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 622:	8b 45 f8             	mov    -0x8(%ebp),%eax
 625:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 629:	c9                   	leave  
 62a:	c3                   	ret    

0000062b <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 62b:	55                   	push   %ebp
 62c:	89 e5                	mov    %esp,%ebp
 62e:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 631:	8b 45 08             	mov    0x8(%ebp),%eax
 634:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 637:	8b 45 0c             	mov    0xc(%ebp),%eax
 63a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 63d:	eb 17                	jmp    656 <memmove+0x2b>
    *dst++ = *src++;
 63f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 642:	8d 50 01             	lea    0x1(%eax),%edx
 645:	89 55 fc             	mov    %edx,-0x4(%ebp)
 648:	8b 55 f8             	mov    -0x8(%ebp),%edx
 64b:	8d 4a 01             	lea    0x1(%edx),%ecx
 64e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 651:	0f b6 12             	movzbl (%edx),%edx
 654:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 656:	8b 45 10             	mov    0x10(%ebp),%eax
 659:	8d 50 ff             	lea    -0x1(%eax),%edx
 65c:	89 55 10             	mov    %edx,0x10(%ebp)
 65f:	85 c0                	test   %eax,%eax
 661:	7f dc                	jg     63f <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 663:	8b 45 08             	mov    0x8(%ebp),%eax
}
 666:	c9                   	leave  
 667:	c3                   	ret    

00000668 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 668:	b8 01 00 00 00       	mov    $0x1,%eax
 66d:	cd 40                	int    $0x40
 66f:	c3                   	ret    

00000670 <exit>:
SYSCALL(exit)
 670:	b8 02 00 00 00       	mov    $0x2,%eax
 675:	cd 40                	int    $0x40
 677:	c3                   	ret    

00000678 <wait>:
SYSCALL(wait)
 678:	b8 03 00 00 00       	mov    $0x3,%eax
 67d:	cd 40                	int    $0x40
 67f:	c3                   	ret    

00000680 <pipe>:
SYSCALL(pipe)
 680:	b8 04 00 00 00       	mov    $0x4,%eax
 685:	cd 40                	int    $0x40
 687:	c3                   	ret    

00000688 <read>:
SYSCALL(read)
 688:	b8 05 00 00 00       	mov    $0x5,%eax
 68d:	cd 40                	int    $0x40
 68f:	c3                   	ret    

00000690 <write>:
SYSCALL(write)
 690:	b8 10 00 00 00       	mov    $0x10,%eax
 695:	cd 40                	int    $0x40
 697:	c3                   	ret    

00000698 <close>:
SYSCALL(close)
 698:	b8 15 00 00 00       	mov    $0x15,%eax
 69d:	cd 40                	int    $0x40
 69f:	c3                   	ret    

000006a0 <kill>:
SYSCALL(kill)
 6a0:	b8 06 00 00 00       	mov    $0x6,%eax
 6a5:	cd 40                	int    $0x40
 6a7:	c3                   	ret    

000006a8 <exec>:
SYSCALL(exec)
 6a8:	b8 07 00 00 00       	mov    $0x7,%eax
 6ad:	cd 40                	int    $0x40
 6af:	c3                   	ret    

000006b0 <open>:
SYSCALL(open)
 6b0:	b8 0f 00 00 00       	mov    $0xf,%eax
 6b5:	cd 40                	int    $0x40
 6b7:	c3                   	ret    

000006b8 <mknod>:
SYSCALL(mknod)
 6b8:	b8 11 00 00 00       	mov    $0x11,%eax
 6bd:	cd 40                	int    $0x40
 6bf:	c3                   	ret    

000006c0 <unlink>:
SYSCALL(unlink)
 6c0:	b8 12 00 00 00       	mov    $0x12,%eax
 6c5:	cd 40                	int    $0x40
 6c7:	c3                   	ret    

000006c8 <fstat>:
SYSCALL(fstat)
 6c8:	b8 08 00 00 00       	mov    $0x8,%eax
 6cd:	cd 40                	int    $0x40
 6cf:	c3                   	ret    

000006d0 <link>:
SYSCALL(link)
 6d0:	b8 13 00 00 00       	mov    $0x13,%eax
 6d5:	cd 40                	int    $0x40
 6d7:	c3                   	ret    

000006d8 <mkdir>:
SYSCALL(mkdir)
 6d8:	b8 14 00 00 00       	mov    $0x14,%eax
 6dd:	cd 40                	int    $0x40
 6df:	c3                   	ret    

000006e0 <chdir>:
SYSCALL(chdir)
 6e0:	b8 09 00 00 00       	mov    $0x9,%eax
 6e5:	cd 40                	int    $0x40
 6e7:	c3                   	ret    

000006e8 <dup>:
SYSCALL(dup)
 6e8:	b8 0a 00 00 00       	mov    $0xa,%eax
 6ed:	cd 40                	int    $0x40
 6ef:	c3                   	ret    

000006f0 <getpid>:
SYSCALL(getpid)
 6f0:	b8 0b 00 00 00       	mov    $0xb,%eax
 6f5:	cd 40                	int    $0x40
 6f7:	c3                   	ret    

000006f8 <sbrk>:
SYSCALL(sbrk)
 6f8:	b8 0c 00 00 00       	mov    $0xc,%eax
 6fd:	cd 40                	int    $0x40
 6ff:	c3                   	ret    

00000700 <sleep>:
SYSCALL(sleep)
 700:	b8 0d 00 00 00       	mov    $0xd,%eax
 705:	cd 40                	int    $0x40
 707:	c3                   	ret    

00000708 <uptime>:
SYSCALL(uptime)
 708:	b8 0e 00 00 00       	mov    $0xe,%eax
 70d:	cd 40                	int    $0x40
 70f:	c3                   	ret    

00000710 <halt>:
SYSCALL(halt)
 710:	b8 16 00 00 00       	mov    $0x16,%eax
 715:	cd 40                	int    $0x40
 717:	c3                   	ret    

00000718 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 718:	55                   	push   %ebp
 719:	89 e5                	mov    %esp,%ebp
 71b:	83 ec 18             	sub    $0x18,%esp
 71e:	8b 45 0c             	mov    0xc(%ebp),%eax
 721:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 724:	83 ec 04             	sub    $0x4,%esp
 727:	6a 01                	push   $0x1
 729:	8d 45 f4             	lea    -0xc(%ebp),%eax
 72c:	50                   	push   %eax
 72d:	ff 75 08             	pushl  0x8(%ebp)
 730:	e8 5b ff ff ff       	call   690 <write>
 735:	83 c4 10             	add    $0x10,%esp
}
 738:	90                   	nop
 739:	c9                   	leave  
 73a:	c3                   	ret    

0000073b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 73b:	55                   	push   %ebp
 73c:	89 e5                	mov    %esp,%ebp
 73e:	53                   	push   %ebx
 73f:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 742:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 749:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 74d:	74 17                	je     766 <printint+0x2b>
 74f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 753:	79 11                	jns    766 <printint+0x2b>
    neg = 1;
 755:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 75c:	8b 45 0c             	mov    0xc(%ebp),%eax
 75f:	f7 d8                	neg    %eax
 761:	89 45 ec             	mov    %eax,-0x14(%ebp)
 764:	eb 06                	jmp    76c <printint+0x31>
  } else {
    x = xx;
 766:	8b 45 0c             	mov    0xc(%ebp),%eax
 769:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 76c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 773:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 776:	8d 41 01             	lea    0x1(%ecx),%eax
 779:	89 45 f4             	mov    %eax,-0xc(%ebp)
 77c:	8b 5d 10             	mov    0x10(%ebp),%ebx
 77f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 782:	ba 00 00 00 00       	mov    $0x0,%edx
 787:	f7 f3                	div    %ebx
 789:	89 d0                	mov    %edx,%eax
 78b:	0f b6 80 b8 0e 00 00 	movzbl 0xeb8(%eax),%eax
 792:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 796:	8b 5d 10             	mov    0x10(%ebp),%ebx
 799:	8b 45 ec             	mov    -0x14(%ebp),%eax
 79c:	ba 00 00 00 00       	mov    $0x0,%edx
 7a1:	f7 f3                	div    %ebx
 7a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7aa:	75 c7                	jne    773 <printint+0x38>
  if(neg)
 7ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7b0:	74 2d                	je     7df <printint+0xa4>
    buf[i++] = '-';
 7b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b5:	8d 50 01             	lea    0x1(%eax),%edx
 7b8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 7bb:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 7c0:	eb 1d                	jmp    7df <printint+0xa4>
    putc(fd, buf[i]);
 7c2:	8d 55 dc             	lea    -0x24(%ebp),%edx
 7c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c8:	01 d0                	add    %edx,%eax
 7ca:	0f b6 00             	movzbl (%eax),%eax
 7cd:	0f be c0             	movsbl %al,%eax
 7d0:	83 ec 08             	sub    $0x8,%esp
 7d3:	50                   	push   %eax
 7d4:	ff 75 08             	pushl  0x8(%ebp)
 7d7:	e8 3c ff ff ff       	call   718 <putc>
 7dc:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 7df:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 7e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7e7:	79 d9                	jns    7c2 <printint+0x87>
    putc(fd, buf[i]);
}
 7e9:	90                   	nop
 7ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 7ed:	c9                   	leave  
 7ee:	c3                   	ret    

000007ef <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7ef:	55                   	push   %ebp
 7f0:	89 e5                	mov    %esp,%ebp
 7f2:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 7f5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 7fc:	8d 45 0c             	lea    0xc(%ebp),%eax
 7ff:	83 c0 04             	add    $0x4,%eax
 802:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 805:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 80c:	e9 59 01 00 00       	jmp    96a <printf+0x17b>
    c = fmt[i] & 0xff;
 811:	8b 55 0c             	mov    0xc(%ebp),%edx
 814:	8b 45 f0             	mov    -0x10(%ebp),%eax
 817:	01 d0                	add    %edx,%eax
 819:	0f b6 00             	movzbl (%eax),%eax
 81c:	0f be c0             	movsbl %al,%eax
 81f:	25 ff 00 00 00       	and    $0xff,%eax
 824:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 827:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 82b:	75 2c                	jne    859 <printf+0x6a>
      if(c == '%'){
 82d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 831:	75 0c                	jne    83f <printf+0x50>
        state = '%';
 833:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 83a:	e9 27 01 00 00       	jmp    966 <printf+0x177>
      } else {
        putc(fd, c);
 83f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 842:	0f be c0             	movsbl %al,%eax
 845:	83 ec 08             	sub    $0x8,%esp
 848:	50                   	push   %eax
 849:	ff 75 08             	pushl  0x8(%ebp)
 84c:	e8 c7 fe ff ff       	call   718 <putc>
 851:	83 c4 10             	add    $0x10,%esp
 854:	e9 0d 01 00 00       	jmp    966 <printf+0x177>
      }
    } else if(state == '%'){
 859:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 85d:	0f 85 03 01 00 00    	jne    966 <printf+0x177>
      if(c == 'd'){
 863:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 867:	75 1e                	jne    887 <printf+0x98>
        printint(fd, *ap, 10, 1);
 869:	8b 45 e8             	mov    -0x18(%ebp),%eax
 86c:	8b 00                	mov    (%eax),%eax
 86e:	6a 01                	push   $0x1
 870:	6a 0a                	push   $0xa
 872:	50                   	push   %eax
 873:	ff 75 08             	pushl  0x8(%ebp)
 876:	e8 c0 fe ff ff       	call   73b <printint>
 87b:	83 c4 10             	add    $0x10,%esp
        ap++;
 87e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 882:	e9 d8 00 00 00       	jmp    95f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 887:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 88b:	74 06                	je     893 <printf+0xa4>
 88d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 891:	75 1e                	jne    8b1 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 893:	8b 45 e8             	mov    -0x18(%ebp),%eax
 896:	8b 00                	mov    (%eax),%eax
 898:	6a 00                	push   $0x0
 89a:	6a 10                	push   $0x10
 89c:	50                   	push   %eax
 89d:	ff 75 08             	pushl  0x8(%ebp)
 8a0:	e8 96 fe ff ff       	call   73b <printint>
 8a5:	83 c4 10             	add    $0x10,%esp
        ap++;
 8a8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8ac:	e9 ae 00 00 00       	jmp    95f <printf+0x170>
      } else if(c == 's'){
 8b1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 8b5:	75 43                	jne    8fa <printf+0x10b>
        s = (char*)*ap;
 8b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8ba:	8b 00                	mov    (%eax),%eax
 8bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 8bf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 8c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8c7:	75 25                	jne    8ee <printf+0xff>
          s = "(null)";
 8c9:	c7 45 f4 ef 0b 00 00 	movl   $0xbef,-0xc(%ebp)
        while(*s != 0){
 8d0:	eb 1c                	jmp    8ee <printf+0xff>
          putc(fd, *s);
 8d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d5:	0f b6 00             	movzbl (%eax),%eax
 8d8:	0f be c0             	movsbl %al,%eax
 8db:	83 ec 08             	sub    $0x8,%esp
 8de:	50                   	push   %eax
 8df:	ff 75 08             	pushl  0x8(%ebp)
 8e2:	e8 31 fe ff ff       	call   718 <putc>
 8e7:	83 c4 10             	add    $0x10,%esp
          s++;
 8ea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f1:	0f b6 00             	movzbl (%eax),%eax
 8f4:	84 c0                	test   %al,%al
 8f6:	75 da                	jne    8d2 <printf+0xe3>
 8f8:	eb 65                	jmp    95f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8fa:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 8fe:	75 1d                	jne    91d <printf+0x12e>
        putc(fd, *ap);
 900:	8b 45 e8             	mov    -0x18(%ebp),%eax
 903:	8b 00                	mov    (%eax),%eax
 905:	0f be c0             	movsbl %al,%eax
 908:	83 ec 08             	sub    $0x8,%esp
 90b:	50                   	push   %eax
 90c:	ff 75 08             	pushl  0x8(%ebp)
 90f:	e8 04 fe ff ff       	call   718 <putc>
 914:	83 c4 10             	add    $0x10,%esp
        ap++;
 917:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 91b:	eb 42                	jmp    95f <printf+0x170>
      } else if(c == '%'){
 91d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 921:	75 17                	jne    93a <printf+0x14b>
        putc(fd, c);
 923:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 926:	0f be c0             	movsbl %al,%eax
 929:	83 ec 08             	sub    $0x8,%esp
 92c:	50                   	push   %eax
 92d:	ff 75 08             	pushl  0x8(%ebp)
 930:	e8 e3 fd ff ff       	call   718 <putc>
 935:	83 c4 10             	add    $0x10,%esp
 938:	eb 25                	jmp    95f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 93a:	83 ec 08             	sub    $0x8,%esp
 93d:	6a 25                	push   $0x25
 93f:	ff 75 08             	pushl  0x8(%ebp)
 942:	e8 d1 fd ff ff       	call   718 <putc>
 947:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 94a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 94d:	0f be c0             	movsbl %al,%eax
 950:	83 ec 08             	sub    $0x8,%esp
 953:	50                   	push   %eax
 954:	ff 75 08             	pushl  0x8(%ebp)
 957:	e8 bc fd ff ff       	call   718 <putc>
 95c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 95f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 966:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 96a:	8b 55 0c             	mov    0xc(%ebp),%edx
 96d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 970:	01 d0                	add    %edx,%eax
 972:	0f b6 00             	movzbl (%eax),%eax
 975:	84 c0                	test   %al,%al
 977:	0f 85 94 fe ff ff    	jne    811 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 97d:	90                   	nop
 97e:	c9                   	leave  
 97f:	c3                   	ret    

00000980 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 980:	55                   	push   %ebp
 981:	89 e5                	mov    %esp,%ebp
 983:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 986:	8b 45 08             	mov    0x8(%ebp),%eax
 989:	83 e8 08             	sub    $0x8,%eax
 98c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 98f:	a1 e4 0e 00 00       	mov    0xee4,%eax
 994:	89 45 fc             	mov    %eax,-0x4(%ebp)
 997:	eb 24                	jmp    9bd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 999:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99c:	8b 00                	mov    (%eax),%eax
 99e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9a1:	77 12                	ja     9b5 <free+0x35>
 9a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9a9:	77 24                	ja     9cf <free+0x4f>
 9ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ae:	8b 00                	mov    (%eax),%eax
 9b0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9b3:	77 1a                	ja     9cf <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b8:	8b 00                	mov    (%eax),%eax
 9ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9c3:	76 d4                	jbe    999 <free+0x19>
 9c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c8:	8b 00                	mov    (%eax),%eax
 9ca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9cd:	76 ca                	jbe    999 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 9cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d2:	8b 40 04             	mov    0x4(%eax),%eax
 9d5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9df:	01 c2                	add    %eax,%edx
 9e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e4:	8b 00                	mov    (%eax),%eax
 9e6:	39 c2                	cmp    %eax,%edx
 9e8:	75 24                	jne    a0e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 9ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ed:	8b 50 04             	mov    0x4(%eax),%edx
 9f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f3:	8b 00                	mov    (%eax),%eax
 9f5:	8b 40 04             	mov    0x4(%eax),%eax
 9f8:	01 c2                	add    %eax,%edx
 9fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9fd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a00:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a03:	8b 00                	mov    (%eax),%eax
 a05:	8b 10                	mov    (%eax),%edx
 a07:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a0a:	89 10                	mov    %edx,(%eax)
 a0c:	eb 0a                	jmp    a18 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a11:	8b 10                	mov    (%eax),%edx
 a13:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a16:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a18:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a1b:	8b 40 04             	mov    0x4(%eax),%eax
 a1e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a25:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a28:	01 d0                	add    %edx,%eax
 a2a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a2d:	75 20                	jne    a4f <free+0xcf>
    p->s.size += bp->s.size;
 a2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a32:	8b 50 04             	mov    0x4(%eax),%edx
 a35:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a38:	8b 40 04             	mov    0x4(%eax),%eax
 a3b:	01 c2                	add    %eax,%edx
 a3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a40:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a43:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a46:	8b 10                	mov    (%eax),%edx
 a48:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a4b:	89 10                	mov    %edx,(%eax)
 a4d:	eb 08                	jmp    a57 <free+0xd7>
  } else
    p->s.ptr = bp;
 a4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a52:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a55:	89 10                	mov    %edx,(%eax)
  freep = p;
 a57:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a5a:	a3 e4 0e 00 00       	mov    %eax,0xee4
}
 a5f:	90                   	nop
 a60:	c9                   	leave  
 a61:	c3                   	ret    

00000a62 <morecore>:

static Header*
morecore(uint nu)
{
 a62:	55                   	push   %ebp
 a63:	89 e5                	mov    %esp,%ebp
 a65:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a68:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a6f:	77 07                	ja     a78 <morecore+0x16>
    nu = 4096;
 a71:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a78:	8b 45 08             	mov    0x8(%ebp),%eax
 a7b:	c1 e0 03             	shl    $0x3,%eax
 a7e:	83 ec 0c             	sub    $0xc,%esp
 a81:	50                   	push   %eax
 a82:	e8 71 fc ff ff       	call   6f8 <sbrk>
 a87:	83 c4 10             	add    $0x10,%esp
 a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a8d:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a91:	75 07                	jne    a9a <morecore+0x38>
    return 0;
 a93:	b8 00 00 00 00       	mov    $0x0,%eax
 a98:	eb 26                	jmp    ac0 <morecore+0x5e>
  hp = (Header*)p;
 a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 aa0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa3:	8b 55 08             	mov    0x8(%ebp),%edx
 aa6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aac:	83 c0 08             	add    $0x8,%eax
 aaf:	83 ec 0c             	sub    $0xc,%esp
 ab2:	50                   	push   %eax
 ab3:	e8 c8 fe ff ff       	call   980 <free>
 ab8:	83 c4 10             	add    $0x10,%esp
  return freep;
 abb:	a1 e4 0e 00 00       	mov    0xee4,%eax
}
 ac0:	c9                   	leave  
 ac1:	c3                   	ret    

00000ac2 <malloc>:

void*
malloc(uint nbytes)
{
 ac2:	55                   	push   %ebp
 ac3:	89 e5                	mov    %esp,%ebp
 ac5:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ac8:	8b 45 08             	mov    0x8(%ebp),%eax
 acb:	83 c0 07             	add    $0x7,%eax
 ace:	c1 e8 03             	shr    $0x3,%eax
 ad1:	83 c0 01             	add    $0x1,%eax
 ad4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 ad7:	a1 e4 0e 00 00       	mov    0xee4,%eax
 adc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 adf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ae3:	75 23                	jne    b08 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 ae5:	c7 45 f0 dc 0e 00 00 	movl   $0xedc,-0x10(%ebp)
 aec:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aef:	a3 e4 0e 00 00       	mov    %eax,0xee4
 af4:	a1 e4 0e 00 00       	mov    0xee4,%eax
 af9:	a3 dc 0e 00 00       	mov    %eax,0xedc
    base.s.size = 0;
 afe:	c7 05 e0 0e 00 00 00 	movl   $0x0,0xee0
 b05:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b0b:	8b 00                	mov    (%eax),%eax
 b0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b13:	8b 40 04             	mov    0x4(%eax),%eax
 b16:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b19:	72 4d                	jb     b68 <malloc+0xa6>
      if(p->s.size == nunits)
 b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b1e:	8b 40 04             	mov    0x4(%eax),%eax
 b21:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b24:	75 0c                	jne    b32 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b29:	8b 10                	mov    (%eax),%edx
 b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b2e:	89 10                	mov    %edx,(%eax)
 b30:	eb 26                	jmp    b58 <malloc+0x96>
      else {
        p->s.size -= nunits;
 b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b35:	8b 40 04             	mov    0x4(%eax),%eax
 b38:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b3b:	89 c2                	mov    %eax,%edx
 b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b40:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b46:	8b 40 04             	mov    0x4(%eax),%eax
 b49:	c1 e0 03             	shl    $0x3,%eax
 b4c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b52:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b55:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b58:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b5b:	a3 e4 0e 00 00       	mov    %eax,0xee4
      return (void*)(p + 1);
 b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b63:	83 c0 08             	add    $0x8,%eax
 b66:	eb 3b                	jmp    ba3 <malloc+0xe1>
    }
    if(p == freep)
 b68:	a1 e4 0e 00 00       	mov    0xee4,%eax
 b6d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b70:	75 1e                	jne    b90 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b72:	83 ec 0c             	sub    $0xc,%esp
 b75:	ff 75 ec             	pushl  -0x14(%ebp)
 b78:	e8 e5 fe ff ff       	call   a62 <morecore>
 b7d:	83 c4 10             	add    $0x10,%esp
 b80:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b83:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b87:	75 07                	jne    b90 <malloc+0xce>
        return 0;
 b89:	b8 00 00 00 00       	mov    $0x0,%eax
 b8e:	eb 13                	jmp    ba3 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b93:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b96:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b99:	8b 00                	mov    (%eax),%eax
 b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b9e:	e9 6d ff ff ff       	jmp    b10 <malloc+0x4e>
}
 ba3:	c9                   	leave  
 ba4:	c3                   	ret    
