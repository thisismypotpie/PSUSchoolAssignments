
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

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
  11:	81 ec 20 02 00 00    	sub    $0x220,%esp
  int fd, i;
  char path[] = "stressfs0";
  17:	c7 45 de 73 74 72 65 	movl   $0x65727473,-0x22(%ebp)
  1e:	c7 45 e2 73 73 66 73 	movl   $0x73667373,-0x1e(%ebp)
  25:	66 c7 45 e6 30 00    	movw   $0x30,-0x1a(%ebp)
  char data[512];

  printf(1, "stressfs starting\n");
  2b:	68 c0 07 00 00       	push   $0x7c0
  30:	6a 01                	push   $0x1
  32:	e8 71 04 00 00       	call   4a8 <printf>
  memset(data, 'a', sizeof(data));
  37:	83 c4 0c             	add    $0xc,%esp
  3a:	68 00 02 00 00       	push   $0x200
  3f:	6a 61                	push   $0x61
  41:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  47:	50                   	push   %eax
  48:	e8 37 01 00 00       	call   184 <memset>
  4d:	83 c4 10             	add    $0x10,%esp

  for(i = 0; i < 4; i++)
  50:	bb 00 00 00 00       	mov    $0x0,%ebx
    if(fork() > 0)
  55:	e8 0c 03 00 00       	call   366 <fork>
  5a:	85 c0                	test   %eax,%eax
  5c:	7f 08                	jg     66 <main+0x66>
  for(i = 0; i < 4; i++)
  5e:	83 c3 01             	add    $0x1,%ebx
  61:	83 fb 04             	cmp    $0x4,%ebx
  64:	75 ef                	jne    55 <main+0x55>
      break;

  printf(1, "write %d\n", i);
  66:	83 ec 04             	sub    $0x4,%esp
  69:	53                   	push   %ebx
  6a:	68 d3 07 00 00       	push   $0x7d3
  6f:	6a 01                	push   $0x1
  71:	e8 32 04 00 00       	call   4a8 <printf>

  path[8] += i;
  76:	00 5d e6             	add    %bl,-0x1a(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  79:	83 c4 08             	add    $0x8,%esp
  7c:	68 02 02 00 00       	push   $0x202
  81:	8d 45 de             	lea    -0x22(%ebp),%eax
  84:	50                   	push   %eax
  85:	e8 24 03 00 00       	call   3ae <open>
  8a:	89 c6                	mov    %eax,%esi
  8c:	83 c4 10             	add    $0x10,%esp
  8f:	bb 14 00 00 00       	mov    $0x14,%ebx
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  94:	8d bd de fd ff ff    	lea    -0x222(%ebp),%edi
  9a:	83 ec 04             	sub    $0x4,%esp
  9d:	68 00 02 00 00       	push   $0x200
  a2:	57                   	push   %edi
  a3:	56                   	push   %esi
  a4:	e8 e5 02 00 00       	call   38e <write>
  for(i = 0; i < 20; i++)
  a9:	83 c4 10             	add    $0x10,%esp
  ac:	83 eb 01             	sub    $0x1,%ebx
  af:	75 e9                	jne    9a <main+0x9a>
  close(fd);
  b1:	83 ec 0c             	sub    $0xc,%esp
  b4:	56                   	push   %esi
  b5:	e8 dc 02 00 00       	call   396 <close>

  printf(1, "read\n");
  ba:	83 c4 08             	add    $0x8,%esp
  bd:	68 dd 07 00 00       	push   $0x7dd
  c2:	6a 01                	push   $0x1
  c4:	e8 df 03 00 00       	call   4a8 <printf>

  fd = open(path, O_RDONLY);
  c9:	83 c4 08             	add    $0x8,%esp
  cc:	6a 00                	push   $0x0
  ce:	8d 45 de             	lea    -0x22(%ebp),%eax
  d1:	50                   	push   %eax
  d2:	e8 d7 02 00 00       	call   3ae <open>
  d7:	89 c6                	mov    %eax,%esi
  d9:	83 c4 10             	add    $0x10,%esp
  dc:	bb 14 00 00 00       	mov    $0x14,%ebx
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  e1:	8d bd de fd ff ff    	lea    -0x222(%ebp),%edi
  e7:	83 ec 04             	sub    $0x4,%esp
  ea:	68 00 02 00 00       	push   $0x200
  ef:	57                   	push   %edi
  f0:	56                   	push   %esi
  f1:	e8 90 02 00 00       	call   386 <read>
  for (i = 0; i < 20; i++)
  f6:	83 c4 10             	add    $0x10,%esp
  f9:	83 eb 01             	sub    $0x1,%ebx
  fc:	75 e9                	jne    e7 <main+0xe7>
  close(fd);
  fe:	83 ec 0c             	sub    $0xc,%esp
 101:	56                   	push   %esi
 102:	e8 8f 02 00 00       	call   396 <close>

  wait();
 107:	e8 6a 02 00 00       	call   376 <wait>

  exit();
 10c:	e8 5d 02 00 00       	call   36e <exit>

00000111 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 111:	55                   	push   %ebp
 112:	89 e5                	mov    %esp,%ebp
 114:	53                   	push   %ebx
 115:	8b 45 08             	mov    0x8(%ebp),%eax
 118:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11b:	89 c2                	mov    %eax,%edx
 11d:	83 c1 01             	add    $0x1,%ecx
 120:	83 c2 01             	add    $0x1,%edx
 123:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 127:	88 5a ff             	mov    %bl,-0x1(%edx)
 12a:	84 db                	test   %bl,%bl
 12c:	75 ef                	jne    11d <strcpy+0xc>
    ;
  return os;
}
 12e:	5b                   	pop    %ebx
 12f:	5d                   	pop    %ebp
 130:	c3                   	ret    

