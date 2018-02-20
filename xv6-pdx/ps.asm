
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <elapsed>:
#include "user.h"
#include "uproc.h"

void
elapsed(uint e)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
    uint elapsed, whole_sec, milisec_ten, milisec_hund, milisec_thou;
    elapsed = e; // find original elapsed time
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
    milisec_thou = (elapsed %= 10); // determine thousandth place
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
  af:	68 ac 0b 00 00       	push   $0xbac
  b4:	6a 01                	push   $0x1
  b6:	e8 39 07 00 00       	call   7f4 <printf>
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
  d2:	83 ec 28             	sub    $0x28,%esp
  int max = 32, active_procs = 0;
  d5:	c7 45 e0 20 00 00 00 	movl   $0x20,-0x20(%ebp)
  dc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  struct uproc* utable = (struct uproc*) malloc(max * sizeof(struct uproc));
  e3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  e6:	89 d0                	mov    %edx,%eax
  e8:	01 c0                	add    %eax,%eax
  ea:	01 d0                	add    %edx,%eax
  ec:	c1 e0 05             	shl    $0x5,%eax
  ef:	83 ec 0c             	sub    $0xc,%esp
  f2:	50                   	push   %eax
  f3:	e8 cf 09 00 00       	call   ac7 <malloc>
  f8:	83 c4 10             	add    $0x10,%esp
  fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  // system call -> sysproc.c -> proc.c -> return
  active_procs = getprocs(max, utable); // populate utable
  fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
 101:	83 ec 08             	sub    $0x8,%esp
 104:	ff 75 d8             	pushl  -0x28(%ebp)
 107:	50                   	push   %eax
 108:	e8 08 06 00 00       	call   715 <getprocs>
 10d:	83 c4 10             	add    $0x10,%esp
 110:	89 45 dc             	mov    %eax,-0x24(%ebp)
  // error from sysproc.c - value not pulled from stack
  if (active_procs == -1) {
 113:	83 7d dc ff          	cmpl   $0xffffffff,-0x24(%ebp)
 117:	75 25                	jne    13e <main+0x7d>
      printf(1, "Error in active process table creation.\n");
 119:	83 ec 08             	sub    $0x8,%esp
 11c:	68 b8 0b 00 00       	push   $0xbb8
 121:	6a 01                	push   $0x1
 123:	e8 cc 06 00 00       	call   7f4 <printf>
 128:	83 c4 10             	add    $0x10,%esp
      free(utable);
 12b:	83 ec 0c             	sub    $0xc,%esp
 12e:	ff 75 d8             	pushl  -0x28(%ebp)
 131:	e8 4f 08 00 00       	call   985 <free>
 136:	83 c4 10             	add    $0x10,%esp
      exit();
 139:	e8 ff 04 00 00       	call   63d <exit>
  }
  // no active processes
  else if (active_procs == 0) {
 13e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
 142:	75 25                	jne    169 <main+0xa8>
      printf(1, "No active processes.\n");
 144:	83 ec 08             	sub    $0x8,%esp
 147:	68 e1 0b 00 00       	push   $0xbe1
 14c:	6a 01                	push   $0x1
 14e:	e8 a1 06 00 00       	call   7f4 <printf>
 153:	83 c4 10             	add    $0x10,%esp
      free(utable);
 156:	83 ec 0c             	sub    $0xc,%esp
 159:	ff 75 d8             	pushl  -0x28(%ebp)
 15c:	e8 24 08 00 00       	call   985 <free>
 161:	83 c4 10             	add    $0x10,%esp
      exit();
 164:	e8 d4 04 00 00       	call   63d <exit>
          printf(1, "\t%s\t%d", utable[i].state, utable[i].size);
      }
      printf(1, "\n");
  }
