
_rm:     file format elf32-i386


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
  14:	8b 39                	mov    (%ecx),%edi
  16:	8b 59 04             	mov    0x4(%ecx),%ebx
  19:	83 c3 04             	add    $0x4,%ebx
  if(argc < 2){
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  1c:	be 01 00 00 00       	mov    $0x1,%esi
  if(argc < 2){
  21:	83 ff 01             	cmp    $0x1,%edi
  24:	7e 20                	jle    46 <main+0x46>
    if(unlink(argv[i]) < 0){
  26:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  29:	83 ec 0c             	sub    $0xc,%esp
  2c:	ff 33                	pushl  (%ebx)
  2e:	e8 f0 02 00 00       	call   323 <unlink>
  33:	83 c4 10             	add    $0x10,%esp
  36:	85 c0                	test   %eax,%eax
  38:	78 20                	js     5a <main+0x5a>
  for(i = 1; i < argc; i++){
  3a:	83 c6 01             	add    $0x1,%esi
  3d:	83 c3 04             	add    $0x4,%ebx
  40:	39 f7                	cmp    %esi,%edi
  42:	75 e2                	jne    26 <main+0x26>
  44:	eb 2b                	jmp    71 <main+0x71>
    printf(2, "Usage: rm files...\n");
  46:	83 ec 08             	sub    $0x8,%esp
  49:	68 24 07 00 00       	push   $0x724
  4e:	6a 02                	push   $0x2
  50:	e8 b8 03 00 00       	call   40d <printf>
    exit();
  55:	e8 79 02 00 00       	call   2d3 <exit>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  5a:	83 ec 04             	sub    $0x4,%esp
  5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  60:	ff 30                	pushl  (%eax)
  62:	68 38 07 00 00       	push   $0x738
  67:	6a 02                	push   $0x2
  69:	e8 9f 03 00 00       	call   40d <printf>
      break;
  6e:	83 c4 10             	add    $0x10,%esp
    }
  }

  exit();
  71:	e8 5d 02 00 00       	call   2d3 <exit>

00000076 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  76:	55                   	push   %ebp
  77:	89 e5                	mov    %esp,%ebp
  79:	53                   	push   %ebx
  7a:	8b 45 08             	mov    0x8(%ebp),%eax
  7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  80:	89 c2                	mov    %eax,%edx
  82:	83 c1 01             	add    $0x1,%ecx
  85:	83 c2 01             	add    $0x1,%edx
  88:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  8c:	88 5a ff             	mov    %bl,-0x1(%edx)
  8f:	84 db                	test   %bl,%bl
  91:	75 ef                	jne    82 <strcpy+0xc>
    ;
  return os;
}
  93:	5b                   	pop    %ebx
  94:	5d                   	pop    %ebp
  95:	c3                   	ret    

00000096 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  96:	55                   	push   %ebp
  97:	89 e5                	mov    %esp,%ebp
  99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  9f:	0f b6 01             	movzbl (%ecx),%eax
  a2:	84 c0                	test   %al,%al
  a4:	74 15                	je     bb <strcmp+0x25>
  a6:	3a 02                	cmp    (%edx),%al
  a8:	75 11                	jne    bb <strcmp+0x25>
    p++, q++;
  aa:	83 c1 01             	add    $0x1,%ecx
  ad:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  b0:	0f b6 01             	movzbl (%ecx),%eax
  b3:	84 c0                	test   %al,%al
  b5:	74 04                	je     bb <strcmp+0x25>
  b7:	3a 02                	cmp    (%edx),%al
  b9:	74 ef                	je     aa <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
  bb:	0f b6 c0             	movzbl %al,%eax
  be:	0f b6 12             	movzbl (%edx),%edx
  c1:	29 d0                	sub    %edx,%eax
}
  c3:	5d                   	pop    %ebp
  c4:	c3                   	ret    

000000c5 <strlen>:

uint
strlen(char *s)
{
  c5:	55                   	push   %ebp
  c6:	89 e5                	mov    %esp,%ebp
  c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  cb:	80 39 00             	cmpb   $0x0,(%ecx)
  ce:	74 12                	je     e2 <strlen+0x1d>
  d0:	ba 00 00 00 00       	mov    $0x0,%edx
  d5:	83 c2 01             	add    $0x1,%edx
  d8:	89 d0                	mov    %edx,%eax
  da:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  de:	75 f5                	jne    d5 <strlen+0x10>
    ;
  return n;
}
  e0:	5d                   	pop    %ebp
  e1:	c3                   	ret    
  for(n = 0; s[n]; n++)
  e2:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
  e7:	eb f7                	jmp    e0 <strlen+0x1b>

