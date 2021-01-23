
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 3){
  12:	83 39 03             	cmpl   $0x3,(%ecx)
  15:	74 14                	je     2b <main+0x2b>
    printf(2, "Usage: ln old new\n");
  17:	83 ec 08             	sub    $0x8,%esp
  1a:	68 0c 07 00 00       	push   $0x70c
  1f:	6a 02                	push   $0x2
  21:	e8 cd 03 00 00       	call   3f3 <printf>
    exit();
  26:	e8 8e 02 00 00       	call   2b9 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2b:	83 ec 08             	sub    $0x8,%esp
  2e:	ff 73 08             	pushl  0x8(%ebx)
  31:	ff 73 04             	pushl  0x4(%ebx)
  34:	e8 e0 02 00 00       	call   319 <link>
  39:	83 c4 10             	add    $0x10,%esp
  3c:	85 c0                	test   %eax,%eax
  3e:	78 05                	js     45 <main+0x45>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  40:	e8 74 02 00 00       	call   2b9 <exit>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  45:	ff 73 08             	pushl  0x8(%ebx)
  48:	ff 73 04             	pushl  0x4(%ebx)
  4b:	68 1f 07 00 00       	push   $0x71f
  50:	6a 02                	push   $0x2
  52:	e8 9c 03 00 00       	call   3f3 <printf>
  57:	83 c4 10             	add    $0x10,%esp
  5a:	eb e4                	jmp    40 <main+0x40>

0000005c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  5c:	55                   	push   %ebp
  5d:	89 e5                	mov    %esp,%ebp
  5f:	53                   	push   %ebx
  60:	8b 45 08             	mov    0x8(%ebp),%eax
  63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	89 c2                	mov    %eax,%edx
  68:	83 c1 01             	add    $0x1,%ecx
  6b:	83 c2 01             	add    $0x1,%edx
  6e:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  72:	88 5a ff             	mov    %bl,-0x1(%edx)
  75:	84 db                	test   %bl,%bl
  77:	75 ef                	jne    68 <strcpy+0xc>
    ;
  return os;
}
  79:	5b                   	pop    %ebx
  7a:	5d                   	pop    %ebp
  7b:	c3                   	ret    

0000007c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  7f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  82:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  85:	0f b6 01             	movzbl (%ecx),%eax
  88:	84 c0                	test   %al,%al
  8a:	74 15                	je     a1 <strcmp+0x25>
  8c:	3a 02                	cmp    (%edx),%al
  8e:	75 11                	jne    a1 <strcmp+0x25>
    p++, q++;
  90:	83 c1 01             	add    $0x1,%ecx
  93:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  96:	0f b6 01             	movzbl (%ecx),%eax
  99:	84 c0                	test   %al,%al
  9b:	74 04                	je     a1 <strcmp+0x25>
  9d:	3a 02                	cmp    (%edx),%al
  9f:	74 ef                	je     90 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  a1:	0f b6 c0             	movzbl %al,%eax
  a4:	0f b6 12             	movzbl (%edx),%edx
  a7:	29 d0                	sub    %edx,%eax
}
  a9:	5d                   	pop    %ebp
  aa:	c3                   	ret    

000000ab <strlen>:

uint
strlen(char *s)
{
  ab:	55                   	push   %ebp
  ac:	89 e5                	mov    %esp,%ebp
  ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  b1:	80 39 00             	cmpb   $0x0,(%ecx)
  b4:	74 12                	je     c8 <strlen+0x1d>
  b6:	ba 00 00 00 00       	mov    $0x0,%edx
  bb:	83 c2 01             	add    $0x1,%edx
  be:	89 d0                	mov    %edx,%eax
  c0:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  c4:	75 f5                	jne    bb <strlen+0x10>
    ;
  return n;
}
  c6:	5d                   	pop    %ebp
  c7:	c3                   	ret    
  for(n = 0; s[n]; n++)
  c8:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
  cd:	eb f7                	jmp    c6 <strlen+0x1b>

000000cf <memset>:

void*
memset(void *dst, int c, uint n)
{
  cf:	55                   	push   %ebp
  d0:	89 e5                	mov    %esp,%ebp
  d2:	57                   	push   %edi
  d3:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  d6:	89 d7                	mov    %edx,%edi
  d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  db:	8b 45 0c             	mov    0xc(%ebp),%eax
  de:	fc                   	cld    
  df:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  e1:	89 d0                	mov    %edx,%eax
  e3:	5f                   	pop    %edi
  e4:	5d                   	pop    %ebp
  e5:	c3                   	ret    

000000e6 <strchr>:

char*
strchr(const char *s, char c)
{
  e6:	55                   	push   %ebp
  e7:	89 e5                	mov    %esp,%ebp
  e9:	53                   	push   %ebx
  ea:	8b 45 08             	mov    0x8(%ebp),%eax
  ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
  f0:	0f b6 10             	movzbl (%eax),%edx
  f3:	84 d2                	test   %dl,%dl
  f5:	74 1e                	je     115 <strchr+0x2f>
  f7:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
  f9:	38 d3                	cmp    %dl,%bl
  fb:	74 15                	je     112 <strchr+0x2c>
  for(; *s; s++)
  fd:	83 c0 01             	add    $0x1,%eax
 100:	0f b6 10             	movzbl (%eax),%edx
 103:	84 d2                	test   %dl,%dl
 105:	74 06                	je     10d <strchr+0x27>
    if(*s == c)
 107:	38 ca                	cmp    %cl,%dl
 109:	75 f2                	jne    fd <strchr+0x17>
 10b:	eb 05                	jmp    112 <strchr+0x2c>
      return (char*)s;
  return 0;
 10d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 112:	5b                   	pop    %ebx
 113:	5d                   	pop    %ebp
 114:	c3                   	ret    
  return 0;
 115:	b8 00 00 00 00       	mov    $0x0,%eax
 11a:	eb f6                	jmp    112 <strchr+0x2c>

0000011c <gets>:

char*
gets(char *buf, int max)
{
 11c:	55                   	push   %ebp
 11d:	89 e5                	mov    %esp,%ebp
 11f:	57                   	push   %edi
 120:	56                   	push   %esi
 121:	53                   	push   %ebx
 122:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 125:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 12a:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 12d:	8d 5e 01             	lea    0x1(%esi),%ebx
 130:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 133:	7d 2b                	jge    160 <gets+0x44>
    cc = read(0, &c, 1);
 135:	83 ec 04             	sub    $0x4,%esp
 138:	6a 01                	push   $0x1
 13a:	57                   	push   %edi
 13b:	6a 00                	push   $0x0
 13d:	e8 8f 01 00 00       	call   2d1 <read>
    if(cc < 1)
 142:	83 c4 10             	add    $0x10,%esp
 145:	85 c0                	test   %eax,%eax
 147:	7e 17                	jle    160 <gets+0x44>
      break;
    buf[i++] = c;
 149:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 14d:	8b 55 08             	mov    0x8(%ebp),%edx
 150:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 154:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 156:	3c 0a                	cmp    $0xa,%al
 158:	74 04                	je     15e <gets+0x42>
 15a:	3c 0d                	cmp    $0xd,%al
 15c:	75 cf                	jne    12d <gets+0x11>
  for(i=0; i+1 < max; ){
 15e:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 160:	8b 45 08             	mov    0x8(%ebp),%eax
 163:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 167:	8d 65 f4             	lea    -0xc(%ebp),%esp
 16a:	5b                   	pop    %ebx
 16b:	5e                   	pop    %esi
 16c:	5f                   	pop    %edi
 16d:	5d                   	pop    %ebp
 16e:	c3                   	ret    

0000016f <stat>:

int
stat(char *n, struct stat *st)
{
 16f:	55                   	push   %ebp
 170:	89 e5                	mov    %esp,%ebp
 172:	56                   	push   %esi
 173:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 174:	83 ec 08             	sub    $0x8,%esp
 177:	6a 00                	push   $0x0
 179:	ff 75 08             	pushl  0x8(%ebp)
 17c:	e8 78 01 00 00       	call   2f9 <open>
  if(fd < 0)
 181:	83 c4 10             	add    $0x10,%esp
 184:	85 c0                	test   %eax,%eax
 186:	78 24                	js     1ac <stat+0x3d>
 188:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 18a:	83 ec 08             	sub    $0x8,%esp
 18d:	ff 75 0c             	pushl  0xc(%ebp)
 190:	50                   	push   %eax
 191:	e8 7b 01 00 00       	call   311 <fstat>
 196:	89 c6                	mov    %eax,%esi
  close(fd);
 198:	89 1c 24             	mov    %ebx,(%esp)
 19b:	e8 41 01 00 00       	call   2e1 <close>
  return r;
 1a0:	83 c4 10             	add    $0x10,%esp
}
 1a3:	89 f0                	mov    %esi,%eax
 1a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1a8:	5b                   	pop    %ebx
 1a9:	5e                   	pop    %esi
 1aa:	5d                   	pop    %ebp
 1ab:	c3                   	ret    
    return -1;
 1ac:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1b1:	eb f0                	jmp    1a3 <stat+0x34>

000001b3 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 1b3:	55                   	push   %ebp
 1b4:	89 e5                	mov    %esp,%ebp
 1b6:	56                   	push   %esi
 1b7:	53                   	push   %ebx
 1b8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1bb:	0f b6 0a             	movzbl (%edx),%ecx
 1be:	80 f9 20             	cmp    $0x20,%cl
 1c1:	75 0b                	jne    1ce <atoi+0x1b>
 1c3:	83 c2 01             	add    $0x1,%edx
 1c6:	0f b6 0a             	movzbl (%edx),%ecx
 1c9:	80 f9 20             	cmp    $0x20,%cl
 1cc:	74 f5                	je     1c3 <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
 1ce:	80 f9 2d             	cmp    $0x2d,%cl
 1d1:	74 3b                	je     20e <atoi+0x5b>
  if (*s == '+'  || *s == '-')
 1d3:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 1d6:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 1db:	f6 c1 fd             	test   $0xfd,%cl
 1de:	74 33                	je     213 <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
 1e0:	0f b6 0a             	movzbl (%edx),%ecx
 1e3:	8d 41 d0             	lea    -0x30(%ecx),%eax
 1e6:	3c 09                	cmp    $0x9,%al
 1e8:	77 2e                	ja     218 <atoi+0x65>
 1ea:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 1ef:	83 c2 01             	add    $0x1,%edx
 1f2:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1f5:	0f be c9             	movsbl %cl,%ecx
 1f8:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 1fc:	0f b6 0a             	movzbl (%edx),%ecx
 1ff:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 202:	80 fb 09             	cmp    $0x9,%bl
 205:	76 e8                	jbe    1ef <atoi+0x3c>
  return sign*n;
 207:	0f af c6             	imul   %esi,%eax
}
 20a:	5b                   	pop    %ebx
 20b:	5e                   	pop    %esi
 20c:	5d                   	pop    %ebp
 20d:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 20e:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 213:	83 c2 01             	add    $0x1,%edx
 216:	eb c8                	jmp    1e0 <atoi+0x2d>
  while('0' <= *s && *s <= '9')
 218:	b8 00 00 00 00       	mov    $0x0,%eax
 21d:	eb e8                	jmp    207 <atoi+0x54>

0000021f <atoo>:

int
atoo(const char *s)
{
 21f:	55                   	push   %ebp
 220:	89 e5                	mov    %esp,%ebp
 222:	56                   	push   %esi
 223:	53                   	push   %ebx
 224:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 227:	0f b6 0a             	movzbl (%edx),%ecx
 22a:	80 f9 20             	cmp    $0x20,%cl
 22d:	75 0b                	jne    23a <atoo+0x1b>
 22f:	83 c2 01             	add    $0x1,%edx
 232:	0f b6 0a             	movzbl (%edx),%ecx
 235:	80 f9 20             	cmp    $0x20,%cl
 238:	74 f5                	je     22f <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
 23a:	80 f9 2d             	cmp    $0x2d,%cl
 23d:	74 38                	je     277 <atoo+0x58>
  if (*s == '+'  || *s == '-')
 23f:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 242:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 247:	f6 c1 fd             	test   $0xfd,%cl
 24a:	74 30                	je     27c <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
 24c:	0f b6 0a             	movzbl (%edx),%ecx
 24f:	8d 41 d0             	lea    -0x30(%ecx),%eax
 252:	3c 07                	cmp    $0x7,%al
 254:	77 2b                	ja     281 <atoo+0x62>
 256:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
 25b:	83 c2 01             	add    $0x1,%edx
 25e:	0f be c9             	movsbl %cl,%ecx
 261:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 265:	0f b6 0a             	movzbl (%edx),%ecx
 268:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 26b:	80 fb 07             	cmp    $0x7,%bl
 26e:	76 eb                	jbe    25b <atoo+0x3c>
  return sign*n;
 270:	0f af c6             	imul   %esi,%eax
}
 273:	5b                   	pop    %ebx
 274:	5e                   	pop    %esi
 275:	5d                   	pop    %ebp
 276:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 277:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 27c:	83 c2 01             	add    $0x1,%edx
 27f:	eb cb                	jmp    24c <atoo+0x2d>
  while('0' <= *s && *s <= '7')
 281:	b8 00 00 00 00       	mov    $0x0,%eax
 286:	eb e8                	jmp    270 <atoo+0x51>

00000288 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 288:	55                   	push   %ebp
 289:	89 e5                	mov    %esp,%ebp
 28b:	56                   	push   %esi
 28c:	53                   	push   %ebx
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
 290:	8b 75 0c             	mov    0xc(%ebp),%esi
 293:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 296:	85 db                	test   %ebx,%ebx
 298:	7e 13                	jle    2ad <memmove+0x25>
 29a:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 29f:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2a3:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2a6:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2a9:	39 d3                	cmp    %edx,%ebx
 2ab:	75 f2                	jne    29f <memmove+0x17>
  return vdst;
}
 2ad:	5b                   	pop    %ebx
 2ae:	5e                   	pop    %esi
 2af:	5d                   	pop    %ebp
 2b0:	c3                   	ret    

000002b1 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b1:	b8 01 00 00 00       	mov    $0x1,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret    

000002b9 <exit>:
SYSCALL(exit)
 2b9:	b8 02 00 00 00       	mov    $0x2,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <wait>:
SYSCALL(wait)
 2c1:	b8 03 00 00 00       	mov    $0x3,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <pipe>:
SYSCALL(pipe)
 2c9:	b8 04 00 00 00       	mov    $0x4,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <read>:
SYSCALL(read)
 2d1:	b8 05 00 00 00       	mov    $0x5,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <write>:
SYSCALL(write)
 2d9:	b8 10 00 00 00       	mov    $0x10,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <close>:
SYSCALL(close)
 2e1:	b8 15 00 00 00       	mov    $0x15,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <kill>:
SYSCALL(kill)
 2e9:	b8 06 00 00 00       	mov    $0x6,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <exec>:
SYSCALL(exec)
 2f1:	b8 07 00 00 00       	mov    $0x7,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <open>:
SYSCALL(open)
 2f9:	b8 0f 00 00 00       	mov    $0xf,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <mknod>:
SYSCALL(mknod)
 301:	b8 11 00 00 00       	mov    $0x11,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <unlink>:
SYSCALL(unlink)
 309:	b8 12 00 00 00       	mov    $0x12,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <fstat>:
SYSCALL(fstat)
 311:	b8 08 00 00 00       	mov    $0x8,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <link>:
SYSCALL(link)
 319:	b8 13 00 00 00       	mov    $0x13,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <mkdir>:
SYSCALL(mkdir)
 321:	b8 14 00 00 00       	mov    $0x14,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <chdir>:
SYSCALL(chdir)
 329:	b8 09 00 00 00       	mov    $0x9,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <dup>:
SYSCALL(dup)
 331:	b8 0a 00 00 00       	mov    $0xa,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <getpid>:
SYSCALL(getpid)
 339:	b8 0b 00 00 00       	mov    $0xb,%eax
 33e:	cd 40                	int    $0x40
 340:	c3                   	ret    

00000341 <sbrk>:
SYSCALL(sbrk)
 341:	b8 0c 00 00 00       	mov    $0xc,%eax
 346:	cd 40                	int    $0x40
 348:	c3                   	ret    

00000349 <sleep>:
SYSCALL(sleep)
 349:	b8 0d 00 00 00       	mov    $0xd,%eax
 34e:	cd 40                	int    $0x40
 350:	c3                   	ret    

00000351 <uptime>:
SYSCALL(uptime)
 351:	b8 0e 00 00 00       	mov    $0xe,%eax
 356:	cd 40                	int    $0x40
 358:	c3                   	ret    

00000359 <halt>:
SYSCALL(halt)
 359:	b8 16 00 00 00       	mov    $0x16,%eax
 35e:	cd 40                	int    $0x40
 360:	c3                   	ret    

00000361 <date>:
SYSCALL(date)
 361:	b8 17 00 00 00       	mov    $0x17,%eax
 366:	cd 40                	int    $0x40
 368:	c3                   	ret    

00000369 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 369:	55                   	push   %ebp
 36a:	89 e5                	mov    %esp,%ebp
 36c:	57                   	push   %edi
 36d:	56                   	push   %esi
 36e:	53                   	push   %ebx
 36f:	83 ec 3c             	sub    $0x3c,%esp
 372:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 374:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 378:	74 14                	je     38e <printint+0x25>
 37a:	85 d2                	test   %edx,%edx
 37c:	79 10                	jns    38e <printint+0x25>
    neg = 1;
    x = -xx;
 37e:	f7 da                	neg    %edx
    neg = 1;
 380:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 387:	bf 00 00 00 00       	mov    $0x0,%edi
 38c:	eb 0b                	jmp    399 <printint+0x30>
  neg = 0;
 38e:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 395:	eb f0                	jmp    387 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 397:	89 df                	mov    %ebx,%edi
 399:	8d 5f 01             	lea    0x1(%edi),%ebx
 39c:	89 d0                	mov    %edx,%eax
 39e:	ba 00 00 00 00       	mov    $0x0,%edx
 3a3:	f7 f1                	div    %ecx
 3a5:	0f b6 92 3c 07 00 00 	movzbl 0x73c(%edx),%edx
 3ac:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 3b0:	89 c2                	mov    %eax,%edx
 3b2:	85 c0                	test   %eax,%eax
 3b4:	75 e1                	jne    397 <printint+0x2e>
  if(neg)
 3b6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 3ba:	74 08                	je     3c4 <printint+0x5b>
    buf[i++] = '-';
 3bc:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3c1:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 3c4:	83 eb 01             	sub    $0x1,%ebx
 3c7:	78 22                	js     3eb <printint+0x82>
  write(fd, &c, 1);
 3c9:	8d 7d d7             	lea    -0x29(%ebp),%edi
 3cc:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 3d1:	88 45 d7             	mov    %al,-0x29(%ebp)
 3d4:	83 ec 04             	sub    $0x4,%esp
 3d7:	6a 01                	push   $0x1
 3d9:	57                   	push   %edi
 3da:	56                   	push   %esi
 3db:	e8 f9 fe ff ff       	call   2d9 <write>
  while(--i >= 0)
 3e0:	83 eb 01             	sub    $0x1,%ebx
 3e3:	83 c4 10             	add    $0x10,%esp
 3e6:	83 fb ff             	cmp    $0xffffffff,%ebx
 3e9:	75 e1                	jne    3cc <printint+0x63>
    putc(fd, buf[i]);
}
 3eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3ee:	5b                   	pop    %ebx
 3ef:	5e                   	pop    %esi
 3f0:	5f                   	pop    %edi
 3f1:	5d                   	pop    %ebp
 3f2:	c3                   	ret    

000003f3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3f3:	55                   	push   %ebp
 3f4:	89 e5                	mov    %esp,%ebp
 3f6:	57                   	push   %edi
 3f7:	56                   	push   %esi
 3f8:	53                   	push   %ebx
 3f9:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3fc:	8b 75 0c             	mov    0xc(%ebp),%esi
 3ff:	0f b6 1e             	movzbl (%esi),%ebx
 402:	84 db                	test   %bl,%bl
 404:	0f 84 b1 01 00 00    	je     5bb <printf+0x1c8>
 40a:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 40d:	8d 45 10             	lea    0x10(%ebp),%eax
 410:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 413:	bf 00 00 00 00       	mov    $0x0,%edi
 418:	eb 2d                	jmp    447 <printf+0x54>
 41a:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 41d:	83 ec 04             	sub    $0x4,%esp
 420:	6a 01                	push   $0x1
 422:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 425:	50                   	push   %eax
 426:	ff 75 08             	pushl  0x8(%ebp)
 429:	e8 ab fe ff ff       	call   2d9 <write>
 42e:	83 c4 10             	add    $0x10,%esp
 431:	eb 05                	jmp    438 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 433:	83 ff 25             	cmp    $0x25,%edi
 436:	74 22                	je     45a <printf+0x67>
 438:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 43b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 43f:	84 db                	test   %bl,%bl
 441:	0f 84 74 01 00 00    	je     5bb <printf+0x1c8>
    c = fmt[i] & 0xff;
 447:	0f be d3             	movsbl %bl,%edx
 44a:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 44d:	85 ff                	test   %edi,%edi
 44f:	75 e2                	jne    433 <printf+0x40>
      if(c == '%'){
 451:	83 f8 25             	cmp    $0x25,%eax
 454:	75 c4                	jne    41a <printf+0x27>
        state = '%';
 456:	89 c7                	mov    %eax,%edi
 458:	eb de                	jmp    438 <printf+0x45>
      if(c == 'd'){
 45a:	83 f8 64             	cmp    $0x64,%eax
 45d:	74 59                	je     4b8 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 45f:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 465:	83 fa 70             	cmp    $0x70,%edx
 468:	74 7a                	je     4e4 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 46a:	83 f8 73             	cmp    $0x73,%eax
 46d:	0f 84 9d 00 00 00    	je     510 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 473:	83 f8 63             	cmp    $0x63,%eax
 476:	0f 84 f2 00 00 00    	je     56e <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 47c:	83 f8 25             	cmp    $0x25,%eax
 47f:	0f 84 15 01 00 00    	je     59a <printf+0x1a7>
 485:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 489:	83 ec 04             	sub    $0x4,%esp
 48c:	6a 01                	push   $0x1
 48e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 491:	50                   	push   %eax
 492:	ff 75 08             	pushl  0x8(%ebp)
 495:	e8 3f fe ff ff       	call   2d9 <write>
 49a:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 49d:	83 c4 0c             	add    $0xc,%esp
 4a0:	6a 01                	push   $0x1
 4a2:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4a5:	50                   	push   %eax
 4a6:	ff 75 08             	pushl  0x8(%ebp)
 4a9:	e8 2b fe ff ff       	call   2d9 <write>
 4ae:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4b1:	bf 00 00 00 00       	mov    $0x0,%edi
 4b6:	eb 80                	jmp    438 <printf+0x45>
        printint(fd, *ap, 10, 1);
 4b8:	83 ec 0c             	sub    $0xc,%esp
 4bb:	6a 01                	push   $0x1
 4bd:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4c2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4c5:	8b 17                	mov    (%edi),%edx
 4c7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ca:	e8 9a fe ff ff       	call   369 <printint>
        ap++;
 4cf:	89 f8                	mov    %edi,%eax
 4d1:	83 c0 04             	add    $0x4,%eax
 4d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4d7:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4da:	bf 00 00 00 00       	mov    $0x0,%edi
 4df:	e9 54 ff ff ff       	jmp    438 <printf+0x45>
        printint(fd, *ap, 16, 0);
 4e4:	83 ec 0c             	sub    $0xc,%esp
 4e7:	6a 00                	push   $0x0
 4e9:	b9 10 00 00 00       	mov    $0x10,%ecx
 4ee:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4f1:	8b 17                	mov    (%edi),%edx
 4f3:	8b 45 08             	mov    0x8(%ebp),%eax
 4f6:	e8 6e fe ff ff       	call   369 <printint>
        ap++;
 4fb:	89 f8                	mov    %edi,%eax
 4fd:	83 c0 04             	add    $0x4,%eax
 500:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 503:	83 c4 10             	add    $0x10,%esp
      state = 0;
 506:	bf 00 00 00 00       	mov    $0x0,%edi
 50b:	e9 28 ff ff ff       	jmp    438 <printf+0x45>
        s = (char*)*ap;
 510:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 513:	8b 01                	mov    (%ecx),%eax
        ap++;
 515:	83 c1 04             	add    $0x4,%ecx
 518:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 51b:	85 c0                	test   %eax,%eax
 51d:	74 13                	je     532 <printf+0x13f>
        s = (char*)*ap;
 51f:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 521:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 524:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 529:	84 c0                	test   %al,%al
 52b:	75 0f                	jne    53c <printf+0x149>
 52d:	e9 06 ff ff ff       	jmp    438 <printf+0x45>
          s = "(null)";
 532:	bb 33 07 00 00       	mov    $0x733,%ebx
        while(*s != 0){
 537:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 53c:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 53f:	89 75 d0             	mov    %esi,-0x30(%ebp)
 542:	8b 75 08             	mov    0x8(%ebp),%esi
 545:	88 45 e3             	mov    %al,-0x1d(%ebp)
 548:	83 ec 04             	sub    $0x4,%esp
 54b:	6a 01                	push   $0x1
 54d:	57                   	push   %edi
 54e:	56                   	push   %esi
 54f:	e8 85 fd ff ff       	call   2d9 <write>
          s++;
 554:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 557:	0f b6 03             	movzbl (%ebx),%eax
 55a:	83 c4 10             	add    $0x10,%esp
 55d:	84 c0                	test   %al,%al
 55f:	75 e4                	jne    545 <printf+0x152>
 561:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 564:	bf 00 00 00 00       	mov    $0x0,%edi
 569:	e9 ca fe ff ff       	jmp    438 <printf+0x45>
        putc(fd, *ap);
 56e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 571:	8b 07                	mov    (%edi),%eax
 573:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 576:	83 ec 04             	sub    $0x4,%esp
 579:	6a 01                	push   $0x1
 57b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 57e:	50                   	push   %eax
 57f:	ff 75 08             	pushl  0x8(%ebp)
 582:	e8 52 fd ff ff       	call   2d9 <write>
        ap++;
 587:	83 c7 04             	add    $0x4,%edi
 58a:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 58d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 590:	bf 00 00 00 00       	mov    $0x0,%edi
 595:	e9 9e fe ff ff       	jmp    438 <printf+0x45>
 59a:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 59d:	83 ec 04             	sub    $0x4,%esp
 5a0:	6a 01                	push   $0x1
 5a2:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5a5:	50                   	push   %eax
 5a6:	ff 75 08             	pushl  0x8(%ebp)
 5a9:	e8 2b fd ff ff       	call   2d9 <write>
 5ae:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5b1:	bf 00 00 00 00       	mov    $0x0,%edi
 5b6:	e9 7d fe ff ff       	jmp    438 <printf+0x45>
    }
  }
}
 5bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5be:	5b                   	pop    %ebx
 5bf:	5e                   	pop    %esi
 5c0:	5f                   	pop    %edi
 5c1:	5d                   	pop    %ebp
 5c2:	c3                   	ret    

000005c3 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5c3:	55                   	push   %ebp
 5c4:	89 e5                	mov    %esp,%ebp
 5c6:	57                   	push   %edi
 5c7:	56                   	push   %esi
 5c8:	53                   	push   %ebx
 5c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5cc:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5cf:	a1 d8 09 00 00       	mov    0x9d8,%eax
 5d4:	eb 0c                	jmp    5e2 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d6:	8b 10                	mov    (%eax),%edx
 5d8:	39 c2                	cmp    %eax,%edx
 5da:	77 04                	ja     5e0 <free+0x1d>
 5dc:	39 ca                	cmp    %ecx,%edx
 5de:	77 10                	ja     5f0 <free+0x2d>
{
 5e0:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e2:	39 c8                	cmp    %ecx,%eax
 5e4:	73 f0                	jae    5d6 <free+0x13>
 5e6:	8b 10                	mov    (%eax),%edx
 5e8:	39 ca                	cmp    %ecx,%edx
 5ea:	77 04                	ja     5f0 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ec:	39 c2                	cmp    %eax,%edx
 5ee:	77 f0                	ja     5e0 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5f0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5f3:	8b 10                	mov    (%eax),%edx
 5f5:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5f8:	39 fa                	cmp    %edi,%edx
 5fa:	74 19                	je     615 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5fc:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5ff:	8b 50 04             	mov    0x4(%eax),%edx
 602:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 605:	39 f1                	cmp    %esi,%ecx
 607:	74 1b                	je     624 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 609:	89 08                	mov    %ecx,(%eax)
  freep = p;
 60b:	a3 d8 09 00 00       	mov    %eax,0x9d8
}
 610:	5b                   	pop    %ebx
 611:	5e                   	pop    %esi
 612:	5f                   	pop    %edi
 613:	5d                   	pop    %ebp
 614:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 615:	03 72 04             	add    0x4(%edx),%esi
 618:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 61b:	8b 10                	mov    (%eax),%edx
 61d:	8b 12                	mov    (%edx),%edx
 61f:	89 53 f8             	mov    %edx,-0x8(%ebx)
 622:	eb db                	jmp    5ff <free+0x3c>
    p->s.size += bp->s.size;
 624:	03 53 fc             	add    -0x4(%ebx),%edx
 627:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 62a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 62d:	89 10                	mov    %edx,(%eax)
 62f:	eb da                	jmp    60b <free+0x48>

00000631 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 631:	55                   	push   %ebp
 632:	89 e5                	mov    %esp,%ebp
 634:	57                   	push   %edi
 635:	56                   	push   %esi
 636:	53                   	push   %ebx
 637:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 63a:	8b 45 08             	mov    0x8(%ebp),%eax
 63d:	8d 58 07             	lea    0x7(%eax),%ebx
 640:	c1 eb 03             	shr    $0x3,%ebx
 643:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 646:	8b 15 d8 09 00 00    	mov    0x9d8,%edx
 64c:	85 d2                	test   %edx,%edx
 64e:	74 20                	je     670 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 650:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 652:	8b 48 04             	mov    0x4(%eax),%ecx
 655:	39 cb                	cmp    %ecx,%ebx
 657:	76 3c                	jbe    695 <malloc+0x64>
 659:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 65f:	be 00 10 00 00       	mov    $0x1000,%esi
 664:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 667:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 66e:	eb 70                	jmp    6e0 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 670:	c7 05 d8 09 00 00 dc 	movl   $0x9dc,0x9d8
 677:	09 00 00 
 67a:	c7 05 dc 09 00 00 dc 	movl   $0x9dc,0x9dc
 681:	09 00 00 
    base.s.size = 0;
 684:	c7 05 e0 09 00 00 00 	movl   $0x0,0x9e0
 68b:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 68e:	ba dc 09 00 00       	mov    $0x9dc,%edx
 693:	eb bb                	jmp    650 <malloc+0x1f>
      if(p->s.size == nunits)
 695:	39 cb                	cmp    %ecx,%ebx
 697:	74 1c                	je     6b5 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 699:	29 d9                	sub    %ebx,%ecx
 69b:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 69e:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6a1:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6a4:	89 15 d8 09 00 00    	mov    %edx,0x9d8
      return (void*)(p + 1);
 6aa:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6b0:	5b                   	pop    %ebx
 6b1:	5e                   	pop    %esi
 6b2:	5f                   	pop    %edi
 6b3:	5d                   	pop    %ebp
 6b4:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6b5:	8b 08                	mov    (%eax),%ecx
 6b7:	89 0a                	mov    %ecx,(%edx)
 6b9:	eb e9                	jmp    6a4 <malloc+0x73>
  hp->s.size = nu;
 6bb:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 6be:	83 ec 0c             	sub    $0xc,%esp
 6c1:	83 c0 08             	add    $0x8,%eax
 6c4:	50                   	push   %eax
 6c5:	e8 f9 fe ff ff       	call   5c3 <free>
  return freep;
 6ca:	8b 15 d8 09 00 00    	mov    0x9d8,%edx
      if((p = morecore(nunits)) == 0)
 6d0:	83 c4 10             	add    $0x10,%esp
 6d3:	85 d2                	test   %edx,%edx
 6d5:	74 2b                	je     702 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d7:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6d9:	8b 48 04             	mov    0x4(%eax),%ecx
 6dc:	39 d9                	cmp    %ebx,%ecx
 6de:	73 b5                	jae    695 <malloc+0x64>
 6e0:	89 c2                	mov    %eax,%edx
    if(p == freep)
 6e2:	39 05 d8 09 00 00    	cmp    %eax,0x9d8
 6e8:	75 ed                	jne    6d7 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 6ea:	83 ec 0c             	sub    $0xc,%esp
 6ed:	57                   	push   %edi
 6ee:	e8 4e fc ff ff       	call   341 <sbrk>
  if(p == (char*)-1)
 6f3:	83 c4 10             	add    $0x10,%esp
 6f6:	83 f8 ff             	cmp    $0xffffffff,%eax
 6f9:	75 c0                	jne    6bb <malloc+0x8a>
        return 0;
 6fb:	b8 00 00 00 00       	mov    $0x0,%eax
 700:	eb ab                	jmp    6ad <malloc+0x7c>
 702:	b8 00 00 00 00       	mov    $0x0,%eax
 707:	eb a4                	jmp    6ad <malloc+0x7c>