00000131 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 131:	55                   	push   %ebp
 132:	89 e5                	mov    %esp,%ebp
 134:	8b 4d 08             	mov    0x8(%ebp),%ecx
 137:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 13a:	0f b6 01             	movzbl (%ecx),%eax
 13d:	84 c0                	test   %al,%al
 13f:	74 15                	je     156 <strcmp+0x25>
 141:	3a 02                	cmp    (%edx),%al
 143:	75 11                	jne    156 <strcmp+0x25>
    p++, q++;
 145:	83 c1 01             	add    $0x1,%ecx
 148:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 14b:	0f b6 01             	movzbl (%ecx),%eax
 14e:	84 c0                	test   %al,%al
 150:	74 04                	je     156 <strcmp+0x25>
 152:	3a 02                	cmp    (%edx),%al
 154:	74 ef                	je     145 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 156:	0f b6 c0             	movzbl %al,%eax
 159:	0f b6 12             	movzbl (%edx),%edx
 15c:	29 d0                	sub    %edx,%eax
}
 15e:	5d                   	pop    %ebp
 15f:	c3                   	ret    

00000160 <strlen>:

uint
strlen(char *s)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 166:	80 39 00             	cmpb   $0x0,(%ecx)
 169:	74 12                	je     17d <strlen+0x1d>
 16b:	ba 00 00 00 00       	mov    $0x0,%edx
 170:	83 c2 01             	add    $0x1,%edx
 173:	89 d0                	mov    %edx,%eax
 175:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 179:	75 f5                	jne    170 <strlen+0x10>
    ;
  return n;
}
 17b:	5d                   	pop    %ebp
 17c:	c3                   	ret    
  for(n = 0; s[n]; n++)
 17d:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 182:	eb f7                	jmp    17b <strlen+0x1b>

00000184 <memset>:

void*
memset(void *dst, int c, uint n)
{
 184:	55                   	push   %ebp
 185:	89 e5                	mov    %esp,%ebp
 187:	57                   	push   %edi
 188:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 18b:	89 d7                	mov    %edx,%edi
 18d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 190:	8b 45 0c             	mov    0xc(%ebp),%eax
 193:	fc                   	cld    
 194:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 196:	89 d0                	mov    %edx,%eax
 198:	5f                   	pop    %edi
 199:	5d                   	pop    %ebp
 19a:	c3                   	ret    

0000019b <strchr>:

char*
strchr(const char *s, char c)
{
 19b:	55                   	push   %ebp
 19c:	89 e5                	mov    %esp,%ebp
 19e:	53                   	push   %ebx
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
 1a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 1a5:	0f b6 10             	movzbl (%eax),%edx
 1a8:	84 d2                	test   %dl,%dl
 1aa:	74 1e                	je     1ca <strchr+0x2f>
 1ac:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 1ae:	38 d3                	cmp    %dl,%bl
 1b0:	74 15                	je     1c7 <strchr+0x2c>
  for(; *s; s++)
 1b2:	83 c0 01             	add    $0x1,%eax
 1b5:	0f b6 10             	movzbl (%eax),%edx
 1b8:	84 d2                	test   %dl,%dl
 1ba:	74 06                	je     1c2 <strchr+0x27>
    if(*s == c)
 1bc:	38 ca                	cmp    %cl,%dl
 1be:	75 f2                	jne    1b2 <strchr+0x17>
 1c0:	eb 05                	jmp    1c7 <strchr+0x2c>
      return (char*)s;
  return 0;
 1c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1c7:	5b                   	pop    %ebx
 1c8:	5d                   	pop    %ebp
 1c9:	c3                   	ret    
  return 0;
 1ca:	b8 00 00 00 00       	mov    $0x0,%eax
 1cf:	eb f6                	jmp    1c7 <strchr+0x2c>

000001d1 <gets>:

char*
gets(char *buf, int max)
{
 1d1:	55                   	push   %ebp
 1d2:	89 e5                	mov    %esp,%ebp
 1d4:	57                   	push   %edi
 1d5:	56                   	push   %esi
 1d6:	53                   	push   %ebx
 1d7:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1da:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 1df:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 1e2:	8d 5e 01             	lea    0x1(%esi),%ebx
 1e5:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1e8:	7d 2b                	jge    215 <gets+0x44>
    cc = read(0, &c, 1);
 1ea:	83 ec 04             	sub    $0x4,%esp
 1ed:	6a 01                	push   $0x1
 1ef:	57                   	push   %edi
 1f0:	6a 00                	push   $0x0
 1f2:	e8 8f 01 00 00       	call   386 <read>
    if(cc < 1)
 1f7:	83 c4 10             	add    $0x10,%esp
 1fa:	85 c0                	test   %eax,%eax
 1fc:	7e 17                	jle    215 <gets+0x44>
      break;
    buf[i++] = c;
 1fe:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 202:	8b 55 08             	mov    0x8(%ebp),%edx
 205:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 209:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 20b:	3c 0a                	cmp    $0xa,%al
 20d:	74 04                	je     213 <gets+0x42>
 20f:	3c 0d                	cmp    $0xd,%al
 211:	75 cf                	jne    1e2 <gets+0x11>
  for(i=0; i+1 < max; ){
 213:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 21c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 21f:	5b                   	pop    %ebx
 220:	5e                   	pop    %esi
 221:	5f                   	pop    %edi
 222:	5d                   	pop    %ebp
 223:	c3                   	ret    

00000224 <stat>:

int
stat(char *n, struct stat *st)
{
 224:	55                   	push   %ebp
 225:	89 e5                	mov    %esp,%ebp
 227:	56                   	push   %esi
 228:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 229:	83 ec 08             	sub    $0x8,%esp
 22c:	6a 00                	push   $0x0
 22e:	ff 75 08             	pushl  0x8(%ebp)
 231:	e8 78 01 00 00       	call   3ae <open>
  if(fd < 0)
 236:	83 c4 10             	add    $0x10,%esp
 239:	85 c0                	test   %eax,%eax
 23b:	78 24                	js     261 <stat+0x3d>
 23d:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 23f:	83 ec 08             	sub    $0x8,%esp
 242:	ff 75 0c             	pushl  0xc(%ebp)
 245:	50                   	push   %eax
 246:	e8 7b 01 00 00       	call   3c6 <fstat>
 24b:	89 c6                	mov    %eax,%esi
  close(fd);
 24d:	89 1c 24             	mov    %ebx,(%esp)
 250:	e8 41 01 00 00       	call   396 <close>
  return r;
 255:	83 c4 10             	add    $0x10,%esp
}
 258:	89 f0                	mov    %esi,%eax
 25a:	8d 65 f8             	lea    -0x8(%ebp),%esp
 25d:	5b                   	pop    %ebx
 25e:	5e                   	pop    %esi
 25f:	5d                   	pop    %ebp
 260:	c3                   	ret    
    return -1;
 261:	be ff ff ff ff       	mov    $0xffffffff,%esi
 266:	eb f0                	jmp    258 <stat+0x34>

00000268 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 268:	55                   	push   %ebp
 269:	89 e5                	mov    %esp,%ebp
 26b:	56                   	push   %esi
 26c:	53                   	push   %ebx
 26d:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 270:	0f b6 0a             	movzbl (%edx),%ecx
 273:	80 f9 20             	cmp    $0x20,%cl
 276:	75 0b                	jne    283 <atoi+0x1b>
 278:	83 c2 01             	add    $0x1,%edx
 27b:	0f b6 0a             	movzbl (%edx),%ecx
 27e:	80 f9 20             	cmp    $0x20,%cl
 281:	74 f5                	je     278 <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
 283:	80 f9 2d             	cmp    $0x2d,%cl
 286:	74 3b                	je     2c3 <atoi+0x5b>
  if (*s == '+'  || *s == '-')
 288:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 28b:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 290:	f6 c1 fd             	test   $0xfd,%cl
 293:	74 33                	je     2c8 <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
 295:	0f b6 0a             	movzbl (%edx),%ecx
 298:	8d 41 d0             	lea    -0x30(%ecx),%eax
 29b:	3c 09                	cmp    $0x9,%al
 29d:	77 2e                	ja     2cd <atoi+0x65>
 29f:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 2a4:	83 c2 01             	add    $0x1,%edx
 2a7:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2aa:	0f be c9             	movsbl %cl,%ecx
 2ad:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 2b1:	0f b6 0a             	movzbl (%edx),%ecx
 2b4:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 2b7:	80 fb 09             	cmp    $0x9,%bl
 2ba:	76 e8                	jbe    2a4 <atoi+0x3c>
  return sign*n;
 2bc:	0f af c6             	imul   %esi,%eax
}
 2bf:	5b                   	pop    %ebx
 2c0:	5e                   	pop    %esi
 2c1:	5d                   	pop    %ebp
 2c2:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 2c3:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 2c8:	83 c2 01             	add    $0x1,%edx
 2cb:	eb c8                	jmp    295 <atoi+0x2d>
  while('0' <= *s && *s <= '9')
 2cd:	b8 00 00 00 00       	mov    $0x0,%eax
 2d2:	eb e8                	jmp    2bc <atoi+0x54>

000002d4 <atoo>:

int
atoo(const char *s)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	56                   	push   %esi
 2d8:	53                   	push   %ebx
 2d9:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 2dc:	0f b6 0a             	movzbl (%edx),%ecx
 2df:	80 f9 20             	cmp    $0x20,%cl
 2e2:	75 0b                	jne    2ef <atoo+0x1b>
 2e4:	83 c2 01             	add    $0x1,%edx
 2e7:	0f b6 0a             	movzbl (%edx),%ecx
 2ea:	80 f9 20             	cmp    $0x20,%cl
 2ed:	74 f5                	je     2e4 <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
 2ef:	80 f9 2d             	cmp    $0x2d,%cl
 2f2:	74 38                	je     32c <atoo+0x58>
  if (*s == '+'  || *s == '-')
 2f4:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 2f7:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 2fc:	f6 c1 fd             	test   $0xfd,%cl
 2ff:	74 30                	je     331 <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
 301:	0f b6 0a             	movzbl (%edx),%ecx
 304:	8d 41 d0             	lea    -0x30(%ecx),%eax
 307:	3c 07                	cmp    $0x7,%al
 309:	77 2b                	ja     336 <atoo+0x62>
 30b:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
 310:	83 c2 01             	add    $0x1,%edx
 313:	0f be c9             	movsbl %cl,%ecx
 316:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 31a:	0f b6 0a             	movzbl (%edx),%ecx
 31d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 320:	80 fb 07             	cmp    $0x7,%bl
 323:	76 eb                	jbe    310 <atoo+0x3c>
  return sign*n;
 325:	0f af c6             	imul   %esi,%eax
}
 328:	5b                   	pop    %ebx
 329:	5e                   	pop    %esi
 32a:	5d                   	pop    %ebp
 32b:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 32c:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 331:	83 c2 01             	add    $0x1,%edx
 334:	eb cb                	jmp    301 <atoo+0x2d>
  while('0' <= *s && *s <= '7')
 336:	b8 00 00 00 00       	mov    $0x0,%eax
 33b:	eb e8                	jmp    325 <atoo+0x51>

0000033d <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 33d:	55                   	push   %ebp
 33e:	89 e5                	mov    %esp,%ebp
 340:	56                   	push   %esi
 341:	53                   	push   %ebx
 342:	8b 45 08             	mov    0x8(%ebp),%eax
 345:	8b 75 0c             	mov    0xc(%ebp),%esi
 348:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 34b:	85 db                	test   %ebx,%ebx
 34d:	7e 13                	jle    362 <memmove+0x25>
 34f:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 354:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 358:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 35b:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 35e:	39 d3                	cmp    %edx,%ebx
 360:	75 f2                	jne    354 <memmove+0x17>
  return vdst;
}
 362:	5b                   	pop    %ebx
 363:	5e                   	pop    %esi
 364:	5d                   	pop    %ebp
 365:	c3                   	ret    

00000366 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 366:	b8 01 00 00 00       	mov    $0x1,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <exit>:
SYSCALL(exit)
 36e:	b8 02 00 00 00       	mov    $0x2,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <wait>:
SYSCALL(wait)
 376:	b8 03 00 00 00       	mov    $0x3,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <pipe>:
SYSCALL(pipe)
 37e:	b8 04 00 00 00       	mov    $0x4,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <read>:
SYSCALL(read)
 386:	b8 05 00 00 00       	mov    $0x5,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <write>:
SYSCALL(write)
 38e:	b8 10 00 00 00       	mov    $0x10,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <close>:
SYSCALL(close)
 396:	b8 15 00 00 00       	mov    $0x15,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <kill>:
SYSCALL(kill)
 39e:	b8 06 00 00 00       	mov    $0x6,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <exec>:
SYSCALL(exec)
 3a6:	b8 07 00 00 00       	mov    $0x7,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <open>:
SYSCALL(open)
 3ae:	b8 0f 00 00 00       	mov    $0xf,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <mknod>:
SYSCALL(mknod)
 3b6:	b8 11 00 00 00       	mov    $0x11,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <unlink>:
SYSCALL(unlink)
 3be:	b8 12 00 00 00       	mov    $0x12,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <fstat>:
SYSCALL(fstat)
 3c6:	b8 08 00 00 00       	mov    $0x8,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <link>:
SYSCALL(link)
 3ce:	b8 13 00 00 00       	mov    $0x13,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <mkdir>:
SYSCALL(mkdir)
 3d6:	b8 14 00 00 00       	mov    $0x14,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <chdir>:
SYSCALL(chdir)
 3de:	b8 09 00 00 00       	mov    $0x9,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <dup>:
SYSCALL(dup)
 3e6:	b8 0a 00 00 00       	mov    $0xa,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <getpid>:
SYSCALL(getpid)
 3ee:	b8 0b 00 00 00       	mov    $0xb,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <sbrk>:
SYSCALL(sbrk)
 3f6:	b8 0c 00 00 00       	mov    $0xc,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <sleep>:
SYSCALL(sleep)
 3fe:	b8 0d 00 00 00       	mov    $0xd,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <uptime>:
SYSCALL(uptime)
 406:	b8 0e 00 00 00       	mov    $0xe,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <halt>:
SYSCALL(halt)
 40e:	b8 16 00 00 00       	mov    $0x16,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <date>:
SYSCALL(date)
 416:	b8 17 00 00 00       	mov    $0x17,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 41e:	55                   	push   %ebp
 41f:	89 e5                	mov    %esp,%ebp
 421:	57                   	push   %edi
 422:	56                   	push   %esi
 423:	53                   	push   %ebx
 424:	83 ec 3c             	sub    $0x3c,%esp
 427:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 429:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 42d:	74 14                	je     443 <printint+0x25>
 42f:	85 d2                	test   %edx,%edx
 431:	79 10                	jns    443 <printint+0x25>
    neg = 1;
    x = -xx;
 433:	f7 da                	neg    %edx
    neg = 1;
 435:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 43c:	bf 00 00 00 00       	mov    $0x0,%edi
 441:	eb 0b                	jmp    44e <printint+0x30>
  neg = 0;
 443:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 44a:	eb f0                	jmp    43c <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 44c:	89 df                	mov    %ebx,%edi
 44e:	8d 5f 01             	lea    0x1(%edi),%ebx
 451:	89 d0                	mov    %edx,%eax
 453:	ba 00 00 00 00       	mov    $0x0,%edx
 458:	f7 f1                	div    %ecx
 45a:	0f b6 92 ec 07 00 00 	movzbl 0x7ec(%edx),%edx
 461:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 465:	89 c2                	mov    %eax,%edx
 467:	85 c0                	test   %eax,%eax
 469:	75 e1                	jne    44c <printint+0x2e>
  if(neg)
 46b:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 46f:	74 08                	je     479 <printint+0x5b>
    buf[i++] = '-';
 471:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 476:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 479:	83 eb 01             	sub    $0x1,%ebx
 47c:	78 22                	js     4a0 <printint+0x82>
  write(fd, &c, 1);
 47e:	8d 7d d7             	lea    -0x29(%ebp),%edi
 481:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 486:	88 45 d7             	mov    %al,-0x29(%ebp)
 489:	83 ec 04             	sub    $0x4,%esp
 48c:	6a 01                	push   $0x1
 48e:	57                   	push   %edi
 48f:	56                   	push   %esi
 490:	e8 f9 fe ff ff       	call   38e <write>
  while(--i >= 0)
 495:	83 eb 01             	sub    $0x1,%ebx
 498:	83 c4 10             	add    $0x10,%esp
 49b:	83 fb ff             	cmp    $0xffffffff,%ebx
 49e:	75 e1                	jne    481 <printint+0x63>
    putc(fd, buf[i]);
}
 4a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4a3:	5b                   	pop    %ebx
 4a4:	5e                   	pop    %esi
 4a5:	5f                   	pop    %edi
 4a6:	5d                   	pop    %ebp
 4a7:	c3                   	ret    

