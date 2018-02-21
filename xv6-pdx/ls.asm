
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
  68:	68 0c 0f 00 00       	push   $0xf0c
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
  9a:	05 0c 0f 00 00       	add    $0xf0c,%eax
  9f:	83 ec 04             	sub    $0x4,%esp
  a2:	53                   	push   %ebx
  a3:	6a 20                	push   $0x20
  a5:	50                   	push   %eax
  a6:	e8 57 03 00 00       	call   402 <memset>
  ab:	83 c4 10             	add    $0x10,%esp
  return buf;
  ae:	b8 0c 0f 00 00       	mov    $0xf0c,%eax
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
  e3:	68 e5 0b 00 00       	push   $0xbe5
  e8:	6a 02                	push   $0x2
  ea:	e8 40 07 00 00       	call   82f <printf>
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
 116:	68 f9 0b 00 00       	push   $0xbf9
 11b:	6a 02                	push   $0x2
 11d:	e8 0d 07 00 00       	call   82f <printf>
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
 179:	68 0d 0c 00 00       	push   $0xc0d
 17e:	6a 01                	push   $0x1
 180:	e8 aa 06 00 00       	call   82f <printf>
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
 1a8:	68 1a 0c 00 00       	push   $0xc1a
 1ad:	6a 01                	push   $0x1
 1af:	e8 7b 06 00 00       	call   82f <printf>
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
 25c:	68 f9 0b 00 00       	push   $0xbf9
 261:	6a 01                	push   $0x1
 263:	e8 c7 05 00 00       	call   82f <printf>
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
 29c:	68 0d 0c 00 00       	push   $0xc0d
 2a1:	6a 01                	push   $0x1
 2a3:	e8 87 05 00 00       	call   82f <printf>
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
 2fe:	68 2d 0c 00 00       	push   $0xc2d
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

00000718 <date>:
SYSCALL(date)
 718:	b8 17 00 00 00       	mov    $0x17,%eax
 71d:	cd 40                	int    $0x40
 71f:	c3                   	ret    

00000720 <getuid>:
SYSCALL(getuid)
 720:	b8 18 00 00 00       	mov    $0x18,%eax
 725:	cd 40                	int    $0x40
 727:	c3                   	ret    

00000728 <getgid>:
SYSCALL(getgid)
 728:	b8 19 00 00 00       	mov    $0x19,%eax
 72d:	cd 40                	int    $0x40
 72f:	c3                   	ret    

00000730 <getppid>:
SYSCALL(getppid)
 730:	b8 1a 00 00 00       	mov    $0x1a,%eax
 735:	cd 40                	int    $0x40
 737:	c3                   	ret    

00000738 <setuid>:
SYSCALL(setuid)
 738:	b8 1b 00 00 00       	mov    $0x1b,%eax
 73d:	cd 40                	int    $0x40
 73f:	c3                   	ret    

00000740 <setgid>:
SYSCALL(setgid)
 740:	b8 1c 00 00 00       	mov    $0x1c,%eax
 745:	cd 40                	int    $0x40
 747:	c3                   	ret    

00000748 <getprocs>:
SYSCALL(getprocs)
 748:	b8 1d 00 00 00       	mov    $0x1d,%eax
 74d:	cd 40                	int    $0x40
 74f:	c3                   	ret    

00000750 <setpriority>:
SYSCALL(setpriority)
 750:	b8 1e 00 00 00       	mov    $0x1e,%eax
 755:	cd 40                	int    $0x40
 757:	c3                   	ret    

00000758 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 758:	55                   	push   %ebp
 759:	89 e5                	mov    %esp,%ebp
 75b:	83 ec 18             	sub    $0x18,%esp
 75e:	8b 45 0c             	mov    0xc(%ebp),%eax
 761:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 764:	83 ec 04             	sub    $0x4,%esp
 767:	6a 01                	push   $0x1
 769:	8d 45 f4             	lea    -0xc(%ebp),%eax
 76c:	50                   	push   %eax
 76d:	ff 75 08             	pushl  0x8(%ebp)
 770:	e8 1b ff ff ff       	call   690 <write>
 775:	83 c4 10             	add    $0x10,%esp
}
 778:	90                   	nop
 779:	c9                   	leave  
 77a:	c3                   	ret    

