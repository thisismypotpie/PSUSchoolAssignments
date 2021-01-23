
_echo:     file format elf32-i386


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
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 01                	mov    (%ecx),%eax
  16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  19:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  for(i = 1; i < argc; i++)
  1c:	83 f8 01             	cmp    $0x1,%eax
  1f:	7e 41                	jle    62 <main+0x62>
  21:	8d 5f 04             	lea    0x4(%edi),%ebx
  24:	8d 74 87 fc          	lea    -0x4(%edi,%eax,4),%esi
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  28:	39 f3                	cmp    %esi,%ebx
  2a:	74 1b                	je     47 <main+0x47>
  2c:	68 14 07 00 00       	push   $0x714
  31:	ff 33                	pushl  (%ebx)
  33:	68 16 07 00 00       	push   $0x716
  38:	6a 01                	push   $0x1
  3a:	e8 bf 03 00 00       	call   3fe <printf>
  3f:	83 c3 04             	add    $0x4,%ebx
  42:	83 c4 10             	add    $0x10,%esp
  45:	eb e1                	jmp    28 <main+0x28>
  47:	68 1b 07 00 00       	push   $0x71b
  4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  4f:	ff 74 87 fc          	pushl  -0x4(%edi,%eax,4)
  53:	68 16 07 00 00       	push   $0x716
  58:	6a 01                	push   $0x1
  5a:	e8 9f 03 00 00       	call   3fe <printf>
  5f:	83 c4 10             	add    $0x10,%esp
  exit();
  62:	e8 5d 02 00 00       	call   2c4 <exit>

00000067 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  67:	55                   	push   %ebp
  68:	89 e5                	mov    %esp,%ebp
  6a:	53                   	push   %ebx
  6b:	8b 45 08             	mov    0x8(%ebp),%eax
  6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  71:	89 c2                	mov    %eax,%edx
  73:	83 c1 01             	add    $0x1,%ecx
  76:	83 c2 01             	add    $0x1,%edx
  79:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  7d:	88 5a ff             	mov    %bl,-0x1(%edx)
  80:	84 db                	test   %bl,%bl
  82:	75 ef                	jne    73 <strcpy+0xc>
    ;
  return os;
}
  84:	5b                   	pop    %ebx
  85:	5d                   	pop    %ebp
  86:	c3                   	ret    

00000087 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  87:	55                   	push   %ebp
  88:	89 e5                	mov    %esp,%ebp
  8a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  90:	0f b6 01             	movzbl (%ecx),%eax
  93:	84 c0                	test   %al,%al
  95:	74 15                	je     ac <strcmp+0x25>
  97:	3a 02                	cmp    (%edx),%al
  99:	75 11                	jne    ac <strcmp+0x25>
    p++, q++;
  9b:	83 c1 01             	add    $0x1,%ecx
  9e:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  a1:	0f b6 01             	movzbl (%ecx),%eax
  a4:	84 c0                	test   %al,%al
  a6:	74 04                	je     ac <strcmp+0x25>
  a8:	3a 02                	cmp    (%edx),%al
  aa:	74 ef                	je     9b <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  ac:	0f b6 c0             	movzbl %al,%eax
  af:	0f b6 12             	movzbl (%edx),%edx
  b2:	29 d0                	sub    %edx,%eax
}
  b4:	5d                   	pop    %ebp
  b5:	c3                   	ret    

000000b6 <strlen>:

uint
strlen(char *s)
{
  b6:	55                   	push   %ebp
  b7:	89 e5                	mov    %esp,%ebp
  b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  bc:	80 39 00             	cmpb   $0x0,(%ecx)
  bf:	74 12                	je     d3 <strlen+0x1d>
  c1:	ba 00 00 00 00       	mov    $0x0,%edx
  c6:	83 c2 01             	add    $0x1,%edx
  c9:	89 d0                	mov    %edx,%eax
  cb:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  cf:	75 f5                	jne    c6 <strlen+0x10>
    ;
  return n;
}
  d1:	5d                   	pop    %ebp
  d2:	c3                   	ret    
  for(n = 0; s[n]; n++)
  d3:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
  d8:	eb f7                	jmp    d1 <strlen+0x1b>

000000da <memset>:

