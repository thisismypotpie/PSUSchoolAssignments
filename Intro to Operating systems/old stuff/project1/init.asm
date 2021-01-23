
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   f:	83 ec 08             	sub    $0x8,%esp
  12:	6a 02                	push   $0x2
  14:	68 8c 07 00 00       	push   $0x78c
  19:	e8 5e 03 00 00       	call   37c <open>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	78 1b                	js     40 <main+0x40>
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  25:	83 ec 0c             	sub    $0xc,%esp
  28:	6a 00                	push   $0x0
  2a:	e8 85 03 00 00       	call   3b4 <dup>
  dup(0);  // stderr
  2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  36:	e8 79 03 00 00       	call   3b4 <dup>
  3b:	83 c4 10             	add    $0x10,%esp
  3e:	eb 58                	jmp    98 <main+0x98>
    mknod("console", 1, 1);
  40:	83 ec 04             	sub    $0x4,%esp
  43:	6a 01                	push   $0x1
  45:	6a 01                	push   $0x1
  47:	68 8c 07 00 00       	push   $0x78c
  4c:	e8 33 03 00 00       	call   384 <mknod>
    open("console", O_RDWR);
  51:	83 c4 08             	add    $0x8,%esp
  54:	6a 02                	push   $0x2
  56:	68 8c 07 00 00       	push   $0x78c
  5b:	e8 1c 03 00 00       	call   37c <open>
  60:	83 c4 10             	add    $0x10,%esp
  63:	eb c0                	jmp    25 <main+0x25>

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
  65:	83 ec 08             	sub    $0x8,%esp
  68:	68 a7 07 00 00       	push   $0x7a7
  6d:	6a 01                	push   $0x1
  6f:	e8 02 04 00 00       	call   476 <printf>
      exit();
  74:	e8 c3 02 00 00       	call   33c <exit>
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  79:	83 ec 08             	sub    $0x8,%esp
  7c:	68 d3 07 00 00       	push   $0x7d3
  81:	6a 01                	push   $0x1
  83:	e8 ee 03 00 00       	call   476 <printf>
  88:	83 c4 10             	add    $0x10,%esp
    while((wpid=wait()) >= 0 && wpid != pid)
  8b:	e8 b4 02 00 00       	call   344 <wait>
  90:	39 c3                	cmp    %eax,%ebx
  92:	74 04                	je     98 <main+0x98>
  94:	85 c0                	test   %eax,%eax
  96:	79 e1                	jns    79 <main+0x79>
    printf(1, "init: starting sh\n");
  98:	83 ec 08             	sub    $0x8,%esp
  9b:	68 94 07 00 00       	push   $0x794
  a0:	6a 01                	push   $0x1
  a2:	e8 cf 03 00 00       	call   476 <printf>
    pid = fork();
  a7:	e8 88 02 00 00       	call   334 <fork>
  ac:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
  ae:	83 c4 10             	add    $0x10,%esp
  b1:	85 c0                	test   %eax,%eax
  b3:	78 b0                	js     65 <main+0x65>
    if(pid == 0){
  b5:	85 c0                	test   %eax,%eax
  b7:	75 d2                	jne    8b <main+0x8b>
      exec("sh", argv);
  b9:	83 ec 08             	sub    $0x8,%esp
  bc:	68 80 0a 00 00       	push   $0xa80
  c1:	68 ba 07 00 00       	push   $0x7ba
  c6:	e8 a9 02 00 00       	call   374 <exec>
      printf(1, "init: exec sh failed\n");
  cb:	83 c4 08             	add    $0x8,%esp
  ce:	68 bd 07 00 00       	push   $0x7bd
  d3:	6a 01                	push   $0x1
  d5:	e8 9c 03 00 00       	call   476 <printf>
      exit();
  da:	e8 5d 02 00 00       	call   33c <exit>

000000df <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  df:	55                   	push   %ebp
  e0:	89 e5                	mov    %esp,%ebp
  e2:	53                   	push   %ebx
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e9:	89 c2                	mov    %eax,%edx
  eb:	83 c1 01             	add    $0x1,%ecx
  ee:	83 c2 01             	add    $0x1,%edx
  f1:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  f5:	88 5a ff             	mov    %bl,-0x1(%edx)
  f8:	84 db                	test   %bl,%bl
  fa:	75 ef                	jne    eb <strcpy+0xc>
    ;
  return os;
}
  fc:	5b                   	pop    %ebx
  fd:	5d                   	pop    %ebp
  fe:	c3                   	ret    