000000e9 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e9:	55                   	push   %ebp
  ea:	89 e5                	mov    %esp,%ebp
  ec:	57                   	push   %edi
  ed:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  f0:	89 d7                	mov    %edx,%edi
  f2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  f8:	fc                   	cld    
  f9:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  fb:	89 d0                	mov    %edx,%eax
  fd:	5f                   	pop    %edi
  fe:	5d                   	pop    %ebp
  ff:	c3                   	ret    

00000100 <strchr>:

char*
strchr(const char *s, char c)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	53                   	push   %ebx
 104:	8b 45 08             	mov    0x8(%ebp),%eax
 107:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 10a:	0f b6 10             	movzbl (%eax),%edx
 10d:	84 d2                	test   %dl,%dl
 10f:	74 1e                	je     12f <strchr+0x2f>
 111:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 113:	38 d3                	cmp    %dl,%bl
 115:	74 15                	je     12c <strchr+0x2c>
  for(; *s; s++)
 117:	83 c0 01             	add    $0x1,%eax
 11a:	0f b6 10             	movzbl (%eax),%edx
 11d:	84 d2                	test   %dl,%dl
 11f:	74 06                	je     127 <strchr+0x27>
    if(*s == c)
 121:	38 ca                	cmp    %cl,%dl
 123:	75 f2                	jne    117 <strchr+0x17>
 125:	eb 05                	jmp    12c <strchr+0x2c>
      return (char*)s;
  return 0;
 127:	b8 00 00 00 00       	mov    $0x0,%eax
}
 12c:	5b                   	pop    %ebx
 12d:	5d                   	pop    %ebp
 12e:	c3                   	ret    
  return 0;
 12f:	b8 00 00 00 00       	mov    $0x0,%eax
 134:	eb f6                	jmp    12c <strchr+0x2c>

00000136 <gets>:

char*
gets(char *buf, int max)
{
 136:	55                   	push   %ebp
 137:	89 e5                	mov    %esp,%ebp
 139:	57                   	push   %edi
 13a:	56                   	push   %esi
 13b:	53                   	push   %ebx
 13c:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13f:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 144:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 147:	8d 5e 01             	lea    0x1(%esi),%ebx
 14a:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 14d:	7d 2b                	jge    17a <gets+0x44>
    cc = read(0, &c, 1);
 14f:	83 ec 04             	sub    $0x4,%esp
 152:	6a 01                	push   $0x1
 154:	57                   	push   %edi
 155:	6a 00                	push   $0x0
 157:	e8 8f 01 00 00       	call   2eb <read>
    if(cc < 1)
 15c:	83 c4 10             	add    $0x10,%esp
 15f:	85 c0                	test   %eax,%eax
 161:	7e 17                	jle    17a <gets+0x44>
      break;
    buf[i++] = c;
 163:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 167:	8b 55 08             	mov    0x8(%ebp),%edx
 16a:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 16e:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 170:	3c 0a                	cmp    $0xa,%al
 172:	74 04                	je     178 <gets+0x42>
 174:	3c 0d                	cmp    $0xd,%al
 176:	75 cf                	jne    147 <gets+0x11>
  for(i=0; i+1 < max; ){
 178:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 17a:	8b 45 08             	mov    0x8(%ebp),%eax
 17d:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 181:	8d 65 f4             	lea    -0xc(%ebp),%esp
 184:	5b                   	pop    %ebx
 185:	5e                   	pop    %esi
 186:	5f                   	pop    %edi
 187:	5d                   	pop    %ebp
 188:	c3                   	ret    

00000189 <stat>:

int
stat(char *n, struct stat *st)
{
 189:	55                   	push   %ebp
 18a:	89 e5                	mov    %esp,%ebp
 18c:	56                   	push   %esi
 18d:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18e:	83 ec 08             	sub    $0x8,%esp
 191:	6a 00                	push   $0x0
 193:	ff 75 08             	pushl  0x8(%ebp)
 196:	e8 78 01 00 00       	call   313 <open>
  if(fd < 0)
 19b:	83 c4 10             	add    $0x10,%esp
 19e:	85 c0                	test   %eax,%eax
 1a0:	78 24                	js     1c6 <stat+0x3d>
 1a2:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1a4:	83 ec 08             	sub    $0x8,%esp
 1a7:	ff 75 0c             	pushl  0xc(%ebp)
 1aa:	50                   	push   %eax
 1ab:	e8 7b 01 00 00       	call   32b <fstat>
 1b0:	89 c6                	mov    %eax,%esi
  close(fd);
 1b2:	89 1c 24             	mov    %ebx,(%esp)
 1b5:	e8 41 01 00 00       	call   2fb <close>
  return r;
 1ba:	83 c4 10             	add    $0x10,%esp
}
 1bd:	89 f0                	mov    %esi,%eax
 1bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1c2:	5b                   	pop    %ebx
 1c3:	5e                   	pop    %esi
 1c4:	5d                   	pop    %ebp
 1c5:	c3                   	ret    
    return -1;
 1c6:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1cb:	eb f0                	jmp    1bd <stat+0x34>

000001cd <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 1cd:	55                   	push   %ebp
 1ce:	89 e5                	mov    %esp,%ebp
 1d0:	56                   	push   %esi
 1d1:	53                   	push   %ebx
 1d2:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 1d5:	0f b6 0a             	movzbl (%edx),%ecx
 1d8:	80 f9 20             	cmp    $0x20,%cl
 1db:	75 0b                	jne    1e8 <atoi+0x1b>
 1dd:	83 c2 01             	add    $0x1,%edx
 1e0:	0f b6 0a             	movzbl (%edx),%ecx
 1e3:	80 f9 20             	cmp    $0x20,%cl
 1e6:	74 f5                	je     1dd <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
 1e8:	80 f9 2d             	cmp    $0x2d,%cl
 1eb:	74 3b                	je     228 <atoi+0x5b>
  if (*s == '+'  || *s == '-')
 1ed:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 1f0:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 1f5:	f6 c1 fd             	test   $0xfd,%cl
 1f8:	74 33                	je     22d <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
 1fa:	0f b6 0a             	movzbl (%edx),%ecx
 1fd:	8d 41 d0             	lea    -0x30(%ecx),%eax
 200:	3c 09                	cmp    $0x9,%al
 202:	77 2e                	ja     232 <atoi+0x65>
 204:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 209:	83 c2 01             	add    $0x1,%edx
 20c:	8d 04 80             	lea    (%eax,%eax,4),%eax
 20f:	0f be c9             	movsbl %cl,%ecx
 212:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 216:	0f b6 0a             	movzbl (%edx),%ecx
 219:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 21c:	80 fb 09             	cmp    $0x9,%bl
 21f:	76 e8                	jbe    209 <atoi+0x3c>
  return sign*n;
 221:	0f af c6             	imul   %esi,%eax
}
 224:	5b                   	pop    %ebx
 225:	5e                   	pop    %esi
 226:	5d                   	pop    %ebp
 227:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 228:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 22d:	83 c2 01             	add    $0x1,%edx
 230:	eb c8                	jmp    1fa <atoi+0x2d>
  while('0' <= *s && *s <= '9')
 232:	b8 00 00 00 00       	mov    $0x0,%eax
 237:	eb e8                	jmp    221 <atoi+0x54>

00000239 <atoo>:

int
atoo(const char *s)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
 23c:	56                   	push   %esi
 23d:	53                   	push   %ebx
 23e:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 241:	0f b6 0a             	movzbl (%edx),%ecx
 244:	80 f9 20             	cmp    $0x20,%cl
 247:	75 0b                	jne    254 <atoo+0x1b>
 249:	83 c2 01             	add    $0x1,%edx
 24c:	0f b6 0a             	movzbl (%edx),%ecx
 24f:	80 f9 20             	cmp    $0x20,%cl
 252:	74 f5                	je     249 <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
 254:	80 f9 2d             	cmp    $0x2d,%cl
 257:	74 38                	je     291 <atoo+0x58>
  if (*s == '+'  || *s == '-')
 259:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 25c:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 261:	f6 c1 fd             	test   $0xfd,%cl
 264:	74 30                	je     296 <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
 266:	0f b6 0a             	movzbl (%edx),%ecx
 269:	8d 41 d0             	lea    -0x30(%ecx),%eax
 26c:	3c 07                	cmp    $0x7,%al
 26e:	77 2b                	ja     29b <atoo+0x62>
 270:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
 275:	83 c2 01             	add    $0x1,%edx
 278:	0f be c9             	movsbl %cl,%ecx
 27b:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 27f:	0f b6 0a             	movzbl (%edx),%ecx
 282:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 285:	80 fb 07             	cmp    $0x7,%bl
 288:	76 eb                	jbe    275 <atoo+0x3c>
  return sign*n;
 28a:	0f af c6             	imul   %esi,%eax
}
 28d:	5b                   	pop    %ebx
 28e:	5e                   	pop    %esi
 28f:	5d                   	pop    %ebp
 290:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 291:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 296:	83 c2 01             	add    $0x1,%edx
 299:	eb cb                	jmp    266 <atoo+0x2d>
  while('0' <= *s && *s <= '7')
 29b:	b8 00 00 00 00       	mov    $0x0,%eax
 2a0:	eb e8                	jmp    28a <atoo+0x51>