void*
memset(void *dst, int c, uint n)
{
  da:	55                   	push   %ebp
  db:	89 e5                	mov    %esp,%ebp
  dd:	57                   	push   %edi
  de:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  e1:	89 d7                	mov    %edx,%edi
  e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  e9:	fc                   	cld    
  ea:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  ec:	89 d0                	mov    %edx,%eax
  ee:	5f                   	pop    %edi
  ef:	5d                   	pop    %ebp
  f0:	c3                   	ret    

000000f1 <strchr>:

char*
strchr(const char *s, char c)
{
  f1:	55                   	push   %ebp
  f2:	89 e5                	mov    %esp,%ebp
  f4:	53                   	push   %ebx
  f5:	8b 45 08             	mov    0x8(%ebp),%eax
  f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
  fb:	0f b6 10             	movzbl (%eax),%edx
  fe:	84 d2                	test   %dl,%dl
 100:	74 1e                	je     120 <strchr+0x2f>
 102:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 104:	38 d3                	cmp    %dl,%bl
 106:	74 15                	je     11d <strchr+0x2c>
  for(; *s; s++)
 108:	83 c0 01             	add    $0x1,%eax
 10b:	0f b6 10             	movzbl (%eax),%edx
 10e:	84 d2                	test   %dl,%dl
 110:	74 06                	je     118 <strchr+0x27>
    if(*s == c)
 112:	38 ca                	cmp    %cl,%dl
 114:	75 f2                	jne    108 <strchr+0x17>
 116:	eb 05                	jmp    11d <strchr+0x2c>
      return (char*)s;
  return 0;
 118:	b8 00 00 00 00       	mov    $0x0,%eax
}
 11d:	5b                   	pop    %ebx
 11e:	5d                   	pop    %ebp
 11f:	c3                   	ret    
  return 0;
 120:	b8 00 00 00 00       	mov    $0x0,%eax
 125:	eb f6                	jmp    11d <strchr+0x2c>

00000127 <gets>:

char*
gets(char *buf, int max)
{
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	57                   	push   %edi
 12b:	56                   	push   %esi
 12c:	53                   	push   %ebx
 12d:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 130:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 135:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 138:	8d 5e 01             	lea    0x1(%esi),%ebx
 13b:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 13e:	7d 2b                	jge    16b <gets+0x44>
    cc = read(0, &c, 1);
 140:	83 ec 04             	sub    $0x4,%esp
 143:	6a 01                	push   $0x1
 145:	57                   	push   %edi
 146:	6a 00                	push   $0x0
 148:	e8 8f 01 00 00       	call   2dc <read>
    if(cc < 1)
 14d:	83 c4 10             	add    $0x10,%esp
 150:	85 c0                	test   %eax,%eax
 152:	7e 17                	jle    16b <gets+0x44>
      break;
    buf[i++] = c;
 154:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 158:	8b 55 08             	mov    0x8(%ebp),%edx
 15b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 15f:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 161:	3c 0a                	cmp    $0xa,%al
 163:	74 04                	je     169 <gets+0x42>
 165:	3c 0d                	cmp    $0xd,%al
 167:	75 cf                	jne    138 <gets+0x11>
  for(i=0; i+1 < max; ){
 169:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 172:	8d 65 f4             	lea    -0xc(%ebp),%esp
 175:	5b                   	pop    %ebx
 176:	5e                   	pop    %esi
 177:	5f                   	pop    %edi
 178:	5d                   	pop    %ebp
 179:	c3                   	ret    

0000017a <stat>:

int
stat(char *n, struct stat *st)
{
 17a:	55                   	push   %ebp
 17b:	89 e5                	mov    %esp,%ebp
 17d:	56                   	push   %esi
 17e:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17f:	83 ec 08             	sub    $0x8,%esp
 182:	6a 00                	push   $0x0
 184:	ff 75 08             	pushl  0x8(%ebp)
 187:	e8 78 01 00 00       	call   304 <open>
  if(fd < 0)
 18c:	83 c4 10             	add    $0x10,%esp
 18f:	85 c0                	test   %eax,%eax
 191:	78 24                	js     1b7 <stat+0x3d>
 193:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 195:	83 ec 08             	sub    $0x8,%esp
 198:	ff 75 0c             	pushl  0xc(%ebp)
 19b:	50                   	push   %eax
 19c:	e8 7b 01 00 00       	call   31c <fstat>
 1a1:	89 c6                	mov    %eax,%esi
  close(fd);
 1a3:	89 1c 24             	mov    %ebx,(%esp)
 1a6:	e8 41 01 00 00       	call   2ec <close>
  return r;
 1ab:	83 c4 10             	add    $0x10,%esp
}
 1ae:	89 f0                	mov    %esi,%eax
 1b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1b3:	5b                   	pop    %ebx
 1b4:	5e                   	pop    %esi
 1b5:	5d                   	pop    %ebp
 1b6:	c3                   	ret    
    return -1;
 1b7:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1bc:	eb f0                	jmp    1ae <stat+0x34>

000001be <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 1be:	55                   	push   %ebp
 1bf:	89 e5                	mov    %esp,%ebp
 1c1:	56                   	push   %esi
 1c2:	53                   	push   %ebx
 1c3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1c6:	0f b6 0a             	movzbl (%edx),%ecx
 1c9:	80 f9 20             	cmp    $0x20,%cl
 1cc:	75 0b                	jne    1d9 <atoi+0x1b>
 1ce:	83 c2 01             	add    $0x1,%edx
 1d1:	0f b6 0a             	movzbl (%edx),%ecx
 1d4:	80 f9 20             	cmp    $0x20,%cl
 1d7:	74 f5                	je     1ce <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
 1d9:	80 f9 2d             	cmp    $0x2d,%cl
 1dc:	74 3b                	je     219 <atoi+0x5b>
  if (*s == '+'  || *s == '-')
 1de:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 1e1:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 1e6:	f6 c1 fd             	test   $0xfd,%cl
 1e9:	74 33                	je     21e <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
 1eb:	0f b6 0a             	movzbl (%edx),%ecx
 1ee:	8d 41 d0             	lea    -0x30(%ecx),%eax
 1f1:	3c 09                	cmp    $0x9,%al
 1f3:	77 2e                	ja     223 <atoi+0x65>
 1f5:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 1fa:	83 c2 01             	add    $0x1,%edx
 1fd:	8d 04 80             	lea    (%eax,%eax,4),%eax
 200:	0f be c9             	movsbl %cl,%ecx
 203:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 207:	0f b6 0a             	movzbl (%edx),%ecx
 20a:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 20d:	80 fb 09             	cmp    $0x9,%bl
 210:	76 e8                	jbe    1fa <atoi+0x3c>
  return sign*n;
 212:	0f af c6             	imul   %esi,%eax
}
 215:	5b                   	pop    %ebx
 216:	5e                   	pop    %esi
 217:	5d                   	pop    %ebp
 218:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 219:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 21e:	83 c2 01             	add    $0x1,%edx
 221:	eb c8                	jmp    1eb <atoi+0x2d>
  while('0' <= *s && *s <= '9')
 223:	b8 00 00 00 00       	mov    $0x0,%eax
 228:	eb e8                	jmp    212 <atoi+0x54>

0000022a <atoo>:

int
atoo(const char *s)
{
 22a:	55                   	push   %ebp
 22b:	89 e5                	mov    %esp,%ebp
 22d:	56                   	push   %esi
 22e:	53                   	push   %ebx
 22f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 232:	0f b6 0a             	movzbl (%edx),%ecx
 235:	80 f9 20             	cmp    $0x20,%cl
 238:	75 0b                	jne    245 <atoo+0x1b>
 23a:	83 c2 01             	add    $0x1,%edx
 23d:	0f b6 0a             	movzbl (%edx),%ecx
 240:	80 f9 20             	cmp    $0x20,%cl
 243:	74 f5                	je     23a <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
 245:	80 f9 2d             	cmp    $0x2d,%cl
 248:	74 38                	je     282 <atoo+0x58>
  if (*s == '+'  || *s == '-')
 24a:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 24d:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 252:	f6 c1 fd             	test   $0xfd,%cl
 255:	74 30                	je     287 <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
 257:	0f b6 0a             	movzbl (%edx),%ecx
 25a:	8d 41 d0             	lea    -0x30(%ecx),%eax
 25d:	3c 07                	cmp    $0x7,%al
 25f:	77 2b                	ja     28c <atoo+0x62>
 261:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
 266:	83 c2 01             	add    $0x1,%edx
 269:	0f be c9             	movsbl %cl,%ecx
 26c:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 270:	0f b6 0a             	movzbl (%edx),%ecx
 273:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 276:	80 fb 07             	cmp    $0x7,%bl
 279:	76 eb                	jbe    266 <atoo+0x3c>
  return sign*n;
 27b:	0f af c6             	imul   %esi,%eax
}
 27e:	5b                   	pop    %ebx
 27f:	5e                   	pop    %esi
 280:	5d                   	pop    %ebp
 281:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 282:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 287:	83 c2 01             	add    $0x1,%edx
 28a:	eb cb                	jmp    257 <atoo+0x2d>
  while('0' <= *s && *s <= '7')
 28c:	b8 00 00 00 00       	mov    $0x0,%eax
 291:	eb e8                	jmp    27b <atoo+0x51>

00000293 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 293:	55                   	push   %ebp
 294:	89 e5                	mov    %esp,%ebp
 296:	56                   	push   %esi
 297:	53                   	push   %ebx
 298:	8b 45 08             	mov    0x8(%ebp),%eax
 29b:	8b 75 0c             	mov    0xc(%ebp),%esi
 29e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2a1:	85 db                	test   %ebx,%ebx
 2a3:	7e 13                	jle    2b8 <memmove+0x25>
 2a5:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 2aa:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2ae:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2b1:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2b4:	39 d3                	cmp    %edx,%ebx
 2b6:	75 f2                	jne    2aa <memmove+0x17>
  return vdst;
}
 2b8:	5b                   	pop    %ebx
 2b9:	5e                   	pop    %esi
 2ba:	5d                   	pop    %ebp
 2bb:	c3                   	ret    

000002bc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2bc:	b8 01 00 00 00       	mov    $0x1,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <exit>:
SYSCALL(exit)
 2c4:	b8 02 00 00 00       	mov    $0x2,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <wait>:
SYSCALL(wait)
 2cc:	b8 03 00 00 00       	mov    $0x3,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <pipe>:
SYSCALL(pipe)
 2d4:	b8 04 00 00 00       	mov    $0x4,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <read>:
SYSCALL(read)
 2dc:	b8 05 00 00 00       	mov    $0x5,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <write>:
SYSCALL(write)
 2e4:	b8 10 00 00 00       	mov    $0x10,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <close>:
SYSCALL(close)
 2ec:	b8 15 00 00 00       	mov    $0x15,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <kill>:
SYSCALL(kill)
 2f4:	b8 06 00 00 00       	mov    $0x6,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <exec>:
SYSCALL(exec)
 2fc:	b8 07 00 00 00       	mov    $0x7,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <open>:
SYSCALL(open)
 304:	b8 0f 00 00 00       	mov    $0xf,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <mknod>:
SYSCALL(mknod)
 30c:	b8 11 00 00 00       	mov    $0x11,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <unlink>:
SYSCALL(unlink)
 314:	b8 12 00 00 00       	mov    $0x12,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <fstat>:
SYSCALL(fstat)
 31c:	b8 08 00 00 00       	mov    $0x8,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <link>:
SYSCALL(link)
 324:	b8 13 00 00 00       	mov    $0x13,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <mkdir>:
SYSCALL(mkdir)
 32c:	b8 14 00 00 00       	mov    $0x14,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <chdir>:
SYSCALL(chdir)
 334:	b8 09 00 00 00       	mov    $0x9,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <dup>:
SYSCALL(dup)
 33c:	b8 0a 00 00 00       	mov    $0xa,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <getpid>:
SYSCALL(getpid)
 344:	b8 0b 00 00 00       	mov    $0xb,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <sbrk>:
SYSCALL(sbrk)
 34c:	b8 0c 00 00 00       	mov    $0xc,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <sleep>:
SYSCALL(sleep)
 354:	b8 0d 00 00 00       	mov    $0xd,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <uptime>:
SYSCALL(uptime)
 35c:	b8 0e 00 00 00       	mov    $0xe,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <halt>:
SYSCALL(halt)
 364:	b8 16 00 00 00       	mov    $0x16,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <date>:
SYSCALL(date)
 36c:	b8 17 00 00 00       	mov    $0x17,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	57                   	push   %edi
 378:	56                   	push   %esi
 379:	53                   	push   %ebx
 37a:	83 ec 3c             	sub    $0x3c,%esp
 37d:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 37f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 383:	74 14                	je     399 <printint+0x25>
 385:	85 d2                	test   %edx,%edx
 387:	79 10                	jns    399 <printint+0x25>
    neg = 1;
    x = -xx;
 389:	f7 da                	neg    %edx
    neg = 1;
 38b:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 392:	bf 00 00 00 00       	mov    $0x0,%edi
 397:	eb 0b                	jmp    3a4 <printint+0x30>
  neg = 0;
 399:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3a0:	eb f0                	jmp    392 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 3a2:	89 df                	mov    %ebx,%edi
 3a4:	8d 5f 01             	lea    0x1(%edi),%ebx
 3a7:	89 d0                	mov    %edx,%eax
 3a9:	ba 00 00 00 00       	mov    $0x0,%edx
 3ae:	f7 f1                	div    %ecx
 3b0:	0f b6 92 24 07 00 00 	movzbl 0x724(%edx),%edx
 3b7:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 3bb:	89 c2                	mov    %eax,%edx
 3bd:	85 c0                	test   %eax,%eax
 3bf:	75 e1                	jne    3a2 <printint+0x2e>
  if(neg)
 3c1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 3c5:	74 08                	je     3cf <printint+0x5b>
    buf[i++] = '-';
 3c7:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3cc:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 3cf:	83 eb 01             	sub    $0x1,%ebx
 3d2:	78 22                	js     3f6 <printint+0x82>
  write(fd, &c, 1);
 3d4:	8d 7d d7             	lea    -0x29(%ebp),%edi
 3d7:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 3dc:	88 45 d7             	mov    %al,-0x29(%ebp)
 3df:	83 ec 04             	sub    $0x4,%esp
 3e2:	6a 01                	push   $0x1
 3e4:	57                   	push   %edi
 3e5:	56                   	push   %esi
 3e6:	e8 f9 fe ff ff       	call   2e4 <write>
  while(--i >= 0)
 3eb:	83 eb 01             	sub    $0x1,%ebx
 3ee:	83 c4 10             	add    $0x10,%esp
 3f1:	83 fb ff             	cmp    $0xffffffff,%ebx
 3f4:	75 e1                	jne    3d7 <printint+0x63>
    putc(fd, buf[i]);
}
 3f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3f9:	5b                   	pop    %ebx
 3fa:	5e                   	pop    %esi
 3fb:	5f                   	pop    %edi
 3fc:	5d                   	pop    %ebp
 3fd:	c3                   	ret    