#else
  else if (active_procs > 0) {
 169:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
 16d:	0f 8e 8d 01 00 00    	jle    300 <main+0x23f>
      printf(1, "\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s",
 173:	68 f7 0b 00 00       	push   $0xbf7
 178:	68 fc 0b 00 00       	push   $0xbfc
 17d:	68 02 0c 00 00       	push   $0xc02
 182:	68 06 0c 00 00       	push   $0xc06
 187:	68 0e 0c 00 00       	push   $0xc0e
 18c:	68 13 0c 00 00       	push   $0xc13
 191:	68 18 0c 00 00       	push   $0xc18
 196:	68 1c 0c 00 00       	push   $0xc1c
 19b:	68 20 0c 00 00       	push   $0xc20
 1a0:	68 25 0c 00 00       	push   $0xc25
 1a5:	68 2c 0c 00 00       	push   $0xc2c
 1aa:	6a 01                	push   $0x1
 1ac:	e8 43 06 00 00       	call   7f4 <printf>
 1b1:	83 c4 30             	add    $0x30,%esp
              "PID", "Name", "UID", "GID", "PPID", "Prio", "Elapsed", "CPU", "State", "Size");
      for (int i = 0; i < active_procs; ++i) {
 1b4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 1bb:	e9 22 01 00 00       	jmp    2e2 <main+0x221>
          printf(1, "\n%d\t%s\t%d\t%d\t%d\t%d",
                  utable[i].pid, utable[i].name, utable[i].uid, utable[i].gid, utable[i].ppid, utable[i].priority);
 1c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 1c3:	89 d0                	mov    %edx,%eax
 1c5:	01 c0                	add    %eax,%eax
 1c7:	01 d0                	add    %edx,%eax
 1c9:	c1 e0 05             	shl    $0x5,%eax
 1cc:	89 c2                	mov    %eax,%edx
 1ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
 1d1:	01 d0                	add    %edx,%eax
#else
  else if (active_procs > 0) {
      printf(1, "\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s",
              "PID", "Name", "UID", "GID", "PPID", "Prio", "Elapsed", "CPU", "State", "Size");
      for (int i = 0; i < active_procs; ++i) {
          printf(1, "\n%d\t%s\t%d\t%d\t%d\t%d",
 1d3:	8b 78 5c             	mov    0x5c(%eax),%edi
                  utable[i].pid, utable[i].name, utable[i].uid, utable[i].gid, utable[i].ppid, utable[i].priority);
 1d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 1d9:	89 d0                	mov    %edx,%eax
 1db:	01 c0                	add    %eax,%eax
 1dd:	01 d0                	add    %edx,%eax
 1df:	c1 e0 05             	shl    $0x5,%eax
 1e2:	89 c2                	mov    %eax,%edx
 1e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
 1e7:	01 d0                	add    %edx,%eax
#else
  else if (active_procs > 0) {
      printf(1, "\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s",
              "PID", "Name", "UID", "GID", "PPID", "Prio", "Elapsed", "CPU", "State", "Size");
      for (int i = 0; i < active_procs; ++i) {
          printf(1, "\n%d\t%s\t%d\t%d\t%d\t%d",
 1e9:	8b 70 0c             	mov    0xc(%eax),%esi
                  utable[i].pid, utable[i].name, utable[i].uid, utable[i].gid, utable[i].ppid, utable[i].priority);
 1ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 1ef:	89 d0                	mov    %edx,%eax
 1f1:	01 c0                	add    %eax,%eax
 1f3:	01 d0                	add    %edx,%eax
 1f5:	c1 e0 05             	shl    $0x5,%eax
 1f8:	89 c2                	mov    %eax,%edx
 1fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
 1fd:	01 d0                	add    %edx,%eax
#else
  else if (active_procs > 0) {
      printf(1, "\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s",
              "PID", "Name", "UID", "GID", "PPID", "Prio", "Elapsed", "CPU", "State", "Size");
      for (int i = 0; i < active_procs; ++i) {
          printf(1, "\n%d\t%s\t%d\t%d\t%d\t%d",
 1ff:	8b 58 08             	mov    0x8(%eax),%ebx
                  utable[i].pid, utable[i].name, utable[i].uid, utable[i].gid, utable[i].ppid, utable[i].priority);
 202:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 205:	89 d0                	mov    %edx,%eax
 207:	01 c0                	add    %eax,%eax
 209:	01 d0                	add    %edx,%eax
 20b:	c1 e0 05             	shl    $0x5,%eax
 20e:	89 c2                	mov    %eax,%edx
 210:	8b 45 d8             	mov    -0x28(%ebp),%eax
 213:	01 d0                	add    %edx,%eax
#else
  else if (active_procs > 0) {
      printf(1, "\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s",
              "PID", "Name", "UID", "GID", "PPID", "Prio", "Elapsed", "CPU", "State", "Size");
      for (int i = 0; i < active_procs; ++i) {
          printf(1, "\n%d\t%s\t%d\t%d\t%d\t%d",
 215:	8b 48 04             	mov    0x4(%eax),%ecx
                  utable[i].pid, utable[i].name, utable[i].uid, utable[i].gid, utable[i].ppid, utable[i].priority);
 218:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 21b:	89 d0                	mov    %edx,%eax
 21d:	01 c0                	add    %eax,%eax
 21f:	01 d0                	add    %edx,%eax
 221:	c1 e0 05             	shl    $0x5,%eax
 224:	89 c2                	mov    %eax,%edx
 226:	8b 45 d8             	mov    -0x28(%ebp),%eax
 229:	01 d0                	add    %edx,%eax
 22b:	83 c0 3c             	add    $0x3c,%eax
 22e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 231:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 234:	89 d0                	mov    %edx,%eax
 236:	01 c0                	add    %eax,%eax
 238:	01 d0                	add    %edx,%eax
 23a:	c1 e0 05             	shl    $0x5,%eax
 23d:	89 c2                	mov    %eax,%edx
 23f:	8b 45 d8             	mov    -0x28(%ebp),%eax
 242:	01 d0                	add    %edx,%eax
#else
  else if (active_procs > 0) {
      printf(1, "\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s",
              "PID", "Name", "UID", "GID", "PPID", "Prio", "Elapsed", "CPU", "State", "Size");
      for (int i = 0; i < active_procs; ++i) {
          printf(1, "\n%d\t%s\t%d\t%d\t%d\t%d",
 244:	8b 00                	mov    (%eax),%eax
 246:	57                   	push   %edi
 247:	56                   	push   %esi
 248:	53                   	push   %ebx
 249:	51                   	push   %ecx
 24a:	ff 75 d4             	pushl  -0x2c(%ebp)
 24d:	50                   	push   %eax
 24e:	68 4b 0c 00 00       	push   $0xc4b
 253:	6a 01                	push   $0x1
 255:	e8 9a 05 00 00       	call   7f4 <printf>
 25a:	83 c4 20             	add    $0x20,%esp
                  utable[i].pid, utable[i].name, utable[i].uid, utable[i].gid, utable[i].ppid, utable[i].priority);
          elapsed(utable[i].elapsed_ticks);
 25d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 260:	89 d0                	mov    %edx,%eax
 262:	01 c0                	add    %eax,%eax
 264:	01 d0                	add    %edx,%eax
 266:	c1 e0 05             	shl    $0x5,%eax
 269:	89 c2                	mov    %eax,%edx
 26b:	8b 45 d8             	mov    -0x28(%ebp),%eax
 26e:	01 d0                	add    %edx,%eax
 270:	8b 40 10             	mov    0x10(%eax),%eax
 273:	83 ec 0c             	sub    $0xc,%esp
 276:	50                   	push   %eax
 277:	e8 84 fd ff ff       	call   0 <elapsed>
 27c:	83 c4 10             	add    $0x10,%esp
          elapsed(utable[i].CPU_total_ticks);
 27f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 282:	89 d0                	mov    %edx,%eax
 284:	01 c0                	add    %eax,%eax
 286:	01 d0                	add    %edx,%eax
 288:	c1 e0 05             	shl    $0x5,%eax
 28b:	89 c2                	mov    %eax,%edx
 28d:	8b 45 d8             	mov    -0x28(%ebp),%eax
 290:	01 d0                	add    %edx,%eax
 292:	8b 40 14             	mov    0x14(%eax),%eax
 295:	83 ec 0c             	sub    $0xc,%esp
 298:	50                   	push   %eax
 299:	e8 62 fd ff ff       	call   0 <elapsed>
 29e:	83 c4 10             	add    $0x10,%esp
          printf(1, "\t%s\t%d", utable[i].state, utable[i].size);
 2a1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 2a4:	89 d0                	mov    %edx,%eax
 2a6:	01 c0                	add    %eax,%eax
 2a8:	01 d0                	add    %edx,%eax
 2aa:	c1 e0 05             	shl    $0x5,%eax
 2ad:	89 c2                	mov    %eax,%edx
 2af:	8b 45 d8             	mov    -0x28(%ebp),%eax
 2b2:	01 d0                	add    %edx,%eax
 2b4:	8b 48 38             	mov    0x38(%eax),%ecx
 2b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 2ba:	89 d0                	mov    %edx,%eax
 2bc:	01 c0                	add    %eax,%eax
 2be:	01 d0                	add    %edx,%eax
 2c0:	c1 e0 05             	shl    $0x5,%eax
 2c3:	89 c2                	mov    %eax,%edx
 2c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
 2c8:	01 d0                	add    %edx,%eax
 2ca:	83 c0 18             	add    $0x18,%eax
 2cd:	51                   	push   %ecx
 2ce:	50                   	push   %eax
 2cf:	68 5e 0c 00 00       	push   $0xc5e
 2d4:	6a 01                	push   $0x1
 2d6:	e8 19 05 00 00       	call   7f4 <printf>
 2db:	83 c4 10             	add    $0x10,%esp
  }
#else
  else if (active_procs > 0) {
      printf(1, "\n%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s",
              "PID", "Name", "UID", "GID", "PPID", "Prio", "Elapsed", "CPU", "State", "Size");
      for (int i = 0; i < active_procs; ++i) {
 2de:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 2e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2e5:	3b 45 dc             	cmp    -0x24(%ebp),%eax
 2e8:	0f 8c d2 fe ff ff    	jl     1c0 <main+0xff>
                  utable[i].pid, utable[i].name, utable[i].uid, utable[i].gid, utable[i].ppid, utable[i].priority);
          elapsed(utable[i].elapsed_ticks);
          elapsed(utable[i].CPU_total_ticks);
          printf(1, "\t%s\t%d", utable[i].state, utable[i].size);
      }
      printf(1, "\n");
 2ee:	83 ec 08             	sub    $0x8,%esp
 2f1:	68 65 0c 00 00       	push   $0xc65
 2f6:	6a 01                	push   $0x1
 2f8:	e8 f7 04 00 00       	call   7f4 <printf>
 2fd:	83 c4 10             	add    $0x10,%esp
  }
#endif
  free(utable);
 300:	83 ec 0c             	sub    $0xc,%esp
 303:	ff 75 d8             	pushl  -0x28(%ebp)
 306:	e8 7a 06 00 00       	call   985 <free>
 30b:	83 c4 10             	add    $0x10,%esp
  exit();
 30e:	e8 2a 03 00 00       	call   63d <exit>

00000313 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 313:	55                   	push   %ebp
 314:	89 e5                	mov    %esp,%ebp
 316:	57                   	push   %edi
 317:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 318:	8b 4d 08             	mov    0x8(%ebp),%ecx
 31b:	8b 55 10             	mov    0x10(%ebp),%edx
 31e:	8b 45 0c             	mov    0xc(%ebp),%eax
 321:	89 cb                	mov    %ecx,%ebx
 323:	89 df                	mov    %ebx,%edi
 325:	89 d1                	mov    %edx,%ecx
 327:	fc                   	cld    
 328:	f3 aa                	rep stos %al,%es:(%edi)
 32a:	89 ca                	mov    %ecx,%edx
 32c:	89 fb                	mov    %edi,%ebx
 32e:	89 5d 08             	mov    %ebx,0x8(%ebp)
 331:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 334:	90                   	nop
 335:	5b                   	pop    %ebx
 336:	5f                   	pop    %edi
 337:	5d                   	pop    %ebp
 338:	c3                   	ret    

00000339 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 339:	55                   	push   %ebp
 33a:	89 e5                	mov    %esp,%ebp
 33c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 33f:	8b 45 08             	mov    0x8(%ebp),%eax
 342:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 345:	90                   	nop
 346:	8b 45 08             	mov    0x8(%ebp),%eax
 349:	8d 50 01             	lea    0x1(%eax),%edx
 34c:	89 55 08             	mov    %edx,0x8(%ebp)
 34f:	8b 55 0c             	mov    0xc(%ebp),%edx
 352:	8d 4a 01             	lea    0x1(%edx),%ecx
 355:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 358:	0f b6 12             	movzbl (%edx),%edx
 35b:	88 10                	mov    %dl,(%eax)
 35d:	0f b6 00             	movzbl (%eax),%eax
 360:	84 c0                	test   %al,%al
 362:	75 e2                	jne    346 <strcpy+0xd>
    ;
  return os;
 364:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 367:	c9                   	leave  
 368:	c3                   	ret    

00000369 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 369:	55                   	push   %ebp
 36a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 36c:	eb 08                	jmp    376 <strcmp+0xd>
    p++, q++;
 36e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 372:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 376:	8b 45 08             	mov    0x8(%ebp),%eax
 379:	0f b6 00             	movzbl (%eax),%eax
 37c:	84 c0                	test   %al,%al
 37e:	74 10                	je     390 <strcmp+0x27>
 380:	8b 45 08             	mov    0x8(%ebp),%eax
 383:	0f b6 10             	movzbl (%eax),%edx
 386:	8b 45 0c             	mov    0xc(%ebp),%eax
 389:	0f b6 00             	movzbl (%eax),%eax
 38c:	38 c2                	cmp    %al,%dl
 38e:	74 de                	je     36e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 390:	8b 45 08             	mov    0x8(%ebp),%eax
 393:	0f b6 00             	movzbl (%eax),%eax
 396:	0f b6 d0             	movzbl %al,%edx
 399:	8b 45 0c             	mov    0xc(%ebp),%eax
 39c:	0f b6 00             	movzbl (%eax),%eax
 39f:	0f b6 c0             	movzbl %al,%eax
 3a2:	29 c2                	sub    %eax,%edx
 3a4:	89 d0                	mov    %edx,%eax
}
 3a6:	5d                   	pop    %ebp
 3a7:	c3                   	ret    

000003a8 <strlen>:

uint
strlen(char *s)
{
 3a8:	55                   	push   %ebp
 3a9:	89 e5                	mov    %esp,%ebp
 3ab:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3b5:	eb 04                	jmp    3bb <strlen+0x13>
 3b7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3bb:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3be:	8b 45 08             	mov    0x8(%ebp),%eax
 3c1:	01 d0                	add    %edx,%eax
 3c3:	0f b6 00             	movzbl (%eax),%eax
 3c6:	84 c0                	test   %al,%al
 3c8:	75 ed                	jne    3b7 <strlen+0xf>
    ;
  return n;
 3ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3cd:	c9                   	leave  
 3ce:	c3                   	ret    

000003cf <memset>:

void*
memset(void *dst, int c, uint n)
{
 3cf:	55                   	push   %ebp
 3d0:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 3d2:	8b 45 10             	mov    0x10(%ebp),%eax
 3d5:	50                   	push   %eax
 3d6:	ff 75 0c             	pushl  0xc(%ebp)
 3d9:	ff 75 08             	pushl  0x8(%ebp)
 3dc:	e8 32 ff ff ff       	call   313 <stosb>
 3e1:	83 c4 0c             	add    $0xc,%esp
  return dst;
 3e4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3e7:	c9                   	leave  
 3e8:	c3                   	ret    

000003e9 <strchr>:

char*
strchr(const char *s, char c)
{
 3e9:	55                   	push   %ebp
 3ea:	89 e5                	mov    %esp,%ebp
 3ec:	83 ec 04             	sub    $0x4,%esp
 3ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f2:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 3f5:	eb 14                	jmp    40b <strchr+0x22>
    if(*s == c)
 3f7:	8b 45 08             	mov    0x8(%ebp),%eax
 3fa:	0f b6 00             	movzbl (%eax),%eax
 3fd:	3a 45 fc             	cmp    -0x4(%ebp),%al
 400:	75 05                	jne    407 <strchr+0x1e>
      return (char*)s;
 402:	8b 45 08             	mov    0x8(%ebp),%eax
 405:	eb 13                	jmp    41a <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 407:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 40b:	8b 45 08             	mov    0x8(%ebp),%eax
 40e:	0f b6 00             	movzbl (%eax),%eax
 411:	84 c0                	test   %al,%al
 413:	75 e2                	jne    3f7 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 415:	b8 00 00 00 00       	mov    $0x0,%eax
}
 41a:	c9                   	leave  
 41b:	c3                   	ret    

0000041c <gets>:

char*
gets(char *buf, int max)
{
 41c:	55                   	push   %ebp
 41d:	89 e5                	mov    %esp,%ebp
 41f:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 422:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 429:	eb 42                	jmp    46d <gets+0x51>
    cc = read(0, &c, 1);
 42b:	83 ec 04             	sub    $0x4,%esp
 42e:	6a 01                	push   $0x1
 430:	8d 45 ef             	lea    -0x11(%ebp),%eax
 433:	50                   	push   %eax
 434:	6a 00                	push   $0x0
 436:	e8 1a 02 00 00       	call   655 <read>
 43b:	83 c4 10             	add    $0x10,%esp
 43e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 441:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 445:	7e 33                	jle    47a <gets+0x5e>
      break;
    buf[i++] = c;
 447:	8b 45 f4             	mov    -0xc(%ebp),%eax
 44a:	8d 50 01             	lea    0x1(%eax),%edx
 44d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 450:	89 c2                	mov    %eax,%edx
 452:	8b 45 08             	mov    0x8(%ebp),%eax
 455:	01 c2                	add    %eax,%edx
 457:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 45b:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 45d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 461:	3c 0a                	cmp    $0xa,%al
 463:	74 16                	je     47b <gets+0x5f>
 465:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 469:	3c 0d                	cmp    $0xd,%al
 46b:	74 0e                	je     47b <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 46d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 470:	83 c0 01             	add    $0x1,%eax
 473:	3b 45 0c             	cmp    0xc(%ebp),%eax
 476:	7c b3                	jl     42b <gets+0xf>
 478:	eb 01                	jmp    47b <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 47a:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 47b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 47e:	8b 45 08             	mov    0x8(%ebp),%eax
 481:	01 d0                	add    %edx,%eax
 483:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 486:	8b 45 08             	mov    0x8(%ebp),%eax
}
 489:	c9                   	leave  
 48a:	c3                   	ret    

0000048b <stat>:

int
stat(char *n, struct stat *st)
{
 48b:	55                   	push   %ebp
 48c:	89 e5                	mov    %esp,%ebp
 48e:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 491:	83 ec 08             	sub    $0x8,%esp
 494:	6a 00                	push   $0x0
 496:	ff 75 08             	pushl  0x8(%ebp)
 499:	e8 df 01 00 00       	call   67d <open>
 49e:	83 c4 10             	add    $0x10,%esp
 4a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4a8:	79 07                	jns    4b1 <stat+0x26>
    return -1;
 4aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4af:	eb 25                	jmp    4d6 <stat+0x4b>
  r = fstat(fd, st);
 4b1:	83 ec 08             	sub    $0x8,%esp
 4b4:	ff 75 0c             	pushl  0xc(%ebp)
 4b7:	ff 75 f4             	pushl  -0xc(%ebp)
 4ba:	e8 d6 01 00 00       	call   695 <fstat>
 4bf:	83 c4 10             	add    $0x10,%esp
 4c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4c5:	83 ec 0c             	sub    $0xc,%esp
 4c8:	ff 75 f4             	pushl  -0xc(%ebp)
 4cb:	e8 95 01 00 00       	call   665 <close>
 4d0:	83 c4 10             	add    $0x10,%esp
  return r;
 4d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 4d6:	c9                   	leave  
 4d7:	c3                   	ret    

000004d8 <atoi>:

int
atoi(const char *s)
{
 4d8:	55                   	push   %ebp
 4d9:	89 e5                	mov    %esp,%ebp
 4db:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 4de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 4e5:	eb 04                	jmp    4eb <atoi+0x13>
 4e7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 4eb:	8b 45 08             	mov    0x8(%ebp),%eax
 4ee:	0f b6 00             	movzbl (%eax),%eax
 4f1:	3c 20                	cmp    $0x20,%al
 4f3:	74 f2                	je     4e7 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 4f5:	8b 45 08             	mov    0x8(%ebp),%eax
 4f8:	0f b6 00             	movzbl (%eax),%eax
 4fb:	3c 2d                	cmp    $0x2d,%al
 4fd:	75 07                	jne    506 <atoi+0x2e>
 4ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 504:	eb 05                	jmp    50b <atoi+0x33>
 506:	b8 01 00 00 00       	mov    $0x1,%eax
 50b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 50e:	8b 45 08             	mov    0x8(%ebp),%eax
 511:	0f b6 00             	movzbl (%eax),%eax
 514:	3c 2b                	cmp    $0x2b,%al
 516:	74 0a                	je     522 <atoi+0x4a>
 518:	8b 45 08             	mov    0x8(%ebp),%eax
 51b:	0f b6 00             	movzbl (%eax),%eax
 51e:	3c 2d                	cmp    $0x2d,%al
 520:	75 2b                	jne    54d <atoi+0x75>
    s++;
 522:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 526:	eb 25                	jmp    54d <atoi+0x75>
    n = n*10 + *s++ - '0';
 528:	8b 55 fc             	mov    -0x4(%ebp),%edx
 52b:	89 d0                	mov    %edx,%eax
 52d:	c1 e0 02             	shl    $0x2,%eax
 530:	01 d0                	add    %edx,%eax
 532:	01 c0                	add    %eax,%eax
 534:	89 c1                	mov    %eax,%ecx
 536:	8b 45 08             	mov    0x8(%ebp),%eax
 539:	8d 50 01             	lea    0x1(%eax),%edx
 53c:	89 55 08             	mov    %edx,0x8(%ebp)
 53f:	0f b6 00             	movzbl (%eax),%eax
 542:	0f be c0             	movsbl %al,%eax
 545:	01 c8                	add    %ecx,%eax
 547:	83 e8 30             	sub    $0x30,%eax
 54a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 54d:	8b 45 08             	mov    0x8(%ebp),%eax
 550:	0f b6 00             	movzbl (%eax),%eax
 553:	3c 2f                	cmp    $0x2f,%al
 555:	7e 0a                	jle    561 <atoi+0x89>
 557:	8b 45 08             	mov    0x8(%ebp),%eax
 55a:	0f b6 00             	movzbl (%eax),%eax
 55d:	3c 39                	cmp    $0x39,%al
 55f:	7e c7                	jle    528 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 561:	8b 45 f8             	mov    -0x8(%ebp),%eax
 564:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 568:	c9                   	leave  
 569:	c3                   	ret    

0000056a <atoo>:

int
atoo(const char *s)
{
 56a:	55                   	push   %ebp
 56b:	89 e5                	mov    %esp,%ebp
 56d:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 570:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 577:	eb 04                	jmp    57d <atoo+0x13>
 579:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 57d:	8b 45 08             	mov    0x8(%ebp),%eax
 580:	0f b6 00             	movzbl (%eax),%eax
 583:	3c 20                	cmp    $0x20,%al
 585:	74 f2                	je     579 <atoo+0xf>
  sign = (*s == '-') ? -1 : 1;
 587:	8b 45 08             	mov    0x8(%ebp),%eax
 58a:	0f b6 00             	movzbl (%eax),%eax
 58d:	3c 2d                	cmp    $0x2d,%al
 58f:	75 07                	jne    598 <atoo+0x2e>
 591:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 596:	eb 05                	jmp    59d <atoo+0x33>
 598:	b8 01 00 00 00       	mov    $0x1,%eax
 59d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 5a0:	8b 45 08             	mov    0x8(%ebp),%eax
 5a3:	0f b6 00             	movzbl (%eax),%eax
 5a6:	3c 2b                	cmp    $0x2b,%al
 5a8:	74 0a                	je     5b4 <atoo+0x4a>
 5aa:	8b 45 08             	mov    0x8(%ebp),%eax
 5ad:	0f b6 00             	movzbl (%eax),%eax
 5b0:	3c 2d                	cmp    $0x2d,%al
 5b2:	75 27                	jne    5db <atoo+0x71>
    s++;
 5b4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '7')
 5b8:	eb 21                	jmp    5db <atoo+0x71>
    n = n*8 + *s++ - '0';
 5ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5bd:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
 5c4:	8b 45 08             	mov    0x8(%ebp),%eax
 5c7:	8d 50 01             	lea    0x1(%eax),%edx
 5ca:	89 55 08             	mov    %edx,0x8(%ebp)
 5cd:	0f b6 00             	movzbl (%eax),%eax
 5d0:	0f be c0             	movsbl %al,%eax
 5d3:	01 c8                	add    %ecx,%eax
 5d5:	83 e8 30             	sub    $0x30,%eax
 5d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '7')
 5db:	8b 45 08             	mov    0x8(%ebp),%eax
 5de:	0f b6 00             	movzbl (%eax),%eax
 5e1:	3c 2f                	cmp    $0x2f,%al
 5e3:	7e 0a                	jle    5ef <atoo+0x85>
 5e5:	8b 45 08             	mov    0x8(%ebp),%eax
 5e8:	0f b6 00             	movzbl (%eax),%eax
 5eb:	3c 37                	cmp    $0x37,%al
 5ed:	7e cb                	jle    5ba <atoo+0x50>
    n = n*8 + *s++ - '0';
  return sign*n;
 5ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f2:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 5f6:	c9                   	leave  
 5f7:	c3                   	ret    

000005f8 <memmove>:


void*
memmove(void *vdst, void *vsrc, int n)
{
 5f8:	55                   	push   %ebp
 5f9:	89 e5                	mov    %esp,%ebp
 5fb:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 5fe:	8b 45 08             	mov    0x8(%ebp),%eax
 601:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 604:	8b 45 0c             	mov    0xc(%ebp),%eax
 607:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 60a:	eb 17                	jmp    623 <memmove+0x2b>
    *dst++ = *src++;
 60c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60f:	8d 50 01             	lea    0x1(%eax),%edx
 612:	89 55 fc             	mov    %edx,-0x4(%ebp)
 615:	8b 55 f8             	mov    -0x8(%ebp),%edx
 618:	8d 4a 01             	lea    0x1(%edx),%ecx
 61b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 61e:	0f b6 12             	movzbl (%edx),%edx
 621:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 623:	8b 45 10             	mov    0x10(%ebp),%eax
 626:	8d 50 ff             	lea    -0x1(%eax),%edx
 629:	89 55 10             	mov    %edx,0x10(%ebp)
 62c:	85 c0                	test   %eax,%eax
 62e:	7f dc                	jg     60c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 630:	8b 45 08             	mov    0x8(%ebp),%eax
}
 633:	c9                   	leave  
 634:	c3                   	ret    

00000635 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 635:	b8 01 00 00 00       	mov    $0x1,%eax
 63a:	cd 40                	int    $0x40
 63c:	c3                   	ret    

0000063d <exit>:
SYSCALL(exit)
 63d:	b8 02 00 00 00       	mov    $0x2,%eax
 642:	cd 40                	int    $0x40
 644:	c3                   	ret    

00000645 <wait>:
SYSCALL(wait)
 645:	b8 03 00 00 00       	mov    $0x3,%eax
 64a:	cd 40                	int    $0x40
 64c:	c3                   	ret    

0000064d <pipe>:
SYSCALL(pipe)
 64d:	b8 04 00 00 00       	mov    $0x4,%eax
 652:	cd 40                	int    $0x40
 654:	c3                   	ret    

00000655 <read>:
SYSCALL(read)
 655:	b8 05 00 00 00       	mov    $0x5,%eax
 65a:	cd 40                	int    $0x40
 65c:	c3                   	ret    

0000065d <write>:
SYSCALL(write)
 65d:	b8 10 00 00 00       	mov    $0x10,%eax
 662:	cd 40                	int    $0x40
 664:	c3                   	ret    

00000665 <close>:
SYSCALL(close)
 665:	b8 15 00 00 00       	mov    $0x15,%eax
 66a:	cd 40                	int    $0x40
 66c:	c3                   	ret    

0000066d <kill>:
SYSCALL(kill)
 66d:	b8 06 00 00 00       	mov    $0x6,%eax
 672:	cd 40                	int    $0x40
 674:	c3                   	ret    

00000675 <exec>:
SYSCALL(exec)
 675:	b8 07 00 00 00       	mov    $0x7,%eax
 67a:	cd 40                	int    $0x40
 67c:	c3                   	ret    

0000067d <open>:
SYSCALL(open)
 67d:	b8 0f 00 00 00       	mov    $0xf,%eax
 682:	cd 40                	int    $0x40
 684:	c3                   	ret    

00000685 <mknod>:
SYSCALL(mknod)
 685:	b8 11 00 00 00       	mov    $0x11,%eax
 68a:	cd 40                	int    $0x40
 68c:	c3                   	ret    

0000068d <unlink>:
SYSCALL(unlink)
 68d:	b8 12 00 00 00       	mov    $0x12,%eax
 692:	cd 40                	int    $0x40
 694:	c3                   	ret    

00000695 <fstat>:
SYSCALL(fstat)
 695:	b8 08 00 00 00       	mov    $0x8,%eax
 69a:	cd 40                	int    $0x40
 69c:	c3                   	ret    

0000069d <link>:
SYSCALL(link)
 69d:	b8 13 00 00 00       	mov    $0x13,%eax
 6a2:	cd 40                	int    $0x40
 6a4:	c3                   	ret    

000006a5 <mkdir>:
SYSCALL(mkdir)
 6a5:	b8 14 00 00 00       	mov    $0x14,%eax
 6aa:	cd 40                	int    $0x40
 6ac:	c3                   	ret    

000006ad <chdir>:
SYSCALL(chdir)
 6ad:	b8 09 00 00 00       	mov    $0x9,%eax
 6b2:	cd 40                	int    $0x40
 6b4:	c3                   	ret    

000006b5 <dup>:
SYSCALL(dup)
 6b5:	b8 0a 00 00 00       	mov    $0xa,%eax
 6ba:	cd 40                	int    $0x40
 6bc:	c3                   	ret    

000006bd <getpid>:
SYSCALL(getpid)
 6bd:	b8 0b 00 00 00       	mov    $0xb,%eax
 6c2:	cd 40                	int    $0x40
 6c4:	c3                   	ret    

000006c5 <sbrk>:
SYSCALL(sbrk)
 6c5:	b8 0c 00 00 00       	mov    $0xc,%eax
 6ca:	cd 40                	int    $0x40
 6cc:	c3                   	ret    

000006cd <sleep>:
SYSCALL(sleep)
 6cd:	b8 0d 00 00 00       	mov    $0xd,%eax
 6d2:	cd 40                	int    $0x40
 6d4:	c3                   	ret    

000006d5 <uptime>:
SYSCALL(uptime)
 6d5:	b8 0e 00 00 00       	mov    $0xe,%eax
 6da:	cd 40                	int    $0x40
 6dc:	c3                   	ret    

000006dd <halt>:
SYSCALL(halt)
 6dd:	b8 16 00 00 00       	mov    $0x16,%eax
 6e2:	cd 40                	int    $0x40
 6e4:	c3                   	ret    

000006e5 <date>:
SYSCALL(date)
 6e5:	b8 17 00 00 00       	mov    $0x17,%eax
 6ea:	cd 40                	int    $0x40
 6ec:	c3                   	ret    

000006ed <getuid>:
SYSCALL(getuid)
 6ed:	b8 18 00 00 00       	mov    $0x18,%eax
 6f2:	cd 40                	int    $0x40
 6f4:	c3                   	ret    

000006f5 <getgid>:
SYSCALL(getgid)
 6f5:	b8 19 00 00 00       	mov    $0x19,%eax
 6fa:	cd 40                	int    $0x40
 6fc:	c3                   	ret    

000006fd <getppid>:
SYSCALL(getppid)
 6fd:	b8 1a 00 00 00       	mov    $0x1a,%eax
 702:	cd 40                	int    $0x40
 704:	c3                   	ret    

00000705 <setuid>:
SYSCALL(setuid)
 705:	b8 1b 00 00 00       	mov    $0x1b,%eax
 70a:	cd 40                	int    $0x40
 70c:	c3                   	ret    

0000070d <setgid>:
SYSCALL(setgid)
 70d:	b8 1c 00 00 00       	mov    $0x1c,%eax
 712:	cd 40                	int    $0x40
 714:	c3                   	ret    

00000715 <getprocs>:
SYSCALL(getprocs)
 715:	b8 1d 00 00 00       	mov    $0x1d,%eax
 71a:	cd 40                	int    $0x40
 71c:	c3                   	ret    

0000071d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 71d:	55                   	push   %ebp
 71e:	89 e5                	mov    %esp,%ebp
 720:	83 ec 18             	sub    $0x18,%esp
 723:	8b 45 0c             	mov    0xc(%ebp),%eax
 726:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 729:	83 ec 04             	sub    $0x4,%esp
 72c:	6a 01                	push   $0x1
 72e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 731:	50                   	push   %eax
 732:	ff 75 08             	pushl  0x8(%ebp)
 735:	e8 23 ff ff ff       	call   65d <write>
 73a:	83 c4 10             	add    $0x10,%esp
}
 73d:	90                   	nop
 73e:	c9                   	leave  
 73f:	c3                   	ret    

00000740 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 740:	55                   	push   %ebp
 741:	89 e5                	mov    %esp,%ebp
 743:	53                   	push   %ebx
 744:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 747:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 74e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 752:	74 17                	je     76b <printint+0x2b>
 754:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 758:	79 11                	jns    76b <printint+0x2b>
    neg = 1;
 75a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 761:	8b 45 0c             	mov    0xc(%ebp),%eax
 764:	f7 d8                	neg    %eax
 766:	89 45 ec             	mov    %eax,-0x14(%ebp)
 769:	eb 06                	jmp    771 <printint+0x31>
  } else {
    x = xx;
 76b:	8b 45 0c             	mov    0xc(%ebp),%eax
 76e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 771:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 778:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 77b:	8d 41 01             	lea    0x1(%ecx),%eax
 77e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 781:	8b 5d 10             	mov    0x10(%ebp),%ebx
 784:	8b 45 ec             	mov    -0x14(%ebp),%eax
 787:	ba 00 00 00 00       	mov    $0x0,%edx
 78c:	f7 f3                	div    %ebx
 78e:	89 d0                	mov    %edx,%eax
 790:	0f b6 80 04 0f 00 00 	movzbl 0xf04(%eax),%eax
 797:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 79b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 79e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7a1:	ba 00 00 00 00       	mov    $0x0,%edx
 7a6:	f7 f3                	div    %ebx
 7a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 7af:	75 c7                	jne    778 <printint+0x38>
  if(neg)
 7b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7b5:	74 2d                	je     7e4 <printint+0xa4>
    buf[i++] = '-';
 7b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ba:	8d 50 01             	lea    0x1(%eax),%edx
 7bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 7c0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 7c5:	eb 1d                	jmp    7e4 <printint+0xa4>
    putc(fd, buf[i]);
 7c7:	8d 55 dc             	lea    -0x24(%ebp),%edx
 7ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cd:	01 d0                	add    %edx,%eax
 7cf:	0f b6 00             	movzbl (%eax),%eax
 7d2:	0f be c0             	movsbl %al,%eax
 7d5:	83 ec 08             	sub    $0x8,%esp
 7d8:	50                   	push   %eax
 7d9:	ff 75 08             	pushl  0x8(%ebp)
 7dc:	e8 3c ff ff ff       	call   71d <putc>
 7e1:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 7e4:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 7e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ec:	79 d9                	jns    7c7 <printint+0x87>
    putc(fd, buf[i]);
}
 7ee:	90                   	nop
 7ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 7f2:	c9                   	leave  
 7f3:	c3                   	ret    

000007f4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 7f4:	55                   	push   %ebp
 7f5:	89 e5                	mov    %esp,%ebp
 7f7:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 7fa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 801:	8d 45 0c             	lea    0xc(%ebp),%eax
 804:	83 c0 04             	add    $0x4,%eax
 807:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 80a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 811:	e9 59 01 00 00       	jmp    96f <printf+0x17b>
    c = fmt[i] & 0xff;
 816:	8b 55 0c             	mov    0xc(%ebp),%edx
 819:	8b 45 f0             	mov    -0x10(%ebp),%eax
 81c:	01 d0                	add    %edx,%eax
 81e:	0f b6 00             	movzbl (%eax),%eax
 821:	0f be c0             	movsbl %al,%eax
 824:	25 ff 00 00 00       	and    $0xff,%eax
 829:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 82c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 830:	75 2c                	jne    85e <printf+0x6a>
      if(c == '%'){
 832:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 836:	75 0c                	jne    844 <printf+0x50>
        state = '%';
 838:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 83f:	e9 27 01 00 00       	jmp    96b <printf+0x177>
      } else {
        putc(fd, c);
 844:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 847:	0f be c0             	movsbl %al,%eax
 84a:	83 ec 08             	sub    $0x8,%esp
 84d:	50                   	push   %eax
 84e:	ff 75 08             	pushl  0x8(%ebp)
 851:	e8 c7 fe ff ff       	call   71d <putc>
 856:	83 c4 10             	add    $0x10,%esp
 859:	e9 0d 01 00 00       	jmp    96b <printf+0x177>
      }
    } else if(state == '%'){
 85e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 862:	0f 85 03 01 00 00    	jne    96b <printf+0x177>
      if(c == 'd'){
 868:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 86c:	75 1e                	jne    88c <printf+0x98>
        printint(fd, *ap, 10, 1);
 86e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 871:	8b 00                	mov    (%eax),%eax
 873:	6a 01                	push   $0x1
 875:	6a 0a                	push   $0xa
 877:	50                   	push   %eax
 878:	ff 75 08             	pushl  0x8(%ebp)
 87b:	e8 c0 fe ff ff       	call   740 <printint>
 880:	83 c4 10             	add    $0x10,%esp
        ap++;
 883:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 887:	e9 d8 00 00 00       	jmp    964 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 88c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 890:	74 06                	je     898 <printf+0xa4>
 892:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 896:	75 1e                	jne    8b6 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 898:	8b 45 e8             	mov    -0x18(%ebp),%eax
 89b:	8b 00                	mov    (%eax),%eax
 89d:	6a 00                	push   $0x0
 89f:	6a 10                	push   $0x10
 8a1:	50                   	push   %eax
 8a2:	ff 75 08             	pushl  0x8(%ebp)
 8a5:	e8 96 fe ff ff       	call   740 <printint>
 8aa:	83 c4 10             	add    $0x10,%esp
        ap++;
 8ad:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8b1:	e9 ae 00 00 00       	jmp    964 <printf+0x170>
      } else if(c == 's'){
 8b6:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 8ba:	75 43                	jne    8ff <printf+0x10b>
        s = (char*)*ap;
 8bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8bf:	8b 00                	mov    (%eax),%eax
 8c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 8c4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 8c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8cc:	75 25                	jne    8f3 <printf+0xff>
          s = "(null)";
 8ce:	c7 45 f4 67 0c 00 00 	movl   $0xc67,-0xc(%ebp)
        while(*s != 0){
 8d5:	eb 1c                	jmp    8f3 <printf+0xff>
          putc(fd, *s);
 8d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8da:	0f b6 00             	movzbl (%eax),%eax
 8dd:	0f be c0             	movsbl %al,%eax
 8e0:	83 ec 08             	sub    $0x8,%esp
 8e3:	50                   	push   %eax
 8e4:	ff 75 08             	pushl  0x8(%ebp)
 8e7:	e8 31 fe ff ff       	call   71d <putc>
 8ec:	83 c4 10             	add    $0x10,%esp
          s++;
 8ef:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 8f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f6:	0f b6 00             	movzbl (%eax),%eax
 8f9:	84 c0                	test   %al,%al
 8fb:	75 da                	jne    8d7 <printf+0xe3>
 8fd:	eb 65                	jmp    964 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 8ff:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 903:	75 1d                	jne    922 <printf+0x12e>
        putc(fd, *ap);
 905:	8b 45 e8             	mov    -0x18(%ebp),%eax
 908:	8b 00                	mov    (%eax),%eax
 90a:	0f be c0             	movsbl %al,%eax
 90d:	83 ec 08             	sub    $0x8,%esp
 910:	50                   	push   %eax
 911:	ff 75 08             	pushl  0x8(%ebp)
 914:	e8 04 fe ff ff       	call   71d <putc>
 919:	83 c4 10             	add    $0x10,%esp
        ap++;
 91c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 920:	eb 42                	jmp    964 <printf+0x170>
      } else if(c == '%'){
 922:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 926:	75 17                	jne    93f <printf+0x14b>
        putc(fd, c);
 928:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 92b:	0f be c0             	movsbl %al,%eax
 92e:	83 ec 08             	sub    $0x8,%esp
 931:	50                   	push   %eax
 932:	ff 75 08             	pushl  0x8(%ebp)
 935:	e8 e3 fd ff ff       	call   71d <putc>
 93a:	83 c4 10             	add    $0x10,%esp
 93d:	eb 25                	jmp    964 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 93f:	83 ec 08             	sub    $0x8,%esp
 942:	6a 25                	push   $0x25
 944:	ff 75 08             	pushl  0x8(%ebp)
 947:	e8 d1 fd ff ff       	call   71d <putc>
 94c:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 94f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 952:	0f be c0             	movsbl %al,%eax
 955:	83 ec 08             	sub    $0x8,%esp
 958:	50                   	push   %eax
 959:	ff 75 08             	pushl  0x8(%ebp)
 95c:	e8 bc fd ff ff       	call   71d <putc>
 961:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 964:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 96b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 96f:	8b 55 0c             	mov    0xc(%ebp),%edx
 972:	8b 45 f0             	mov    -0x10(%ebp),%eax
 975:	01 d0                	add    %edx,%eax
 977:	0f b6 00             	movzbl (%eax),%eax
 97a:	84 c0                	test   %al,%al
 97c:	0f 85 94 fe ff ff    	jne    816 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 982:	90                   	nop
 983:	c9                   	leave  
 984:	c3                   	ret    

00000985 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 985:	55                   	push   %ebp
 986:	89 e5                	mov    %esp,%ebp
 988:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 98b:	8b 45 08             	mov    0x8(%ebp),%eax
 98e:	83 e8 08             	sub    $0x8,%eax
 991:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 994:	a1 20 0f 00 00       	mov    0xf20,%eax
 999:	89 45 fc             	mov    %eax,-0x4(%ebp)
 99c:	eb 24                	jmp    9c2 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 99e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9a1:	8b 00                	mov    (%eax),%eax
 9a3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9a6:	77 12                	ja     9ba <free+0x35>
 9a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9ab:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9ae:	77 24                	ja     9d4 <free+0x4f>
 9b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b3:	8b 00                	mov    (%eax),%eax
 9b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9b8:	77 1a                	ja     9d4 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9bd:	8b 00                	mov    (%eax),%eax
 9bf:	89 45 fc             	mov    %eax,-0x4(%ebp)
 9c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9c5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 9c8:	76 d4                	jbe    99e <free+0x19>
 9ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9cd:	8b 00                	mov    (%eax),%eax
 9cf:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 9d2:	76 ca                	jbe    99e <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 9d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9d7:	8b 40 04             	mov    0x4(%eax),%eax
 9da:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 9e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9e4:	01 c2                	add    %eax,%edx
 9e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9e9:	8b 00                	mov    (%eax),%eax
 9eb:	39 c2                	cmp    %eax,%edx
 9ed:	75 24                	jne    a13 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 9ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 9f2:	8b 50 04             	mov    0x4(%eax),%edx
 9f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9f8:	8b 00                	mov    (%eax),%eax
 9fa:	8b 40 04             	mov    0x4(%eax),%eax
 9fd:	01 c2                	add    %eax,%edx
 9ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a02:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a05:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a08:	8b 00                	mov    (%eax),%eax
 a0a:	8b 10                	mov    (%eax),%edx
 a0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a0f:	89 10                	mov    %edx,(%eax)
 a11:	eb 0a                	jmp    a1d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a13:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a16:	8b 10                	mov    (%eax),%edx
 a18:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a1b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a20:	8b 40 04             	mov    0x4(%eax),%eax
 a23:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a2d:	01 d0                	add    %edx,%eax
 a2f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a32:	75 20                	jne    a54 <free+0xcf>
    p->s.size += bp->s.size;
 a34:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a37:	8b 50 04             	mov    0x4(%eax),%edx
 a3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a3d:	8b 40 04             	mov    0x4(%eax),%eax
 a40:	01 c2                	add    %eax,%edx
 a42:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a45:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 a48:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a4b:	8b 10                	mov    (%eax),%edx
 a4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a50:	89 10                	mov    %edx,(%eax)
 a52:	eb 08                	jmp    a5c <free+0xd7>
  } else
    p->s.ptr = bp;
 a54:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a57:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a5a:	89 10                	mov    %edx,(%eax)
  freep = p;
 a5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a5f:	a3 20 0f 00 00       	mov    %eax,0xf20
}
 a64:	90                   	nop
 a65:	c9                   	leave  
 a66:	c3                   	ret    

00000a67 <morecore>:

static Header*
morecore(uint nu)
{
 a67:	55                   	push   %ebp
 a68:	89 e5                	mov    %esp,%ebp
 a6a:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 a6d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 a74:	77 07                	ja     a7d <morecore+0x16>
    nu = 4096;
 a76:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 a7d:	8b 45 08             	mov    0x8(%ebp),%eax
 a80:	c1 e0 03             	shl    $0x3,%eax
 a83:	83 ec 0c             	sub    $0xc,%esp
 a86:	50                   	push   %eax
 a87:	e8 39 fc ff ff       	call   6c5 <sbrk>
 a8c:	83 c4 10             	add    $0x10,%esp
 a8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 a92:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 a96:	75 07                	jne    a9f <morecore+0x38>
    return 0;
 a98:	b8 00 00 00 00       	mov    $0x0,%eax
 a9d:	eb 26                	jmp    ac5 <morecore+0x5e>
  hp = (Header*)p;
 a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa8:	8b 55 08             	mov    0x8(%ebp),%edx
 aab:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ab1:	83 c0 08             	add    $0x8,%eax
 ab4:	83 ec 0c             	sub    $0xc,%esp
 ab7:	50                   	push   %eax
 ab8:	e8 c8 fe ff ff       	call   985 <free>
 abd:	83 c4 10             	add    $0x10,%esp
  return freep;
 ac0:	a1 20 0f 00 00       	mov    0xf20,%eax
}
 ac5:	c9                   	leave  
 ac6:	c3                   	ret    

00000ac7 <malloc>:

void*
malloc(uint nbytes)
{
 ac7:	55                   	push   %ebp
 ac8:	89 e5                	mov    %esp,%ebp
 aca:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 acd:	8b 45 08             	mov    0x8(%ebp),%eax
 ad0:	83 c0 07             	add    $0x7,%eax
 ad3:	c1 e8 03             	shr    $0x3,%eax
 ad6:	83 c0 01             	add    $0x1,%eax
 ad9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 adc:	a1 20 0f 00 00       	mov    0xf20,%eax
 ae1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ae4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ae8:	75 23                	jne    b0d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 aea:	c7 45 f0 18 0f 00 00 	movl   $0xf18,-0x10(%ebp)
 af1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 af4:	a3 20 0f 00 00       	mov    %eax,0xf20
 af9:	a1 20 0f 00 00       	mov    0xf20,%eax
 afe:	a3 18 0f 00 00       	mov    %eax,0xf18
    base.s.size = 0;
 b03:	c7 05 1c 0f 00 00 00 	movl   $0x0,0xf1c
 b0a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b10:	8b 00                	mov    (%eax),%eax
 b12:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b18:	8b 40 04             	mov    0x4(%eax),%eax
 b1b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b1e:	72 4d                	jb     b6d <malloc+0xa6>
      if(p->s.size == nunits)
 b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b23:	8b 40 04             	mov    0x4(%eax),%eax
 b26:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b29:	75 0c                	jne    b37 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b2e:	8b 10                	mov    (%eax),%edx
 b30:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b33:	89 10                	mov    %edx,(%eax)
 b35:	eb 26                	jmp    b5d <malloc+0x96>
      else {
        p->s.size -= nunits;
 b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b3a:	8b 40 04             	mov    0x4(%eax),%eax
 b3d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 b40:	89 c2                	mov    %eax,%edx
 b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b45:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b4b:	8b 40 04             	mov    0x4(%eax),%eax
 b4e:	c1 e0 03             	shl    $0x3,%eax
 b51:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b57:	8b 55 ec             	mov    -0x14(%ebp),%edx
 b5a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 b5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b60:	a3 20 0f 00 00       	mov    %eax,0xf20
      return (void*)(p + 1);
 b65:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b68:	83 c0 08             	add    $0x8,%eax
 b6b:	eb 3b                	jmp    ba8 <malloc+0xe1>
    }
    if(p == freep)
 b6d:	a1 20 0f 00 00       	mov    0xf20,%eax
 b72:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 b75:	75 1e                	jne    b95 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 b77:	83 ec 0c             	sub    $0xc,%esp
 b7a:	ff 75 ec             	pushl  -0x14(%ebp)
 b7d:	e8 e5 fe ff ff       	call   a67 <morecore>
 b82:	83 c4 10             	add    $0x10,%esp
 b85:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b8c:	75 07                	jne    b95 <malloc+0xce>
        return 0;
 b8e:	b8 00 00 00 00       	mov    $0x0,%eax
 b93:	eb 13                	jmp    ba8 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b98:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b9e:	8b 00                	mov    (%eax),%eax
 ba0:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ba3:	e9 6d ff ff ff       	jmp    b15 <malloc+0x4e>
}
 ba8:	c9                   	leave  
 ba9:	c3                   	ret    
