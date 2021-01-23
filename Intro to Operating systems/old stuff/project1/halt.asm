
_halt:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
// halt the system.
#include "types.h"
#include "user.h"

int
main(void) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  halt();
  11:	e8 02 03 00 00       	call   318 <halt>
  exit();
  16:	e8 5d 02 00 00       	call   278 <exit>

0000001b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  1b:	55                   	push   %ebp
  1c:	89 e5                	mov    %esp,%ebp
  1e:	53                   	push   %ebx
  1f:	8b 45 08             	mov    0x8(%ebp),%eax
  22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  25:	89 c2                	mov    %eax,%edx
  27:	83 c1 01             	add    $0x1,%ecx
  2a:	83 c2 01             	add    $0x1,%edx
  2d:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  31:	88 5a ff             	mov    %bl,-0x1(%edx)
  34:	84 db                	test   %bl,%bl
  36:	75 ef                	jne    27 <strcpy+0xc>
    ;
  return os;
}
  38:	5b                   	pop    %ebx
  39:	5d                   	pop    %ebp
  3a:	c3                   	ret    

0000003b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  3b:	55                   	push   %ebp
  3c:	89 e5                	mov    %esp,%ebp
  3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  41:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  44:	0f b6 01             	movzbl (%ecx),%eax
  47:	84 c0                	test   %al,%al
  49:	74 15                	je     60 <strcmp+0x25>
  4b:	3a 02                	cmp    (%edx),%al
  4d:	75 11                	jne    60 <strcmp+0x25>
    p++, q++;
  4f:	83 c1 01             	add    $0x1,%ecx
  52:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  55:	0f b6 01             	movzbl (%ecx),%eax
  58:	84 c0                	test   %al,%al
  5a:	74 04                	je     60 <strcmp+0x25>
  5c:	3a 02                	cmp    (%edx),%al
  5e:	74 ef                	je     4f <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  60:	0f b6 c0             	movzbl %al,%eax
  63:	0f b6 12             	movzbl (%edx),%edx
  66:	29 d0                	sub    %edx,%eax
}
  68:	5d                   	pop    %ebp
  69:	c3                   	ret    

0000006a <strlen>:

uint
strlen(char *s)
{
  6a:	55                   	push   %ebp
  6b:	89 e5                	mov    %esp,%ebp
  6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  70:	80 39 00             	cmpb   $0x0,(%ecx)
  73:	74 12                	je     87 <strlen+0x1d>
  75:	ba 00 00 00 00       	mov    $0x0,%edx
  7a:	83 c2 01             	add    $0x1,%edx
  7d:	89 d0                	mov    %edx,%eax
  7f:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  83:	75 f5                	jne    7a <strlen+0x10>
    ;
  return n;
}
  85:	5d                   	pop    %ebp
  86:	c3                   	ret    
  for(n = 0; s[n]; n++)
  87:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
  8c:	eb f7                	jmp    85 <strlen+0x1b>

0000008e <memset>:

void*
memset(void *dst, int c, uint n)
{
  8e:	55                   	push   %ebp
  8f:	89 e5                	mov    %esp,%ebp
  91:	57                   	push   %edi
  92:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  95:	89 d7                	mov    %edx,%edi
  97:	8b 4d 10             	mov    0x10(%ebp),%ecx
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	fc                   	cld    
  9e:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  a0:	89 d0                	mov    %edx,%eax
  a2:	5f                   	pop    %edi
  a3:	5d                   	pop    %ebp
  a4:	c3                   	ret    

000000a5 <strchr>:

char*
strchr(const char *s, char c)
{
  a5:	55                   	push   %ebp
  a6:	89 e5                	mov    %esp,%ebp
  a8:	53                   	push   %ebx
  a9:	8b 45 08             	mov    0x8(%ebp),%eax
  ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
  af:	0f b6 10             	movzbl (%eax),%edx
  b2:	84 d2                	test   %dl,%dl
  b4:	74 1e                	je     d4 <strchr+0x2f>
  b6:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
  b8:	38 d3                	cmp    %dl,%bl
  ba:	74 15                	je     d1 <strchr+0x2c>
  for(; *s; s++)
  bc:	83 c0 01             	add    $0x1,%eax
  bf:	0f b6 10             	movzbl (%eax),%edx
  c2:	84 d2                	test   %dl,%dl
  c4:	74 06                	je     cc <strchr+0x27>
    if(*s == c)
  c6:	38 ca                	cmp    %cl,%dl
  c8:	75 f2                	jne    bc <strchr+0x17>
  ca:	eb 05                	jmp    d1 <strchr+0x2c>
      return (char*)s;
  return 0;
  cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  d1:	5b                   	pop    %ebx
  d2:	5d                   	pop    %ebp
  d3:	c3                   	ret    
  return 0;
  d4:	b8 00 00 00 00       	mov    $0x0,%eax
  d9:	eb f6                	jmp    d1 <strchr+0x2c>

000000db <gets>:

char*
gets(char *buf, int max)
{
  db:	55                   	push   %ebp
  dc:	89 e5                	mov    %esp,%ebp
  de:	57                   	push   %edi
  df:	56                   	push   %esi
  e0:	53                   	push   %ebx
  e1:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  e4:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
  e9:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
  ec:	8d 5e 01             	lea    0x1(%esi),%ebx
  ef:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  f2:	7d 2b                	jge    11f <gets+0x44>
    cc = read(0, &c, 1);
  f4:	83 ec 04             	sub    $0x4,%esp
  f7:	6a 01                	push   $0x1
  f9:	57                   	push   %edi
  fa:	6a 00                	push   $0x0
  fc:	e8 8f 01 00 00       	call   290 <read>
    if(cc < 1)
 101:	83 c4 10             	add    $0x10,%esp
 104:	85 c0                	test   %eax,%eax
 106:	7e 17                	jle    11f <gets+0x44>
      break;
    buf[i++] = c;
 108:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 10c:	8b 55 08             	mov    0x8(%ebp),%edx
 10f:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 113:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 115:	3c 0a                	cmp    $0xa,%al
 117:	74 04                	je     11d <gets+0x42>
 119:	3c 0d                	cmp    $0xd,%al
 11b:	75 cf                	jne    ec <gets+0x11>
  for(i=0; i+1 < max; ){
 11d:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 126:	8d 65 f4             	lea    -0xc(%ebp),%esp
 129:	5b                   	pop    %ebx
 12a:	5e                   	pop    %esi
 12b:	5f                   	pop    %edi
 12c:	5d                   	pop    %ebp
 12d:	c3                   	ret    

0000012e <stat>:

int
stat(char *n, struct stat *st)
{
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
 131:	56                   	push   %esi
 132:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 133:	83 ec 08             	sub    $0x8,%esp
 136:	6a 00                	push   $0x0
 138:	ff 75 08             	pushl  0x8(%ebp)
 13b:	e8 78 01 00 00       	call   2b8 <open>
  if(fd < 0)
 140:	83 c4 10             	add    $0x10,%esp
 143:	85 c0                	test   %eax,%eax
 145:	78 24                	js     16b <stat+0x3d>
 147:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 149:	83 ec 08             	sub    $0x8,%esp
 14c:	ff 75 0c             	pushl  0xc(%ebp)
 14f:	50                   	push   %eax
 150:	e8 7b 01 00 00       	call   2d0 <fstat>
 155:	89 c6                	mov    %eax,%esi
  close(fd);
 157:	89 1c 24             	mov    %ebx,(%esp)
 15a:	e8 41 01 00 00       	call   2a0 <close>
  return r;
 15f:	83 c4 10             	add    $0x10,%esp
}
 162:	89 f0                	mov    %esi,%eax
 164:	8d 65 f8             	lea    -0x8(%ebp),%esp
 167:	5b                   	pop    %ebx
 168:	5e                   	pop    %esi
 169:	5d                   	pop    %ebp
 16a:	c3                   	ret    
    return -1;
 16b:	be ff ff ff ff       	mov    $0xffffffff,%esi
 170:	eb f0                	jmp    162 <stat+0x34>

00000172 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 172:	55                   	push   %ebp
 173:	89 e5                	mov    %esp,%ebp
 175:	56                   	push   %esi
 176:	53                   	push   %ebx
 177:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 17a:	0f b6 0a             	movzbl (%edx),%ecx
 17d:	80 f9 20             	cmp    $0x20,%cl
 180:	75 0b                	jne    18d <atoi+0x1b>
 182:	83 c2 01             	add    $0x1,%edx
 185:	0f b6 0a             	movzbl (%edx),%ecx
 188:	80 f9 20             	cmp    $0x20,%cl
 18b:	74 f5                	je     182 <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
 18d:	80 f9 2d             	cmp    $0x2d,%cl
 190:	74 3b                	je     1cd <atoi+0x5b>
  if (*s == '+'  || *s == '-')
 192:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 195:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 19a:	f6 c1 fd             	test   $0xfd,%cl
 19d:	74 33                	je     1d2 <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
 19f:	0f b6 0a             	movzbl (%edx),%ecx
 1a2:	8d 41 d0             	lea    -0x30(%ecx),%eax
 1a5:	3c 09                	cmp    $0x9,%al
 1a7:	77 2e                	ja     1d7 <atoi+0x65>
 1a9:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 1ae:	83 c2 01             	add    $0x1,%edx
 1b1:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1b4:	0f be c9             	movsbl %cl,%ecx
 1b7:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 1bb:	0f b6 0a             	movzbl (%edx),%ecx
 1be:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 1c1:	80 fb 09             	cmp    $0x9,%bl
 1c4:	76 e8                	jbe    1ae <atoi+0x3c>
  return sign*n;
 1c6:	0f af c6             	imul   %esi,%eax
}
 1c9:	5b                   	pop    %ebx
 1ca:	5e                   	pop    %esi
 1cb:	5d                   	pop    %ebp
 1cc:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 1cd:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 1d2:	83 c2 01             	add    $0x1,%edx
 1d5:	eb c8                	jmp    19f <atoi+0x2d>
  while('0' <= *s && *s <= '9')
 1d7:	b8 00 00 00 00       	mov    $0x0,%eax
 1dc:	eb e8                	jmp    1c6 <atoi+0x54>

000001de <atoo>:

int
atoo(const char *s)
{
 1de:	55                   	push   %ebp
 1df:	89 e5                	mov    %esp,%ebp
 1e1:	56                   	push   %esi
 1e2:	53                   	push   %ebx
 1e3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1e6:	0f b6 0a             	movzbl (%edx),%ecx
 1e9:	80 f9 20             	cmp    $0x20,%cl
 1ec:	75 0b                	jne    1f9 <atoo+0x1b>
 1ee:	83 c2 01             	add    $0x1,%edx
 1f1:	0f b6 0a             	movzbl (%edx),%ecx
 1f4:	80 f9 20             	cmp    $0x20,%cl
 1f7:	74 f5                	je     1ee <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
 1f9:	80 f9 2d             	cmp    $0x2d,%cl
 1fc:	74 38                	je     236 <atoo+0x58>
  if (*s == '+'  || *s == '-')
 1fe:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 201:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 206:	f6 c1 fd             	test   $0xfd,%cl
 209:	74 30                	je     23b <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
 20b:	0f b6 0a             	movzbl (%edx),%ecx
 20e:	8d 41 d0             	lea    -0x30(%ecx),%eax
 211:	3c 07                	cmp    $0x7,%al
 213:	77 2b                	ja     240 <atoo+0x62>
 215:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
 21a:	83 c2 01             	add    $0x1,%edx
 21d:	0f be c9             	movsbl %cl,%ecx
 220:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 224:	0f b6 0a             	movzbl (%edx),%ecx
 227:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 22a:	80 fb 07             	cmp    $0x7,%bl
 22d:	76 eb                	jbe    21a <atoo+0x3c>
  return sign*n;
 22f:	0f af c6             	imul   %esi,%eax
}
 232:	5b                   	pop    %ebx
 233:	5e                   	pop    %esi
 234:	5d                   	pop    %ebp
 235:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 236:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 23b:	83 c2 01             	add    $0x1,%edx
 23e:	eb cb                	jmp    20b <atoo+0x2d>
  while('0' <= *s && *s <= '7')
 240:	b8 00 00 00 00       	mov    $0x0,%eax
 245:	eb e8                	jmp    22f <atoo+0x51>

00000247 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 247:	55                   	push   %ebp
 248:	89 e5                	mov    %esp,%ebp
 24a:	56                   	push   %esi
 24b:	53                   	push   %ebx
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	8b 75 0c             	mov    0xc(%ebp),%esi
 252:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 255:	85 db                	test   %ebx,%ebx
 257:	7e 13                	jle    26c <memmove+0x25>
 259:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 25e:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 262:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 265:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 268:	39 d3                	cmp    %edx,%ebx
 26a:	75 f2                	jne    25e <memmove+0x17>
  return vdst;
}
 26c:	5b                   	pop    %ebx
 26d:	5e                   	pop    %esi
 26e:	5d                   	pop    %ebp
 26f:	c3                   	ret    

00000270 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 270:	b8 01 00 00 00       	mov    $0x1,%eax
 275:	cd 40                	int    $0x40
 277:	c3                   	ret    

00000278 <exit>:
SYSCALL(exit)
 278:	b8 02 00 00 00       	mov    $0x2,%eax
 27d:	cd 40                	int    $0x40
 27f:	c3                   	ret    

00000280 <wait>:
SYSCALL(wait)
 280:	b8 03 00 00 00       	mov    $0x3,%eax
 285:	cd 40                	int    $0x40
 287:	c3                   	ret    

00000288 <pipe>:
SYSCALL(pipe)
 288:	b8 04 00 00 00       	mov    $0x4,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <read>:
SYSCALL(read)
 290:	b8 05 00 00 00       	mov    $0x5,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <write>:
SYSCALL(write)
 298:	b8 10 00 00 00       	mov    $0x10,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <close>:
SYSCALL(close)
 2a0:	b8 15 00 00 00       	mov    $0x15,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <kill>:
SYSCALL(kill)
 2a8:	b8 06 00 00 00       	mov    $0x6,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <exec>:
SYSCALL(exec)
 2b0:	b8 07 00 00 00       	mov    $0x7,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <open>:
SYSCALL(open)
 2b8:	b8 0f 00 00 00       	mov    $0xf,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <mknod>:
SYSCALL(mknod)
 2c0:	b8 11 00 00 00       	mov    $0x11,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <unlink>:
SYSCALL(unlink)
 2c8:	b8 12 00 00 00       	mov    $0x12,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <fstat>:
SYSCALL(fstat)
 2d0:	b8 08 00 00 00       	mov    $0x8,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <link>:
SYSCALL(link)
 2d8:	b8 13 00 00 00       	mov    $0x13,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <mkdir>:
SYSCALL(mkdir)
 2e0:	b8 14 00 00 00       	mov    $0x14,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <chdir>:
SYSCALL(chdir)
 2e8:	b8 09 00 00 00       	mov    $0x9,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <dup>:
SYSCALL(dup)
 2f0:	b8 0a 00 00 00       	mov    $0xa,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <getpid>:
SYSCALL(getpid)
 2f8:	b8 0b 00 00 00       	mov    $0xb,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <sbrk>:
SYSCALL(sbrk)
 300:	b8 0c 00 00 00       	mov    $0xc,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <sleep>:
SYSCALL(sleep)
 308:	b8 0d 00 00 00       	mov    $0xd,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <uptime>:
SYSCALL(uptime)
 310:	b8 0e 00 00 00       	mov    $0xe,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <halt>:
SYSCALL(halt)
 318:	b8 16 00 00 00       	mov    $0x16,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <date>:
SYSCALL(date)
 320:	b8 17 00 00 00       	mov    $0x17,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 328:	55                   	push   %ebp
 329:	89 e5                	mov    %esp,%ebp
 32b:	57                   	push   %edi
 32c:	56                   	push   %esi
 32d:	53                   	push   %ebx
 32e:	83 ec 3c             	sub    $0x3c,%esp
 331:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 333:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 337:	74 14                	je     34d <printint+0x25>
 339:	85 d2                	test   %edx,%edx
 33b:	79 10                	jns    34d <printint+0x25>
    neg = 1;
    x = -xx;
 33d:	f7 da                	neg    %edx
    neg = 1;
 33f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 346:	bf 00 00 00 00       	mov    $0x0,%edi
 34b:	eb 0b                	jmp    358 <printint+0x30>
  neg = 0;
 34d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 354:	eb f0                	jmp    346 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 356:	89 df                	mov    %ebx,%edi
 358:	8d 5f 01             	lea    0x1(%edi),%ebx
 35b:	89 d0                	mov    %edx,%eax
 35d:	ba 00 00 00 00       	mov    $0x0,%edx
 362:	f7 f1                	div    %ecx
 364:	0f b6 92 d0 06 00 00 	movzbl 0x6d0(%edx),%edx
 36b:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 36f:	89 c2                	mov    %eax,%edx
 371:	85 c0                	test   %eax,%eax
 373:	75 e1                	jne    356 <printint+0x2e>
  if(neg)
 375:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 379:	74 08                	je     383 <printint+0x5b>
    buf[i++] = '-';
 37b:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 380:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 383:	83 eb 01             	sub    $0x1,%ebx
 386:	78 22                	js     3aa <printint+0x82>
  write(fd, &c, 1);
 388:	8d 7d d7             	lea    -0x29(%ebp),%edi
 38b:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 390:	88 45 d7             	mov    %al,-0x29(%ebp)
 393:	83 ec 04             	sub    $0x4,%esp
 396:	6a 01                	push   $0x1
 398:	57                   	push   %edi
 399:	56                   	push   %esi
 39a:	e8 f9 fe ff ff       	call   298 <write>
  while(--i >= 0)
 39f:	83 eb 01             	sub    $0x1,%ebx
 3a2:	83 c4 10             	add    $0x10,%esp
 3a5:	83 fb ff             	cmp    $0xffffffff,%ebx
 3a8:	75 e1                	jne    38b <printint+0x63>
    putc(fd, buf[i]);
}
 3aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ad:	5b                   	pop    %ebx
 3ae:	5e                   	pop    %esi
 3af:	5f                   	pop    %edi
 3b0:	5d                   	pop    %ebp
 3b1:	c3                   	ret    

000003b2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3b2:	55                   	push   %ebp
 3b3:	89 e5                	mov    %esp,%ebp
 3b5:	57                   	push   %edi
 3b6:	56                   	push   %esi
 3b7:	53                   	push   %ebx
 3b8:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3bb:	8b 75 0c             	mov    0xc(%ebp),%esi
 3be:	0f b6 1e             	movzbl (%esi),%ebx
 3c1:	84 db                	test   %bl,%bl
 3c3:	0f 84 b1 01 00 00    	je     57a <printf+0x1c8>
 3c9:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 3cc:	8d 45 10             	lea    0x10(%ebp),%eax
 3cf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 3d2:	bf 00 00 00 00       	mov    $0x0,%edi
 3d7:	eb 2d                	jmp    406 <printf+0x54>
 3d9:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 3dc:	83 ec 04             	sub    $0x4,%esp
 3df:	6a 01                	push   $0x1
 3e1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 3e4:	50                   	push   %eax
 3e5:	ff 75 08             	pushl  0x8(%ebp)
 3e8:	e8 ab fe ff ff       	call   298 <write>
 3ed:	83 c4 10             	add    $0x10,%esp
 3f0:	eb 05                	jmp    3f7 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 3f2:	83 ff 25             	cmp    $0x25,%edi
 3f5:	74 22                	je     419 <printf+0x67>
 3f7:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 3fa:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 3fe:	84 db                	test   %bl,%bl
 400:	0f 84 74 01 00 00    	je     57a <printf+0x1c8>
    c = fmt[i] & 0xff;
 406:	0f be d3             	movsbl %bl,%edx
 409:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 40c:	85 ff                	test   %edi,%edi
 40e:	75 e2                	jne    3f2 <printf+0x40>
      if(c == '%'){
 410:	83 f8 25             	cmp    $0x25,%eax
 413:	75 c4                	jne    3d9 <printf+0x27>
        state = '%';
 415:	89 c7                	mov    %eax,%edi
 417:	eb de                	jmp    3f7 <printf+0x45>
      if(c == 'd'){
 419:	83 f8 64             	cmp    $0x64,%eax
 41c:	74 59                	je     477 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 41e:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 424:	83 fa 70             	cmp    $0x70,%edx
 427:	74 7a                	je     4a3 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 429:	83 f8 73             	cmp    $0x73,%eax
 42c:	0f 84 9d 00 00 00    	je     4cf <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 432:	83 f8 63             	cmp    $0x63,%eax
 435:	0f 84 f2 00 00 00    	je     52d <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 43b:	83 f8 25             	cmp    $0x25,%eax
 43e:	0f 84 15 01 00 00    	je     559 <printf+0x1a7>
 444:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 448:	83 ec 04             	sub    $0x4,%esp
 44b:	6a 01                	push   $0x1
 44d:	8d 45 e7             	lea    -0x19(%ebp),%eax
 450:	50                   	push   %eax
 451:	ff 75 08             	pushl  0x8(%ebp)
 454:	e8 3f fe ff ff       	call   298 <write>
 459:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 45c:	83 c4 0c             	add    $0xc,%esp
 45f:	6a 01                	push   $0x1
 461:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 464:	50                   	push   %eax
 465:	ff 75 08             	pushl  0x8(%ebp)
 468:	e8 2b fe ff ff       	call   298 <write>
 46d:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 470:	bf 00 00 00 00       	mov    $0x0,%edi
 475:	eb 80                	jmp    3f7 <printf+0x45>
        printint(fd, *ap, 10, 1);
 477:	83 ec 0c             	sub    $0xc,%esp
 47a:	6a 01                	push   $0x1
 47c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 481:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 484:	8b 17                	mov    (%edi),%edx
 486:	8b 45 08             	mov    0x8(%ebp),%eax
 489:	e8 9a fe ff ff       	call   328 <printint>
        ap++;
 48e:	89 f8                	mov    %edi,%eax
 490:	83 c0 04             	add    $0x4,%eax
 493:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 496:	83 c4 10             	add    $0x10,%esp
      state = 0;
 499:	bf 00 00 00 00       	mov    $0x0,%edi
 49e:	e9 54 ff ff ff       	jmp    3f7 <printf+0x45>
        printint(fd, *ap, 16, 0);
 4a3:	83 ec 0c             	sub    $0xc,%esp
 4a6:	6a 00                	push   $0x0
 4a8:	b9 10 00 00 00       	mov    $0x10,%ecx
 4ad:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4b0:	8b 17                	mov    (%edi),%edx
 4b2:	8b 45 08             	mov    0x8(%ebp),%eax
 4b5:	e8 6e fe ff ff       	call   328 <printint>
        ap++;
 4ba:	89 f8                	mov    %edi,%eax
 4bc:	83 c0 04             	add    $0x4,%eax
 4bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4c2:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4c5:	bf 00 00 00 00       	mov    $0x0,%edi
 4ca:	e9 28 ff ff ff       	jmp    3f7 <printf+0x45>
        s = (char*)*ap;
 4cf:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 4d2:	8b 01                	mov    (%ecx),%eax
        ap++;
 4d4:	83 c1 04             	add    $0x4,%ecx
 4d7:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 4da:	85 c0                	test   %eax,%eax
 4dc:	74 13                	je     4f1 <printf+0x13f>
        s = (char*)*ap;
 4de:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 4e0:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 4e3:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 4e8:	84 c0                	test   %al,%al
 4ea:	75 0f                	jne    4fb <printf+0x149>
 4ec:	e9 06 ff ff ff       	jmp    3f7 <printf+0x45>
          s = "(null)";
 4f1:	bb c8 06 00 00       	mov    $0x6c8,%ebx
        while(*s != 0){
 4f6:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 4fb:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 4fe:	89 75 d0             	mov    %esi,-0x30(%ebp)
 501:	8b 75 08             	mov    0x8(%ebp),%esi
 504:	88 45 e3             	mov    %al,-0x1d(%ebp)
 507:	83 ec 04             	sub    $0x4,%esp
 50a:	6a 01                	push   $0x1
 50c:	57                   	push   %edi
 50d:	56                   	push   %esi
 50e:	e8 85 fd ff ff       	call   298 <write>
          s++;
 513:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 516:	0f b6 03             	movzbl (%ebx),%eax
 519:	83 c4 10             	add    $0x10,%esp
 51c:	84 c0                	test   %al,%al
 51e:	75 e4                	jne    504 <printf+0x152>
 520:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 523:	bf 00 00 00 00       	mov    $0x0,%edi
 528:	e9 ca fe ff ff       	jmp    3f7 <printf+0x45>
        putc(fd, *ap);
 52d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 530:	8b 07                	mov    (%edi),%eax
 532:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 535:	83 ec 04             	sub    $0x4,%esp
 538:	6a 01                	push   $0x1
 53a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 53d:	50                   	push   %eax
 53e:	ff 75 08             	pushl  0x8(%ebp)
 541:	e8 52 fd ff ff       	call   298 <write>
        ap++;
 546:	83 c7 04             	add    $0x4,%edi
 549:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 54c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 54f:	bf 00 00 00 00       	mov    $0x0,%edi
 554:	e9 9e fe ff ff       	jmp    3f7 <printf+0x45>
 559:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 55c:	83 ec 04             	sub    $0x4,%esp
 55f:	6a 01                	push   $0x1
 561:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 564:	50                   	push   %eax
 565:	ff 75 08             	pushl  0x8(%ebp)
 568:	e8 2b fd ff ff       	call   298 <write>
 56d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 570:	bf 00 00 00 00       	mov    $0x0,%edi
 575:	e9 7d fe ff ff       	jmp    3f7 <printf+0x45>
    }
  }
}
 57a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 57d:	5b                   	pop    %ebx
 57e:	5e                   	pop    %esi
 57f:	5f                   	pop    %edi
 580:	5d                   	pop    %ebp
 581:	c3                   	ret    

00000582 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 582:	55                   	push   %ebp
 583:	89 e5                	mov    %esp,%ebp
 585:	57                   	push   %edi
 586:	56                   	push   %esi
 587:	53                   	push   %ebx
 588:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 58b:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 58e:	a1 68 09 00 00       	mov    0x968,%eax
 593:	eb 0c                	jmp    5a1 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 595:	8b 10                	mov    (%eax),%edx
 597:	39 c2                	cmp    %eax,%edx
 599:	77 04                	ja     59f <free+0x1d>
 59b:	39 ca                	cmp    %ecx,%edx
 59d:	77 10                	ja     5af <free+0x2d>
{
 59f:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5a1:	39 c8                	cmp    %ecx,%eax
 5a3:	73 f0                	jae    595 <free+0x13>
 5a5:	8b 10                	mov    (%eax),%edx
 5a7:	39 ca                	cmp    %ecx,%edx
 5a9:	77 04                	ja     5af <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ab:	39 c2                	cmp    %eax,%edx
 5ad:	77 f0                	ja     59f <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5af:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5b2:	8b 10                	mov    (%eax),%edx
 5b4:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5b7:	39 fa                	cmp    %edi,%edx
 5b9:	74 19                	je     5d4 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5bb:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5be:	8b 50 04             	mov    0x4(%eax),%edx
 5c1:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5c4:	39 f1                	cmp    %esi,%ecx
 5c6:	74 1b                	je     5e3 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5c8:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5ca:	a3 68 09 00 00       	mov    %eax,0x968
}
 5cf:	5b                   	pop    %ebx
 5d0:	5e                   	pop    %esi
 5d1:	5f                   	pop    %edi
 5d2:	5d                   	pop    %ebp
 5d3:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5d4:	03 72 04             	add    0x4(%edx),%esi
 5d7:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5da:	8b 10                	mov    (%eax),%edx
 5dc:	8b 12                	mov    (%edx),%edx
 5de:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5e1:	eb db                	jmp    5be <free+0x3c>
    p->s.size += bp->s.size;
 5e3:	03 53 fc             	add    -0x4(%ebx),%edx
 5e6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5e9:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5ec:	89 10                	mov    %edx,(%eax)
 5ee:	eb da                	jmp    5ca <free+0x48>

000005f0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 5f0:	55                   	push   %ebp
 5f1:	89 e5                	mov    %esp,%ebp
 5f3:	57                   	push   %edi
 5f4:	56                   	push   %esi
 5f5:	53                   	push   %ebx
 5f6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5f9:	8b 45 08             	mov    0x8(%ebp),%eax
 5fc:	8d 58 07             	lea    0x7(%eax),%ebx
 5ff:	c1 eb 03             	shr    $0x3,%ebx
 602:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 605:	8b 15 68 09 00 00    	mov    0x968,%edx
 60b:	85 d2                	test   %edx,%edx
 60d:	74 20                	je     62f <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 60f:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 611:	8b 48 04             	mov    0x4(%eax),%ecx
 614:	39 cb                	cmp    %ecx,%ebx
 616:	76 3c                	jbe    654 <malloc+0x64>
 618:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 61e:	be 00 10 00 00       	mov    $0x1000,%esi
 623:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 626:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 62d:	eb 70                	jmp    69f <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 62f:	c7 05 68 09 00 00 6c 	movl   $0x96c,0x968
 636:	09 00 00 
 639:	c7 05 6c 09 00 00 6c 	movl   $0x96c,0x96c
 640:	09 00 00 
    base.s.size = 0;
 643:	c7 05 70 09 00 00 00 	movl   $0x0,0x970
 64a:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 64d:	ba 6c 09 00 00       	mov    $0x96c,%edx
 652:	eb bb                	jmp    60f <malloc+0x1f>
      if(p->s.size == nunits)
 654:	39 cb                	cmp    %ecx,%ebx
 656:	74 1c                	je     674 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 658:	29 d9                	sub    %ebx,%ecx
 65a:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 65d:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 660:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 663:	89 15 68 09 00 00    	mov    %edx,0x968
      return (void*)(p + 1);
 669:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 66c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 66f:	5b                   	pop    %ebx
 670:	5e                   	pop    %esi
 671:	5f                   	pop    %edi
 672:	5d                   	pop    %ebp
 673:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 674:	8b 08                	mov    (%eax),%ecx
 676:	89 0a                	mov    %ecx,(%edx)
 678:	eb e9                	jmp    663 <malloc+0x73>
  hp->s.size = nu;
 67a:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 67d:	83 ec 0c             	sub    $0xc,%esp
 680:	83 c0 08             	add    $0x8,%eax
 683:	50                   	push   %eax
 684:	e8 f9 fe ff ff       	call   582 <free>
  return freep;
 689:	8b 15 68 09 00 00    	mov    0x968,%edx
      if((p = morecore(nunits)) == 0)
 68f:	83 c4 10             	add    $0x10,%esp
 692:	85 d2                	test   %edx,%edx
 694:	74 2b                	je     6c1 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 696:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 698:	8b 48 04             	mov    0x4(%eax),%ecx
 69b:	39 d9                	cmp    %ebx,%ecx
 69d:	73 b5                	jae    654 <malloc+0x64>
 69f:	89 c2                	mov    %eax,%edx
    if(p == freep)
 6a1:	39 05 68 09 00 00    	cmp    %eax,0x968
 6a7:	75 ed                	jne    696 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 6a9:	83 ec 0c             	sub    $0xc,%esp
 6ac:	57                   	push   %edi
 6ad:	e8 4e fc ff ff       	call   300 <sbrk>
  if(p == (char*)-1)
 6b2:	83 c4 10             	add    $0x10,%esp
 6b5:	83 f8 ff             	cmp    $0xffffffff,%eax
 6b8:	75 c0                	jne    67a <malloc+0x8a>
        return 0;
 6ba:	b8 00 00 00 00       	mov    $0x0,%eax
 6bf:	eb ab                	jmp    66c <malloc+0x7c>
 6c1:	b8 00 00 00 00       	mov    $0x0,%eax
 6c6:	eb a4                	jmp    66c <malloc+0x7c>