000002a2 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 2a2:	55                   	push   %ebp
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	56                   	push   %esi
 2a6:	53                   	push   %ebx
 2a7:	8b 45 08             	mov    0x8(%ebp),%eax
 2aa:	8b 75 0c             	mov    0xc(%ebp),%esi
 2ad:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2b0:	85 db                	test   %ebx,%ebx
 2b2:	7e 13                	jle    2c7 <memmove+0x25>
 2b4:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 2b9:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2bd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2c0:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 2c3:	39 d3                	cmp    %edx,%ebx
 2c5:	75 f2                	jne    2b9 <memmove+0x17>
  return vdst;
}
 2c7:	5b                   	pop    %ebx
 2c8:	5e                   	pop    %esi
 2c9:	5d                   	pop    %ebp
 2ca:	c3                   	ret    

000002cb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2cb:	b8 01 00 00 00       	mov    $0x1,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <exit>:
SYSCALL(exit)
 2d3:	b8 02 00 00 00       	mov    $0x2,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <wait>:
SYSCALL(wait)
 2db:	b8 03 00 00 00       	mov    $0x3,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <pipe>:
SYSCALL(pipe)
 2e3:	b8 04 00 00 00       	mov    $0x4,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <read>:
SYSCALL(read)
 2eb:	b8 05 00 00 00       	mov    $0x5,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <write>:
SYSCALL(write)
 2f3:	b8 10 00 00 00       	mov    $0x10,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <close>:
SYSCALL(close)
 2fb:	b8 15 00 00 00       	mov    $0x15,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <kill>:
SYSCALL(kill)
 303:	b8 06 00 00 00       	mov    $0x6,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <exec>:
SYSCALL(exec)
 30b:	b8 07 00 00 00       	mov    $0x7,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <open>:
SYSCALL(open)
 313:	b8 0f 00 00 00       	mov    $0xf,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <mknod>:
SYSCALL(mknod)
 31b:	b8 11 00 00 00       	mov    $0x11,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <unlink>:
SYSCALL(unlink)
 323:	b8 12 00 00 00       	mov    $0x12,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <fstat>:
SYSCALL(fstat)
 32b:	b8 08 00 00 00       	mov    $0x8,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <link>:
SYSCALL(link)
 333:	b8 13 00 00 00       	mov    $0x13,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <mkdir>:
SYSCALL(mkdir)
 33b:	b8 14 00 00 00       	mov    $0x14,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <chdir>:
SYSCALL(chdir)
 343:	b8 09 00 00 00       	mov    $0x9,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <dup>:
SYSCALL(dup)
 34b:	b8 0a 00 00 00       	mov    $0xa,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <getpid>:
SYSCALL(getpid)
 353:	b8 0b 00 00 00       	mov    $0xb,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <sbrk>:
SYSCALL(sbrk)
 35b:	b8 0c 00 00 00       	mov    $0xc,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <sleep>:
SYSCALL(sleep)
 363:	b8 0d 00 00 00       	mov    $0xd,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <uptime>:
SYSCALL(uptime)
 36b:	b8 0e 00 00 00       	mov    $0xe,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <halt>:
SYSCALL(halt)
 373:	b8 16 00 00 00       	mov    $0x16,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <date>:
SYSCALL(date)
 37b:	b8 17 00 00 00       	mov    $0x17,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 383:	55                   	push   %ebp
 384:	89 e5                	mov    %esp,%ebp
 386:	57                   	push   %edi
 387:	56                   	push   %esi
 388:	53                   	push   %ebx
 389:	83 ec 3c             	sub    $0x3c,%esp
 38c:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 38e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 392:	74 14                	je     3a8 <printint+0x25>
 394:	85 d2                	test   %edx,%edx
 396:	79 10                	jns    3a8 <printint+0x25>
    neg = 1;
    x = -xx;
 398:	f7 da                	neg    %edx
    neg = 1;
 39a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3a1:	bf 00 00 00 00       	mov    $0x0,%edi
 3a6:	eb 0b                	jmp    3b3 <printint+0x30>
  neg = 0;
 3a8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3af:	eb f0                	jmp    3a1 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 3b1:	89 df                	mov    %ebx,%edi
 3b3:	8d 5f 01             	lea    0x1(%edi),%ebx
 3b6:	89 d0                	mov    %edx,%eax
 3b8:	ba 00 00 00 00       	mov    $0x0,%edx
 3bd:	f7 f1                	div    %ecx
 3bf:	0f b6 92 58 07 00 00 	movzbl 0x758(%edx),%edx
 3c6:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 3ca:	89 c2                	mov    %eax,%edx
 3cc:	85 c0                	test   %eax,%eax
 3ce:	75 e1                	jne    3b1 <printint+0x2e>
  if(neg)
 3d0:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 3d4:	74 08                	je     3de <printint+0x5b>
    buf[i++] = '-';
 3d6:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3db:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 3de:	83 eb 01             	sub    $0x1,%ebx
 3e1:	78 22                	js     405 <printint+0x82>
  write(fd, &c, 1);
 3e3:	8d 7d d7             	lea    -0x29(%ebp),%edi
 3e6:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 3eb:	88 45 d7             	mov    %al,-0x29(%ebp)
 3ee:	83 ec 04             	sub    $0x4,%esp
 3f1:	6a 01                	push   $0x1
 3f3:	57                   	push   %edi
 3f4:	56                   	push   %esi
 3f5:	e8 f9 fe ff ff       	call   2f3 <write>
  while(--i >= 0)
 3fa:	83 eb 01             	sub    $0x1,%ebx
 3fd:	83 c4 10             	add    $0x10,%esp
 400:	83 fb ff             	cmp    $0xffffffff,%ebx
 403:	75 e1                	jne    3e6 <printint+0x63>
    putc(fd, buf[i]);
}
 405:	8d 65 f4             	lea    -0xc(%ebp),%esp
 408:	5b                   	pop    %ebx
 409:	5e                   	pop    %esi
 40a:	5f                   	pop    %edi
 40b:	5d                   	pop    %ebp
 40c:	c3                   	ret    