0000077b <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 77b:	55                   	push   %ebp
 77c:	89 e5                	mov    %esp,%ebp
 77e:	53                   	push   %ebx
 77f:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 782:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 789:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 78d:	74 17                	je     7a6 <printint+0x2b>
 78f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 793:	79 11                	jns    7a6 <printint+0x2b>
    neg = 1;
 795:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 79c:	8b 45 0c             	mov    0xc(%ebp),%eax
 79f:	f7 d8                	neg    %eax
 7a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7a4:	eb 06                	jmp    7ac <printint+0x31>
  } else {
    x = xx;
 7a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 7a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 7ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 7b3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 7b6:	8d 41 01             	lea    0x1(%ecx),%eax
 7b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7c2:	ba 00 00 00 00       	mov    $0x0,%edx
 7c7:	f7 f3                	div    %ebx
 7c9:	89 d0                	mov    %edx,%eax
 7cb:	0f b6 80 f8 0e 00 00 	movzbl 0xef8(%eax),%eax
 7d2:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 7d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7dc:	ba 00 00 00 00       	mov    $0x0,%edx
 7e1:	f7 f3                	div    %ebx
 7e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7ea:	75 c7                	jne    7b3 <printint+0x38>
  if(neg)
 7ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7f0:	74 2d                	je     81f <printint+0xa4>
    buf[i++] = '-';
 7f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f5:	8d 50 01             	lea    0x1(%eax),%edx
 7f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 7fb:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 800:	eb 1d                	jmp    81f <printint+0xa4>
    putc(fd, buf[i]);
 802:	8d 55 dc             	lea    -0x24(%ebp),%edx
 805:	8b 45 f4             	mov    -0xc(%ebp),%eax
 808:	01 d0                	add    %edx,%eax
 80a:	0f b6 00             	movzbl (%eax),%eax
 80d:	0f be c0             	movsbl %al,%eax
 810:	83 ec 08             	sub    $0x8,%esp
 813:	50                   	push   %eax
 814:	ff 75 08             	pushl  0x8(%ebp)
 817:	e8 3c ff ff ff       	call   758 <putc>
 81c:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 81f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 823:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 827:	79 d9                	jns    802 <printint+0x87>
    putc(fd, buf[i]);
}
 829:	90                   	nop
 82a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 82d:	c9                   	leave  
 82e:	c3                   	ret    