000004a8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4a8:	55                   	push   %ebp
 4a9:	89 e5                	mov    %esp,%ebp
 4ab:	57                   	push   %edi
 4ac:	56                   	push   %esi
 4ad:	53                   	push   %ebx
 4ae:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 4b1:	8b 75 0c             	mov    0xc(%ebp),%esi
 4b4:	0f b6 1e             	movzbl (%esi),%ebx
 4b7:	84 db                	test   %bl,%bl
 4b9:	0f 84 b1 01 00 00    	je     670 <printf+0x1c8>
 4bf:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 4c2:	8d 45 10             	lea    0x10(%ebp),%eax
 4c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 4c8:	bf 00 00 00 00       	mov    $0x0,%edi
 4cd:	eb 2d                	jmp    4fc <printf+0x54>
 4cf:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 4d2:	83 ec 04             	sub    $0x4,%esp
 4d5:	6a 01                	push   $0x1
 4d7:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 4da:	50                   	push   %eax
 4db:	ff 75 08             	pushl  0x8(%ebp)
 4de:	e8 ab fe ff ff       	call   38e <write>
 4e3:	83 c4 10             	add    $0x10,%esp
 4e6:	eb 05                	jmp    4ed <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4e8:	83 ff 25             	cmp    $0x25,%edi
 4eb:	74 22                	je     50f <printf+0x67>
 4ed:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 4f0:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 4f4:	84 db                	test   %bl,%bl
 4f6:	0f 84 74 01 00 00    	je     670 <printf+0x1c8>
    c = fmt[i] & 0xff;
 4fc:	0f be d3             	movsbl %bl,%edx
 4ff:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 502:	85 ff                	test   %edi,%edi
 504:	75 e2                	jne    4e8 <printf+0x40>
      if(c == '%'){
 506:	83 f8 25             	cmp    $0x25,%eax
 509:	75 c4                	jne    4cf <printf+0x27>
        state = '%';
 50b:	89 c7                	mov    %eax,%edi
 50d:	eb de                	jmp    4ed <printf+0x45>
      if(c == 'd'){
 50f:	83 f8 64             	cmp    $0x64,%eax
 512:	74 59                	je     56d <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 514:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 51a:	83 fa 70             	cmp    $0x70,%edx
 51d:	74 7a                	je     599 <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 51f:	83 f8 73             	cmp    $0x73,%eax
 522:	0f 84 9d 00 00 00    	je     5c5 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 528:	83 f8 63             	cmp    $0x63,%eax
 52b:	0f 84 f2 00 00 00    	je     623 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 531:	83 f8 25             	cmp    $0x25,%eax
 534:	0f 84 15 01 00 00    	je     64f <printf+0x1a7>
 53a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 53e:	83 ec 04             	sub    $0x4,%esp
 541:	6a 01                	push   $0x1
 543:	8d 45 e7             	lea    -0x19(%ebp),%eax
 546:	50                   	push   %eax
 547:	ff 75 08             	pushl  0x8(%ebp)
 54a:	e8 3f fe ff ff       	call   38e <write>
 54f:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 552:	83 c4 0c             	add    $0xc,%esp
 555:	6a 01                	push   $0x1
 557:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 55a:	50                   	push   %eax
 55b:	ff 75 08             	pushl  0x8(%ebp)
 55e:	e8 2b fe ff ff       	call   38e <write>
 563:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 566:	bf 00 00 00 00       	mov    $0x0,%edi
 56b:	eb 80                	jmp    4ed <printf+0x45>
        printint(fd, *ap, 10, 1);
 56d:	83 ec 0c             	sub    $0xc,%esp
 570:	6a 01                	push   $0x1
 572:	b9 0a 00 00 00       	mov    $0xa,%ecx
 577:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 57a:	8b 17                	mov    (%edi),%edx
 57c:	8b 45 08             	mov    0x8(%ebp),%eax
 57f:	e8 9a fe ff ff       	call   41e <printint>
        ap++;
 584:	89 f8                	mov    %edi,%eax
 586:	83 c0 04             	add    $0x4,%eax
 589:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 58c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 58f:	bf 00 00 00 00       	mov    $0x0,%edi
 594:	e9 54 ff ff ff       	jmp    4ed <printf+0x45>
        printint(fd, *ap, 16, 0);
 599:	83 ec 0c             	sub    $0xc,%esp
 59c:	6a 00                	push   $0x0
 59e:	b9 10 00 00 00       	mov    $0x10,%ecx
 5a3:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5a6:	8b 17                	mov    (%edi),%edx
 5a8:	8b 45 08             	mov    0x8(%ebp),%eax
 5ab:	e8 6e fe ff ff       	call   41e <printint>
        ap++;
 5b0:	89 f8                	mov    %edi,%eax
 5b2:	83 c0 04             	add    $0x4,%eax
 5b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 5b8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5bb:	bf 00 00 00 00       	mov    $0x0,%edi
 5c0:	e9 28 ff ff ff       	jmp    4ed <printf+0x45>
        s = (char*)*ap;
 5c5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 5c8:	8b 01                	mov    (%ecx),%eax
        ap++;
 5ca:	83 c1 04             	add    $0x4,%ecx
 5cd:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 5d0:	85 c0                	test   %eax,%eax
 5d2:	74 13                	je     5e7 <printf+0x13f>
        s = (char*)*ap;
 5d4:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 5d6:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 5d9:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 5de:	84 c0                	test   %al,%al
 5e0:	75 0f                	jne    5f1 <printf+0x149>
 5e2:	e9 06 ff ff ff       	jmp    4ed <printf+0x45>
          s = "(null)";
 5e7:	bb e3 07 00 00       	mov    $0x7e3,%ebx
        while(*s != 0){
 5ec:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 5f1:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 5f4:	89 75 d0             	mov    %esi,-0x30(%ebp)
 5f7:	8b 75 08             	mov    0x8(%ebp),%esi
 5fa:	88 45 e3             	mov    %al,-0x1d(%ebp)
 5fd:	83 ec 04             	sub    $0x4,%esp
 600:	6a 01                	push   $0x1
 602:	57                   	push   %edi
 603:	56                   	push   %esi
 604:	e8 85 fd ff ff       	call   38e <write>
          s++;
 609:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 60c:	0f b6 03             	movzbl (%ebx),%eax
 60f:	83 c4 10             	add    $0x10,%esp
 612:	84 c0                	test   %al,%al
 614:	75 e4                	jne    5fa <printf+0x152>
 616:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 619:	bf 00 00 00 00       	mov    $0x0,%edi
 61e:	e9 ca fe ff ff       	jmp    4ed <printf+0x45>
        putc(fd, *ap);
 623:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 626:	8b 07                	mov    (%edi),%eax
 628:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 62b:	83 ec 04             	sub    $0x4,%esp
 62e:	6a 01                	push   $0x1
 630:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 633:	50                   	push   %eax
 634:	ff 75 08             	pushl  0x8(%ebp)
 637:	e8 52 fd ff ff       	call   38e <write>
        ap++;
 63c:	83 c7 04             	add    $0x4,%edi
 63f:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 642:	83 c4 10             	add    $0x10,%esp
      state = 0;
 645:	bf 00 00 00 00       	mov    $0x0,%edi
 64a:	e9 9e fe ff ff       	jmp    4ed <printf+0x45>
 64f:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 652:	83 ec 04             	sub    $0x4,%esp
 655:	6a 01                	push   $0x1
 657:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 65a:	50                   	push   %eax
 65b:	ff 75 08             	pushl  0x8(%ebp)
 65e:	e8 2b fd ff ff       	call   38e <write>
 663:	83 c4 10             	add    $0x10,%esp
      state = 0;
 666:	bf 00 00 00 00       	mov    $0x0,%edi
 66b:	e9 7d fe ff ff       	jmp    4ed <printf+0x45>
    }
  }
}
 670:	8d 65 f4             	lea    -0xc(%ebp),%esp
 673:	5b                   	pop    %ebx
 674:	5e                   	pop    %esi
 675:	5f                   	pop    %edi
 676:	5d                   	pop    %ebp
 677:	c3                   	ret    