0000040d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 40d:	55                   	push   %ebp
 40e:	89 e5                	mov    %esp,%ebp
 410:	57                   	push   %edi
 411:	56                   	push   %esi
 412:	53                   	push   %ebx
 413:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 416:	8b 75 0c             	mov    0xc(%ebp),%esi
 419:	0f b6 1e             	movzbl (%esi),%ebx
 41c:	84 db                	test   %bl,%bl
 41e:	0f 84 b1 01 00 00    	je     5d5 <printf+0x1c8>
 424:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 427:	8d 45 10             	lea    0x10(%ebp),%eax
 42a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 42d:	bf 00 00 00 00       	mov    $0x0,%edi
 432:	eb 2d                	jmp    461 <printf+0x54>
 434:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 437:	83 ec 04             	sub    $0x4,%esp
 43a:	6a 01                	push   $0x1
 43c:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 43f:	50                   	push   %eax
 440:	ff 75 08             	pushl  0x8(%ebp)
 443:	e8 ab fe ff ff       	call   2f3 <write>
 448:	83 c4 10             	add    $0x10,%esp
 44b:	eb 05                	jmp    452 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 44d:	83 ff 25             	cmp    $0x25,%edi
 450:	74 22                	je     474 <printf+0x67>
 452:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 455:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 459:	84 db                	test   %bl,%bl
 45b:	0f 84 74 01 00 00    	je     5d5 <printf+0x1c8>
    c = fmt[i] & 0xff;
 461:	0f be d3             	movsbl %bl,%edx
 464:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 467:	85 ff                	test   %edi,%edi
 469:	75 e2                	jne    44d <printf+0x40>
      if(c == '%'){
 46b:	83 f8 25             	cmp    $0x25,%eax
 46e:	75 c4                	jne    434 <printf+0x27>
        state = '%';
 470:	89 c7                	mov    %eax,%edi
 472:	eb de                	jmp    452 <printf+0x45>
      if(c == 'd'){
 474:	83 f8 64             	cmp    $0x64,%eax
 477:	74 59                	je     4d2 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 479:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 47f:	83 fa 70             	cmp    $0x70,%edx
 482:	74 7a                	je     4fe <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 484:	83 f8 73             	cmp    $0x73,%eax
 487:	0f 84 9d 00 00 00    	je     52a <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 48d:	83 f8 63             	cmp    $0x63,%eax
 490:	0f 84 f2 00 00 00    	je     588 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 496:	83 f8 25             	cmp    $0x25,%eax
 499:	0f 84 15 01 00 00    	je     5b4 <printf+0x1a7>
 49f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 4a3:	83 ec 04             	sub    $0x4,%esp
 4a6:	6a 01                	push   $0x1
 4a8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4ab:	50                   	push   %eax
 4ac:	ff 75 08             	pushl  0x8(%ebp)
 4af:	e8 3f fe ff ff       	call   2f3 <write>
 4b4:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 4b7:	83 c4 0c             	add    $0xc,%esp
 4ba:	6a 01                	push   $0x1
 4bc:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4bf:	50                   	push   %eax
 4c0:	ff 75 08             	pushl  0x8(%ebp)
 4c3:	e8 2b fe ff ff       	call   2f3 <write>
 4c8:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4cb:	bf 00 00 00 00       	mov    $0x0,%edi
 4d0:	eb 80                	jmp    452 <printf+0x45>
        printint(fd, *ap, 10, 1);
 4d2:	83 ec 0c             	sub    $0xc,%esp
 4d5:	6a 01                	push   $0x1
 4d7:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4dc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 4df:	8b 17                	mov    (%edi),%edx
 4e1:	8b 45 08             	mov    0x8(%ebp),%eax
 4e4:	e8 9a fe ff ff       	call   383 <printint>
        ap++;
 4e9:	89 f8                	mov    %edi,%eax
 4eb:	83 c0 04             	add    $0x4,%eax
 4ee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4f1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4f4:	bf 00 00 00 00       	mov    $0x0,%edi
 4f9:	e9 54 ff ff ff       	jmp    452 <printf+0x45>
        printint(fd, *ap, 16, 0);
 4fe:	83 ec 0c             	sub    $0xc,%esp
 501:	6a 00                	push   $0x0
 503:	b9 10 00 00 00       	mov    $0x10,%ecx
 508:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 50b:	8b 17                	mov    (%edi),%edx
 50d:	8b 45 08             	mov    0x8(%ebp),%eax
 510:	e8 6e fe ff ff       	call   383 <printint>
        ap++;
 515:	89 f8                	mov    %edi,%eax
 517:	83 c0 04             	add    $0x4,%eax
 51a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 51d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 520:	bf 00 00 00 00       	mov    $0x0,%edi
 525:	e9 28 ff ff ff       	jmp    452 <printf+0x45>
        s = (char*)*ap;
 52a:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 52d:	8b 01                	mov    (%ecx),%eax
        ap++;
 52f:	83 c1 04             	add    $0x4,%ecx
 532:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 535:	85 c0                	test   %eax,%eax
 537:	74 13                	je     54c <printf+0x13f>
        s = (char*)*ap;
 539:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 53b:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 53e:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 543:	84 c0                	test   %al,%al
 545:	75 0f                	jne    556 <printf+0x149>
 547:	e9 06 ff ff ff       	jmp    452 <printf+0x45>
          s = "(null)";
 54c:	bb 51 07 00 00       	mov    $0x751,%ebx
        while(*s != 0){
 551:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 556:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 559:	89 75 d0             	mov    %esi,-0x30(%ebp)
 55c:	8b 75 08             	mov    0x8(%ebp),%esi
 55f:	88 45 e3             	mov    %al,-0x1d(%ebp)
 562:	83 ec 04             	sub    $0x4,%esp
 565:	6a 01                	push   $0x1
 567:	57                   	push   %edi
 568:	56                   	push   %esi
 569:	e8 85 fd ff ff       	call   2f3 <write>
          s++;
 56e:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 571:	0f b6 03             	movzbl (%ebx),%eax
 574:	83 c4 10             	add    $0x10,%esp
 577:	84 c0                	test   %al,%al
 579:	75 e4                	jne    55f <printf+0x152>
 57b:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 57e:	bf 00 00 00 00       	mov    $0x0,%edi
 583:	e9 ca fe ff ff       	jmp    452 <printf+0x45>
        putc(fd, *ap);
 588:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 58b:	8b 07                	mov    (%edi),%eax
 58d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 590:	83 ec 04             	sub    $0x4,%esp
 593:	6a 01                	push   $0x1
 595:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 598:	50                   	push   %eax
 599:	ff 75 08             	pushl  0x8(%ebp)
 59c:	e8 52 fd ff ff       	call   2f3 <write>
        ap++;
 5a1:	83 c7 04             	add    $0x4,%edi
 5a4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 5a7:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5aa:	bf 00 00 00 00       	mov    $0x0,%edi
 5af:	e9 9e fe ff ff       	jmp    452 <printf+0x45>
 5b4:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 5b7:	83 ec 04             	sub    $0x4,%esp
 5ba:	6a 01                	push   $0x1
 5bc:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 5bf:	50                   	push   %eax
 5c0:	ff 75 08             	pushl  0x8(%ebp)
 5c3:	e8 2b fd ff ff       	call   2f3 <write>
 5c8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5cb:	bf 00 00 00 00       	mov    $0x0,%edi
 5d0:	e9 7d fe ff ff       	jmp    452 <printf+0x45>
    }
  }
}
 5d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5d8:	5b                   	pop    %ebx
 5d9:	5e                   	pop    %esi
 5da:	5f                   	pop    %edi
 5db:	5d                   	pop    %ebp
 5dc:	c3                   	ret    

