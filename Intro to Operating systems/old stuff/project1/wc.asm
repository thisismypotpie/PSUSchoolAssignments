
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 ec 1c             	sub    $0x1c,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
   9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  l = w = c = 0;
  10:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  17:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  1e:	be 00 00 00 00       	mov    $0x0,%esi
  while((n = read(fd, buf, sizeof(buf))) > 0){
  23:	eb 4d                	jmp    72 <wc+0x72>
      c++;
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
        inword = 0;
      else if(!inword){
  25:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  29:	75 0b                	jne    36 <wc+0x36>
        w++;
  2b:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
        inword = 1;
  2f:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    for(i=0; i<n; i++){
  36:	83 c3 01             	add    $0x1,%ebx
  39:	39 df                	cmp    %ebx,%edi
  3b:	74 32                	je     6f <wc+0x6f>
      if(buf[i] == '\n')
  3d:	0f b6 83 60 0b 00 00 	movzbl 0xb60(%ebx),%eax
        l++;
  44:	3c 0a                	cmp    $0xa,%al
  46:	0f 94 c2             	sete   %dl
  49:	0f b6 d2             	movzbl %dl,%edx
  4c:	01 d6                	add    %edx,%esi
      if(strchr(" \r\t\n\v", buf[i]))
  4e:	83 ec 08             	sub    $0x8,%esp
  51:	0f be c0             	movsbl %al,%eax
  54:	50                   	push   %eax
  55:	68 14 08 00 00       	push   $0x814
  5a:	e8 92 01 00 00       	call   1f1 <strchr>
  5f:	83 c4 10             	add    $0x10,%esp
  62:	85 c0                	test   %eax,%eax
  64:	74 bf                	je     25 <wc+0x25>
        inword = 0;
  66:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6d:	eb c7                	jmp    36 <wc+0x36>
  6f:	01 5d dc             	add    %ebx,-0x24(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	83 ec 04             	sub    $0x4,%esp
  75:	68 00 02 00 00       	push   $0x200
  7a:	68 60 0b 00 00       	push   $0xb60
  7f:	ff 75 08             	pushl  0x8(%ebp)
  82:	e8 55 03 00 00       	call   3dc <read>
  87:	89 c7                	mov    %eax,%edi
  89:	83 c4 10             	add    $0x10,%esp
  8c:	85 c0                	test   %eax,%eax
  8e:	7e 07                	jle    97 <wc+0x97>
    for(i=0; i<n; i++){
  90:	bb 00 00 00 00       	mov    $0x0,%ebx
  95:	eb a6                	jmp    3d <wc+0x3d>
      }
    }
  }
  if(n < 0){
  97:	85 c0                	test   %eax,%eax
  99:	78 24                	js     bf <wc+0xbf>
    printf(1, "wc: read error\n");
    exit();
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  9b:	83 ec 08             	sub    $0x8,%esp
  9e:	ff 75 0c             	pushl  0xc(%ebp)
  a1:	ff 75 dc             	pushl  -0x24(%ebp)
  a4:	ff 75 e0             	pushl  -0x20(%ebp)
  a7:	56                   	push   %esi
  a8:	68 2a 08 00 00       	push   $0x82a
  ad:	6a 01                	push   $0x1
  af:	e8 4a 04 00 00       	call   4fe <printf>
}
  b4:	83 c4 20             	add    $0x20,%esp
  b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ba:	5b                   	pop    %ebx
  bb:	5e                   	pop    %esi
  bc:	5f                   	pop    %edi
  bd:	5d                   	pop    %ebp
  be:	c3                   	ret    
    printf(1, "wc: read error\n");
  bf:	83 ec 08             	sub    $0x8,%esp
  c2:	68 1a 08 00 00       	push   $0x81a
  c7:	6a 01                	push   $0x1
  c9:	e8 30 04 00 00       	call   4fe <printf>
    exit();
  ce:	e8 f1 02 00 00       	call   3c4 <exit>

000000d3 <main>:

int
main(int argc, char *argv[])
{
  d3:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  d7:	83 e4 f0             	and    $0xfffffff0,%esp
  da:	ff 71 fc             	pushl  -0x4(%ecx)
  dd:	55                   	push   %ebp
  de:	89 e5                	mov    %esp,%ebp
  e0:	57                   	push   %edi
  e1:	56                   	push   %esi
  e2:	53                   	push   %ebx
  e3:	51                   	push   %ecx
  e4:	83 ec 18             	sub    $0x18,%esp
  e7:	8b 01                	mov    (%ecx),%eax
  e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  ec:	8b 59 04             	mov    0x4(%ecx),%ebx
  ef:	83 c3 04             	add    $0x4,%ebx
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
  f2:	bf 01 00 00 00       	mov    $0x1,%edi
  if(argc <= 1){
  f7:	83 f8 01             	cmp    $0x1,%eax
  fa:	7e 3e                	jle    13a <main+0x67>
    if((fd = open(argv[i], 0)) < 0){
  fc:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  ff:	83 ec 08             	sub    $0x8,%esp
 102:	6a 00                	push   $0x0
 104:	ff 33                	pushl  (%ebx)
 106:	e8 f9 02 00 00       	call   404 <open>
 10b:	89 c6                	mov    %eax,%esi
 10d:	83 c4 10             	add    $0x10,%esp
 110:	85 c0                	test   %eax,%eax
 112:	78 3a                	js     14e <main+0x7b>
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
 114:	83 ec 08             	sub    $0x8,%esp
 117:	ff 33                	pushl  (%ebx)
 119:	50                   	push   %eax
 11a:	e8 e1 fe ff ff       	call   0 <wc>
    close(fd);
 11f:	89 34 24             	mov    %esi,(%esp)
 122:	e8 c5 02 00 00       	call   3ec <close>
  for(i = 1; i < argc; i++){
 127:	83 c7 01             	add    $0x1,%edi
 12a:	83 c3 04             	add    $0x4,%ebx
 12d:	83 c4 10             	add    $0x10,%esp
 130:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
 133:	75 c7                	jne    fc <main+0x29>
  }
  exit();
 135:	e8 8a 02 00 00       	call   3c4 <exit>
    wc(0, "");
 13a:	83 ec 08             	sub    $0x8,%esp
 13d:	68 29 08 00 00       	push   $0x829
 142:	6a 00                	push   $0x0
 144:	e8 b7 fe ff ff       	call   0 <wc>
    exit();
 149:	e8 76 02 00 00       	call   3c4 <exit>
      printf(1, "wc: cannot open %s\n", argv[i]);
 14e:	83 ec 04             	sub    $0x4,%esp
 151:	8b 45 e0             	mov    -0x20(%ebp),%eax
 154:	ff 30                	pushl  (%eax)
 156:	68 37 08 00 00       	push   $0x837
 15b:	6a 01                	push   $0x1
 15d:	e8 9c 03 00 00       	call   4fe <printf>
      exit();
 162:	e8 5d 02 00 00       	call   3c4 <exit>

00000167 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 167:	55                   	push   %ebp
 168:	89 e5                	mov    %esp,%ebp
 16a:	53                   	push   %ebx
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 171:	89 c2                	mov    %eax,%edx
 173:	83 c1 01             	add    $0x1,%ecx
 176:	83 c2 01             	add    $0x1,%edx
 179:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 17d:	88 5a ff             	mov    %bl,-0x1(%edx)
 180:	84 db                	test   %bl,%bl
 182:	75 ef                	jne    173 <strcpy+0xc>
    ;
  return os;
}
 184:	5b                   	pop    %ebx
 185:	5d                   	pop    %ebp
 186:	c3                   	ret    

00000187 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 187:	55                   	push   %ebp
 188:	89 e5                	mov    %esp,%ebp
 18a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 18d:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 190:	0f b6 01             	movzbl (%ecx),%eax
 193:	84 c0                	test   %al,%al
 195:	74 15                	je     1ac <strcmp+0x25>
 197:	3a 02                	cmp    (%edx),%al
 199:	75 11                	jne    1ac <strcmp+0x25>
    p++, q++;
 19b:	83 c1 01             	add    $0x1,%ecx
 19e:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 1a1:	0f b6 01             	movzbl (%ecx),%eax
 1a4:	84 c0                	test   %al,%al
 1a6:	74 04                	je     1ac <strcmp+0x25>
 1a8:	3a 02                	cmp    (%edx),%al
 1aa:	74 ef                	je     19b <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 1ac:	0f b6 c0             	movzbl %al,%eax
 1af:	0f b6 12             	movzbl (%edx),%edx
 1b2:	29 d0                	sub    %edx,%eax
}
 1b4:	5d                   	pop    %ebp
 1b5:	c3                   	ret    

000001b6 <strlen>:

uint
strlen(char *s)
{
 1b6:	55                   	push   %ebp
 1b7:	89 e5                	mov    %esp,%ebp
 1b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 1bc:	80 39 00             	cmpb   $0x0,(%ecx)
 1bf:	74 12                	je     1d3 <strlen+0x1d>
 1c1:	ba 00 00 00 00       	mov    $0x0,%edx
 1c6:	83 c2 01             	add    $0x1,%edx
 1c9:	89 d0                	mov    %edx,%eax
 1cb:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 1cf:	75 f5                	jne    1c6 <strlen+0x10>
    ;
  return n;
}
 1d1:	5d                   	pop    %ebp
 1d2:	c3                   	ret    
  for(n = 0; s[n]; n++)
 1d3:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 1d8:	eb f7                	jmp    1d1 <strlen+0x1b>

000001da <memset>:

void*
memset(void *dst, int c, uint n)
{
 1da:	55                   	push   %ebp
 1db:	89 e5                	mov    %esp,%ebp
 1dd:	57                   	push   %edi
 1de:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1e1:	89 d7                	mov    %edx,%edi
 1e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e9:	fc                   	cld    
 1ea:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1ec:	89 d0                	mov    %edx,%eax
 1ee:	5f                   	pop    %edi
 1ef:	5d                   	pop    %ebp
 1f0:	c3                   	ret    

000001f1 <strchr>:

char*
strchr(const char *s, char c)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	53                   	push   %ebx
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
 1f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 1fb:	0f b6 10             	movzbl (%eax),%edx
 1fe:	84 d2                	test   %dl,%dl
 200:	74 1e                	je     220 <strchr+0x2f>
 202:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 204:	38 d3                	cmp    %dl,%bl
 206:	74 15                	je     21d <strchr+0x2c>
  for(; *s; s++)
 208:	83 c0 01             	add    $0x1,%eax
 20b:	0f b6 10             	movzbl (%eax),%edx
 20e:	84 d2                	test   %dl,%dl
 210:	74 06                	je     218 <strchr+0x27>
    if(*s == c)
 212:	38 ca                	cmp    %cl,%dl
 214:	75 f2                	jne    208 <strchr+0x17>
 216:	eb 05                	jmp    21d <strchr+0x2c>
      return (char*)s;
  return 0;
 218:	b8 00 00 00 00       	mov    $0x0,%eax
}
 21d:	5b                   	pop    %ebx
 21e:	5d                   	pop    %ebp
 21f:	c3                   	ret    
  return 0;
 220:	b8 00 00 00 00       	mov    $0x0,%eax
 225:	eb f6                	jmp    21d <strchr+0x2c>

00000227 <gets>:

char*
gets(char *buf, int max)
{
 227:	55                   	push   %ebp
 228:	89 e5                	mov    %esp,%ebp
 22a:	57                   	push   %edi
 22b:	56                   	push   %esi
 22c:	53                   	push   %ebx
 22d:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 230:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 235:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 238:	8d 5e 01             	lea    0x1(%esi),%ebx
 23b:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 23e:	7d 2b                	jge    26b <gets+0x44>
    cc = read(0, &c, 1);
 240:	83 ec 04             	sub    $0x4,%esp
 243:	6a 01                	push   $0x1
 245:	57                   	push   %edi
 246:	6a 00                	push   $0x0
 248:	e8 8f 01 00 00       	call   3dc <read>
    if(cc < 1)
 24d:	83 c4 10             	add    $0x10,%esp
 250:	85 c0                	test   %eax,%eax
 252:	7e 17                	jle    26b <gets+0x44>
      break;
    buf[i++] = c;
 254:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 258:	8b 55 08             	mov    0x8(%ebp),%edx
 25b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 25f:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 261:	3c 0a                	cmp    $0xa,%al
 263:	74 04                	je     269 <gets+0x42>
 265:	3c 0d                	cmp    $0xd,%al
 267:	75 cf                	jne    238 <gets+0x11>
  for(i=0; i+1 < max; ){
 269:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 272:	8d 65 f4             	lea    -0xc(%ebp),%esp
 275:	5b                   	pop    %ebx
 276:	5e                   	pop    %esi
 277:	5f                   	pop    %edi
 278:	5d                   	pop    %ebp
 279:	c3                   	ret    

0000027a <stat>:

int
stat(char *n, struct stat *st)
{
 27a:	55                   	push   %ebp
 27b:	89 e5                	mov    %esp,%ebp
 27d:	56                   	push   %esi
 27e:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27f:	83 ec 08             	sub    $0x8,%esp
 282:	6a 00                	push   $0x0
 284:	ff 75 08             	pushl  0x8(%ebp)
 287:	e8 78 01 00 00       	call   404 <open>
  if(fd < 0)
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	85 c0                	test   %eax,%eax
 291:	78 24                	js     2b7 <stat+0x3d>
 293:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 295:	83 ec 08             	sub    $0x8,%esp
 298:	ff 75 0c             	pushl  0xc(%ebp)
 29b:	50                   	push   %eax
 29c:	e8 7b 01 00 00       	call   41c <fstat>
 2a1:	89 c6                	mov    %eax,%esi
  close(fd);
 2a3:	89 1c 24             	mov    %ebx,(%esp)
 2a6:	e8 41 01 00 00       	call   3ec <close>
  return r;
 2ab:	83 c4 10             	add    $0x10,%esp
}
 2ae:	89 f0                	mov    %esi,%eax
 2b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2b3:	5b                   	pop    %ebx
 2b4:	5e                   	pop    %esi
 2b5:	5d                   	pop    %ebp
 2b6:	c3                   	ret    
    return -1;
 2b7:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2bc:	eb f0                	jmp    2ae <stat+0x34>

000002be <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 2be:	55                   	push   %ebp
 2bf:	89 e5                	mov    %esp,%ebp
 2c1:	56                   	push   %esi
 2c2:	53                   	push   %ebx
 2c3:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 2c6:	0f b6 0a             	movzbl (%edx),%ecx
 2c9:	80 f9 20             	cmp    $0x20,%cl
 2cc:	75 0b                	jne    2d9 <atoi+0x1b>
 2ce:	83 c2 01             	add    $0x1,%edx
 2d1:	0f b6 0a             	movzbl (%edx),%ecx
 2d4:	80 f9 20             	cmp    $0x20,%cl
 2d7:	74 f5                	je     2ce <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
 2d9:	80 f9 2d             	cmp    $0x2d,%cl
 2dc:	74 3b                	je     319 <atoi+0x5b>
  if (*s == '+'  || *s == '-')
 2de:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 2e1:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 2e6:	f6 c1 fd             	test   $0xfd,%cl
 2e9:	74 33                	je     31e <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
 2eb:	0f b6 0a             	movzbl (%edx),%ecx
 2ee:	8d 41 d0             	lea    -0x30(%ecx),%eax
 2f1:	3c 09                	cmp    $0x9,%al
 2f3:	77 2e                	ja     323 <atoi+0x65>
 2f5:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 2fa:	83 c2 01             	add    $0x1,%edx
 2fd:	8d 04 80             	lea    (%eax,%eax,4),%eax
 300:	0f be c9             	movsbl %cl,%ecx
 303:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 307:	0f b6 0a             	movzbl (%edx),%ecx
 30a:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 30d:	80 fb 09             	cmp    $0x9,%bl
 310:	76 e8                	jbe    2fa <atoi+0x3c>
  return sign*n;
 312:	0f af c6             	imul   %esi,%eax
}
 315:	5b                   	pop    %ebx
 316:	5e                   	pop    %esi
 317:	5d                   	pop    %ebp
 318:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 319:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 31e:	83 c2 01             	add    $0x1,%edx
 321:	eb c8                	jmp    2eb <atoi+0x2d>
  while('0' <= *s && *s <= '9')
 323:	b8 00 00 00 00       	mov    $0x0,%eax
 328:	eb e8                	jmp    312 <atoi+0x54>

0000032a <atoo>:

int
atoo(const char *s)
{
 32a:	55                   	push   %ebp
 32b:	89 e5                	mov    %esp,%ebp
 32d:	56                   	push   %esi
 32e:	53                   	push   %ebx
 32f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 332:	0f b6 0a             	movzbl (%edx),%ecx
 335:	80 f9 20             	cmp    $0x20,%cl
 338:	75 0b                	jne    345 <atoo+0x1b>
 33a:	83 c2 01             	add    $0x1,%edx
 33d:	0f b6 0a             	movzbl (%edx),%ecx
 340:	80 f9 20             	cmp    $0x20,%cl
 343:	74 f5                	je     33a <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
 345:	80 f9 2d             	cmp    $0x2d,%cl
 348:	74 38                	je     382 <atoo+0x58>
  if (*s == '+'  || *s == '-')
 34a:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 34d:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 352:	f6 c1 fd             	test   $0xfd,%cl
 355:	74 30                	je     387 <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
 357:	0f b6 0a             	movzbl (%edx),%ecx
 35a:	8d 41 d0             	lea    -0x30(%ecx),%eax
 35d:	3c 07                	cmp    $0x7,%al
 35f:	77 2b                	ja     38c <atoo+0x62>
 361:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
 366:	83 c2 01             	add    $0x1,%edx
 369:	0f be c9             	movsbl %cl,%ecx
 36c:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 370:	0f b6 0a             	movzbl (%edx),%ecx
 373:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 376:	80 fb 07             	cmp    $0x7,%bl
 379:	76 eb                	jbe    366 <atoo+0x3c>
  return sign*n;
 37b:	0f af c6             	imul   %esi,%eax
}
 37e:	5b                   	pop    %ebx
 37f:	5e                   	pop    %esi
 380:	5d                   	pop    %ebp
 381:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 382:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 387:	83 c2 01             	add    $0x1,%edx
 38a:	eb cb                	jmp    357 <atoo+0x2d>
  while('0' <= *s && *s <= '7')
 38c:	b8 00 00 00 00       	mov    $0x0,%eax
 391:	eb e8                	jmp    37b <atoo+0x51>

00000393 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 393:	55                   	push   %ebp
 394:	89 e5                	mov    %esp,%ebp
 396:	56                   	push   %esi
 397:	53                   	push   %ebx
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	8b 75 0c             	mov    0xc(%ebp),%esi
 39e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3a1:	85 db                	test   %ebx,%ebx
 3a3:	7e 13                	jle    3b8 <memmove+0x25>
 3a5:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 3aa:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 3ae:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 3b1:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 3b4:	39 d3                	cmp    %edx,%ebx
 3b6:	75 f2                	jne    3aa <memmove+0x17>
  return vdst;
}
 3b8:	5b                   	pop    %ebx
 3b9:	5e                   	pop    %esi
 3ba:	5d                   	pop    %ebp
 3bb:	c3                   	ret    

000003bc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3bc:	b8 01 00 00 00       	mov    $0x1,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <exit>:
SYSCALL(exit)
 3c4:	b8 02 00 00 00       	mov    $0x2,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <wait>:
SYSCALL(wait)
 3cc:	b8 03 00 00 00       	mov    $0x3,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <pipe>:
SYSCALL(pipe)
 3d4:	b8 04 00 00 00       	mov    $0x4,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <read>:
SYSCALL(read)
 3dc:	b8 05 00 00 00       	mov    $0x5,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <write>:
SYSCALL(write)
 3e4:	b8 10 00 00 00       	mov    $0x10,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <close>:
SYSCALL(close)
 3ec:	b8 15 00 00 00       	mov    $0x15,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <kill>:
SYSCALL(kill)
 3f4:	b8 06 00 00 00       	mov    $0x6,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <exec>:
SYSCALL(exec)
 3fc:	b8 07 00 00 00       	mov    $0x7,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <open>:
SYSCALL(open)
 404:	b8 0f 00 00 00       	mov    $0xf,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <mknod>:
SYSCALL(mknod)
 40c:	b8 11 00 00 00       	mov    $0x11,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <unlink>:
SYSCALL(unlink)
 414:	b8 12 00 00 00       	mov    $0x12,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <fstat>:
SYSCALL(fstat)
 41c:	b8 08 00 00 00       	mov    $0x8,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <link>:
SYSCALL(link)
 424:	b8 13 00 00 00       	mov    $0x13,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <mkdir>:
SYSCALL(mkdir)
 42c:	b8 14 00 00 00       	mov    $0x14,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <chdir>:
SYSCALL(chdir)
 434:	b8 09 00 00 00       	mov    $0x9,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <dup>:
SYSCALL(dup)
 43c:	b8 0a 00 00 00       	mov    $0xa,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <getpid>:
SYSCALL(getpid)
 444:	b8 0b 00 00 00       	mov    $0xb,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <sbrk>:
SYSCALL(sbrk)
 44c:	b8 0c 00 00 00       	mov    $0xc,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <sleep>:
SYSCALL(sleep)
 454:	b8 0d 00 00 00       	mov    $0xd,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <uptime>:
SYSCALL(uptime)
 45c:	b8 0e 00 00 00       	mov    $0xe,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <halt>:
SYSCALL(halt)
 464:	b8 16 00 00 00       	mov    $0x16,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <date>:
SYSCALL(date)
 46c:	b8 17 00 00 00       	mov    $0x17,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 474:	55                   	push   %ebp
 475:	89 e5                	mov    %esp,%ebp
 477:	57                   	push   %edi
 478:	56                   	push   %esi
 479:	53                   	push   %ebx
 47a:	83 ec 3c             	sub    $0x3c,%esp
 47d:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 47f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 483:	74 14                	je     499 <printint+0x25>
 485:	85 d2                	test   %edx,%edx
 487:	79 10                	jns    499 <printint+0x25>
    neg = 1;
    x = -xx;
 489:	f7 da                	neg    %edx
    neg = 1;
 48b:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 492:	bf 00 00 00 00       	mov    $0x0,%edi
 497:	eb 0b                	jmp    4a4 <printint+0x30>
  neg = 0;
 499:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 4a0:	eb f0                	jmp    492 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 4a2:	89 df                	mov    %ebx,%edi
 4a4:	8d 5f 01             	lea    0x1(%edi),%ebx
 4a7:	89 d0                	mov    %edx,%eax
 4a9:	ba 00 00 00 00       	mov    $0x0,%edx
 4ae:	f7 f1                	div    %ecx
 4b0:	0f b6 92 54 08 00 00 	movzbl 0x854(%edx),%edx
 4b7:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 4bb:	89 c2                	mov    %eax,%edx
 4bd:	85 c0                	test   %eax,%eax
 4bf:	75 e1                	jne    4a2 <printint+0x2e>
  if(neg)
 4c1:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 4c5:	74 08                	je     4cf <printint+0x5b>
    buf[i++] = '-';
 4c7:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 4cc:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 4cf:	83 eb 01             	sub    $0x1,%ebx
 4d2:	78 22                	js     4f6 <printint+0x82>
  write(fd, &c, 1);
 4d4:	8d 7d d7             	lea    -0x29(%ebp),%edi
 4d7:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 4dc:	88 45 d7             	mov    %al,-0x29(%ebp)
 4df:	83 ec 04             	sub    $0x4,%esp
 4e2:	6a 01                	push   $0x1
 4e4:	57                   	push   %edi
 4e5:	56                   	push   %esi
 4e6:	e8 f9 fe ff ff       	call   3e4 <write>
  while(--i >= 0)
 4eb:	83 eb 01             	sub    $0x1,%ebx
 4ee:	83 c4 10             	add    $0x10,%esp
 4f1:	83 fb ff             	cmp    $0xffffffff,%ebx
 4f4:	75 e1                	jne    4d7 <printint+0x63>
    putc(fd, buf[i]);
}
 4f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4f9:	5b                   	pop    %ebx
 4fa:	5e                   	pop    %esi
 4fb:	5f                   	pop    %edi
 4fc:	5d                   	pop    %ebp
 4fd:	c3                   	ret    

000004fe <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4fe:	55                   	push   %ebp
 4ff:	89 e5                	mov    %esp,%ebp
 501:	57                   	push   %edi
 502:	56                   	push   %esi
 503:	53                   	push   %ebx
 504:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 507:	8b 75 0c             	mov    0xc(%ebp),%esi
 50a:	0f b6 1e             	movzbl (%esi),%ebx
 50d:	84 db                	test   %bl,%bl
 50f:	0f 84 b1 01 00 00    	je     6c6 <printf+0x1c8>
 515:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 518:	8d 45 10             	lea    0x10(%ebp),%eax
 51b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 51e:	bf 00 00 00 00       	mov    $0x0,%edi
 523:	eb 2d                	jmp    552 <printf+0x54>
 525:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 528:	83 ec 04             	sub    $0x4,%esp
 52b:	6a 01                	push   $0x1
 52d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 530:	50                   	push   %eax
 531:	ff 75 08             	pushl  0x8(%ebp)
 534:	e8 ab fe ff ff       	call   3e4 <write>
 539:	83 c4 10             	add    $0x10,%esp
 53c:	eb 05                	jmp    543 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 53e:	83 ff 25             	cmp    $0x25,%edi
 541:	74 22                	je     565 <printf+0x67>
 543:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 546:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 54a:	84 db                	test   %bl,%bl
 54c:	0f 84 74 01 00 00    	je     6c6 <printf+0x1c8>
    c = fmt[i] & 0xff;
 552:	0f be d3             	movsbl %bl,%edx
 555:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 558:	85 ff                	test   %edi,%edi
 55a:	75 e2                	jne    53e <printf+0x40>
      if(c == '%'){
 55c:	83 f8 25             	cmp    $0x25,%eax
 55f:	75 c4                	jne    525 <printf+0x27>
        state = '%';
 561:	89 c7                	mov    %eax,%edi
 563:	eb de                	jmp    543 <printf+0x45>
      if(c == 'd'){
 565:	83 f8 64             	cmp    $0x64,%eax
 568:	74 59                	je     5c3 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 56a:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 570:	83 fa 70             	cmp    $0x70,%edx
 573:	74 7a                	je     5ef <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 575:	83 f8 73             	cmp    $0x73,%eax
 578:	0f 84 9d 00 00 00    	je     61b <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 57e:	83 f8 63             	cmp    $0x63,%eax
 581:	0f 84 f2 00 00 00    	je     679 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 587:	83 f8 25             	cmp    $0x25,%eax
 58a:	0f 84 15 01 00 00    	je     6a5 <printf+0x1a7>
 590:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 594:	83 ec 04             	sub    $0x4,%esp
 597:	6a 01                	push   $0x1
 599:	8d 45 e7             	lea    -0x19(%ebp),%eax
 59c:	50                   	push   %eax
 59d:	ff 75 08             	pushl  0x8(%ebp)
 5a0:	e8 3f fe ff ff       	call   3e4 <write>
 5a5:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 5a8:	83 c4 0c             	add    $0xc,%esp
 5ab:	6a 01                	push   $0x1
 5ad:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 5b0:	50                   	push   %eax
 5b1:	ff 75 08             	pushl  0x8(%ebp)
 5b4:	e8 2b fe ff ff       	call   3e4 <write>
 5b9:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5bc:	bf 00 00 00 00       	mov    $0x0,%edi
 5c1:	eb 80                	jmp    543 <printf+0x45>
        printint(fd, *ap, 10, 1);
 5c3:	83 ec 0c             	sub    $0xc,%esp
 5c6:	6a 01                	push   $0x1
 5c8:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5cd:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5d0:	8b 17                	mov    (%edi),%edx
 5d2:	8b 45 08             	mov    0x8(%ebp),%eax
 5d5:	e8 9a fe ff ff       	call   474 <printint>
        ap++;
 5da:	89 f8                	mov    %edi,%eax
 5dc:	83 c0 04             	add    $0x4,%eax
 5df:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 5e2:	83 c4 10             	add    $0x10,%esp
      state = 0;
 5e5:	bf 00 00 00 00       	mov    $0x0,%edi
 5ea:	e9 54 ff ff ff       	jmp    543 <printf+0x45>
        printint(fd, *ap, 16, 0);
 5ef:	83 ec 0c             	sub    $0xc,%esp
 5f2:	6a 00                	push   $0x0
 5f4:	b9 10 00 00 00       	mov    $0x10,%ecx
 5f9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 5fc:	8b 17                	mov    (%edi),%edx
 5fe:	8b 45 08             	mov    0x8(%ebp),%eax
 601:	e8 6e fe ff ff       	call   474 <printint>
        ap++;
 606:	89 f8                	mov    %edi,%eax
 608:	83 c0 04             	add    $0x4,%eax
 60b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 60e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 611:	bf 00 00 00 00       	mov    $0x0,%edi
 616:	e9 28 ff ff ff       	jmp    543 <printf+0x45>
        s = (char*)*ap;
 61b:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 61e:	8b 01                	mov    (%ecx),%eax
        ap++;
 620:	83 c1 04             	add    $0x4,%ecx
 623:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 626:	85 c0                	test   %eax,%eax
 628:	74 13                	je     63d <printf+0x13f>
        s = (char*)*ap;
 62a:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 62c:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 62f:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 634:	84 c0                	test   %al,%al
 636:	75 0f                	jne    647 <printf+0x149>
 638:	e9 06 ff ff ff       	jmp    543 <printf+0x45>
          s = "(null)";
 63d:	bb 4b 08 00 00       	mov    $0x84b,%ebx
        while(*s != 0){
 642:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 647:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 64a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 64d:	8b 75 08             	mov    0x8(%ebp),%esi
 650:	88 45 e3             	mov    %al,-0x1d(%ebp)
 653:	83 ec 04             	sub    $0x4,%esp
 656:	6a 01                	push   $0x1
 658:	57                   	push   %edi
 659:	56                   	push   %esi
 65a:	e8 85 fd ff ff       	call   3e4 <write>
          s++;
 65f:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 662:	0f b6 03             	movzbl (%ebx),%eax
 665:	83 c4 10             	add    $0x10,%esp
 668:	84 c0                	test   %al,%al
 66a:	75 e4                	jne    650 <printf+0x152>
 66c:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 66f:	bf 00 00 00 00       	mov    $0x0,%edi
 674:	e9 ca fe ff ff       	jmp    543 <printf+0x45>
        putc(fd, *ap);
 679:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 67c:	8b 07                	mov    (%edi),%eax
 67e:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 681:	83 ec 04             	sub    $0x4,%esp
 684:	6a 01                	push   $0x1
 686:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 689:	50                   	push   %eax
 68a:	ff 75 08             	pushl  0x8(%ebp)
 68d:	e8 52 fd ff ff       	call   3e4 <write>
        ap++;
 692:	83 c7 04             	add    $0x4,%edi
 695:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 698:	83 c4 10             	add    $0x10,%esp
      state = 0;
 69b:	bf 00 00 00 00       	mov    $0x0,%edi
 6a0:	e9 9e fe ff ff       	jmp    543 <printf+0x45>
 6a5:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 6a8:	83 ec 04             	sub    $0x4,%esp
 6ab:	6a 01                	push   $0x1
 6ad:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 6b0:	50                   	push   %eax
 6b1:	ff 75 08             	pushl  0x8(%ebp)
 6b4:	e8 2b fd ff ff       	call   3e4 <write>
 6b9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6bc:	bf 00 00 00 00       	mov    $0x0,%edi
 6c1:	e9 7d fe ff ff       	jmp    543 <printf+0x45>
    }
  }
}
 6c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6c9:	5b                   	pop    %ebx
 6ca:	5e                   	pop    %esi
 6cb:	5f                   	pop    %edi
 6cc:	5d                   	pop    %ebp
 6cd:	c3                   	ret    

000006ce <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ce:	55                   	push   %ebp
 6cf:	89 e5                	mov    %esp,%ebp
 6d1:	57                   	push   %edi
 6d2:	56                   	push   %esi
 6d3:	53                   	push   %ebx
 6d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d7:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6da:	a1 40 0b 00 00       	mov    0xb40,%eax
 6df:	eb 0c                	jmp    6ed <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e1:	8b 10                	mov    (%eax),%edx
 6e3:	39 c2                	cmp    %eax,%edx
 6e5:	77 04                	ja     6eb <free+0x1d>
 6e7:	39 ca                	cmp    %ecx,%edx
 6e9:	77 10                	ja     6fb <free+0x2d>
{
 6eb:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ed:	39 c8                	cmp    %ecx,%eax
 6ef:	73 f0                	jae    6e1 <free+0x13>
 6f1:	8b 10                	mov    (%eax),%edx
 6f3:	39 ca                	cmp    %ecx,%edx
 6f5:	77 04                	ja     6fb <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f7:	39 c2                	cmp    %eax,%edx
 6f9:	77 f0                	ja     6eb <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6fb:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6fe:	8b 10                	mov    (%eax),%edx
 700:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 703:	39 fa                	cmp    %edi,%edx
 705:	74 19                	je     720 <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 707:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 70a:	8b 50 04             	mov    0x4(%eax),%edx
 70d:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 710:	39 f1                	cmp    %esi,%ecx
 712:	74 1b                	je     72f <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 714:	89 08                	mov    %ecx,(%eax)
  freep = p;
 716:	a3 40 0b 00 00       	mov    %eax,0xb40
}
 71b:	5b                   	pop    %ebx
 71c:	5e                   	pop    %esi
 71d:	5f                   	pop    %edi
 71e:	5d                   	pop    %ebp
 71f:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 720:	03 72 04             	add    0x4(%edx),%esi
 723:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 726:	8b 10                	mov    (%eax),%edx
 728:	8b 12                	mov    (%edx),%edx
 72a:	89 53 f8             	mov    %edx,-0x8(%ebx)
 72d:	eb db                	jmp    70a <free+0x3c>
    p->s.size += bp->s.size;
 72f:	03 53 fc             	add    -0x4(%ebx),%edx
 732:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 735:	8b 53 f8             	mov    -0x8(%ebx),%edx
 738:	89 10                	mov    %edx,(%eax)
 73a:	eb da                	jmp    716 <free+0x48>

0000073c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 73c:	55                   	push   %ebp
 73d:	89 e5                	mov    %esp,%ebp
 73f:	57                   	push   %edi
 740:	56                   	push   %esi
 741:	53                   	push   %ebx
 742:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 745:	8b 45 08             	mov    0x8(%ebp),%eax
 748:	8d 58 07             	lea    0x7(%eax),%ebx
 74b:	c1 eb 03             	shr    $0x3,%ebx
 74e:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 751:	8b 15 40 0b 00 00    	mov    0xb40,%edx
 757:	85 d2                	test   %edx,%edx
 759:	74 20                	je     77b <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 75b:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 75d:	8b 48 04             	mov    0x4(%eax),%ecx
 760:	39 cb                	cmp    %ecx,%ebx
 762:	76 3c                	jbe    7a0 <malloc+0x64>
 764:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 76a:	be 00 10 00 00       	mov    $0x1000,%esi
 76f:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 772:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 779:	eb 70                	jmp    7eb <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 77b:	c7 05 40 0b 00 00 44 	movl   $0xb44,0xb40
 782:	0b 00 00 
 785:	c7 05 44 0b 00 00 44 	movl   $0xb44,0xb44
 78c:	0b 00 00 
    base.s.size = 0;
 78f:	c7 05 48 0b 00 00 00 	movl   $0x0,0xb48
 796:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 799:	ba 44 0b 00 00       	mov    $0xb44,%edx
 79e:	eb bb                	jmp    75b <malloc+0x1f>
      if(p->s.size == nunits)
 7a0:	39 cb                	cmp    %ecx,%ebx
 7a2:	74 1c                	je     7c0 <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 7a4:	29 d9                	sub    %ebx,%ecx
 7a6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 7a9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 7ac:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 7af:	89 15 40 0b 00 00    	mov    %edx,0xb40
      return (void*)(p + 1);
 7b5:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7bb:	5b                   	pop    %ebx
 7bc:	5e                   	pop    %esi
 7bd:	5f                   	pop    %edi
 7be:	5d                   	pop    %ebp
 7bf:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 7c0:	8b 08                	mov    (%eax),%ecx
 7c2:	89 0a                	mov    %ecx,(%edx)
 7c4:	eb e9                	jmp    7af <malloc+0x73>
  hp->s.size = nu;
 7c6:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 7c9:	83 ec 0c             	sub    $0xc,%esp
 7cc:	83 c0 08             	add    $0x8,%eax
 7cf:	50                   	push   %eax
 7d0:	e8 f9 fe ff ff       	call   6ce <free>
  return freep;
 7d5:	8b 15 40 0b 00 00    	mov    0xb40,%edx
      if((p = morecore(nunits)) == 0)
 7db:	83 c4 10             	add    $0x10,%esp
 7de:	85 d2                	test   %edx,%edx
 7e0:	74 2b                	je     80d <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7e2:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7e4:	8b 48 04             	mov    0x4(%eax),%ecx
 7e7:	39 d9                	cmp    %ebx,%ecx
 7e9:	73 b5                	jae    7a0 <malloc+0x64>
 7eb:	89 c2                	mov    %eax,%edx
    if(p == freep)
 7ed:	39 05 40 0b 00 00    	cmp    %eax,0xb40
 7f3:	75 ed                	jne    7e2 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 7f5:	83 ec 0c             	sub    $0xc,%esp
 7f8:	57                   	push   %edi
 7f9:	e8 4e fc ff ff       	call   44c <sbrk>
  if(p == (char*)-1)
 7fe:	83 c4 10             	add    $0x10,%esp
 801:	83 f8 ff             	cmp    $0xffffffff,%eax
 804:	75 c0                	jne    7c6 <malloc+0x8a>
        return 0;
 806:	b8 00 00 00 00       	mov    $0x0,%eax
 80b:	eb ab                	jmp    7b8 <malloc+0x7c>
 80d:	b8 00 00 00 00       	mov    $0x0,%eax
 812:	eb a4                	jmp    7b8 <malloc+0x7c>
