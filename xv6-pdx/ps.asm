
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <elapsed>:
#include "user.h"
#include "uproc.h"

void
elapsed(uint ticks)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
    uint elapsed, whole_sec, milisec_ten, milisec_hund, milisec_thou;
    elapsed = ticks; // find original elapsed time
   6:	8b 45 08             	mov    0x8(%ebp),%eax
   9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    whole_sec = elapsed / 1000; // the the left of the decimal point
   c:	8b 45 f4             	mov    -0xc(%ebp),%eax
   f:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
  14:	f7 e2                	mul    %edx
  16:	89 d0                	mov    %edx,%eax
  18:	c1 e8 06             	shr    $0x6,%eax
  1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    // % to shave off leading digit of elapsed for decimal place calcs
    milisec_ten = (elapsed %= 1000) / 100; // divide and round up to nearest int
  1e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  21:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
  26:	89 c8                	mov    %ecx,%eax
  28:	f7 e2                	mul    %edx
  2a:	89 d0                	mov    %edx,%eax
  2c:	c1 e8 06             	shr    $0x6,%eax
  2f:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
  35:	29 c1                	sub    %eax,%ecx
  37:	89 c8                	mov    %ecx,%eax
  39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  3f:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  44:	f7 e2                	mul    %edx
  46:	89 d0                	mov    %edx,%eax
  48:	c1 e8 05             	shr    $0x5,%eax
  4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    milisec_hund = (elapsed %= 100) / 10; // shave off previously counted int, repeat
  4e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  51:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  56:	89 c8                	mov    %ecx,%eax
  58:	f7 e2                	mul    %edx
  5a:	89 d0                	mov    %edx,%eax
  5c:	c1 e8 05             	shr    $0x5,%eax
  5f:	6b c0 64             	imul   $0x64,%eax,%eax
  62:	29 c1                	sub    %eax,%ecx
  64:	89 c8                	mov    %ecx,%eax
  66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  6c:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  71:	f7 e2                	mul    %edx
  73:	89 d0                	mov    %edx,%eax
  75:	c1 e8 03             	shr    $0x3,%eax
  78:	89 45 e8             	mov    %eax,-0x18(%ebp)
    milisec_thou = elapsed %= 10; // determine thousandth place
  7b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  7e:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  83:	89 c8                	mov    %ecx,%eax
  85:	f7 e2                	mul    %edx
  87:	c1 ea 03             	shr    $0x3,%edx
  8a:	89 d0                	mov    %edx,%eax
  8c:	c1 e0 02             	shl    $0x2,%eax
  8f:	01 d0                	add    %edx,%eax
  91:	01 c0                	add    %eax,%eax
  93:	29 c1                	sub    %eax,%ecx
  95:	89 c8                	mov    %ecx,%eax
  97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  9d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    printf(1, "\t%d.%d%d%d", whole_sec, milisec_ten, milisec_hund, milisec_thou);
  a0:	83 ec 08             	sub    $0x8,%esp
  a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  a6:	ff 75 e8             	pushl  -0x18(%ebp)
  a9:	ff 75 ec             	pushl  -0x14(%ebp)
  ac:	ff 75 f0             	pushl  -0x10(%ebp)
  af:	68 44 0b 00 00       	push   $0xb44
  b4:	6a 01                	push   $0x1
  b6:	e8 d0 06 00 00       	call   78b <printf>
  bb:	83 c4 20             	add    $0x20,%esp
}
  be:	90                   	nop
  bf:	c9                   	leave  
  c0:	c3                   	ret    

000000c1 <main>:

int
main(void)
{
  c1:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  c5:	83 e4 f0             	and    $0xfffffff0,%esp
  c8:	ff 71 fc             	pushl  -0x4(%ecx)
  cb:	55                   	push   %ebp
  cc:	89 e5                	mov    %esp,%ebp
  ce:	57                   	push   %edi
  cf:	56                   	push   %esi
  d0:	53                   	push   %ebx
  d1:	51                   	push   %ecx
  d2:	83 ec 18             	sub    $0x18,%esp
  int max = 32, active_procs = 0;
  d5:	c7 45 e0 20 00 00 00 	movl   $0x20,-0x20(%ebp)
  dc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  struct uproc* utable = (struct uproc*) malloc(max * sizeof(struct uproc));
  e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  e6:	6b c0 5c             	imul   $0x5c,%eax,%eax
  e9:	83 ec 0c             	sub    $0xc,%esp
  ec:	50                   	push   %eax
  ed:	e8 6c 09 00 00       	call   a5e <malloc>
  f2:	83 c4 10             	add    $0x10,%esp
  f5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  // system call -> sysproc.c -> proc.c -> return
  active_procs = getprocs(max, utable); // populate utable
  f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  fb:	83 ec 08             	sub    $0x8,%esp
  fe:	ff 75 d8             	pushl  -0x28(%ebp)
 101:	50                   	push   %eax
 102:	e8 a5 05 00 00       	call   6ac <getprocs>
 107:	83 c4 10             	add    $0x10,%esp
 10a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  // error from sysproc.c - valued not pulled from stack
  if (active_procs == -1) {
 10d:	83 7d dc ff          	cmpl   $0xffffffff,-0x24(%ebp)
 111:	75 25                	jne    138 <main+0x77>
      printf(1, "Error in active process table creation.\n");
 113:	83 ec 08             	sub    $0x8,%esp
 116:	68 50 0b 00 00       	push   $0xb50
 11b:	6a 01                	push   $0x1
 11d:	e8 69 06 00 00       	call   78b <printf>
 122:	83 c4 10             	add    $0x10,%esp
      free(utable);
 125:	83 ec 0c             	sub    $0xc,%esp
 128:	ff 75 d8             	pushl  -0x28(%ebp)
 12b:	e8 ec 07 00 00       	call   91c <free>
 130:	83 c4 10             	add    $0x10,%esp
      exit();
 133:	e8 9c 04 00 00       	call   5d4 <exit>
  }
  // no active processes
  else if (active_procs == 0) {
 138:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
 13c:	75 25                	jne    163 <main+0xa2>
      printf(1, "No active processes.\n");
 13e:	83 ec 08             	sub    $0x8,%esp
 141:	68 79 0b 00 00       	push   $0xb79
 146:	6a 01                	push   $0x1
 148:	e8 3e 06 00 00       	call   78b <printf>
 14d:	83 c4 10             	add    $0x10,%esp
      free(utable);
 150:	83 ec 0c             	sub    $0xc,%esp
 153:	ff 75 d8             	pushl  -0x28(%ebp)
 156:	e8 c1 07 00 00       	call   91c <free>
 15b:	83 c4 10             	add    $0x10,%esp
      exit();
 15e:	e8 71 04 00 00       	call   5d4 <exit>
  }
  // loop utable and print process information
  else if (active_procs > 0) {
 163:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
 167:	0f 8e 2a 01 00 00    	jle    297 <main+0x1d6>
      printf(1, "\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s",
 16d:	83 ec 04             	sub    $0x4,%esp
 170:	68 8f 0b 00 00       	push   $0xb8f
 175:	68 94 0b 00 00       	push   $0xb94
 17a:	68 9a 0b 00 00       	push   $0xb9a
 17f:	68 9e 0b 00 00       	push   $0xb9e
 184:	68 a6 0b 00 00       	push   $0xba6
 189:	68 ab 0b 00 00       	push   $0xbab
 18e:	68 af 0b 00 00       	push   $0xbaf
 193:	68 b3 0b 00 00       	push   $0xbb3
 198:	68 b8 0b 00 00       	push   $0xbb8
 19d:	68 bc 0b 00 00       	push   $0xbbc
 1a2:	6a 01                	push   $0x1
 1a4:	e8 e2 05 00 00       	call   78b <printf>
 1a9:	83 c4 30             	add    $0x30,%esp
              "PID", "Name", "UID", "GID", "PPID", "Elapsed", "CPU", "State", "Size");
      for (int i = 0; i < active_procs; ++i) {
 1ac:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 1b3:	e9 c1 00 00 00       	jmp    279 <main+0x1b8>
          printf(1, "\n%d\t%s\t%d\t%d\t%d",
                  utable[i].pid, utable[i].name, utable[i].uid, utable[i].gid, utable[i].ppid);
 1b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1bb:	6b d0 5c             	imul   $0x5c,%eax,%edx
 1be:	8b 45 d8             	mov    -0x28(%ebp),%eax
 1c1:	01 d0                	add    %edx,%eax
  // loop utable and print process information
  else if (active_procs > 0) {
      printf(1, "\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s",
              "PID", "Name", "UID", "GID", "PPID", "Elapsed", "CPU", "State", "Size");
      for (int i = 0; i < active_procs; ++i) {
          printf(1, "\n%d\t%s\t%d\t%d\t%d",
 1c3:	8b 58 0c             	mov    0xc(%eax),%ebx
                  utable[i].pid, utable[i].name, utable[i].uid, utable[i].gid, utable[i].ppid);
 1c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1c9:	6b d0 5c             	imul   $0x5c,%eax,%edx
 1cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
 1cf:	01 d0                	add    %edx,%eax
  // loop utable and print process information
  else if (active_procs > 0) {
      printf(1, "\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s",
              "PID", "Name", "UID", "GID", "PPID", "Elapsed", "CPU", "State", "Size");
      for (int i = 0; i < active_procs; ++i) {
          printf(1, "\n%d\t%s\t%d\t%d\t%d",
 1d1:	8b 48 08             	mov    0x8(%eax),%ecx
                  utable[i].pid, utable[i].name, utable[i].uid, utable[i].gid, utable[i].ppid);
 1d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1d7:	6b d0 5c             	imul   $0x5c,%eax,%edx
 1da:	8b 45 d8             	mov    -0x28(%ebp),%eax
 1dd:	01 d0                	add    %edx,%eax
  // loop utable and print process information
  else if (active_procs > 0) {
      printf(1, "\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s",
              "PID", "Name", "UID", "GID", "PPID", "Elapsed", "CPU", "State", "Size");
      for (int i = 0; i < active_procs; ++i) {
          printf(1, "\n%d\t%s\t%d\t%d\t%d",
 1df:	8b 50 04             	mov    0x4(%eax),%edx
                  utable[i].pid, utable[i].name, utable[i].uid, utable[i].gid, utable[i].ppid);
 1e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1e5:	6b f0 5c             	imul   $0x5c,%eax,%esi
 1e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
 1eb:	01 f0                	add    %esi,%eax
 1ed:	8d 70 3c             	lea    0x3c(%eax),%esi
 1f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1f3:	6b f8 5c             	imul   $0x5c,%eax,%edi
 1f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
 1f9:	01 f8                	add    %edi,%eax
  // loop utable and print process information
  else if (active_procs > 0) {
      printf(1, "\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s",
              "PID", "Name", "UID", "GID", "PPID", "Elapsed", "CPU", "State", "Size");
      for (int i = 0; i < active_procs; ++i) {
          printf(1, "\n%d\t%s\t%d\t%d\t%d",
 1fb:	8b 00                	mov    (%eax),%eax
 1fd:	83 ec 04             	sub    $0x4,%esp
 200:	53                   	push   %ebx
 201:	51                   	push   %ecx
 202:	52                   	push   %edx
 203:	56                   	push   %esi
 204:	50                   	push   %eax
 205:	68 d8 0b 00 00       	push   $0xbd8
 20a:	6a 01                	push   $0x1
 20c:	e8 7a 05 00 00       	call   78b <printf>
 211:	83 c4 20             	add    $0x20,%esp
                  utable[i].pid, utable[i].name, utable[i].uid, utable[i].gid, utable[i].ppid);
          elapsed(utable[i].elapsed_ticks);
 214:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 217:	6b d0 5c             	imul   $0x5c,%eax,%edx
 21a:	8b 45 d8             	mov    -0x28(%ebp),%eax
 21d:	01 d0                	add    %edx,%eax
 21f:	8b 40 10             	mov    0x10(%eax),%eax
 222:	83 ec 0c             	sub    $0xc,%esp
 225:	50                   	push   %eax
 226:	e8 d5 fd ff ff       	call   0 <elapsed>
 22b:	83 c4 10             	add    $0x10,%esp
          elapsed(utable[i].CPU_total_ticks);
 22e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 231:	6b d0 5c             	imul   $0x5c,%eax,%edx
 234:	8b 45 d8             	mov    -0x28(%ebp),%eax
 237:	01 d0                	add    %edx,%eax
 239:	8b 40 14             	mov    0x14(%eax),%eax
 23c:	83 ec 0c             	sub    $0xc,%esp
 23f:	50                   	push   %eax
 240:	e8 bb fd ff ff       	call   0 <elapsed>
 245:	83 c4 10             	add    $0x10,%esp
          printf(1, "\t%s\t%d", utable[i].state, utable[i].size);
 248:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 24b:	6b d0 5c             	imul   $0x5c,%eax,%edx
 24e:	8b 45 d8             	mov    -0x28(%ebp),%eax
 251:	01 d0                	add    %edx,%eax
 253:	8b 40 38             	mov    0x38(%eax),%eax
 256:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 259:	6b ca 5c             	imul   $0x5c,%edx,%ecx
 25c:	8b 55 d8             	mov    -0x28(%ebp),%edx
 25f:	01 ca                	add    %ecx,%edx
 261:	83 c2 18             	add    $0x18,%edx
 264:	50                   	push   %eax
 265:	52                   	push   %edx
 266:	68 e8 0b 00 00       	push   $0xbe8
 26b:	6a 01                	push   $0x1
 26d:	e8 19 05 00 00       	call   78b <printf>
 272:	83 c4 10             	add    $0x10,%esp
  }
  // loop utable and print process information
  else if (active_procs > 0) {
      printf(1, "\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s",
              "PID", "Name", "UID", "GID", "PPID", "Elapsed", "CPU", "State", "Size");
      for (int i = 0; i < active_procs; ++i) {
 275:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 279:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 27c:	3b 45 dc             	cmp    -0x24(%ebp),%eax
 27f:	0f 8c 33 ff ff ff    	jl     1b8 <main+0xf7>
                  utable[i].pid, utable[i].name, utable[i].uid, utable[i].gid, utable[i].ppid);
          elapsed(utable[i].elapsed_ticks);
          elapsed(utable[i].CPU_total_ticks);
          printf(1, "\t%s\t%d", utable[i].state, utable[i].size);
      }
      printf(1, "\n");
 285:	83 ec 08             	sub    $0x8,%esp
 288:	68 ef 0b 00 00       	push   $0xbef
 28d:	6a 01                	push   $0x1
 28f:	e8 f7 04 00 00       	call   78b <printf>
 294:	83 c4 10             	add    $0x10,%esp
  }
  free(utable);
 297:	83 ec 0c             	sub    $0xc,%esp
 29a:	ff 75 d8             	pushl  -0x28(%ebp)
 29d:	e8 7a 06 00 00       	call   91c <free>
 2a2:	83 c4 10             	add    $0x10,%esp
  exit();
 2a5:	e8 2a 03 00 00       	call   5d4 <exit>

000002aa <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 2aa:	55                   	push   %ebp
 2ab:	89 e5                	mov    %esp,%ebp
 2ad:	57                   	push   %edi
 2ae:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 2af:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2b2:	8b 55 10             	mov    0x10(%ebp),%edx
 2b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b8:	89 cb                	mov    %ecx,%ebx
 2ba:	89 df                	mov    %ebx,%edi
 2bc:	89 d1                	mov    %edx,%ecx
 2be:	fc                   	cld    
 2bf:	f3 aa                	rep stos %al,%es:(%edi)
 2c1:	89 ca                	mov    %ecx,%edx
 2c3:	89 fb                	mov    %edi,%ebx
 2c5:	89 5d 08             	mov    %ebx,0x8(%ebp)
 2c8:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 2cb:	90                   	nop
 2cc:	5b                   	pop    %ebx
 2cd:	5f                   	pop    %edi
 2ce:	5d                   	pop    %ebp
 2cf:	c3                   	ret    

000002d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2d0:	55                   	push   %ebp
 2d1:	89 e5                	mov    %esp,%ebp
 2d3:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 2d6:	8b 45 08             	mov    0x8(%ebp),%eax
 2d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 2dc:	90                   	nop
 2dd:	8b 45 08             	mov    0x8(%ebp),%eax
 2e0:	8d 50 01             	lea    0x1(%eax),%edx
 2e3:	89 55 08             	mov    %edx,0x8(%ebp)
 2e6:	8b 55 0c             	mov    0xc(%ebp),%edx
 2e9:	8d 4a 01             	lea    0x1(%edx),%ecx
 2ec:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 2ef:	0f b6 12             	movzbl (%edx),%edx
 2f2:	88 10                	mov    %dl,(%eax)
 2f4:	0f b6 00             	movzbl (%eax),%eax
 2f7:	84 c0                	test   %al,%al
 2f9:	75 e2                	jne    2dd <strcpy+0xd>
    ;
  return os;
 2fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2fe:	c9                   	leave  
 2ff:	c3                   	ret    

00000300 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 303:	eb 08                	jmp    30d <strcmp+0xd>
    p++, q++;
 305:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 309:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 30d:	8b 45 08             	mov    0x8(%ebp),%eax
 310:	0f b6 00             	movzbl (%eax),%eax
 313:	84 c0                	test   %al,%al
 315:	74 10                	je     327 <strcmp+0x27>
 317:	8b 45 08             	mov    0x8(%ebp),%eax
 31a:	0f b6 10             	movzbl (%eax),%edx
 31d:	8b 45 0c             	mov    0xc(%ebp),%eax
 320:	0f b6 00             	movzbl (%eax),%eax
 323:	38 c2                	cmp    %al,%dl
 325:	74 de                	je     305 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	0f b6 00             	movzbl (%eax),%eax
 32d:	0f b6 d0             	movzbl %al,%edx
 330:	8b 45 0c             	mov    0xc(%ebp),%eax
 333:	0f b6 00             	movzbl (%eax),%eax
 336:	0f b6 c0             	movzbl %al,%eax
 339:	29 c2                	sub    %eax,%edx
 33b:	89 d0                	mov    %edx,%eax
}
 33d:	5d                   	pop    %ebp
 33e:	c3                   	ret    

0000033f <strlen>:

uint
strlen(char *s)
{
 33f:	55                   	push   %ebp
 340:	89 e5                	mov    %esp,%ebp
 342:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 345:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 34c:	eb 04                	jmp    352 <strlen+0x13>
 34e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 352:	8b 55 fc             	mov    -0x4(%ebp),%edx
 355:	8b 45 08             	mov    0x8(%ebp),%eax
 358:	01 d0                	add    %edx,%eax
 35a:	0f b6 00             	movzbl (%eax),%eax
 35d:	84 c0                	test   %al,%al
 35f:	75 ed                	jne    34e <strlen+0xf>
    ;
  return n;
 361:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 364:	c9                   	leave  
 365:	c3                   	ret    

00000366 <memset>:

void*
memset(void *dst, int c, uint n)
{
 366:	55                   	push   %ebp
 367:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 369:	8b 45 10             	mov    0x10(%ebp),%eax
 36c:	50                   	push   %eax
 36d:	ff 75 0c             	pushl  0xc(%ebp)
 370:	ff 75 08             	pushl  0x8(%ebp)
 373:	e8 32 ff ff ff       	call   2aa <stosb>
 378:	83 c4 0c             	add    $0xc,%esp
  return dst;
 37b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 37e:	c9                   	leave  
 37f:	c3                   	ret    

00000380 <strchr>:

char*
strchr(const char *s, char c)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	83 ec 04             	sub    $0x4,%esp
 386:	8b 45 0c             	mov    0xc(%ebp),%eax
 389:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 38c:	eb 14                	jmp    3a2 <strchr+0x22>
    if(*s == c)
 38e:	8b 45 08             	mov    0x8(%ebp),%eax
 391:	0f b6 00             	movzbl (%eax),%eax
 394:	3a 45 fc             	cmp    -0x4(%ebp),%al
 397:	75 05                	jne    39e <strchr+0x1e>
      return (char*)s;
 399:	8b 45 08             	mov    0x8(%ebp),%eax
 39c:	eb 13                	jmp    3b1 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 39e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3a2:	8b 45 08             	mov    0x8(%ebp),%eax
 3a5:	0f b6 00             	movzbl (%eax),%eax
 3a8:	84 c0                	test   %al,%al
 3aa:	75 e2                	jne    38e <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 3ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3b1:	c9                   	leave  
 3b2:	c3                   	ret    

000003b3 <gets>:

char*
gets(char *buf, int max)
{
 3b3:	55                   	push   %ebp
 3b4:	89 e5                	mov    %esp,%ebp
 3b6:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 3c0:	eb 42                	jmp    404 <gets+0x51>
    cc = read(0, &c, 1);
 3c2:	83 ec 04             	sub    $0x4,%esp
 3c5:	6a 01                	push   $0x1
 3c7:	8d 45 ef             	lea    -0x11(%ebp),%eax
 3ca:	50                   	push   %eax
 3cb:	6a 00                	push   $0x0
 3cd:	e8 1a 02 00 00       	call   5ec <read>
 3d2:	83 c4 10             	add    $0x10,%esp
 3d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 3d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3dc:	7e 33                	jle    411 <gets+0x5e>
      break;
    buf[i++] = c;
 3de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3e1:	8d 50 01             	lea    0x1(%eax),%edx
 3e4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3e7:	89 c2                	mov    %eax,%edx
 3e9:	8b 45 08             	mov    0x8(%ebp),%eax
 3ec:	01 c2                	add    %eax,%edx
 3ee:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3f2:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 3f4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3f8:	3c 0a                	cmp    $0xa,%al
 3fa:	74 16                	je     412 <gets+0x5f>
 3fc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 400:	3c 0d                	cmp    $0xd,%al
 402:	74 0e                	je     412 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 404:	8b 45 f4             	mov    -0xc(%ebp),%eax
 407:	83 c0 01             	add    $0x1,%eax
 40a:	3b 45 0c             	cmp    0xc(%ebp),%eax
 40d:	7c b3                	jl     3c2 <gets+0xf>
 40f:	eb 01                	jmp    412 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 411:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 412:	8b 55 f4             	mov    -0xc(%ebp),%edx
 415:	8b 45 08             	mov    0x8(%ebp),%eax
 418:	01 d0                	add    %edx,%eax
 41a:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 41d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 420:	c9                   	leave  
 421:	c3                   	ret    

00000422 <stat>:

int
stat(char *n, struct stat *st)
{
 422:	55                   	push   %ebp
 423:	89 e5                	mov    %esp,%ebp
 425:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 428:	83 ec 08             	sub    $0x8,%esp
 42b:	6a 00                	push   $0x0
 42d:	ff 75 08             	pushl  0x8(%ebp)
 430:	e8 df 01 00 00       	call   614 <open>
 435:	83 c4 10             	add    $0x10,%esp
 438:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 43b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 43f:	79 07                	jns    448 <stat+0x26>
    return -1;
 441:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 446:	eb 25                	jmp    46d <stat+0x4b>
  r = fstat(fd, st);
 448:	83 ec 08             	sub    $0x8,%esp
 44b:	ff 75 0c             	pushl  0xc(%ebp)
 44e:	ff 75 f4             	pushl  -0xc(%ebp)
 451:	e8 d6 01 00 00       	call   62c <fstat>
 456:	83 c4 10             	add    $0x10,%esp
 459:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 45c:	83 ec 0c             	sub    $0xc,%esp
 45f:	ff 75 f4             	pushl  -0xc(%ebp)
 462:	e8 95 01 00 00       	call   5fc <close>
 467:	83 c4 10             	add    $0x10,%esp
  return r;
 46a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 46d:	c9                   	leave  
 46e:	c3                   	ret    

0000046f <atoi>:

int
atoi(const char *s)
{
 46f:	55                   	push   %ebp
 470:	89 e5                	mov    %esp,%ebp
 472:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 475:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 47c:	eb 04                	jmp    482 <atoi+0x13>
 47e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 482:	8b 45 08             	mov    0x8(%ebp),%eax
 485:	0f b6 00             	movzbl (%eax),%eax
 488:	3c 20                	cmp    $0x20,%al
 48a:	74 f2                	je     47e <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 48c:	8b 45 08             	mov    0x8(%ebp),%eax
 48f:	0f b6 00             	movzbl (%eax),%eax
 492:	3c 2d                	cmp    $0x2d,%al
 494:	75 07                	jne    49d <atoi+0x2e>
 496:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 49b:	eb 05                	jmp    4a2 <atoi+0x33>
 49d:	b8 01 00 00 00       	mov    $0x1,%eax
 4a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 4a5:	8b 45 08             	mov    0x8(%ebp),%eax
 4a8:	0f b6 00             	movzbl (%eax),%eax
 4ab:	3c 2b                	cmp    $0x2b,%al
 4ad:	74 0a                	je     4b9 <atoi+0x4a>
 4af:	8b 45 08             	mov    0x8(%ebp),%eax
 4b2:	0f b6 00             	movzbl (%eax),%eax
 4b5:	3c 2d                	cmp    $0x2d,%al
 4b7:	75 2b                	jne    4e4 <atoi+0x75>
    s++;
 4b9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 4bd:	eb 25                	jmp    4e4 <atoi+0x75>
    n = n*10 + *s++ - '0';
 4bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4c2:	89 d0                	mov    %edx,%eax
 4c4:	c1 e0 02             	shl    $0x2,%eax
 4c7:	01 d0                	add    %edx,%eax
 4c9:	01 c0                	add    %eax,%eax
 4cb:	89 c1                	mov    %eax,%ecx
 4cd:	8b 45 08             	mov    0x8(%ebp),%eax
 4d0:	8d 50 01             	lea    0x1(%eax),%edx
 4d3:	89 55 08             	mov    %edx,0x8(%ebp)
 4d6:	0f b6 00             	movzbl (%eax),%eax
 4d9:	0f be c0             	movsbl %al,%eax
 4dc:	01 c8                	add    %ecx,%eax
 4de:	83 e8 30             	sub    $0x30,%eax
 4e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 4e4:	8b 45 08             	mov    0x8(%ebp),%eax
 4e7:	0f b6 00             	movzbl (%eax),%eax
 4ea:	3c 2f                	cmp    $0x2f,%al
 4ec:	7e 0a                	jle    4f8 <atoi+0x89>
 4ee:	8b 45 08             	mov    0x8(%ebp),%eax
 4f1:	0f b6 00             	movzbl (%eax),%eax
 4f4:	3c 39                	cmp    $0x39,%al
 4f6:	7e c7                	jle    4bf <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 4f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4fb:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 4ff:	c9                   	leave  
 500:	c3                   	ret    

00000501 <atoo>:

int
atoo(const char *s)
{
 501:	55                   	push   %ebp
 502:	89 e5                	mov    %esp,%ebp
 504:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 507:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 50e:	eb 04                	jmp    514 <atoo+0x13>
 510:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 514:	8b 45 08             	mov    0x8(%ebp),%eax
 517:	0f b6 00             	movzbl (%eax),%eax
 51a:	3c 20                	cmp    $0x20,%al
 51c:	74 f2                	je     510 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 51e:	8b 45 08             	mov    0x8(%ebp),%eax
 521:	0f b6 00             	movzbl (%eax),%eax
 524:	3c 2d                	cmp    $0x2d,%al
 526:	75 07                	jne    52f <atoo+0x2e>
 528:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 52d:	eb 05                	jmp    534 <atoo+0x33>
 52f:	b8 01 00 00 00       	mov    $0x1,%eax
 534:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 537:	8b 45 08             	mov    0x8(%ebp),%eax
 53a:	0f b6 00             	movzbl (%eax),%eax
 53d:	3c 2b                	cmp    $0x2b,%al
 53f:	74 0a                	je     54b <atoo+0x4a>
 541:	8b 45 08             	mov    0x8(%ebp),%eax
 544:	0f b6 00             	movzbl (%eax),%eax
 547:	3c 2d                	cmp    $0x2d,%al
 549:	75 27                	jne    572 <atoo+0x71>
    s++;
 54b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 54f:	eb 21                	jmp    572 <atoo+0x71>
    n = n*8 + *s++ - '0';
 551:	8b 45 fc             	mov    -0x4(%ebp),%eax
 554:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 55b:	8b 45 08             	mov    0x8(%ebp),%eax
 55e:	8d 50 01             	lea    0x1(%eax),%edx
 561:	89 55 08             	mov    %edx,0x8(%ebp)
 564:	0f b6 00             	movzbl (%eax),%eax
 567:	0f be c0             	movsbl %al,%eax
 56a:	01 c8                	add    %ecx,%eax
 56c:	83 e8 30             	sub    $0x30,%eax
 56f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 572:	8b 45 08             	mov    0x8(%ebp),%eax
 575:	0f b6 00             	movzbl (%eax),%eax
 578:	3c 2f                	cmp    $0x2f,%al
 57a:	7e 0a                	jle    586 <atoo+0x85>
 57c:	8b 45 08             	mov    0x8(%ebp),%eax
 57f:	0f b6 00             	movzbl (%eax),%eax
 582:	3c 37                	cmp    $0x37,%al
 584:	7e cb                	jle    551 <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 586:	8b 45 f8             	mov    -0x8(%ebp),%eax
 589:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 58d:	c9                   	leave  
 58e:	c3                   	ret    

0000058f <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 58f:	55                   	push   %ebp
 590:	89 e5                	mov    %esp,%ebp
 592:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 595:	8b 45 08             	mov    0x8(%ebp),%eax
 598:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 59b:	8b 45 0c             	mov    0xc(%ebp),%eax
 59e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 5a1:	eb 17                	jmp    5ba <memmove+0x2b>
    *dst++ = *src++;
 5a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5a6:	8d 50 01             	lea    0x1(%eax),%edx
 5a9:	89 55 fc             	mov    %edx,-0x4(%ebp)
 5ac:	8b 55 f8             	mov    -0x8(%ebp),%edx
 5af:	8d 4a 01             	lea    0x1(%edx),%ecx
 5b2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 5b5:	0f b6 12             	movzbl (%edx),%edx
 5b8:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5ba:	8b 45 10             	mov    0x10(%ebp),%eax
 5bd:	8d 50 ff             	lea    -0x1(%eax),%edx
 5c0:	89 55 10             	mov    %edx,0x10(%ebp)
 5c3:	85 c0                	test   %eax,%eax
 5c5:	7f dc                	jg     5a3 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 5c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5ca:	c9                   	leave  
 5cb:	c3                   	ret    

000005cc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5cc:	b8 01 00 00 00       	mov    $0x1,%eax
 5d1:	cd 40                	int    $0x40
 5d3:	c3                   	ret    

000005d4 <exit>:
SYSCALL(exit)
 5d4:	b8 02 00 00 00       	mov    $0x2,%eax
 5d9:	cd 40                	int    $0x40
 5db:	c3                   	ret    

000005dc <wait>:
SYSCALL(wait)
 5dc:	b8 03 00 00 00       	mov    $0x3,%eax
 5e1:	cd 40                	int    $0x40
 5e3:	c3                   	ret    

000005e4 <pipe>:
SYSCALL(pipe)
 5e4:	b8 04 00 00 00       	mov    $0x4,%eax
 5e9:	cd 40                	int    $0x40
 5eb:	c3                   	ret    

000005ec <read>:
SYSCALL(read)
 5ec:	b8 05 00 00 00       	mov    $0x5,%eax
 5f1:	cd 40                	int    $0x40
 5f3:	c3                   	ret    

000005f4 <write>:
SYSCALL(write)
 5f4:	b8 10 00 00 00       	mov    $0x10,%eax
 5f9:	cd 40                	int    $0x40
 5fb:	c3                   	ret    

000005fc <close>:
SYSCALL(close)
 5fc:	b8 15 00 00 00       	mov    $0x15,%eax
 601:	cd 40                	int    $0x40
 603:	c3                   	ret    

00000604 <kill>:
SYSCALL(kill)
 604:	b8 06 00 00 00       	mov    $0x6,%eax
 609:	cd 40                	int    $0x40
 60b:	c3                   	ret    

0000060c <exec>:
SYSCALL(exec)
 60c:	b8 07 00 00 00       	mov    $0x7,%eax
 611:	cd 40                	int    $0x40
 613:	c3                   	ret    

00000614 <open>:
SYSCALL(open)
 614:	b8 0f 00 00 00       	mov    $0xf,%eax
 619:	cd 40                	int    $0x40
 61b:	c3                   	ret    

0000061c <mknod>:
SYSCALL(mknod)
 61c:	b8 11 00 00 00       	mov    $0x11,%eax
 621:	cd 40                	int    $0x40
 623:	c3                   	ret    

00000624 <unlink>:
SYSCALL(unlink)
 624:	b8 12 00 00 00       	mov    $0x12,%eax
 629:	cd 40                	int    $0x40
 62b:	c3                   	ret    

0000062c <fstat>:
SYSCALL(fstat)
 62c:	b8 08 00 00 00       	mov    $0x8,%eax
 631:	cd 40                	int    $0x40
 633:	c3                   	ret    

00000634 <link>:
SYSCALL(link)
 634:	b8 13 00 00 00       	mov    $0x13,%eax
 639:	cd 40                	int    $0x40
 63b:	c3                   	ret    

0000063c <mkdir>:
SYSCALL(mkdir)
 63c:	b8 14 00 00 00       	mov    $0x14,%eax
 641:	cd 40                	int    $0x40
 643:	c3                   	ret    

00000644 <chdir>:
SYSCALL(chdir)
 644:	b8 09 00 00 00       	mov    $0x9,%eax
 649:	cd 40                	int    $0x40
 64b:	c3                   	ret    

0000064c <dup>:
SYSCALL(dup)
 64c:	b8 0a 00 00 00       	mov    $0xa,%eax
 651:	cd 40                	int    $0x40
 653:	c3                   	ret    

00000654 <getpid>:
SYSCALL(getpid)
 654:	b8 0b 00 00 00       	mov    $0xb,%eax
 659:	cd 40                	int    $0x40
 65b:	c3                   	ret    

0000065c <sbrk>:
SYSCALL(sbrk)
 65c:	b8 0c 00 00 00       	mov    $0xc,%eax
 661:	cd 40                	int    $0x40
 663:	c3                   	ret    

00000664 <sleep>:
SYSCALL(sleep)
 664:	b8 0d 00 00 00       	mov    $0xd,%eax
 669:	cd 40                	int    $0x40
 66b:	c3                   	ret    

0000066c <uptime>:
SYSCALL(uptime)
 66c:	b8 0e 00 00 00       	mov    $0xe,%eax
 671:	cd 40                	int    $0x40
 673:	c3                   	ret    

00000674 <halt>:
SYSCALL(halt)
 674:	b8 16 00 00 00       	mov    $0x16,%eax
 679:	cd 40                	int    $0x40
 67b:	c3                   	ret    

0000067c <date>:
SYSCALL(date)
 67c:	b8 17 00 00 00       	mov    $0x17,%eax
 681:	cd 40                	int    $0x40
 683:	c3                   	ret    

00000684 <getuid>:
SYSCALL(getuid)
 684:	b8 18 00 00 00       	mov    $0x18,%eax
 689:	cd 40                	int    $0x40
 68b:	c3                   	ret    

0000068c <getgid>:
SYSCALL(getgid)
 68c:	b8 19 00 00 00       	mov    $0x19,%eax
 691:	cd 40                	int    $0x40
 693:	c3                   	ret    

00000694 <getppid>:
SYSCALL(getppid)
 694:	b8 1a 00 00 00       	mov    $0x1a,%eax
 699:	cd 40                	int    $0x40
 69b:	c3                   	ret    

0000069c <setuid>:
SYSCALL(setuid)
 69c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 6a1:	cd 40                	int    $0x40
 6a3:	c3                   	ret    

000006a4 <setgid>:
SYSCALL(setgid)
 6a4:	b8 1c 00 00 00       	mov    $0x1c,%eax
 6a9:	cd 40                	int    $0x40
 6ab:	c3                   	ret    

000006ac <getprocs>:
SYSCALL(getprocs)
 6ac:	b8 1d 00 00 00       	mov    $0x1d,%eax
 6b1:	cd 40                	int    $0x40
 6b3:	c3                   	ret    

000006b4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 6b4:	55                   	push   %ebp
 6b5:	89 e5                	mov    %esp,%ebp
 6b7:	83 ec 18             	sub    $0x18,%esp
 6ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 6bd:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 6c0:	83 ec 04             	sub    $0x4,%esp
 6c3:	6a 01                	push   $0x1
 6c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 6c8:	50                   	push   %eax
 6c9:	ff 75 08             	pushl  0x8(%ebp)
 6cc:	e8 23 ff ff ff       	call   5f4 <write>
 6d1:	83 c4 10             	add    $0x10,%esp
}
 6d4:	90                   	nop
 6d5:	c9                   	leave  
 6d6:	c3                   	ret    

000006d7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6d7:	55                   	push   %ebp
 6d8:	89 e5                	mov    %esp,%ebp
 6da:	53                   	push   %ebx
 6db:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 6de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 6e5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 6e9:	74 17                	je     702 <printint+0x2b>
 6eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6ef:	79 11                	jns    702 <printint+0x2b>
    neg = 1;
 6f1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 6f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 6fb:	f7 d8                	neg    %eax
 6fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 700:	eb 06                	jmp    708 <printint+0x31>
  } else {
    x = xx;
 702:	8b 45 0c             	mov    0xc(%ebp),%eax
 705:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 708:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 70f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 712:	8d 41 01             	lea    0x1(%ecx),%eax
 715:	89 45 f4             	mov    %eax,-0xc(%ebp)
 718:	8b 5d 10             	mov    0x10(%ebp),%ebx
 71b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 71e:	ba 00 00 00 00       	mov    $0x0,%edx
 723:	f7 f3                	div    %ebx
 725:	89 d0                	mov    %edx,%eax
 727:	0f b6 80 8c 0e 00 00 	movzbl 0xe8c(%eax),%eax
 72e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 732:	8b 5d 10             	mov    0x10(%ebp),%ebx
 735:	8b 45 ec             	mov    -0x14(%ebp),%eax
 738:	ba 00 00 00 00       	mov    $0x0,%edx
 73d:	f7 f3                	div    %ebx
 73f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 742:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 746:	75 c7                	jne    70f <printint+0x38>
  if(neg)
 748:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74c:	74 2d                	je     77b <printint+0xa4>
    buf[i++] = '-';
 74e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 751:	8d 50 01             	lea    0x1(%eax),%edx
 754:	89 55 f4             	mov    %edx,-0xc(%ebp)
 757:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 75c:	eb 1d                	jmp    77b <printint+0xa4>
    putc(fd, buf[i]);
 75e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 761:	8b 45 f4             	mov    -0xc(%ebp),%eax
 764:	01 d0                	add    %edx,%eax
 766:	0f b6 00             	movzbl (%eax),%eax
 769:	0f be c0             	movsbl %al,%eax
 76c:	83 ec 08             	sub    $0x8,%esp
 76f:	50                   	push   %eax
 770:	ff 75 08             	pushl  0x8(%ebp)
 773:	e8 3c ff ff ff       	call   6b4 <putc>
 778:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 77b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 77f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 783:	79 d9                	jns    75e <printint+0x87>
    putc(fd, buf[i]);
}
 785:	90                   	nop
 786:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 789:	c9                   	leave  
 78a:	c3                   	ret    

0000078b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 78b:	55                   	push   %ebp
 78c:	89 e5                	mov    %esp,%ebp
 78e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 791:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 798:	8d 45 0c             	lea    0xc(%ebp),%eax
 79b:	83 c0 04             	add    $0x4,%eax
 79e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 7a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 7a8:	e9 59 01 00 00       	jmp    906 <printf+0x17b>
    c = fmt[i] & 0xff;
 7ad:	8b 55 0c             	mov    0xc(%ebp),%edx
 7b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b3:	01 d0                	add    %edx,%eax
 7b5:	0f b6 00             	movzbl (%eax),%eax
 7b8:	0f be c0             	movsbl %al,%eax
 7bb:	25 ff 00 00 00       	and    $0xff,%eax
 7c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 7c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7c7:	75 2c                	jne    7f5 <printf+0x6a>
      if(c == '%'){
 7c9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7cd:	75 0c                	jne    7db <printf+0x50>
        state = '%';
 7cf:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 7d6:	e9 27 01 00 00       	jmp    902 <printf+0x177>
      } else {
        putc(fd, c);
 7db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7de:	0f be c0             	movsbl %al,%eax
 7e1:	83 ec 08             	sub    $0x8,%esp
 7e4:	50                   	push   %eax
 7e5:	ff 75 08             	pushl  0x8(%ebp)
 7e8:	e8 c7 fe ff ff       	call   6b4 <putc>
 7ed:	83 c4 10             	add    $0x10,%esp
 7f0:	e9 0d 01 00 00       	jmp    902 <printf+0x177>
      }
    } else if(state == '%'){
 7f5:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 7f9:	0f 85 03 01 00 00    	jne    902 <printf+0x177>
      if(c == 'd'){
 7ff:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 803:	75 1e                	jne    823 <printf+0x98>
        printint(fd, *ap, 10, 1);
 805:	8b 45 e8             	mov    -0x18(%ebp),%eax
 808:	8b 00                	mov    (%eax),%eax
 80a:	6a 01                	push   $0x1
 80c:	6a 0a                	push   $0xa
 80e:	50                   	push   %eax
 80f:	ff 75 08             	pushl  0x8(%ebp)
 812:	e8 c0 fe ff ff       	call   6d7 <printint>
 817:	83 c4 10             	add    $0x10,%esp
        ap++;
 81a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 81e:	e9 d8 00 00 00       	jmp    8fb <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 823:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 827:	74 06                	je     82f <printf+0xa4>
 829:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 82d:	75 1e                	jne    84d <printf+0xc2>
        printint(fd, *ap, 16, 0);
 82f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 832:	8b 00                	mov    (%eax),%eax
 834:	6a 00                	push   $0x0
 836:	6a 10                	push   $0x10
 838:	50                   	push   %eax
 839:	ff 75 08             	pushl  0x8(%ebp)
 83c:	e8 96 fe ff ff       	call   6d7 <printint>
 841:	83 c4 10             	add    $0x10,%esp
        ap++;
 844:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 848:	e9 ae 00 00 00       	jmp    8fb <printf+0x170>
      } else if(c == 's'){
 84d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 851:	75 43                	jne    896 <printf+0x10b>
        s = (char*)*ap;
 853:	8b 45 e8             	mov    -0x18(%ebp),%eax
 856:	8b 00                	mov    (%eax),%eax
 858:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 85b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 85f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 863:	75 25                	jne    88a <printf+0xff>
          s = "(null)";
 865:	c7 45 f4 f1 0b 00 00 	movl   $0xbf1,-0xc(%ebp)
        while(*s != 0){
 86c:	eb 1c                	jmp    88a <printf+0xff>
          putc(fd, *s);
 86e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 871:	0f b6 00             	movzbl (%eax),%eax
 874:	0f be c0             	movsbl %al,%eax
 877:	83 ec 08             	sub    $0x8,%esp
 87a:	50                   	push   %eax
 87b:	ff 75 08             	pushl  0x8(%ebp)
 87e:	e8 31 fe ff ff       	call   6b4 <putc>
 883:	83 c4 10             	add    $0x10,%esp
          s++;
 886:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 88a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88d:	0f b6 00             	movzbl (%eax),%eax
 890:	84 c0                	test   %al,%al
 892:	75 da                	jne    86e <printf+0xe3>
 894:	eb 65                	jmp    8fb <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 896:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 89a:	75 1d                	jne    8b9 <printf+0x12e>
        putc(fd, *ap);
 89c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 89f:	8b 00                	mov    (%eax),%eax
 8a1:	0f be c0             	movsbl %al,%eax
 8a4:	83 ec 08             	sub    $0x8,%esp
 8a7:	50                   	push   %eax
 8a8:	ff 75 08             	pushl  0x8(%ebp)
 8ab:	e8 04 fe ff ff       	call   6b4 <putc>
 8b0:	83 c4 10             	add    $0x10,%esp
        ap++;
 8b3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8b7:	eb 42                	jmp    8fb <printf+0x170>
      } else if(c == '%'){
 8b9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8bd:	75 17                	jne    8d6 <printf+0x14b>
        putc(fd, c);
 8bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8c2:	0f be c0             	movsbl %al,%eax
 8c5:	83 ec 08             	sub    $0x8,%esp
 8c8:	50                   	push   %eax
 8c9:	ff 75 08             	pushl  0x8(%ebp)
 8cc:	e8 e3 fd ff ff       	call   6b4 <putc>
 8d1:	83 c4 10             	add    $0x10,%esp
 8d4:	eb 25                	jmp    8fb <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 8d6:	83 ec 08             	sub    $0x8,%esp
 8d9:	6a 25                	push   $0x25
 8db:	ff 75 08             	pushl  0x8(%ebp)
 8de:	e8 d1 fd ff ff       	call   6b4 <putc>
 8e3:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 8e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8e9:	0f be c0             	movsbl %al,%eax
 8ec:	83 ec 08             	sub    $0x8,%esp
 8ef:	50                   	push   %eax
 8f0:	ff 75 08             	pushl  0x8(%ebp)
 8f3:	e8 bc fd ff ff       	call   6b4 <putc>
 8f8:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 8fb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 902:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 906:	8b 55 0c             	mov    0xc(%ebp),%edx
 909:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90c:	01 d0                	add    %edx,%eax
 90e:	0f b6 00             	movzbl (%eax),%eax
 911:	84 c0                	test   %al,%al
 913:	0f 85 94 fe ff ff    	jne    7ad <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 919:	90                   	nop
 91a:	c9                   	leave  
 91b:	c3                   	ret    

0000091c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 91c:	55                   	push   %ebp
 91d:	89 e5                	mov    %esp,%ebp
 91f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 922:	8b 45 08             	mov    0x8(%ebp),%eax
 925:	83 e8 08             	sub    $0x8,%eax
 928:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 92b:	a1 a8 0e 00 00       	mov    0xea8,%eax
 930:	89 45 fc             	mov    %eax,-0x4(%ebp)
 933:	eb 24                	jmp    959 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 935:	8b 45 fc             	mov    -0x4(%ebp),%eax
 938:	8b 00                	mov    (%eax),%eax
 93a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 93d:	77 12                	ja     951 <free+0x35>
 93f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 942:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 945:	77 24                	ja     96b <free+0x4f>
 947:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94a:	8b 00                	mov    (%eax),%eax
 94c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 94f:	77 1a                	ja     96b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 951:	8b 45 fc             	mov    -0x4(%ebp),%eax
 954:	8b 00                	mov    (%eax),%eax
 956:	89 45 fc             	mov    %eax,-0x4(%ebp)
 959:	8b 45 f8             	mov    -0x8(%ebp),%eax
 95c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 95f:	76 d4                	jbe    935 <free+0x19>
 961:	8b 45 fc             	mov    -0x4(%ebp),%eax
 964:	8b 00                	mov    (%eax),%eax
 966:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 969:	76 ca                	jbe    935 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 96b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96e:	8b 40 04             	mov    0x4(%eax),%eax
 971:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 978:	8b 45 f8             	mov    -0x8(%ebp),%eax
 97b:	01 c2                	add    %eax,%edx
 97d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 980:	8b 00                	mov    (%eax),%eax
 982:	39 c2                	cmp    %eax,%edx
 984:	75 24                	jne    9aa <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 986:	8b 45 f8             	mov    -0x8(%ebp),%eax
 989:	8b 50 04             	mov    0x4(%eax),%edx
 98c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98f:	8b 00                	mov    (%eax),%eax
 991:	8b 40 04             	mov    0x4(%eax),%eax
 994:	01 c2                	add    %eax,%edx
 996:	8b 45 f8             	mov    -0x8(%ebp),%eax
 999:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 99c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 99f:	8b 00                	mov    (%eax),%eax
 9a1:	8b 10                	mov    (%eax),%edx
 9a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9a6:	89 10                	mov    %edx,(%eax)
 9a8:	eb 0a                	jmp    9b4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 9aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ad:	8b 10                	mov    (%eax),%edx
 9af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9b2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 9b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b7:	8b 40 04             	mov    0x4(%eax),%eax
 9ba:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c4:	01 d0                	add    %edx,%eax
 9c6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9c9:	75 20                	jne    9eb <free+0xcf>
    p->s.size += bp->s.size;
 9cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ce:	8b 50 04             	mov    0x4(%eax),%edx
 9d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d4:	8b 40 04             	mov    0x4(%eax),%eax
 9d7:	01 c2                	add    %eax,%edx
 9d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9dc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e2:	8b 10                	mov    (%eax),%edx
 9e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e7:	89 10                	mov    %edx,(%eax)
 9e9:	eb 08                	jmp    9f3 <free+0xd7>
  } else
    p->s.ptr = bp;
 9eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9ee:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9f1:	89 10                	mov    %edx,(%eax)
  freep = p;
 9f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f6:	a3 a8 0e 00 00       	mov    %eax,0xea8
}
 9fb:	90                   	nop
 9fc:	c9                   	leave  
 9fd:	c3                   	ret    

000009fe <morecore>:

static Header*
morecore(uint nu)
{
 9fe:	55                   	push   %ebp
 9ff:	89 e5                	mov    %esp,%ebp
 a01:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a04:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a0b:	77 07                	ja     a14 <morecore+0x16>
    nu = 4096;
 a0d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a14:	8b 45 08             	mov    0x8(%ebp),%eax
 a17:	c1 e0 03             	shl    $0x3,%eax
 a1a:	83 ec 0c             	sub    $0xc,%esp
 a1d:	50                   	push   %eax
 a1e:	e8 39 fc ff ff       	call   65c <sbrk>
 a23:	83 c4 10             	add    $0x10,%esp
 a26:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a29:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a2d:	75 07                	jne    a36 <morecore+0x38>
    return 0;
 a2f:	b8 00 00 00 00       	mov    $0x0,%eax
 a34:	eb 26                	jmp    a5c <morecore+0x5e>
  hp = (Header*)p;
 a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a3f:	8b 55 08             	mov    0x8(%ebp),%edx
 a42:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a48:	83 c0 08             	add    $0x8,%eax
 a4b:	83 ec 0c             	sub    $0xc,%esp
 a4e:	50                   	push   %eax
 a4f:	e8 c8 fe ff ff       	call   91c <free>
 a54:	83 c4 10             	add    $0x10,%esp
  return freep;
 a57:	a1 a8 0e 00 00       	mov    0xea8,%eax
}
 a5c:	c9                   	leave  
 a5d:	c3                   	ret    

00000a5e <malloc>:

void*
malloc(uint nbytes)
{
 a5e:	55                   	push   %ebp
 a5f:	89 e5                	mov    %esp,%ebp
 a61:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a64:	8b 45 08             	mov    0x8(%ebp),%eax
 a67:	83 c0 07             	add    $0x7,%eax
 a6a:	c1 e8 03             	shr    $0x3,%eax
 a6d:	83 c0 01             	add    $0x1,%eax
 a70:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a73:	a1 a8 0e 00 00       	mov    0xea8,%eax
 a78:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a7f:	75 23                	jne    aa4 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a81:	c7 45 f0 a0 0e 00 00 	movl   $0xea0,-0x10(%ebp)
 a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a8b:	a3 a8 0e 00 00       	mov    %eax,0xea8
 a90:	a1 a8 0e 00 00       	mov    0xea8,%eax
 a95:	a3 a0 0e 00 00       	mov    %eax,0xea0
    base.s.size = 0;
 a9a:	c7 05 a4 0e 00 00 00 	movl   $0x0,0xea4
 aa1:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa7:	8b 00                	mov    (%eax),%eax
 aa9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aaf:	8b 40 04             	mov    0x4(%eax),%eax
 ab2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ab5:	72 4d                	jb     b04 <malloc+0xa6>
      if(p->s.size == nunits)
 ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aba:	8b 40 04             	mov    0x4(%eax),%eax
 abd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ac0:	75 0c                	jne    ace <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac5:	8b 10                	mov    (%eax),%edx
 ac7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aca:	89 10                	mov    %edx,(%eax)
 acc:	eb 26                	jmp    af4 <malloc+0x96>
      else {
        p->s.size -= nunits;
 ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad1:	8b 40 04             	mov    0x4(%eax),%eax
 ad4:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ad7:	89 c2                	mov    %eax,%edx
 ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 adc:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae2:	8b 40 04             	mov    0x4(%eax),%eax
 ae5:	c1 e0 03             	shl    $0x3,%eax
 ae8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aee:	8b 55 ec             	mov    -0x14(%ebp),%edx
 af1:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 af7:	a3 a8 0e 00 00       	mov    %eax,0xea8
      return (void*)(p + 1);
 afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aff:	83 c0 08             	add    $0x8,%eax
 b02:	eb 3b                	jmp    b3f <malloc+0xe1>
    }
    if(p == freep)
 b04:	a1 a8 0e 00 00       	mov    0xea8,%eax
 b09:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b0c:	75 1e                	jne    b2c <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b0e:	83 ec 0c             	sub    $0xc,%esp
 b11:	ff 75 ec             	pushl  -0x14(%ebp)
 b14:	e8 e5 fe ff ff       	call   9fe <morecore>
 b19:	83 c4 10             	add    $0x10,%esp
 b1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b23:	75 07                	jne    b2c <malloc+0xce>
        return 0;
 b25:	b8 00 00 00 00       	mov    $0x0,%eax
 b2a:	eb 13                	jmp    b3f <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b35:	8b 00                	mov    (%eax),%eax
 b37:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 b3a:	e9 6d ff ff ff       	jmp    aac <malloc+0x4e>
}
 b3f:	c9                   	leave  
 b40:	c3                   	ret    