000005dd <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5dd:	55                   	push   %ebp
 5de:	89 e5                	mov    %esp,%ebp
 5e0:	57                   	push   %edi
 5e1:	56                   	push   %esi
 5e2:	53                   	push   %ebx
 5e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5e6:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5e9:	a1 fc 09 00 00       	mov    0x9fc,%eax
 5ee:	eb 0c                	jmp    5fc <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f0:	8b 10                	mov    (%eax),%edx
 5f2:	39 c2                	cmp    %eax,%edx
 5f4:	77 04                	ja     5fa <free+0x1d>
 5f6:	39 ca                	cmp    %ecx,%edx
 5f8:	77 10                	ja     60a <free+0x2d>
{
 5fa:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5fc:	39 c8                	cmp    %ecx,%eax
 5fe:	73 f0                	jae    5f0 <free+0x13>
 600:	8b 10                	mov    (%eax),%edx
 602:	39 ca                	cmp    %ecx,%edx
 604:	77 04                	ja     60a <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 606:	39 c2                	cmp    %eax,%edx
 608:	77 f0                	ja     5fa <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 60a:	8b 73 fc             	mov    -0x4(%ebx),%esi
 60d:	8b 10                	mov    (%eax),%edx
 60f:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 612:	39 fa                	cmp    %edi,%edx
 614:	74 19                	je     62f <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 616:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 619:	8b 50 04             	mov    0x4(%eax),%edx
 61c:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 61f:	39 f1                	cmp    %esi,%ecx
 621:	74 1b                	je     63e <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 623:	89 08                	mov    %ecx,(%eax)
  freep = p;
 625:	a3 fc 09 00 00       	mov    %eax,0x9fc
}
 62a:	5b                   	pop    %ebx
 62b:	5e                   	pop    %esi
 62c:	5f                   	pop    %edi
 62d:	5d                   	pop    %ebp
 62e:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 62f:	03 72 04             	add    0x4(%edx),%esi
 632:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 635:	8b 10                	mov    (%eax),%edx
 637:	8b 12                	mov    (%edx),%edx
 639:	89 53 f8             	mov    %edx,-0x8(%ebx)
 63c:	eb db                	jmp    619 <free+0x3c>
    p->s.size += bp->s.size;
 63e:	03 53 fc             	add    -0x4(%ebx),%edx
 641:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 644:	8b 53 f8             	mov    -0x8(%ebx),%edx
 647:	89 10                	mov    %edx,(%eax)
 649:	eb da                	jmp    625 <free+0x48>