00000678 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 678:	55                   	push   %ebp
 679:	89 e5                	mov    %esp,%ebp
 67b:	57                   	push   %edi
 67c:	56                   	push   %esi
 67d:	53                   	push   %ebx
 67e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 681:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 684:	a1 90 0a 00 00       	mov    0xa90,%eax
 689:	eb 0c                	jmp    697 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 68b:	8b 10                	mov    (%eax),%edx
 68d:	39 c2                	cmp    %eax,%edx
 68f:	77 04                	ja     695 <free+0x1d>
 691:	39 ca                	cmp    %ecx,%edx
 693:	77 10                	ja     6a5 <free+0x2d>
{
 695:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 697:	39 c8                	cmp    %ecx,%eax
 699:	73 f0                	jae    68b <free+0x13>
 69b:	8b 10                	mov    (%eax),%edx
 69d:	39 ca                	cmp    %ecx,%edx
 69f:	77 04                	ja     6a5 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a1:	39 c2                	cmp    %eax,%edx
 6a3:	77 f0                	ja     695 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6a5:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6a8:	8b 10                	mov    (%eax),%edx
 6aa:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6ad:	39 fa                	cmp    %edi,%edx
 6af:	74 19                	je     6ca <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 6b1:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 6b4:	8b 50 04             	mov    0x4(%eax),%edx
 6b7:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 6ba:	39 f1                	cmp    %esi,%ecx
 6bc:	74 1b                	je     6d9 <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 6be:	89 08                	mov    %ecx,(%eax)
  freep = p;
 6c0:	a3 90 0a 00 00       	mov    %eax,0xa90
}
 6c5:	5b                   	pop    %ebx
 6c6:	5e                   	pop    %esi
 6c7:	5f                   	pop    %edi
 6c8:	5d                   	pop    %ebp
 6c9:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 6ca:	03 72 04             	add    0x4(%edx),%esi
 6cd:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 6d0:	8b 10                	mov    (%eax),%edx
 6d2:	8b 12                	mov    (%edx),%edx
 6d4:	89 53 f8             	mov    %edx,-0x8(%ebx)
 6d7:	eb db                	jmp    6b4 <free+0x3c>
    p->s.size += bp->s.size;
 6d9:	03 53 fc             	add    -0x4(%ebx),%edx
 6dc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6df:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6e2:	89 10                	mov    %edx,(%eax)
 6e4:	eb da                	jmp    6c0 <free+0x48>