000003fe <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3fe:	55                   	push   %ebp
 3ff:	89 e5                	mov    %esp,%ebp
 401:	57                   	push   %edi
 402:	56                   	push   %esi
 403:	53                   	push   %ebx
 404:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 407:	8b 75 0c             	mov    0xc(%ebp),%esi
 40a:	0f b6 1e             	movzbl (%esi),%ebx
 40d:	84 db                	test   %bl,%bl
 40f:	0f 84 b1 01 00 00    	je     5c6 <printf+0x1c8>
 415:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 418:	8d 45 10             	lea    0x10(%ebp),%eax
 41b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 41e:	bf 00 00 00 00       	mov    $0x0,%edi
 423:	eb 2d                	jmp    452 <printf+0x54>
 425:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 428:	83 ec 04             	sub    $0x4,%esp
 42b:	6a 01                	push   $0x1
 42d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 430:	50                   	push   %eax
 431:	ff 75 08             	pushl  0x8(%ebp)
 434:	e8 ab fe ff ff       	call   2e4 <write>
 439:	83 c4 10             	add    $0x10,%esp
 43c:	eb 05                	jmp    443 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 43e:	83 ff 25             	cmp    $0x25,%edi
 441:	74 22                	je     465 <printf+0x67>
 443:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 446:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 44a:	84 db                	test   %bl,%bl
 44c:	0f 84 74 01 00 00    	je     5c6 <printf+0x1c8>
    c = fmt[i] & 0xff;
 452:	0f be d3             	movsbl %bl,%edx
 455:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 458:	85 ff                	test   %edi,%edi
 45a:	75 e2                	jne    43e <printf+0x40>
      if(c == '%'){
 45c:	83 f8 25             	cmp    $0x25,%eax
 45f:	75 c4                	jne    425 <printf+0x27>
        state = '%';
 461:	89 c7                	mov    %eax,%edi
 463:	eb de                	jmp    443 <printf+0x45>
      if(c == 'd'){
 465:	83 f8 64             	cmp    $0x64,%eax
 468:	74 59                	je     4c3 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 46a:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 470:	83 fa 70             	cmp    $0x70,%edx
 473:	74 7a                	je     4ef <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 475:	83 f8 73             	cmp    $0x73,%eax
 478:	0f 84 9d 00 00 00    	je     51b <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 47e:	83 f8 63             	cmp    $0x63,%eax
 481:	0f 84 f2 00 00 00    	je     579 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 487:	83 f8 25             	cmp    $0x25,%eax
 48a:	0f 84 15 01 00 00    	je     5a5 <printf+0x1a7>
 490:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 494:	83 ec 04             	sub    $0x4,%esp
 497:	6a 01                	push   $0x1
 499:	8d 45 e7             	lea    -0x19(%ebp),%eax
 49c:	50                   	push   %eax
 49d:	ff 75 08             	pushl  0x8(%ebp)
 4a0:	e8 3f fe ff ff       	call   2e4 <write>
 4a5:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 4a8:	83 c4 0c             	add    $0xc,%esp
 4ab:	6a 01                	push   $0x1
 4ad:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4b0:	50                   	push   %eax
 4b1:	ff 75 08             	pushl  0x8(%ebp)
 4b4:	e8 2b fe ff ff       	call   2e4 <write>
 4b9:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4bc:	bf 00 00 00 00       	mov    $0x0,%edi
 4c1:	eb 80                	jmp    443 <printf+0x45>
        printint(fd, *ap, 10, 1);
 4c3:	83 ec 0c             	sub    $0xc,%esp
 4c6:	6a 01                	push   $0x1
 4c8:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4cd:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4d0:	8b 17                	mov    (%edi),%edx
 4d2:	8b 45 08             	mov    0x8(%ebp),%eax
 4d5:	e8 9a fe ff ff       	call   374 <printint>
        ap++;
 4da:	89 f8                	mov    %edi,%eax
 4dc:	83 c0 04             	add    $0x4,%eax
 4df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4e2:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4e5:	bf 00 00 00 00       	mov    $0x0,%edi
 4ea:	e9 54 ff ff ff       	jmp    443 <printf+0x45>
        printint(fd, *ap, 16, 0);
 4ef:	83 ec 0c             	sub    $0xc,%esp
 4f2:	6a 00                	push   $0x0
 4f4:	b9 10 00 00 00       	mov    $0x10,%ecx
 4f9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4fc:	8b 17                	mov    (%edi),%edx
 4fe:	8b 45 08             	mov    0x8(%ebp),%eax
 501:	e8 6e fe ff ff       	call   374 <printint>
        ap++;
 506:	89 f8                	mov    %edi,%eax
 508:	83 c0 04             	add    $0x4,%eax
 50b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 50e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 511:	bf 00 00 00 00       	mov    $0x0,%edi
 516:	e9 28 ff ff ff       	jmp    443 <printf+0x45>
        s = (char*)*ap;
 51b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 51e:	8b 01                	mov    (%ecx),%eax
        ap++;
 520:	83 c1 04             	add    $0x4,%ecx
 523:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 526:	85 c0                	test   %eax,%eax
 528:	74 13                	je     53d <printf+0x13f>
        s = (char*)*ap;
 52a:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 52c:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 52f:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 534:	84 c0                	test   %al,%al
 536:	75 0f                	jne    547 <printf+0x149>
 538:	e9 06 ff ff ff       	jmp    443 <printf+0x45>
          s = "(null)";
 53d:	bb 1d 07 00 00       	mov    $0x71d,%ebx
        while(*s != 0){
 542:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 547:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 54a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 54d:	8b 75 08             	mov    0x8(%ebp),%esi
 550:	88 45 e3             	mov    %al,-0x1d(%ebp)
 553:	83 ec 04             	sub    $0x4,%esp
 556:	6a 01                	push   $0x1
 558:	57                   	push   %edi
 559:	56                   	push   %esi
 55a:	e8 85 fd ff ff       	call   2e4 <write>
          s++;
 55f:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 562:	0f b6 03             	movzbl (%ebx),%eax
 565:	83 c4 10             	add    $0x10,%esp
 568:	84 c0                	test   %al,%al
 56a:	75 e4                	jne    550 <printf+0x152>
 56c:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 56f:	bf 00 00 00 00       	mov    $0x0,%edi
 574:	e9 ca fe ff ff       	jmp    443 <printf+0x45>
        putc(fd, *ap);
 579:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 57c:	8b 07                	mov    (%edi),%eax
 57e:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 581:	83 ec 04             	sub    $0x4,%esp
 584:	6a 01                	push   $0x1
 586:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 589:	50                   	push   %eax
 58a:	ff 75 08             	pushl  0x8(%ebp)
 58d:	e8 52 fd ff ff       	call   2e4 <write>
        ap++;
 592:	83 c7 04             	add    $0x4,%edi
 595:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 598:	83 c4 10             	add    $0x10,%esp
      state = 0;
 59b:	bf 00 00 00 00       	mov    $0x0,%edi
 5a0:	e9 9e fe ff ff       	jmp    443 <printf+0x45>
 5a5:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 5a8:	83 ec 04             	sub    $0x4,%esp
 5ab:	6a 01                	push   $0x1
 5ad:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5b0:	50                   	push   %eax
 5b1:	ff 75 08             	pushl  0x8(%ebp)
 5b4:	e8 2b fd ff ff       	call   2e4 <write>
 5b9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5bc:	bf 00 00 00 00       	mov    $0x0,%edi
 5c1:	e9 7d fe ff ff       	jmp    443 <printf+0x45>
    }
  }
}
 5c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5c9:	5b                   	pop    %ebx
 5ca:	5e                   	pop    %esi
 5cb:	5f                   	pop    %edi
 5cc:	5d                   	pop    %ebp
 5cd:	c3                   	ret    