0000064b <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 64b:	55                   	push   %ebp
 64c:	89 e5                	mov    %esp,%ebp
 64e:	57                   	push   %edi
 64f:	56                   	push   %esi
 650:	53                   	push   %ebx
 651:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 654:	8b 45 08             	mov    0x8(%ebp),%eax
 657:	8d 58 07             	lea    0x7(%eax),%ebx
 65a:	c1 eb 03             	shr    $0x3,%ebx
 65d:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 660:	8b 15 fc 09 00 00    	mov    0x9fc,%edx
 666:	85 d2                	test   %edx,%edx
 668:	74 20                	je     68a <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 66a:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 66c:	8b 48 04             	mov    0x4(%eax),%ecx
 66f:	39 cb                	cmp    %ecx,%ebx
 671:	76 3c                	jbe    6af <malloc+0x64>
 673:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 679:	be 00 10 00 00       	mov    $0x1000,%esi
 67e:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 681:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 688:	eb 70                	jmp    6fa <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 68a:	c7 05 fc 09 00 00 00 	movl   $0xa00,0x9fc
 691:	0a 00 00 
 694:	c7 05 00 0a 00 00 00 	movl   $0xa00,0xa00
 69b:	0a 00 00 
    base.s.size = 0;
 69e:	c7 05 04 0a 00 00 00 	movl   $0x0,0xa04
 6a5:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6a8:	ba 00 0a 00 00       	mov    $0xa00,%edx
 6ad:	eb bb                	jmp    66a <malloc+0x1f>
      if(p->s.size == nunits)
 6af:	39 cb                	cmp    %ecx,%ebx
 6b1:	74 1c                	je     6cf <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6b3:	29 d9                	sub    %ebx,%ecx
 6b5:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6b8:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6bb:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6be:	89 15 fc 09 00 00    	mov    %edx,0x9fc
      return (void*)(p + 1);
 6c4:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6ca:	5b                   	pop    %ebx
 6cb:	5e                   	pop    %esi
 6cc:	5f                   	pop    %edi
 6cd:	5d                   	pop    %ebp
 6ce:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6cf:	8b 08                	mov    (%eax),%ecx
 6d1:	89 0a                	mov    %ecx,(%edx)
 6d3:	eb e9                	jmp    6be <malloc+0x73>
  hp->s.size = nu;
 6d5:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 6d8:	83 ec 0c             	sub    $0xc,%esp
 6db:	83 c0 08             	add    $0x8,%eax
 6de:	50                   	push   %eax
 6df:	e8 f9 fe ff ff       	call   5dd <free>
  return freep;
 6e4:	8b 15 fc 09 00 00    	mov    0x9fc,%edx
      if((p = morecore(nunits)) == 0)
 6ea:	83 c4 10             	add    $0x10,%esp
 6ed:	85 d2                	test   %edx,%edx
 6ef:	74 2b                	je     71c <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6f1:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6f3:	8b 48 04             	mov    0x4(%eax),%ecx
 6f6:	39 d9                	cmp    %ebx,%ecx
 6f8:	73 b5                	jae    6af <malloc+0x64>
 6fa:	89 c2                	mov    %eax,%edx
    if(p == freep)
 6fc:	39 05 fc 09 00 00    	cmp    %eax,0x9fc
 702:	75 ed                	jne    6f1 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 704:	83 ec 0c             	sub    $0xc,%esp
 707:	57                   	push   %edi
 708:	e8 4e fc ff ff       	call   35b <sbrk>
  if(p == (char*)-1)
 70d:	83 c4 10             	add    $0x10,%esp
 710:	83 f8 ff             	cmp    $0xffffffff,%eax
 713:	75 c0                	jne    6d5 <malloc+0x8a>
        return 0;
 715:	b8 00 00 00 00       	mov    $0x0,%eax
 71a:	eb ab                	jmp    6c7 <malloc+0x7c>
 71c:	b8 00 00 00 00       	mov    $0x0,%eax
 721:	eb a4                	jmp    6c7 <malloc+0x7c>