000006e6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6e6:	55                   	push   %ebp
 6e7:	89 e5                	mov    %esp,%ebp
 6e9:	57                   	push   %edi
 6ea:	56                   	push   %esi
 6eb:	53                   	push   %ebx
 6ec:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6ef:	8b 45 08             	mov    0x8(%ebp),%eax
 6f2:	8d 58 07             	lea    0x7(%eax),%ebx
 6f5:	c1 eb 03             	shr    $0x3,%ebx
 6f8:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6fb:	8b 15 90 0a 00 00    	mov    0xa90,%edx
 701:	85 d2                	test   %edx,%edx
 703:	74 20                	je     725 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 705:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 707:	8b 48 04             	mov    0x4(%eax),%ecx
 70a:	39 cb                	cmp    %ecx,%ebx
 70c:	76 3c                	jbe    74a <malloc+0x64>
 70e:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 714:	be 00 10 00 00       	mov    $0x1000,%esi
 719:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 71c:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 723:	eb 70                	jmp    795 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 725:	c7 05 90 0a 00 00 94 	movl   $0xa94,0xa90
 72c:	0a 00 00 
 72f:	c7 05 94 0a 00 00 94 	movl   $0xa94,0xa94
 736:	0a 00 00 
    base.s.size = 0;
 739:	c7 05 98 0a 00 00 00 	movl   $0x0,0xa98
 740:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 743:	ba 94 0a 00 00       	mov    $0xa94,%edx
 748:	eb bb                	jmp    705 <malloc+0x1f>
      if(p->s.size == nunits)
 74a:	39 cb                	cmp    %ecx,%ebx
 74c:	74 1c                	je     76a <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 74e:	29 d9                	sub    %ebx,%ecx
 750:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 753:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 756:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 759:	89 15 90 0a 00 00    	mov    %edx,0xa90
      return (void*)(p + 1);
 75f:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 762:	8d 65 f4             	lea    -0xc(%ebp),%esp
 765:	5b                   	pop    %ebx
 766:	5e                   	pop    %esi
 767:	5f                   	pop    %edi
 768:	5d                   	pop    %ebp
 769:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 76a:	8b 08                	mov    (%eax),%ecx
 76c:	89 0a                	mov    %ecx,(%edx)
 76e:	eb e9                	jmp    759 <malloc+0x73>
  hp->s.size = nu;
 770:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 773:	83 ec 0c             	sub    $0xc,%esp
 776:	83 c0 08             	add    $0x8,%eax
 779:	50                   	push   %eax
 77a:	e8 f9 fe ff ff       	call   678 <free>
  return freep;
 77f:	8b 15 90 0a 00 00    	mov    0xa90,%edx
      if((p = morecore(nunits)) == 0)
 785:	83 c4 10             	add    $0x10,%esp
 788:	85 d2                	test   %edx,%edx
 78a:	74 2b                	je     7b7 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78c:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 78e:	8b 48 04             	mov    0x4(%eax),%ecx
 791:	39 d9                	cmp    %ebx,%ecx
 793:	73 b5                	jae    74a <malloc+0x64>
 795:	89 c2                	mov    %eax,%edx
    if(p == freep)
 797:	39 05 90 0a 00 00    	cmp    %eax,0xa90
 79d:	75 ed                	jne    78c <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 79f:	83 ec 0c             	sub    $0xc,%esp
 7a2:	57                   	push   %edi
 7a3:	e8 4e fc ff ff       	call   3f6 <sbrk>
  if(p == (char*)-1)
 7a8:	83 c4 10             	add    $0x10,%esp
 7ab:	83 f8 ff             	cmp    $0xffffffff,%eax
 7ae:	75 c0                	jne    770 <malloc+0x8a>
        return 0;
 7b0:	b8 00 00 00 00       	mov    $0x0,%eax
 7b5:	eb ab                	jmp    762 <malloc+0x7c>
 7b7:	b8 00 00 00 00       	mov    $0x0,%eax
 7bc:	eb a4                	jmp    762 <malloc+0x7c>