000005ce <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5ce:	55                   	push   %ebp
 5cf:	89 e5                	mov    %esp,%ebp
 5d1:	57                   	push   %edi
 5d2:	56                   	push   %esi
 5d3:	53                   	push   %ebx
 5d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5d7:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5da:	a1 c8 09 00 00       	mov    0x9c8,%eax
 5df:	eb 0c                	jmp    5ed <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5e1:	8b 10                	mov    (%eax),%edx
 5e3:	39 c2                	cmp    %eax,%edx
 5e5:	77 04                	ja     5eb <free+0x1d>
 5e7:	39 ca                	cmp    %ecx,%edx
 5e9:	77 10                	ja     5fb <free+0x2d>
{
 5eb:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ed:	39 c8                	cmp    %ecx,%eax
 5ef:	73 f0                	jae    5e1 <free+0x13>
 5f1:	8b 10                	mov    (%eax),%edx
 5f3:	39 ca                	cmp    %ecx,%edx
 5f5:	77 04                	ja     5fb <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f7:	39 c2                	cmp    %eax,%edx
 5f9:	77 f0                	ja     5eb <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5fb:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5fe:	8b 10                	mov    (%eax),%edx
 600:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 603:	39 fa                	cmp    %edi,%edx
 605:	74 19                	je     620 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 607:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 60a:	8b 50 04             	mov    0x4(%eax),%edx
 60d:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 610:	39 f1                	cmp    %esi,%ecx
 612:	74 1b                	je     62f <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 614:	89 08                	mov    %ecx,(%eax)
  freep = p;
 616:	a3 c8 09 00 00       	mov    %eax,0x9c8
}
 61b:	5b                   	pop    %ebx
 61c:	5e                   	pop    %esi
 61d:	5f                   	pop    %edi
 61e:	5d                   	pop    %ebp
 61f:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 620:	03 72 04             	add    0x4(%edx),%esi
 623:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 626:	8b 10                	mov    (%eax),%edx
 628:	8b 12                	mov    (%edx),%edx
 62a:	89 53 f8             	mov    %edx,-0x8(%ebx)
 62d:	eb db                	jmp    60a <free+0x3c>
    p->s.size += bp->s.size;
 62f:	03 53 fc             	add    -0x4(%ebx),%edx
 632:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 635:	8b 53 f8             	mov    -0x8(%ebx),%edx
 638:	89 10                	mov    %edx,(%eax)
 63a:	eb da                	jmp    616 <free+0x48>