000000ff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ff:	55                   	push   %ebp
 100:	89 e5                	mov    %esp,%ebp
 102:	8b 4d 08             	mov    0x8(%ebp),%ecx
 105:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 108:	0f b6 01             	movzbl (%ecx),%eax
 10b:	84 c0                	test   %al,%al
 10d:	74 15                	je     124 <strcmp+0x25>
 10f:	3a 02                	cmp    (%edx),%al
 111:	75 11                	jne    124 <strcmp+0x25>
    p++, q++;
 113:	83 c1 01             	add    $0x1,%ecx
 116:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 119:	0f b6 01             	movzbl (%ecx),%eax
 11c:	84 c0                	test   %al,%al
 11e:	74 04                	je     124 <strcmp+0x25>
 120:	3a 02                	cmp    (%edx),%al
 122:	74 ef                	je     113 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 124:	0f b6 c0             	movzbl %al,%eax
 127:	0f b6 12             	movzbl (%edx),%edx
 12a:	29 d0                	sub    %edx,%eax
}
 12c:	5d                   	pop    %ebp
 12d:	c3                   	ret    

0000012e <strlen>:

uint
strlen(char *s)
{
 12e:	55                   	push   %ebp
 12f:	89 e5                	mov    %esp,%ebp
 131:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 134:	80 39 00             	cmpb   $0x0,(%ecx)
 137:	74 12                	je     14b <strlen+0x1d>
 139:	ba 00 00 00 00       	mov    $0x0,%edx
 13e:	83 c2 01             	add    $0x1,%edx
 141:	89 d0                	mov    %edx,%eax
 143:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 147:	75 f5                	jne    13e <strlen+0x10>
    ;
  return n;
}
 149:	5d                   	pop    %ebp
 14a:	c3                   	ret    
  for(n = 0; s[n]; n++)
 14b:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 150:	eb f7                	jmp    149 <strlen+0x1b>

00000152 <memset>:

void*
memset(void *dst, int c, uint n)
{
 152:	55                   	push   %ebp
 153:	89 e5                	mov    %esp,%ebp
 155:	57                   	push   %edi
 156:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 159:	89 d7                	mov    %edx,%edi
 15b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 15e:	8b 45 0c             	mov    0xc(%ebp),%eax
 161:	fc                   	cld    
 162:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 164:	89 d0                	mov    %edx,%eax
 166:	5f                   	pop    %edi
 167:	5d                   	pop    %ebp
 168:	c3                   	ret    

00000169 <strchr>:

char*
strchr(const char *s, char c)
{
 169:	55                   	push   %ebp
 16a:	89 e5                	mov    %esp,%ebp
 16c:	53                   	push   %ebx
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 173:	0f b6 10             	movzbl (%eax),%edx
 176:	84 d2                	test   %dl,%dl
 178:	74 1e                	je     198 <strchr+0x2f>
 17a:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 17c:	38 d3                	cmp    %dl,%bl
 17e:	74 15                	je     195 <strchr+0x2c>
  for(; *s; s++)
 180:	83 c0 01             	add    $0x1,%eax
 183:	0f b6 10             	movzbl (%eax),%edx
 186:	84 d2                	test   %dl,%dl
 188:	74 06                	je     190 <strchr+0x27>
    if(*s == c)
 18a:	38 ca                	cmp    %cl,%dl
 18c:	75 f2                	jne    180 <strchr+0x17>
 18e:	eb 05                	jmp    195 <strchr+0x2c>
      return (char*)s;
  return 0;
 190:	b8 00 00 00 00       	mov    $0x0,%eax
}
 195:	5b                   	pop    %ebx
 196:	5d                   	pop    %ebp
 197:	c3                   	ret    
  return 0;
 198:	b8 00 00 00 00       	mov    $0x0,%eax
 19d:	eb f6                	jmp    195 <strchr+0x2c>

0000019f <gets>:

char*
gets(char *buf, int max)
{
 19f:	55                   	push   %ebp
 1a0:	89 e5                	mov    %esp,%ebp
 1a2:	57                   	push   %edi
 1a3:	56                   	push   %esi
 1a4:	53                   	push   %ebx
 1a5:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a8:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 1ad:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 1b0:	8d 5e 01             	lea    0x1(%esi),%ebx
 1b3:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1b6:	7d 2b                	jge    1e3 <gets+0x44>
    cc = read(0, &c, 1);
 1b8:	83 ec 04             	sub    $0x4,%esp
 1bb:	6a 01                	push   $0x1
 1bd:	57                   	push   %edi
 1be:	6a 00                	push   $0x0
 1c0:	e8 8f 01 00 00       	call   354 <read>
    if(cc < 1)
 1c5:	83 c4 10             	add    $0x10,%esp
 1c8:	85 c0                	test   %eax,%eax
 1ca:	7e 17                	jle    1e3 <gets+0x44>
      break;
    buf[i++] = c;
 1cc:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1d0:	8b 55 08             	mov    0x8(%ebp),%edx
 1d3:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 1d7:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 1d9:	3c 0a                	cmp    $0xa,%al
 1db:	74 04                	je     1e1 <gets+0x42>
 1dd:	3c 0d                	cmp    $0xd,%al
 1df:	75 cf                	jne    1b0 <gets+0x11>
  for(i=0; i+1 < max; ){
 1e1:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1ed:	5b                   	pop    %ebx
 1ee:	5e                   	pop    %esi
 1ef:	5f                   	pop    %edi
 1f0:	5d                   	pop    %ebp
 1f1:	c3                   	ret    

000001f2 <stat>:

int
stat(char *n, struct stat *st)
{
 1f2:	55                   	push   %ebp
 1f3:	89 e5                	mov    %esp,%ebp
 1f5:	56                   	push   %esi
 1f6:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f7:	83 ec 08             	sub    $0x8,%esp
 1fa:	6a 00                	push   $0x0
 1fc:	ff 75 08             	pushl  0x8(%ebp)
 1ff:	e8 78 01 00 00       	call   37c <open>
  if(fd < 0)
 204:	83 c4 10             	add    $0x10,%esp
 207:	85 c0                	test   %eax,%eax
 209:	78 24                	js     22f <stat+0x3d>
 20b:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 20d:	83 ec 08             	sub    $0x8,%esp
 210:	ff 75 0c             	pushl  0xc(%ebp)
 213:	50                   	push   %eax
 214:	e8 7b 01 00 00       	call   394 <fstat>
 219:	89 c6                	mov    %eax,%esi
  close(fd);
 21b:	89 1c 24             	mov    %ebx,(%esp)
 21e:	e8 41 01 00 00       	call   364 <close>
  return r;
 223:	83 c4 10             	add    $0x10,%esp
}
 226:	89 f0                	mov    %esi,%eax
 228:	8d 65 f8             	lea    -0x8(%ebp),%esp
 22b:	5b                   	pop    %ebx
 22c:	5e                   	pop    %esi
 22d:	5d                   	pop    %ebp
 22e:	c3                   	ret    
    return -1;
 22f:	be ff ff ff ff       	mov    $0xffffffff,%esi
 234:	eb f0                	jmp    226 <stat+0x34>

00000236 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 236:	55                   	push   %ebp
 237:	89 e5                	mov    %esp,%ebp
 239:	56                   	push   %esi
 23a:	53                   	push   %ebx
 23b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 23e:	0f b6 0a             	movzbl (%edx),%ecx
 241:	80 f9 20             	cmp    $0x20,%cl
 244:	75 0b                	jne    251 <atoi+0x1b>
 246:	83 c2 01             	add    $0x1,%edx
 249:	0f b6 0a             	movzbl (%edx),%ecx
 24c:	80 f9 20             	cmp    $0x20,%cl
 24f:	74 f5                	je     246 <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
 251:	80 f9 2d             	cmp    $0x2d,%cl
 254:	74 3b                	je     291 <atoi+0x5b>
  if (*s == '+'  || *s == '-')
 256:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 259:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 25e:	f6 c1 fd             	test   $0xfd,%cl
 261:	74 33                	je     296 <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
 263:	0f b6 0a             	movzbl (%edx),%ecx
 266:	8d 41 d0             	lea    -0x30(%ecx),%eax
 269:	3c 09                	cmp    $0x9,%al
 26b:	77 2e                	ja     29b <atoi+0x65>
 26d:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 272:	83 c2 01             	add    $0x1,%edx
 275:	8d 04 80             	lea    (%eax,%eax,4),%eax
 278:	0f be c9             	movsbl %cl,%ecx
 27b:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 27f:	0f b6 0a             	movzbl (%edx),%ecx
 282:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 285:	80 fb 09             	cmp    $0x9,%bl
 288:	76 e8                	jbe    272 <atoi+0x3c>
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
 299:	eb c8                	jmp    263 <atoi+0x2d>
  while('0' <= *s && *s <= '9')
 29b:	b8 00 00 00 00       	mov    $0x0,%eax
 2a0:	eb e8                	jmp    28a <atoi+0x54>

000002a2 <atoo>:

int
atoo(const char *s)
{
 2a2:	55                   	push   %ebp
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	56                   	push   %esi
 2a6:	53                   	push   %ebx
 2a7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 2aa:	0f b6 0a             	movzbl (%edx),%ecx
 2ad:	80 f9 20             	cmp    $0x20,%cl
 2b0:	75 0b                	jne    2bd <atoo+0x1b>
 2b2:	83 c2 01             	add    $0x1,%edx
 2b5:	0f b6 0a             	movzbl (%edx),%ecx
 2b8:	80 f9 20             	cmp    $0x20,%cl
 2bb:	74 f5                	je     2b2 <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
 2bd:	80 f9 2d             	cmp    $0x2d,%cl
 2c0:	74 38                	je     2fa <atoo+0x58>
  if (*s == '+'  || *s == '-')
 2c2:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 2c5:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 2ca:	f6 c1 fd             	test   $0xfd,%cl
 2cd:	74 30                	je     2ff <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
 2cf:	0f b6 0a             	movzbl (%edx),%ecx
 2d2:	8d 41 d0             	lea    -0x30(%ecx),%eax
 2d5:	3c 07                	cmp    $0x7,%al
 2d7:	77 2b                	ja     304 <atoo+0x62>
 2d9:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
 2de:	83 c2 01             	add    $0x1,%edx
 2e1:	0f be c9             	movsbl %cl,%ecx
 2e4:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 2e8:	0f b6 0a             	movzbl (%edx),%ecx
 2eb:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 2ee:	80 fb 07             	cmp    $0x7,%bl
 2f1:	76 eb                	jbe    2de <atoo+0x3c>
  return sign*n;
 2f3:	0f af c6             	imul   %esi,%eax
}
 2f6:	5b                   	pop    %ebx
 2f7:	5e                   	pop    %esi
 2f8:	5d                   	pop    %ebp
 2f9:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 2fa:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 2ff:	83 c2 01             	add    $0x1,%edx
 302:	eb cb                	jmp    2cf <atoo+0x2d>
  while('0' <= *s && *s <= '7')
 304:	b8 00 00 00 00       	mov    $0x0,%eax
 309:	eb e8                	jmp    2f3 <atoo+0x51>

0000030b <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 30b:	55                   	push   %ebp
 30c:	89 e5                	mov    %esp,%ebp
 30e:	56                   	push   %esi
 30f:	53                   	push   %ebx
 310:	8b 45 08             	mov    0x8(%ebp),%eax
 313:	8b 75 0c             	mov    0xc(%ebp),%esi
 316:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 319:	85 db                	test   %ebx,%ebx
 31b:	7e 13                	jle    330 <memmove+0x25>
 31d:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 322:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 326:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 329:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 32c:	39 d3                	cmp    %edx,%ebx
 32e:	75 f2                	jne    322 <memmove+0x17>
  return vdst;
}
 330:	5b                   	pop    %ebx
 331:	5e                   	pop    %esi
 332:	5d                   	pop    %ebp
 333:	c3                   	ret    

00000334 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 334:	b8 01 00 00 00       	mov    $0x1,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <exit>:
SYSCALL(exit)
 33c:	b8 02 00 00 00       	mov    $0x2,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <wait>:
SYSCALL(wait)
 344:	b8 03 00 00 00       	mov    $0x3,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <pipe>:
SYSCALL(pipe)
 34c:	b8 04 00 00 00       	mov    $0x4,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <read>:
SYSCALL(read)
 354:	b8 05 00 00 00       	mov    $0x5,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <write>:
SYSCALL(write)
 35c:	b8 10 00 00 00       	mov    $0x10,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <close>:
SYSCALL(close)
 364:	b8 15 00 00 00       	mov    $0x15,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <kill>:
SYSCALL(kill)
 36c:	b8 06 00 00 00       	mov    $0x6,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <exec>:
SYSCALL(exec)
 374:	b8 07 00 00 00       	mov    $0x7,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <open>:
SYSCALL(open)
 37c:	b8 0f 00 00 00       	mov    $0xf,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <mknod>:
SYSCALL(mknod)
 384:	b8 11 00 00 00       	mov    $0x11,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <unlink>:
SYSCALL(unlink)
 38c:	b8 12 00 00 00       	mov    $0x12,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <fstat>:
SYSCALL(fstat)
 394:	b8 08 00 00 00       	mov    $0x8,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <link>:
SYSCALL(link)
 39c:	b8 13 00 00 00       	mov    $0x13,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <mkdir>:
SYSCALL(mkdir)
 3a4:	b8 14 00 00 00       	mov    $0x14,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <chdir>:
SYSCALL(chdir)
 3ac:	b8 09 00 00 00       	mov    $0x9,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <dup>:
SYSCALL(dup)
 3b4:	b8 0a 00 00 00       	mov    $0xa,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <getpid>:
SYSCALL(getpid)
 3bc:	b8 0b 00 00 00       	mov    $0xb,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <sbrk>:
SYSCALL(sbrk)
 3c4:	b8 0c 00 00 00       	mov    $0xc,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <sleep>:
SYSCALL(sleep)
 3cc:	b8 0d 00 00 00       	mov    $0xd,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <uptime>:
SYSCALL(uptime)
 3d4:	b8 0e 00 00 00       	mov    $0xe,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <halt>:
SYSCALL(halt)
 3dc:	b8 16 00 00 00       	mov    $0x16,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <date>:
SYSCALL(date)
 3e4:	b8 17 00 00 00       	mov    $0x17,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3ec:	55                   	push   %ebp
 3ed:	89 e5                	mov    %esp,%ebp
 3ef:	57                   	push   %edi
 3f0:	56                   	push   %esi
 3f1:	53                   	push   %ebx
 3f2:	83 ec 3c             	sub    $0x3c,%esp
 3f5:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3fb:	74 14                	je     411 <printint+0x25>
 3fd:	85 d2                	test   %edx,%edx
 3ff:	79 10                	jns    411 <printint+0x25>
    neg = 1;
    x = -xx;
 401:	f7 da                	neg    %edx
    neg = 1;
 403:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 40a:	bf 00 00 00 00       	mov    $0x0,%edi
 40f:	eb 0b                	jmp    41c <printint+0x30>
  neg = 0;
 411:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 418:	eb f0                	jmp    40a <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 41a:	89 df                	mov    %ebx,%edi
 41c:	8d 5f 01             	lea    0x1(%edi),%ebx
 41f:	89 d0                	mov    %edx,%eax
 421:	ba 00 00 00 00       	mov    $0x0,%edx
 426:	f7 f1                	div    %ecx
 428:	0f b6 92 e4 07 00 00 	movzbl 0x7e4(%edx),%edx
 42f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 433:	89 c2                	mov    %eax,%edx
 435:	85 c0                	test   %eax,%eax
 437:	75 e1                	jne    41a <printint+0x2e>
  if(neg)
 439:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 43d:	74 08                	je     447 <printint+0x5b>
    buf[i++] = '-';
 43f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 444:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 447:	83 eb 01             	sub    $0x1,%ebx
 44a:	78 22                	js     46e <printint+0x82>
  write(fd, &c, 1);
 44c:	8d 7d d7             	lea    -0x29(%ebp),%edi
 44f:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 454:	88 45 d7             	mov    %al,-0x29(%ebp)
 457:	83 ec 04             	sub    $0x4,%esp
 45a:	6a 01                	push   $0x1
 45c:	57                   	push   %edi
 45d:	56                   	push   %esi
 45e:	e8 f9 fe ff ff       	call   35c <write>
  while(--i >= 0)
 463:	83 eb 01             	sub    $0x1,%ebx
 466:	83 c4 10             	add    $0x10,%esp
 469:	83 fb ff             	cmp    $0xffffffff,%ebx
 46c:	75 e1                	jne    44f <printint+0x63>
    putc(fd, buf[i]);
}
 46e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 471:	5b                   	pop    %ebx
 472:	5e                   	pop    %esi
 473:	5f                   	pop    %edi
 474:	5d                   	pop    %ebp
 475:	c3                   	ret    

00000476 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 476:	55                   	push   %ebp
 477:	89 e5                	mov    %esp,%ebp
 479:	57                   	push   %edi
 47a:	56                   	push   %esi
 47b:	53                   	push   %ebx
 47c:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 47f:	8b 75 0c             	mov    0xc(%ebp),%esi
 482:	0f b6 1e             	movzbl (%esi),%ebx
 485:	84 db                	test   %bl,%bl
 487:	0f 84 b1 01 00 00    	je     63e <printf+0x1c8>
 48d:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 490:	8d 45 10             	lea    0x10(%ebp),%eax
 493:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 496:	bf 00 00 00 00       	mov    $0x0,%edi
 49b:	eb 2d                	jmp    4ca <printf+0x54>
 49d:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 4a0:	83 ec 04             	sub    $0x4,%esp
 4a3:	6a 01                	push   $0x1
 4a5:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4a8:	50                   	push   %eax
 4a9:	ff 75 08             	pushl  0x8(%ebp)
 4ac:	e8 ab fe ff ff       	call   35c <write>
 4b1:	83 c4 10             	add    $0x10,%esp
 4b4:	eb 05                	jmp    4bb <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4b6:	83 ff 25             	cmp    $0x25,%edi
 4b9:	74 22                	je     4dd <printf+0x67>
 4bb:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 4be:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 4c2:	84 db                	test   %bl,%bl
 4c4:	0f 84 74 01 00 00    	je     63e <printf+0x1c8>
    c = fmt[i] & 0xff;
 4ca:	0f be d3             	movsbl %bl,%edx
 4cd:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 4d0:	85 ff                	test   %edi,%edi
 4d2:	75 e2                	jne    4b6 <printf+0x40>
      if(c == '%'){
 4d4:	83 f8 25             	cmp    $0x25,%eax
 4d7:	75 c4                	jne    49d <printf+0x27>
        state = '%';
 4d9:	89 c7                	mov    %eax,%edi
 4db:	eb de                	jmp    4bb <printf+0x45>
      if(c == 'd'){
 4dd:	83 f8 64             	cmp    $0x64,%eax
 4e0:	74 59                	je     53b <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4e2:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 4e8:	83 fa 70             	cmp    $0x70,%edx
 4eb:	74 7a                	je     567 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4ed:	83 f8 73             	cmp    $0x73,%eax
 4f0:	0f 84 9d 00 00 00    	je     593 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4f6:	83 f8 63             	cmp    $0x63,%eax
 4f9:	0f 84 f2 00 00 00    	je     5f1 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4ff:	83 f8 25             	cmp    $0x25,%eax
 502:	0f 84 15 01 00 00    	je     61d <printf+0x1a7>
 508:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 50c:	83 ec 04             	sub    $0x4,%esp
 50f:	6a 01                	push   $0x1
 511:	8d 45 e7             	lea    -0x19(%ebp),%eax
 514:	50                   	push   %eax
 515:	ff 75 08             	pushl  0x8(%ebp)
 518:	e8 3f fe ff ff       	call   35c <write>
 51d:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 520:	83 c4 0c             	add    $0xc,%esp
 523:	6a 01                	push   $0x1
 525:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 528:	50                   	push   %eax
 529:	ff 75 08             	pushl  0x8(%ebp)
 52c:	e8 2b fe ff ff       	call   35c <write>
 531:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 534:	bf 00 00 00 00       	mov    $0x0,%edi
 539:	eb 80                	jmp    4bb <printf+0x45>
        printint(fd, *ap, 10, 1);
 53b:	83 ec 0c             	sub    $0xc,%esp
 53e:	6a 01                	push   $0x1
 540:	b9 0a 00 00 00       	mov    $0xa,%ecx
 545:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 548:	8b 17                	mov    (%edi),%edx
 54a:	8b 45 08             	mov    0x8(%ebp),%eax
 54d:	e8 9a fe ff ff       	call   3ec <printint>
        ap++;
 552:	89 f8                	mov    %edi,%eax
 554:	83 c0 04             	add    $0x4,%eax
 557:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 55a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 55d:	bf 00 00 00 00       	mov    $0x0,%edi
 562:	e9 54 ff ff ff       	jmp    4bb <printf+0x45>
        printint(fd, *ap, 16, 0);
 567:	83 ec 0c             	sub    $0xc,%esp
 56a:	6a 00                	push   $0x0
 56c:	b9 10 00 00 00       	mov    $0x10,%ecx
 571:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 574:	8b 17                	mov    (%edi),%edx
 576:	8b 45 08             	mov    0x8(%ebp),%eax
 579:	e8 6e fe ff ff       	call   3ec <printint>
        ap++;
 57e:	89 f8                	mov    %edi,%eax
 580:	83 c0 04             	add    $0x4,%eax
 583:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 586:	83 c4 10             	add    $0x10,%esp
      state = 0;
 589:	bf 00 00 00 00       	mov    $0x0,%edi
 58e:	e9 28 ff ff ff       	jmp    4bb <printf+0x45>
        s = (char*)*ap;
 593:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 596:	8b 01                	mov    (%ecx),%eax
        ap++;
 598:	83 c1 04             	add    $0x4,%ecx
 59b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 59e:	85 c0                	test   %eax,%eax
 5a0:	74 13                	je     5b5 <printf+0x13f>
        s = (char*)*ap;
 5a2:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 5a4:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 5a7:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 5ac:	84 c0                	test   %al,%al
 5ae:	75 0f                	jne    5bf <printf+0x149>
 5b0:	e9 06 ff ff ff       	jmp    4bb <printf+0x45>
          s = "(null)";
 5b5:	bb dc 07 00 00       	mov    $0x7dc,%ebx
        while(*s != 0){
 5ba:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 5bf:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 5c2:	89 75 d0             	mov    %esi,-0x30(%ebp)
 5c5:	8b 75 08             	mov    0x8(%ebp),%esi
 5c8:	88 45 e3             	mov    %al,-0x1d(%ebp)
 5cb:	83 ec 04             	sub    $0x4,%esp
 5ce:	6a 01                	push   $0x1
 5d0:	57                   	push   %edi
 5d1:	56                   	push   %esi
 5d2:	e8 85 fd ff ff       	call   35c <write>
          s++;
 5d7:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 5da:	0f b6 03             	movzbl (%ebx),%eax
 5dd:	83 c4 10             	add    $0x10,%esp
 5e0:	84 c0                	test   %al,%al
 5e2:	75 e4                	jne    5c8 <printf+0x152>
 5e4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 5e7:	bf 00 00 00 00       	mov    $0x0,%edi
 5ec:	e9 ca fe ff ff       	jmp    4bb <printf+0x45>
        putc(fd, *ap);
 5f1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5f4:	8b 07                	mov    (%edi),%eax
 5f6:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 5f9:	83 ec 04             	sub    $0x4,%esp
 5fc:	6a 01                	push   $0x1
 5fe:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 601:	50                   	push   %eax
 602:	ff 75 08             	pushl  0x8(%ebp)
 605:	e8 52 fd ff ff       	call   35c <write>
        ap++;
 60a:	83 c7 04             	add    $0x4,%edi
 60d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 610:	83 c4 10             	add    $0x10,%esp
      state = 0;
 613:	bf 00 00 00 00       	mov    $0x0,%edi
 618:	e9 9e fe ff ff       	jmp    4bb <printf+0x45>
 61d:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 620:	83 ec 04             	sub    $0x4,%esp
 623:	6a 01                	push   $0x1
 625:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 628:	50                   	push   %eax
 629:	ff 75 08             	pushl  0x8(%ebp)
 62c:	e8 2b fd ff ff       	call   35c <write>
 631:	83 c4 10             	add    $0x10,%esp
      state = 0;
 634:	bf 00 00 00 00       	mov    $0x0,%edi
 639:	e9 7d fe ff ff       	jmp    4bb <printf+0x45>
    }
  }
}
 63e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 641:	5b                   	pop    %ebx
 642:	5e                   	pop    %esi
 643:	5f                   	pop    %edi
 644:	5d                   	pop    %ebp
 645:	c3                   	ret    

00000646 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 646:	55                   	push   %ebp
 647:	89 e5                	mov    %esp,%ebp
 649:	57                   	push   %edi
 64a:	56                   	push   %esi
 64b:	53                   	push   %ebx
 64c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 64f:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 652:	a1 88 0a 00 00       	mov    0xa88,%eax
 657:	eb 0c                	jmp    665 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 659:	8b 10                	mov    (%eax),%edx
 65b:	39 c2                	cmp    %eax,%edx
 65d:	77 04                	ja     663 <free+0x1d>
 65f:	39 ca                	cmp    %ecx,%edx
 661:	77 10                	ja     673 <free+0x2d>
{
 663:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 665:	39 c8                	cmp    %ecx,%eax
 667:	73 f0                	jae    659 <free+0x13>
 669:	8b 10                	mov    (%eax),%edx
 66b:	39 ca                	cmp    %ecx,%edx
 66d:	77 04                	ja     673 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 66f:	39 c2                	cmp    %eax,%edx
 671:	77 f0                	ja     663 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 673:	8b 73 fc             	mov    -0x4(%ebx),%esi
 676:	8b 10                	mov    (%eax),%edx
 678:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 67b:	39 fa                	cmp    %edi,%edx
 67d:	74 19                	je     698 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 67f:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 682:	8b 50 04             	mov    0x4(%eax),%edx
 685:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 688:	39 f1                	cmp    %esi,%ecx
 68a:	74 1b                	je     6a7 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 68c:	89 08                	mov    %ecx,(%eax)
  freep = p;
 68e:	a3 88 0a 00 00       	mov    %eax,0xa88
}
 693:	5b                   	pop    %ebx
 694:	5e                   	pop    %esi
 695:	5f                   	pop    %edi
 696:	5d                   	pop    %ebp
 697:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 698:	03 72 04             	add    0x4(%edx),%esi
 69b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 69e:	8b 10                	mov    (%eax),%edx
 6a0:	8b 12                	mov    (%edx),%edx
 6a2:	89 53 f8             	mov    %edx,-0x8(%ebx)
 6a5:	eb db                	jmp    682 <free+0x3c>
    p->s.size += bp->s.size;
 6a7:	03 53 fc             	add    -0x4(%ebx),%edx
 6aa:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ad:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6b0:	89 10                	mov    %edx,(%eax)
 6b2:	eb da                	jmp    68e <free+0x48>

000006b4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6b4:	55                   	push   %ebp
 6b5:	89 e5                	mov    %esp,%ebp
 6b7:	57                   	push   %edi
 6b8:	56                   	push   %esi
 6b9:	53                   	push   %ebx
 6ba:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6bd:	8b 45 08             	mov    0x8(%ebp),%eax
 6c0:	8d 58 07             	lea    0x7(%eax),%ebx
 6c3:	c1 eb 03             	shr    $0x3,%ebx
 6c6:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6c9:	8b 15 88 0a 00 00    	mov    0xa88,%edx
 6cf:	85 d2                	test   %edx,%edx
 6d1:	74 20                	je     6f3 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6d3:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 6d5:	8b 48 04             	mov    0x4(%eax),%ecx
 6d8:	39 cb                	cmp    %ecx,%ebx
 6da:	76 3c                	jbe    718 <malloc+0x64>
 6dc:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 6e2:	be 00 10 00 00       	mov    $0x1000,%esi
 6e7:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 6ea:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 6f1:	eb 70                	jmp    763 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 6f3:	c7 05 88 0a 00 00 8c 	movl   $0xa8c,0xa88
 6fa:	0a 00 00 
 6fd:	c7 05 8c 0a 00 00 8c 	movl   $0xa8c,0xa8c
 704:	0a 00 00 
    base.s.size = 0;
 707:	c7 05 90 0a 00 00 00 	movl   $0x0,0xa90
 70e:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 711:	ba 8c 0a 00 00       	mov    $0xa8c,%edx
 716:	eb bb                	jmp    6d3 <malloc+0x1f>
      if(p->s.size == nunits)
 718:	39 cb                	cmp    %ecx,%ebx
 71a:	74 1c                	je     738 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 71c:	29 d9                	sub    %ebx,%ecx
 71e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 721:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 724:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 727:	89 15 88 0a 00 00    	mov    %edx,0xa88
      return (void*)(p + 1);
 72d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 730:	8d 65 f4             	lea    -0xc(%ebp),%esp
 733:	5b                   	pop    %ebx
 734:	5e                   	pop    %esi
 735:	5f                   	pop    %edi
 736:	5d                   	pop    %ebp
 737:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 738:	8b 08                	mov    (%eax),%ecx
 73a:	89 0a                	mov    %ecx,(%edx)
 73c:	eb e9                	jmp    727 <malloc+0x73>
  hp->s.size = nu;
 73e:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 741:	83 ec 0c             	sub    $0xc,%esp
 744:	83 c0 08             	add    $0x8,%eax
 747:	50                   	push   %eax
 748:	e8 f9 fe ff ff       	call   646 <free>
  return freep;
 74d:	8b 15 88 0a 00 00    	mov    0xa88,%edx
      if((p = morecore(nunits)) == 0)
 753:	83 c4 10             	add    $0x10,%esp
 756:	85 d2                	test   %edx,%edx
 758:	74 2b                	je     785 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 75a:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 75c:	8b 48 04             	mov    0x4(%eax),%ecx
 75f:	39 d9                	cmp    %ebx,%ecx
 761:	73 b5                	jae    718 <malloc+0x64>
 763:	89 c2                	mov    %eax,%edx
    if(p == freep)
 765:	39 05 88 0a 00 00    	cmp    %eax,0xa88
 76b:	75 ed                	jne    75a <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 76d:	83 ec 0c             	sub    $0xc,%esp
 770:	57                   	push   %edi
 771:	e8 4e fc ff ff       	call   3c4 <sbrk>
  if(p == (char*)-1)
 776:	83 c4 10             	add    $0x10,%esp
 779:	83 f8 ff             	cmp    $0xffffffff,%eax
 77c:	75 c0                	jne    73e <malloc+0x8a>
        return 0;
 77e:	b8 00 00 00 00       	mov    $0x0,%eax
 783:	eb ab                	jmp    730 <malloc+0x7c>
 785:	b8 00 00 00 00       	mov    $0x0,%eax
 78a:	eb a4                	jmp    730 <malloc+0x7c>