0000082f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 82f:	55                   	push   %ebp
 830:	89 e5                	mov    %esp,%ebp
 832:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 835:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 83c:	8d 45 0c             	lea    0xc(%ebp),%eax
 83f:	83 c0 04             	add    $0x4,%eax
 842:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 845:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 84c:	e9 59 01 00 00       	jmp    9aa <printf+0x17b>
    c = fmt[i] & 0xff;
 851:	8b 55 0c             	mov    0xc(%ebp),%edx
 854:	8b 45 f0             	mov    -0x10(%ebp),%eax
 857:	01 d0                	add    %edx,%eax
 859:	0f b6 00             	movzbl (%eax),%eax
 85c:	0f be c0             	movsbl %al,%eax
 85f:	25 ff 00 00 00       	and    $0xff,%eax
 864:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 867:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 86b:	75 2c                	jne    899 <printf+0x6a>
      if(c == '%'){
 86d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 871:	75 0c                	jne    87f <printf+0x50>
        state = '%';
 873:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 87a:	e9 27 01 00 00       	jmp    9a6 <printf+0x177>
      } else {
        putc(fd, c);
 87f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 882:	0f be c0             	movsbl %al,%eax
 885:	83 ec 08             	sub    $0x8,%esp
 888:	50                   	push   %eax
 889:	ff 75 08             	pushl  0x8(%ebp)
 88c:	e8 c7 fe ff ff       	call   758 <putc>
 891:	83 c4 10             	add    $0x10,%esp
 894:	e9 0d 01 00 00       	jmp    9a6 <printf+0x177>
      }
    } else if(state == '%'){
 899:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 89d:	0f 85 03 01 00 00    	jne    9a6 <printf+0x177>
      if(c == 'd'){
 8a3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 8a7:	75 1e                	jne    8c7 <printf+0x98>
        printint(fd, *ap, 10, 1);
 8a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8ac:	8b 00                	mov    (%eax),%eax
 8ae:	6a 01                	push   $0x1
 8b0:	6a 0a                	push   $0xa
 8b2:	50                   	push   %eax
 8b3:	ff 75 08             	pushl  0x8(%ebp)
 8b6:	e8 c0 fe ff ff       	call   77b <printint>
 8bb:	83 c4 10             	add    $0x10,%esp
        ap++;
 8be:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8c2:	e9 d8 00 00 00       	jmp    99f <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 8c7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 8cb:	74 06                	je     8d3 <printf+0xa4>
 8cd:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 8d1:	75 1e                	jne    8f1 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 8d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8d6:	8b 00                	mov    (%eax),%eax
 8d8:	6a 00                	push   $0x0
 8da:	6a 10                	push   $0x10
 8dc:	50                   	push   %eax
 8dd:	ff 75 08             	pushl  0x8(%ebp)
 8e0:	e8 96 fe ff ff       	call   77b <printint>
 8e5:	83 c4 10             	add    $0x10,%esp
        ap++;
 8e8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8ec:	e9 ae 00 00 00       	jmp    99f <printf+0x170>
      } else if(c == 's'){
 8f1:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 8f5:	75 43                	jne    93a <printf+0x10b>
        s = (char*)*ap;
 8f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8fa:	8b 00                	mov    (%eax),%eax
 8fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 8ff:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 903:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 907:	75 25                	jne    92e <printf+0xff>
          s = "(null)";
 909:	c7 45 f4 2f 0c 00 00 	movl   $0xc2f,-0xc(%ebp)
        while(*s != 0){
 910:	eb 1c                	jmp    92e <printf+0xff>
          putc(fd, *s);
 912:	8b 45 f4             	mov    -0xc(%ebp),%eax
 915:	0f b6 00             	movzbl (%eax),%eax
 918:	0f be c0             	movsbl %al,%eax
 91b:	83 ec 08             	sub    $0x8,%esp
 91e:	50                   	push   %eax
 91f:	ff 75 08             	pushl  0x8(%ebp)
 922:	e8 31 fe ff ff       	call   758 <putc>
 927:	83 c4 10             	add    $0x10,%esp
          s++;
 92a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 92e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 931:	0f b6 00             	movzbl (%eax),%eax
 934:	84 c0                	test   %al,%al
 936:	75 da                	jne    912 <printf+0xe3>
 938:	eb 65                	jmp    99f <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 93a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 93e:	75 1d                	jne    95d <printf+0x12e>
        putc(fd, *ap);
 940:	8b 45 e8             	mov    -0x18(%ebp),%eax
 943:	8b 00                	mov    (%eax),%eax
 945:	0f be c0             	movsbl %al,%eax
 948:	83 ec 08             	sub    $0x8,%esp
 94b:	50                   	push   %eax
 94c:	ff 75 08             	pushl  0x8(%ebp)
 94f:	e8 04 fe ff ff       	call   758 <putc>
 954:	83 c4 10             	add    $0x10,%esp
        ap++;
 957:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 95b:	eb 42                	jmp    99f <printf+0x170>
      } else if(c == '%'){
 95d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 961:	75 17                	jne    97a <printf+0x14b>
        putc(fd, c);
 963:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 966:	0f be c0             	movsbl %al,%eax
 969:	83 ec 08             	sub    $0x8,%esp
 96c:	50                   	push   %eax
 96d:	ff 75 08             	pushl  0x8(%ebp)
 970:	e8 e3 fd ff ff       	call   758 <putc>
 975:	83 c4 10             	add    $0x10,%esp
 978:	eb 25                	jmp    99f <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 97a:	83 ec 08             	sub    $0x8,%esp
 97d:	6a 25                	push   $0x25
 97f:	ff 75 08             	pushl  0x8(%ebp)
 982:	e8 d1 fd ff ff       	call   758 <putc>
 987:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 98a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 98d:	0f be c0             	movsbl %al,%eax
 990:	83 ec 08             	sub    $0x8,%esp
 993:	50                   	push   %eax
 994:	ff 75 08             	pushl  0x8(%ebp)
 997:	e8 bc fd ff ff       	call   758 <putc>
 99c:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 99f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 9a6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 9aa:	8b 55 0c             	mov    0xc(%ebp),%edx
 9ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9b0:	01 d0                	add    %edx,%eax
 9b2:	0f b6 00             	movzbl (%eax),%eax
 9b5:	84 c0                	test   %al,%al
 9b7:	0f 85 94 fe ff ff    	jne    851 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 9bd:	90                   	nop
 9be:	c9                   	leave  
 9bf:	c3                   	ret    

000009c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9c0:	55                   	push   %ebp
 9c1:	89 e5                	mov    %esp,%ebp
 9c3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9c6:	8b 45 08             	mov    0x8(%ebp),%eax
 9c9:	83 e8 08             	sub    $0x8,%eax
 9cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9cf:	a1 24 0f 00 00       	mov    0xf24,%eax
 9d4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9d7:	eb 24                	jmp    9fd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9dc:	8b 00                	mov    (%eax),%eax
 9de:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9e1:	77 12                	ja     9f5 <free+0x35>
 9e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9e9:	77 24                	ja     a0f <free+0x4f>
 9eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ee:	8b 00                	mov    (%eax),%eax
 9f0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9f3:	77 1a                	ja     a0f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f8:	8b 00                	mov    (%eax),%eax
 9fa:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a00:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a03:	76 d4                	jbe    9d9 <free+0x19>
 a05:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a08:	8b 00                	mov    (%eax),%eax
 a0a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a0d:	76 ca                	jbe    9d9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a12:	8b 40 04             	mov    0x4(%eax),%eax
 a15:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a1f:	01 c2                	add    %eax,%edx
 a21:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a24:	8b 00                	mov    (%eax),%eax
 a26:	39 c2                	cmp    %eax,%edx
 a28:	75 24                	jne    a4e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a2d:	8b 50 04             	mov    0x4(%eax),%edx
 a30:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a33:	8b 00                	mov    (%eax),%eax
 a35:	8b 40 04             	mov    0x4(%eax),%eax
 a38:	01 c2                	add    %eax,%edx
 a3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a3d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a40:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a43:	8b 00                	mov    (%eax),%eax
 a45:	8b 10                	mov    (%eax),%edx
 a47:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a4a:	89 10                	mov    %edx,(%eax)
 a4c:	eb 0a                	jmp    a58 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a51:	8b 10                	mov    (%eax),%edx
 a53:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a56:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a58:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a5b:	8b 40 04             	mov    0x4(%eax),%eax
 a5e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a65:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a68:	01 d0                	add    %edx,%eax
 a6a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a6d:	75 20                	jne    a8f <free+0xcf>
    p->s.size += bp->s.size;
 a6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a72:	8b 50 04             	mov    0x4(%eax),%edx
 a75:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a78:	8b 40 04             	mov    0x4(%eax),%eax
 a7b:	01 c2                	add    %eax,%edx
 a7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a80:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a83:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a86:	8b 10                	mov    (%eax),%edx
 a88:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a8b:	89 10                	mov    %edx,(%eax)
 a8d:	eb 08                	jmp    a97 <free+0xd7>
  } else
    p->s.ptr = bp;
 a8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a92:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a95:	89 10                	mov    %edx,(%eax)
  freep = p;
 a97:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a9a:	a3 24 0f 00 00       	mov    %eax,0xf24
}
 a9f:	90                   	nop
 aa0:	c9                   	leave  
 aa1:	c3                   	ret    

00000aa2 <morecore>:

static Header*
morecore(uint nu)
{
 aa2:	55                   	push   %ebp
 aa3:	89 e5                	mov    %esp,%ebp
 aa5:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 aa8:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 aaf:	77 07                	ja     ab8 <morecore+0x16>
    nu = 4096;
 ab1:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 ab8:	8b 45 08             	mov    0x8(%ebp),%eax
 abb:	c1 e0 03             	shl    $0x3,%eax
 abe:	83 ec 0c             	sub    $0xc,%esp
 ac1:	50                   	push   %eax
 ac2:	e8 31 fc ff ff       	call   6f8 <sbrk>
 ac7:	83 c4 10             	add    $0x10,%esp
 aca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 acd:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 ad1:	75 07                	jne    ada <morecore+0x38>
    return 0;
 ad3:	b8 00 00 00 00       	mov    $0x0,%eax
 ad8:	eb 26                	jmp    b00 <morecore+0x5e>
  hp = (Header*)p;
 ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
 add:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 ae0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ae3:	8b 55 08             	mov    0x8(%ebp),%edx
 ae6:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 ae9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aec:	83 c0 08             	add    $0x8,%eax
 aef:	83 ec 0c             	sub    $0xc,%esp
 af2:	50                   	push   %eax
 af3:	e8 c8 fe ff ff       	call   9c0 <free>
 af8:	83 c4 10             	add    $0x10,%esp
  return freep;
 afb:	a1 24 0f 00 00       	mov    0xf24,%eax
}
 b00:	c9                   	leave  
 b01:	c3                   	ret    

00000b02 <malloc>:

void*
malloc(uint nbytes)
{
 b02:	55                   	push   %ebp
 b03:	89 e5                	mov    %esp,%ebp
 b05:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b08:	8b 45 08             	mov    0x8(%ebp),%eax
 b0b:	83 c0 07             	add    $0x7,%eax
 b0e:	c1 e8 03             	shr    $0x3,%eax
 b11:	83 c0 01             	add    $0x1,%eax
 b14:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b17:	a1 24 0f 00 00       	mov    0xf24,%eax
 b1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b1f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b23:	75 23                	jne    b48 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 b25:	c7 45 f0 1c 0f 00 00 	movl   $0xf1c,-0x10(%ebp)
 b2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b2f:	a3 24 0f 00 00       	mov    %eax,0xf24
 b34:	a1 24 0f 00 00       	mov    0xf24,%eax
 b39:	a3 1c 0f 00 00       	mov    %eax,0xf1c
    base.s.size = 0;
 b3e:	c7 05 20 0f 00 00 00 	movl   $0x0,0xf20
 b45:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b48:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b4b:	8b 00                	mov    (%eax),%eax
 b4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b53:	8b 40 04             	mov    0x4(%eax),%eax
 b56:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b59:	72 4d                	jb     ba8 <malloc+0xa6>
      if(p->s.size == nunits)
 b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b5e:	8b 40 04             	mov    0x4(%eax),%eax
 b61:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b64:	75 0c                	jne    b72 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b69:	8b 10                	mov    (%eax),%edx
 b6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b6e:	89 10                	mov    %edx,(%eax)
 b70:	eb 26                	jmp    b98 <malloc+0x96>
      else {
        p->s.size -= nunits;
 b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b75:	8b 40 04             	mov    0x4(%eax),%eax
 b78:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b7b:	89 c2                	mov    %eax,%edx
 b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b80:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b86:	8b 40 04             	mov    0x4(%eax),%eax
 b89:	c1 e0 03             	shl    $0x3,%eax
 b8c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b92:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b95:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b98:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b9b:	a3 24 0f 00 00       	mov    %eax,0xf24
      return (void*)(p + 1);
 ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ba3:	83 c0 08             	add    $0x8,%eax
 ba6:	eb 3b                	jmp    be3 <malloc+0xe1>
    }
    if(p == freep)
 ba8:	a1 24 0f 00 00       	mov    0xf24,%eax
 bad:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 bb0:	75 1e                	jne    bd0 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 bb2:	83 ec 0c             	sub    $0xc,%esp
 bb5:	ff 75 ec             	pushl  -0x14(%ebp)
 bb8:	e8 e5 fe ff ff       	call   aa2 <morecore>
 bbd:	83 c4 10             	add    $0x10,%esp
 bc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
 bc3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 bc7:	75 07                	jne    bd0 <malloc+0xce>
        return 0;
 bc9:	b8 00 00 00 00       	mov    $0x0,%eax
 bce:	eb 13                	jmp    be3 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
 bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd9:	8b 00                	mov    (%eax),%eax
 bdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 bde:	e9 6d ff ff ff       	jmp    b50 <malloc+0x4e>
}
 be3:	c9                   	leave  
 be4:	c3                   	ret    