0000063c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 63c:	55                   	push   %ebp
 63d:	89 e5                	mov    %esp,%ebp
 63f:	57                   	push   %edi
 640:	56                   	push   %esi
 641:	53                   	push   %ebx
 642:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 645:	8b 45 08             	mov    0x8(%ebp),%eax
 648:	8d 58 07             	lea    0x7(%eax),%ebx
 64b:	c1 eb 03             	shr    $0x3,%ebx
 64e:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 651:	8b 15 c8 09 00 00    	mov    0x9c8,%edx
 657:	85 d2                	test   %edx,%edx
 659:	74 20                	je     67b <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 65b:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 65d:	8b 48 04             	mov    0x4(%eax),%ecx
 660:	39 cb                	cmp    %ecx,%ebx
 662:	76 3c                	jbe    6a0 <malloc+0x64>
 664:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 66a:	be 00 10 00 00       	mov    $0x1000,%esi
 66f:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 672:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 679:	eb 70                	jmp    6eb <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 67b:	c7 05 c8 09 00 00 cc 	movl   $0x9cc,0x9c8
 682:	09 00 00 
 685:	c7 05 cc 09 00 00 cc 	movl   $0x9cc,0x9cc
 68c:	09 00 00 
    base.s.size = 0;
 68f:	c7 05 d0 09 00 00 00 	movl   $0x0,0x9d0
 696:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 699:	ba cc 09 00 00       	mov    $0x9cc,%edx
 69e:	eb bb                	jmp    65b <malloc+0x1f>
      if(p->s.size == nunits)
 6a0:	39 cb                	cmp    %ecx,%ebx
 6a2:	74 1c                	je     6c0 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6a4:	29 d9                	sub    %ebx,%ecx
 6a6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6a9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6ac:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6af:	89 15 c8 09 00 00    	mov    %edx,0x9c8
      return (void*)(p + 1);
 6b5:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6bb:	5b                   	pop    %ebx
 6bc:	5e                   	pop    %esi
 6bd:	5f                   	pop    %edi
 6be:	5d                   	pop    %ebp
 6bf:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6c0:	8b 08                	mov    (%eax),%ecx
 6c2:	89 0a                	mov    %ecx,(%edx)
 6c4:	eb e9                	jmp    6af <malloc+0x73>
  hp->s.size = nu;
 6c6:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 6c9:	83 ec 0c             	sub    $0xc,%esp
 6cc:	83 c0 08             	add    $0x8,%eax
 6cf:	50                   	push   %eax
 6d0:	e8 f9 fe ff ff       	call   5ce <free>
  return freep;
 6d5:	8b 15 c8 09 00 00    	mov    0x9c8,%edx
      if((p = morecore(nunits)) == 0)
 6db:	83 c4 10             	add    $0x10,%esp
 6de:	85 d2                	test   %edx,%edx
 6e0:	74 2b                	je     70d <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6e2:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6e4:	8b 48 04             	mov    0x4(%eax),%ecx
 6e7:	39 d9                	cmp    %ebx,%ecx
 6e9:	73 b5                	jae    6a0 <malloc+0x64>
 6eb:	89 c2                	mov    %eax,%edx
    if(p == freep)
 6ed:	39 05 c8 09 00 00    	cmp    %eax,0x9c8
 6f3:	75 ed                	jne    6e2 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 6f5:	83 ec 0c             	sub    $0xc,%esp
 6f8:	57                   	push   %edi
 6f9:	e8 4e fc ff ff       	call   34c <sbrk>
  if(p == (char*)-1)
 6fe:	83 c4 10             	add    $0x10,%esp
 701:	83 f8 ff             	cmp    $0xffffffff,%eax
 704:	75 c0                	jne    6c6 <malloc+0x8a>
        return 0;
 706:	b8 00 00 00 00       	mov    $0x0,%eax
 70b:	eb ab                	jmp    6b8 <malloc+0x7c>
 70d:	b8 00 00 00 00       	mov    $0x0,%eax
 712:	eb a4                	jmp    6b8 <malloc+0x7c>
