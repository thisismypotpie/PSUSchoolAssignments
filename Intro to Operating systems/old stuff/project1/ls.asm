
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "fs.h"


char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   8:	83 ec 0c             	sub    $0xc,%esp
   b:	53                   	push   %ebx
   c:	e8 33 03 00 00       	call   344 <strlen>
  11:	83 c4 10             	add    $0x10,%esp
  14:	01 d8                	add    %ebx,%eax
  16:	72 11                	jb     29 <fmtname+0x29>
  18:	80 38 2f             	cmpb   $0x2f,(%eax)
  1b:	74 0c                	je     29 <fmtname+0x29>
  1d:	83 e8 01             	sub    $0x1,%eax
  20:	39 c3                	cmp    %eax,%ebx
  22:	77 05                	ja     29 <fmtname+0x29>
  24:	80 38 2f             	cmpb   $0x2f,(%eax)
  27:	75 f4                	jne    1d <fmtname+0x1d>
    ;
  p++;
  29:	8d 58 01             	lea    0x1(%eax),%ebx

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  2c:	83 ec 0c             	sub    $0xc,%esp
  2f:	53                   	push   %ebx
  30:	e8 0f 03 00 00       	call   344 <strlen>
  35:	83 c4 10             	add    $0x10,%esp
  38:	83 f8 0d             	cmp    $0xd,%eax
  3b:	76 09                	jbe    46 <fmtname+0x46>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  3d:	89 d8                	mov    %ebx,%eax
  3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  42:	5b                   	pop    %ebx
  43:	5e                   	pop    %esi
  44:	5d                   	pop    %ebp
  45:	c3                   	ret    
  memmove(buf, p, strlen(p));
  46:	83 ec 0c             	sub    $0xc,%esp
  49:	53                   	push   %ebx
  4a:	e8 f5 02 00 00       	call   344 <strlen>
  4f:	83 c4 0c             	add    $0xc,%esp
  52:	50                   	push   %eax
  53:	53                   	push   %ebx
  54:	68 f4 0c 00 00       	push   $0xcf4
  59:	e8 c3 04 00 00       	call   521 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  5e:	89 1c 24             	mov    %ebx,(%esp)
  61:	e8 de 02 00 00       	call   344 <strlen>
  66:	89 c6                	mov    %eax,%esi
  68:	89 1c 24             	mov    %ebx,(%esp)
  6b:	e8 d4 02 00 00       	call   344 <strlen>
  70:	83 c4 0c             	add    $0xc,%esp
  73:	ba 0e 00 00 00       	mov    $0xe,%edx
  78:	29 f2                	sub    %esi,%edx
  7a:	52                   	push   %edx
  7b:	6a 20                	push   $0x20
  7d:	05 f4 0c 00 00       	add    $0xcf4,%eax
  82:	50                   	push   %eax
  83:	e8 e0 02 00 00       	call   368 <memset>
  return buf;
  88:	83 c4 10             	add    $0x10,%esp
  8b:	bb f4 0c 00 00       	mov    $0xcf4,%ebx
  90:	eb ab                	jmp    3d <fmtname+0x3d>

00000092 <ls>:

void
ls(char *path)
{
  92:	55                   	push   %ebp
  93:	89 e5                	mov    %esp,%ebp
  95:	57                   	push   %edi
  96:	56                   	push   %esi
  97:	53                   	push   %ebx
  98:	81 ec 54 02 00 00    	sub    $0x254,%esp
  9e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  a1:	6a 00                	push   $0x0
  a3:	53                   	push   %ebx
  a4:	e8 e9 04 00 00       	call   592 <open>
  a9:	83 c4 10             	add    $0x10,%esp
  ac:	85 c0                	test   %eax,%eax
  ae:	0f 88 92 00 00 00    	js     146 <ls+0xb4>
  b4:	89 c7                	mov    %eax,%edi
    printf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  b6:	83 ec 08             	sub    $0x8,%esp
  b9:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
  bf:	50                   	push   %eax
  c0:	57                   	push   %edi
  c1:	e8 e4 04 00 00       	call   5aa <fstat>
  c6:	83 c4 10             	add    $0x10,%esp
  c9:	85 c0                	test   %eax,%eax
  cb:	0f 88 8a 00 00 00    	js     15b <ls+0xc9>
    printf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  d1:	0f b7 b5 c4 fd ff ff 	movzwl -0x23c(%ebp),%esi
  d8:	66 83 fe 01          	cmp    $0x1,%si
  dc:	0f 84 96 00 00 00    	je     178 <ls+0xe6>
  e2:	66 83 fe 01          	cmp    $0x1,%si
  e6:	7c 4a                	jl     132 <ls+0xa0>
  e8:	66 83 fe 03          	cmp    $0x3,%si
  ec:	7f 44                	jg     132 <ls+0xa0>
  case T_FILE:
  case T_DEV:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
  ee:	8b 85 d4 fd ff ff    	mov    -0x22c(%ebp),%eax
  f4:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
  fa:	8b 95 cc fd ff ff    	mov    -0x234(%ebp),%edx
 100:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 106:	83 ec 0c             	sub    $0xc,%esp
 109:	53                   	push   %ebx
 10a:	e8 f1 fe ff ff       	call   0 <fmtname>
 10f:	83 c4 08             	add    $0x8,%esp
 112:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 118:	ff b5 b0 fd ff ff    	pushl  -0x250(%ebp)
  switch(st.type){
 11e:	0f bf f6             	movswl %si,%esi
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 121:	56                   	push   %esi
 122:	50                   	push   %eax
 123:	68 cc 09 00 00       	push   $0x9cc
 128:	6a 01                	push   $0x1
 12a:	e8 5d 05 00 00       	call   68c <printf>
    break;
 12f:	83 c4 20             	add    $0x20,%esp
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 132:	83 ec 0c             	sub    $0xc,%esp
 135:	57                   	push   %edi
 136:	e8 3f 04 00 00       	call   57a <close>
 13b:	83 c4 10             	add    $0x10,%esp
}
 13e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 141:	5b                   	pop    %ebx
 142:	5e                   	pop    %esi
 143:	5f                   	pop    %edi
 144:	5d                   	pop    %ebp
 145:	c3                   	ret    
    printf(2, "ls: cannot open %s\n", path);
 146:	83 ec 04             	sub    $0x4,%esp
 149:	53                   	push   %ebx
 14a:	68 a4 09 00 00       	push   $0x9a4
 14f:	6a 02                	push   $0x2
 151:	e8 36 05 00 00       	call   68c <printf>
    return;
 156:	83 c4 10             	add    $0x10,%esp
 159:	eb e3                	jmp    13e <ls+0xac>
    printf(2, "ls: cannot stat %s\n", path);
 15b:	83 ec 04             	sub    $0x4,%esp
 15e:	53                   	push   %ebx
 15f:	68 b8 09 00 00       	push   $0x9b8
 164:	6a 02                	push   $0x2
 166:	e8 21 05 00 00       	call   68c <printf>
    close(fd);
 16b:	89 3c 24             	mov    %edi,(%esp)
 16e:	e8 07 04 00 00       	call   57a <close>
    return;
 173:	83 c4 10             	add    $0x10,%esp
 176:	eb c6                	jmp    13e <ls+0xac>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 178:	83 ec 0c             	sub    $0xc,%esp
 17b:	53                   	push   %ebx
 17c:	e8 c3 01 00 00       	call   344 <strlen>
 181:	83 c0 10             	add    $0x10,%eax
 184:	83 c4 10             	add    $0x10,%esp
 187:	3d 00 02 00 00       	cmp    $0x200,%eax
 18c:	76 14                	jbe    1a2 <ls+0x110>
      printf(1, "ls: path too long\n");
 18e:	83 ec 08             	sub    $0x8,%esp
 191:	68 d9 09 00 00       	push   $0x9d9
 196:	6a 01                	push   $0x1
 198:	e8 ef 04 00 00       	call   68c <printf>
      break;
 19d:	83 c4 10             	add    $0x10,%esp
 1a0:	eb 90                	jmp    132 <ls+0xa0>
    strcpy(buf, path);
 1a2:	83 ec 08             	sub    $0x8,%esp
 1a5:	53                   	push   %ebx
 1a6:	8d b5 e8 fd ff ff    	lea    -0x218(%ebp),%esi
 1ac:	56                   	push   %esi
 1ad:	e8 43 01 00 00       	call   2f5 <strcpy>
    p = buf+strlen(buf);
 1b2:	89 34 24             	mov    %esi,(%esp)
 1b5:	e8 8a 01 00 00       	call   344 <strlen>
 1ba:	01 c6                	add    %eax,%esi
    *p++ = '/';
 1bc:	8d 46 01             	lea    0x1(%esi),%eax
 1bf:	89 85 a8 fd ff ff    	mov    %eax,-0x258(%ebp)
 1c5:	c6 06 2f             	movb   $0x2f,(%esi)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1c8:	83 c4 10             	add    $0x10,%esp
 1cb:	8d 9d d8 fd ff ff    	lea    -0x228(%ebp),%ebx
 1d1:	83 ec 04             	sub    $0x4,%esp
 1d4:	6a 10                	push   $0x10
 1d6:	53                   	push   %ebx
 1d7:	57                   	push   %edi
 1d8:	e8 8d 03 00 00       	call   56a <read>
 1dd:	83 c4 10             	add    $0x10,%esp
 1e0:	83 f8 10             	cmp    $0x10,%eax
 1e3:	0f 85 49 ff ff ff    	jne    132 <ls+0xa0>
      if(de.inum == 0)
 1e9:	66 83 bd d8 fd ff ff 	cmpw   $0x0,-0x228(%ebp)
 1f0:	00 
 1f1:	74 de                	je     1d1 <ls+0x13f>
      memmove(p, de.name, DIRSIZ);
 1f3:	83 ec 04             	sub    $0x4,%esp
 1f6:	6a 0e                	push   $0xe
 1f8:	8d 85 da fd ff ff    	lea    -0x226(%ebp),%eax
 1fe:	50                   	push   %eax
 1ff:	ff b5 a8 fd ff ff    	pushl  -0x258(%ebp)
 205:	e8 17 03 00 00       	call   521 <memmove>
      p[DIRSIZ] = 0;
 20a:	c6 46 0f 00          	movb   $0x0,0xf(%esi)
      if(stat(buf, &st) < 0){
 20e:	83 c4 08             	add    $0x8,%esp
 211:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 217:	50                   	push   %eax
 218:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 21e:	50                   	push   %eax
 21f:	e8 e4 01 00 00       	call   408 <stat>
 224:	83 c4 10             	add    $0x10,%esp
 227:	85 c0                	test   %eax,%eax
 229:	78 5e                	js     289 <ls+0x1f7>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 22b:	8b 85 d4 fd ff ff    	mov    -0x22c(%ebp),%eax
 231:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 237:	8b 95 cc fd ff ff    	mov    -0x234(%ebp),%edx
 23d:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 243:	0f bf 8d c4 fd ff ff 	movswl -0x23c(%ebp),%ecx
 24a:	89 8d ac fd ff ff    	mov    %ecx,-0x254(%ebp)
 250:	83 ec 0c             	sub    $0xc,%esp
 253:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 259:	50                   	push   %eax
 25a:	e8 a1 fd ff ff       	call   0 <fmtname>
 25f:	83 c4 08             	add    $0x8,%esp
 262:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 268:	ff b5 b0 fd ff ff    	pushl  -0x250(%ebp)
 26e:	ff b5 ac fd ff ff    	pushl  -0x254(%ebp)
 274:	50                   	push   %eax
 275:	68 cc 09 00 00       	push   $0x9cc
 27a:	6a 01                	push   $0x1
 27c:	e8 0b 04 00 00       	call   68c <printf>
 281:	83 c4 20             	add    $0x20,%esp
 284:	e9 48 ff ff ff       	jmp    1d1 <ls+0x13f>
        printf(1, "ls: cannot stat %s\n", buf);
 289:	83 ec 04             	sub    $0x4,%esp
 28c:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 292:	50                   	push   %eax
 293:	68 b8 09 00 00       	push   $0x9b8
 298:	6a 01                	push   $0x1
 29a:	e8 ed 03 00 00       	call   68c <printf>
        continue;
 29f:	83 c4 10             	add    $0x10,%esp
 2a2:	e9 2a ff ff ff       	jmp    1d1 <ls+0x13f>

000002a7 <main>:

int
main(int argc, char *argv[])
{
 2a7:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 2ab:	83 e4 f0             	and    $0xfffffff0,%esp
 2ae:	ff 71 fc             	pushl  -0x4(%ecx)
 2b1:	55                   	push   %ebp
 2b2:	89 e5                	mov    %esp,%ebp
 2b4:	56                   	push   %esi
 2b5:	53                   	push   %ebx
 2b6:	51                   	push   %ecx
 2b7:	83 ec 0c             	sub    $0xc,%esp
 2ba:	8b 01                	mov    (%ecx),%eax
 2bc:	8b 51 04             	mov    0x4(%ecx),%edx
  int i;

  if(argc < 2){
 2bf:	83 f8 01             	cmp    $0x1,%eax
 2c2:	7e 1f                	jle    2e3 <main+0x3c>
 2c4:	8d 5a 04             	lea    0x4(%edx),%ebx
 2c7:	8d 34 82             	lea    (%edx,%eax,4),%esi
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2ca:	83 ec 0c             	sub    $0xc,%esp
 2cd:	ff 33                	pushl  (%ebx)
 2cf:	e8 be fd ff ff       	call   92 <ls>
 2d4:	83 c3 04             	add    $0x4,%ebx
  for(i=1; i<argc; i++)
 2d7:	83 c4 10             	add    $0x10,%esp
 2da:	39 f3                	cmp    %esi,%ebx
 2dc:	75 ec                	jne    2ca <main+0x23>
  exit();
 2de:	e8 6f 02 00 00       	call   552 <exit>
    ls(".");
 2e3:	83 ec 0c             	sub    $0xc,%esp
 2e6:	68 ec 09 00 00       	push   $0x9ec
 2eb:	e8 a2 fd ff ff       	call   92 <ls>
    exit();
 2f0:	e8 5d 02 00 00       	call   552 <exit>

000002f5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 2f5:	55                   	push   %ebp
 2f6:	89 e5                	mov    %esp,%ebp
 2f8:	53                   	push   %ebx
 2f9:	8b 45 08             	mov    0x8(%ebp),%eax
 2fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ff:	89 c2                	mov    %eax,%edx
 301:	83 c1 01             	add    $0x1,%ecx
 304:	83 c2 01             	add    $0x1,%edx
 307:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 30b:	88 5a ff             	mov    %bl,-0x1(%edx)
 30e:	84 db                	test   %bl,%bl
 310:	75 ef                	jne    301 <strcpy+0xc>
    ;
  return os;
}
 312:	5b                   	pop    %ebx
 313:	5d                   	pop    %ebp
 314:	c3                   	ret    

00000315 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 315:	55                   	push   %ebp
 316:	89 e5                	mov    %esp,%ebp
 318:	8b 4d 08             	mov    0x8(%ebp),%ecx
 31b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 31e:	0f b6 01             	movzbl (%ecx),%eax
 321:	84 c0                	test   %al,%al
 323:	74 15                	je     33a <strcmp+0x25>
 325:	3a 02                	cmp    (%edx),%al
 327:	75 11                	jne    33a <strcmp+0x25>
    p++, q++;
 329:	83 c1 01             	add    $0x1,%ecx
 32c:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 32f:	0f b6 01             	movzbl (%ecx),%eax
 332:	84 c0                	test   %al,%al
 334:	74 04                	je     33a <strcmp+0x25>
 336:	3a 02                	cmp    (%edx),%al
 338:	74 ef                	je     329 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
 33a:	0f b6 c0             	movzbl %al,%eax
 33d:	0f b6 12             	movzbl (%edx),%edx
 340:	29 d0                	sub    %edx,%eax
}
 342:	5d                   	pop    %ebp
 343:	c3                   	ret    

00000344 <strlen>:

uint
strlen(char *s)
{
 344:	55                   	push   %ebp
 345:	89 e5                	mov    %esp,%ebp
 347:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 34a:	80 39 00             	cmpb   $0x0,(%ecx)
 34d:	74 12                	je     361 <strlen+0x1d>
 34f:	ba 00 00 00 00       	mov    $0x0,%edx
 354:	83 c2 01             	add    $0x1,%edx
 357:	89 d0                	mov    %edx,%eax
 359:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 35d:	75 f5                	jne    354 <strlen+0x10>
    ;
  return n;
}
 35f:	5d                   	pop    %ebp
 360:	c3                   	ret    
  for(n = 0; s[n]; n++)
 361:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
 366:	eb f7                	jmp    35f <strlen+0x1b>

00000368 <memset>:

void*
memset(void *dst, int c, uint n)
{
 368:	55                   	push   %ebp
 369:	89 e5                	mov    %esp,%ebp
 36b:	57                   	push   %edi
 36c:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 36f:	89 d7                	mov    %edx,%edi
 371:	8b 4d 10             	mov    0x10(%ebp),%ecx
 374:	8b 45 0c             	mov    0xc(%ebp),%eax
 377:	fc                   	cld    
 378:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 37a:	89 d0                	mov    %edx,%eax
 37c:	5f                   	pop    %edi
 37d:	5d                   	pop    %ebp
 37e:	c3                   	ret    

0000037f <strchr>:

char*
strchr(const char *s, char c)
{
 37f:	55                   	push   %ebp
 380:	89 e5                	mov    %esp,%ebp
 382:	53                   	push   %ebx
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 389:	0f b6 10             	movzbl (%eax),%edx
 38c:	84 d2                	test   %dl,%dl
 38e:	74 1e                	je     3ae <strchr+0x2f>
 390:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
 392:	38 d3                	cmp    %dl,%bl
 394:	74 15                	je     3ab <strchr+0x2c>
  for(; *s; s++)
 396:	83 c0 01             	add    $0x1,%eax
 399:	0f b6 10             	movzbl (%eax),%edx
 39c:	84 d2                	test   %dl,%dl
 39e:	74 06                	je     3a6 <strchr+0x27>
    if(*s == c)
 3a0:	38 ca                	cmp    %cl,%dl
 3a2:	75 f2                	jne    396 <strchr+0x17>
 3a4:	eb 05                	jmp    3ab <strchr+0x2c>
      return (char*)s;
  return 0;
 3a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3ab:	5b                   	pop    %ebx
 3ac:	5d                   	pop    %ebp
 3ad:	c3                   	ret    
  return 0;
 3ae:	b8 00 00 00 00       	mov    $0x0,%eax
 3b3:	eb f6                	jmp    3ab <strchr+0x2c>

000003b5 <gets>:

char*
gets(char *buf, int max)
{
 3b5:	55                   	push   %ebp
 3b6:	89 e5                	mov    %esp,%ebp
 3b8:	57                   	push   %edi
 3b9:	56                   	push   %esi
 3ba:	53                   	push   %ebx
 3bb:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3be:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
 3c3:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 3c6:	8d 5e 01             	lea    0x1(%esi),%ebx
 3c9:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3cc:	7d 2b                	jge    3f9 <gets+0x44>
    cc = read(0, &c, 1);
 3ce:	83 ec 04             	sub    $0x4,%esp
 3d1:	6a 01                	push   $0x1
 3d3:	57                   	push   %edi
 3d4:	6a 00                	push   $0x0
 3d6:	e8 8f 01 00 00       	call   56a <read>
    if(cc < 1)
 3db:	83 c4 10             	add    $0x10,%esp
 3de:	85 c0                	test   %eax,%eax
 3e0:	7e 17                	jle    3f9 <gets+0x44>
      break;
    buf[i++] = c;
 3e2:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3e6:	8b 55 08             	mov    0x8(%ebp),%edx
 3e9:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
 3ed:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
 3ef:	3c 0a                	cmp    $0xa,%al
 3f1:	74 04                	je     3f7 <gets+0x42>
 3f3:	3c 0d                	cmp    $0xd,%al
 3f5:	75 cf                	jne    3c6 <gets+0x11>
  for(i=0; i+1 < max; ){
 3f7:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 3f9:	8b 45 08             	mov    0x8(%ebp),%eax
 3fc:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 400:	8d 65 f4             	lea    -0xc(%ebp),%esp
 403:	5b                   	pop    %ebx
 404:	5e                   	pop    %esi
 405:	5f                   	pop    %edi
 406:	5d                   	pop    %ebp
 407:	c3                   	ret    

00000408 <stat>:

int
stat(char *n, struct stat *st)
{
 408:	55                   	push   %ebp
 409:	89 e5                	mov    %esp,%ebp
 40b:	56                   	push   %esi
 40c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 40d:	83 ec 08             	sub    $0x8,%esp
 410:	6a 00                	push   $0x0
 412:	ff 75 08             	pushl  0x8(%ebp)
 415:	e8 78 01 00 00       	call   592 <open>
  if(fd < 0)
 41a:	83 c4 10             	add    $0x10,%esp
 41d:	85 c0                	test   %eax,%eax
 41f:	78 24                	js     445 <stat+0x3d>
 421:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 423:	83 ec 08             	sub    $0x8,%esp
 426:	ff 75 0c             	pushl  0xc(%ebp)
 429:	50                   	push   %eax
 42a:	e8 7b 01 00 00       	call   5aa <fstat>
 42f:	89 c6                	mov    %eax,%esi
  close(fd);
 431:	89 1c 24             	mov    %ebx,(%esp)
 434:	e8 41 01 00 00       	call   57a <close>
  return r;
 439:	83 c4 10             	add    $0x10,%esp
}
 43c:	89 f0                	mov    %esi,%eax
 43e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 441:	5b                   	pop    %ebx
 442:	5e                   	pop    %esi
 443:	5d                   	pop    %ebp
 444:	c3                   	ret    
    return -1;
 445:	be ff ff ff ff       	mov    $0xffffffff,%esi
 44a:	eb f0                	jmp    43c <stat+0x34>

0000044c <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
 44c:	55                   	push   %ebp
 44d:	89 e5                	mov    %esp,%ebp
 44f:	56                   	push   %esi
 450:	53                   	push   %ebx
 451:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 454:	0f b6 0a             	movzbl (%edx),%ecx
 457:	80 f9 20             	cmp    $0x20,%cl
 45a:	75 0b                	jne    467 <atoi+0x1b>
 45c:	83 c2 01             	add    $0x1,%edx
 45f:	0f b6 0a             	movzbl (%edx),%ecx
 462:	80 f9 20             	cmp    $0x20,%cl
 465:	74 f5                	je     45c <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
 467:	80 f9 2d             	cmp    $0x2d,%cl
 46a:	74 3b                	je     4a7 <atoi+0x5b>
  if (*s == '+'  || *s == '-')
 46c:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 46f:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 474:	f6 c1 fd             	test   $0xfd,%cl
 477:	74 33                	je     4ac <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
 479:	0f b6 0a             	movzbl (%edx),%ecx
 47c:	8d 41 d0             	lea    -0x30(%ecx),%eax
 47f:	3c 09                	cmp    $0x9,%al
 481:	77 2e                	ja     4b1 <atoi+0x65>
 483:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
 488:	83 c2 01             	add    $0x1,%edx
 48b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 48e:	0f be c9             	movsbl %cl,%ecx
 491:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 495:	0f b6 0a             	movzbl (%edx),%ecx
 498:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 49b:	80 fb 09             	cmp    $0x9,%bl
 49e:	76 e8                	jbe    488 <atoi+0x3c>
  return sign*n;
 4a0:	0f af c6             	imul   %esi,%eax
}
 4a3:	5b                   	pop    %ebx
 4a4:	5e                   	pop    %esi
 4a5:	5d                   	pop    %ebp
 4a6:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 4a7:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 4ac:	83 c2 01             	add    $0x1,%edx
 4af:	eb c8                	jmp    479 <atoi+0x2d>
  while('0' <= *s && *s <= '9')
 4b1:	b8 00 00 00 00       	mov    $0x0,%eax
 4b6:	eb e8                	jmp    4a0 <atoi+0x54>

000004b8 <atoo>:

int
atoo(const char *s)
{
 4b8:	55                   	push   %ebp
 4b9:	89 e5                	mov    %esp,%ebp
 4bb:	56                   	push   %esi
 4bc:	53                   	push   %ebx
 4bd:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
 4c0:	0f b6 0a             	movzbl (%edx),%ecx
 4c3:	80 f9 20             	cmp    $0x20,%cl
 4c6:	75 0b                	jne    4d3 <atoo+0x1b>
 4c8:	83 c2 01             	add    $0x1,%edx
 4cb:	0f b6 0a             	movzbl (%edx),%ecx
 4ce:	80 f9 20             	cmp    $0x20,%cl
 4d1:	74 f5                	je     4c8 <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
 4d3:	80 f9 2d             	cmp    $0x2d,%cl
 4d6:	74 38                	je     510 <atoo+0x58>
  if (*s == '+'  || *s == '-')
 4d8:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
 4db:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
 4e0:	f6 c1 fd             	test   $0xfd,%cl
 4e3:	74 30                	je     515 <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
 4e5:	0f b6 0a             	movzbl (%edx),%ecx
 4e8:	8d 41 d0             	lea    -0x30(%ecx),%eax
 4eb:	3c 07                	cmp    $0x7,%al
 4ed:	77 2b                	ja     51a <atoo+0x62>
 4ef:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
 4f4:	83 c2 01             	add    $0x1,%edx
 4f7:	0f be c9             	movsbl %cl,%ecx
 4fa:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
 4fe:	0f b6 0a             	movzbl (%edx),%ecx
 501:	8d 59 d0             	lea    -0x30(%ecx),%ebx
 504:	80 fb 07             	cmp    $0x7,%bl
 507:	76 eb                	jbe    4f4 <atoo+0x3c>
  return sign*n;
 509:	0f af c6             	imul   %esi,%eax
}
 50c:	5b                   	pop    %ebx
 50d:	5e                   	pop    %esi
 50e:	5d                   	pop    %ebp
 50f:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
 510:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
 515:	83 c2 01             	add    $0x1,%edx
 518:	eb cb                	jmp    4e5 <atoo+0x2d>
  while('0' <= *s && *s <= '7')
 51a:	b8 00 00 00 00       	mov    $0x0,%eax
 51f:	eb e8                	jmp    509 <atoo+0x51>

00000521 <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
 521:	55                   	push   %ebp
 522:	89 e5                	mov    %esp,%ebp
 524:	56                   	push   %esi
 525:	53                   	push   %ebx
 526:	8b 45 08             	mov    0x8(%ebp),%eax
 529:	8b 75 0c             	mov    0xc(%ebp),%esi
 52c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 52f:	85 db                	test   %ebx,%ebx
 531:	7e 13                	jle    546 <memmove+0x25>
 533:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
 538:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 53c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 53f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 542:	39 d3                	cmp    %edx,%ebx
 544:	75 f2                	jne    538 <memmove+0x17>
  return vdst;
}
 546:	5b                   	pop    %ebx
 547:	5e                   	pop    %esi
 548:	5d                   	pop    %ebp
 549:	c3                   	ret    

0000054a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 54a:	b8 01 00 00 00       	mov    $0x1,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <exit>:
SYSCALL(exit)
 552:	b8 02 00 00 00       	mov    $0x2,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <wait>:
SYSCALL(wait)
 55a:	b8 03 00 00 00       	mov    $0x3,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <pipe>:
SYSCALL(pipe)
 562:	b8 04 00 00 00       	mov    $0x4,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <read>:
SYSCALL(read)
 56a:	b8 05 00 00 00       	mov    $0x5,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <write>:
SYSCALL(write)
 572:	b8 10 00 00 00       	mov    $0x10,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <close>:
SYSCALL(close)
 57a:	b8 15 00 00 00       	mov    $0x15,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <kill>:
SYSCALL(kill)
 582:	b8 06 00 00 00       	mov    $0x6,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <exec>:
SYSCALL(exec)
 58a:	b8 07 00 00 00       	mov    $0x7,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <open>:
SYSCALL(open)
 592:	b8 0f 00 00 00       	mov    $0xf,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <mknod>:
SYSCALL(mknod)
 59a:	b8 11 00 00 00       	mov    $0x11,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <unlink>:
SYSCALL(unlink)
 5a2:	b8 12 00 00 00       	mov    $0x12,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <fstat>:
SYSCALL(fstat)
 5aa:	b8 08 00 00 00       	mov    $0x8,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    

000005b2 <link>:
SYSCALL(link)
 5b2:	b8 13 00 00 00       	mov    $0x13,%eax
 5b7:	cd 40                	int    $0x40
 5b9:	c3                   	ret    

000005ba <mkdir>:
SYSCALL(mkdir)
 5ba:	b8 14 00 00 00       	mov    $0x14,%eax
 5bf:	cd 40                	int    $0x40
 5c1:	c3                   	ret    

000005c2 <chdir>:
SYSCALL(chdir)
 5c2:	b8 09 00 00 00       	mov    $0x9,%eax
 5c7:	cd 40                	int    $0x40
 5c9:	c3                   	ret    

000005ca <dup>:
SYSCALL(dup)
 5ca:	b8 0a 00 00 00       	mov    $0xa,%eax
 5cf:	cd 40                	int    $0x40
 5d1:	c3                   	ret    

000005d2 <getpid>:
SYSCALL(getpid)
 5d2:	b8 0b 00 00 00       	mov    $0xb,%eax
 5d7:	cd 40                	int    $0x40
 5d9:	c3                   	ret    

000005da <sbrk>:
SYSCALL(sbrk)
 5da:	b8 0c 00 00 00       	mov    $0xc,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <sleep>:
SYSCALL(sleep)
 5e2:	b8 0d 00 00 00       	mov    $0xd,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <uptime>:
SYSCALL(uptime)
 5ea:	b8 0e 00 00 00       	mov    $0xe,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <halt>:
SYSCALL(halt)
 5f2:	b8 16 00 00 00       	mov    $0x16,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <date>:
SYSCALL(date)
 5fa:	b8 17 00 00 00       	mov    $0x17,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 602:	55                   	push   %ebp
 603:	89 e5                	mov    %esp,%ebp
 605:	57                   	push   %edi
 606:	56                   	push   %esi
 607:	53                   	push   %ebx
 608:	83 ec 3c             	sub    $0x3c,%esp
 60b:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 60d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 611:	74 14                	je     627 <printint+0x25>
 613:	85 d2                	test   %edx,%edx
 615:	79 10                	jns    627 <printint+0x25>
    neg = 1;
    x = -xx;
 617:	f7 da                	neg    %edx
    neg = 1;
 619:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 620:	bf 00 00 00 00       	mov    $0x0,%edi
 625:	eb 0b                	jmp    632 <printint+0x30>
  neg = 0;
 627:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 62e:	eb f0                	jmp    620 <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
 630:	89 df                	mov    %ebx,%edi
 632:	8d 5f 01             	lea    0x1(%edi),%ebx
 635:	89 d0                	mov    %edx,%eax
 637:	ba 00 00 00 00       	mov    $0x0,%edx
 63c:	f7 f1                	div    %ecx
 63e:	0f b6 92 f8 09 00 00 	movzbl 0x9f8(%edx),%edx
 645:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
 649:	89 c2                	mov    %eax,%edx
 64b:	85 c0                	test   %eax,%eax
 64d:	75 e1                	jne    630 <printint+0x2e>
  if(neg)
 64f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
 653:	74 08                	je     65d <printint+0x5b>
    buf[i++] = '-';
 655:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 65a:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
 65d:	83 eb 01             	sub    $0x1,%ebx
 660:	78 22                	js     684 <printint+0x82>
  write(fd, &c, 1);
 662:	8d 7d d7             	lea    -0x29(%ebp),%edi
 665:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
 66a:	88 45 d7             	mov    %al,-0x29(%ebp)
 66d:	83 ec 04             	sub    $0x4,%esp
 670:	6a 01                	push   $0x1
 672:	57                   	push   %edi
 673:	56                   	push   %esi
 674:	e8 f9 fe ff ff       	call   572 <write>
  while(--i >= 0)
 679:	83 eb 01             	sub    $0x1,%ebx
 67c:	83 c4 10             	add    $0x10,%esp
 67f:	83 fb ff             	cmp    $0xffffffff,%ebx
 682:	75 e1                	jne    665 <printint+0x63>
    putc(fd, buf[i]);
}
 684:	8d 65 f4             	lea    -0xc(%ebp),%esp
 687:	5b                   	pop    %ebx
 688:	5e                   	pop    %esi
 689:	5f                   	pop    %edi
 68a:	5d                   	pop    %ebp
 68b:	c3                   	ret    

0000068c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 68c:	55                   	push   %ebp
 68d:	89 e5                	mov    %esp,%ebp
 68f:	57                   	push   %edi
 690:	56                   	push   %esi
 691:	53                   	push   %ebx
 692:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 695:	8b 75 0c             	mov    0xc(%ebp),%esi
 698:	0f b6 1e             	movzbl (%esi),%ebx
 69b:	84 db                	test   %bl,%bl
 69d:	0f 84 b1 01 00 00    	je     854 <printf+0x1c8>
 6a3:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
 6a6:	8d 45 10             	lea    0x10(%ebp),%eax
 6a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
 6ac:	bf 00 00 00 00       	mov    $0x0,%edi
 6b1:	eb 2d                	jmp    6e0 <printf+0x54>
 6b3:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
 6b6:	83 ec 04             	sub    $0x4,%esp
 6b9:	6a 01                	push   $0x1
 6bb:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 6be:	50                   	push   %eax
 6bf:	ff 75 08             	pushl  0x8(%ebp)
 6c2:	e8 ab fe ff ff       	call   572 <write>
 6c7:	83 c4 10             	add    $0x10,%esp
 6ca:	eb 05                	jmp    6d1 <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6cc:	83 ff 25             	cmp    $0x25,%edi
 6cf:	74 22                	je     6f3 <printf+0x67>
 6d1:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 6d4:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 6d8:	84 db                	test   %bl,%bl
 6da:	0f 84 74 01 00 00    	je     854 <printf+0x1c8>
    c = fmt[i] & 0xff;
 6e0:	0f be d3             	movsbl %bl,%edx
 6e3:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 6e6:	85 ff                	test   %edi,%edi
 6e8:	75 e2                	jne    6cc <printf+0x40>
      if(c == '%'){
 6ea:	83 f8 25             	cmp    $0x25,%eax
 6ed:	75 c4                	jne    6b3 <printf+0x27>
        state = '%';
 6ef:	89 c7                	mov    %eax,%edi
 6f1:	eb de                	jmp    6d1 <printf+0x45>
      if(c == 'd'){
 6f3:	83 f8 64             	cmp    $0x64,%eax
 6f6:	74 59                	je     751 <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 6f8:	81 e2 f7 00 00 00    	and    $0xf7,%edx
 6fe:	83 fa 70             	cmp    $0x70,%edx
 701:	74 7a                	je     77d <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 703:	83 f8 73             	cmp    $0x73,%eax
 706:	0f 84 9d 00 00 00    	je     7a9 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 70c:	83 f8 63             	cmp    $0x63,%eax
 70f:	0f 84 f2 00 00 00    	je     807 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 715:	83 f8 25             	cmp    $0x25,%eax
 718:	0f 84 15 01 00 00    	je     833 <printf+0x1a7>
 71e:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
 722:	83 ec 04             	sub    $0x4,%esp
 725:	6a 01                	push   $0x1
 727:	8d 45 e7             	lea    -0x19(%ebp),%eax
 72a:	50                   	push   %eax
 72b:	ff 75 08             	pushl  0x8(%ebp)
 72e:	e8 3f fe ff ff       	call   572 <write>
 733:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 736:	83 c4 0c             	add    $0xc,%esp
 739:	6a 01                	push   $0x1
 73b:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 73e:	50                   	push   %eax
 73f:	ff 75 08             	pushl  0x8(%ebp)
 742:	e8 2b fe ff ff       	call   572 <write>
 747:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 74a:	bf 00 00 00 00       	mov    $0x0,%edi
 74f:	eb 80                	jmp    6d1 <printf+0x45>
        printint(fd, *ap, 10, 1);
 751:	83 ec 0c             	sub    $0xc,%esp
 754:	6a 01                	push   $0x1
 756:	b9 0a 00 00 00       	mov    $0xa,%ecx
 75b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 75e:	8b 17                	mov    (%edi),%edx
 760:	8b 45 08             	mov    0x8(%ebp),%eax
 763:	e8 9a fe ff ff       	call   602 <printint>
        ap++;
 768:	89 f8                	mov    %edi,%eax
 76a:	83 c0 04             	add    $0x4,%eax
 76d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 770:	83 c4 10             	add    $0x10,%esp
      state = 0;
 773:	bf 00 00 00 00       	mov    $0x0,%edi
 778:	e9 54 ff ff ff       	jmp    6d1 <printf+0x45>
        printint(fd, *ap, 16, 0);
 77d:	83 ec 0c             	sub    $0xc,%esp
 780:	6a 00                	push   $0x0
 782:	b9 10 00 00 00       	mov    $0x10,%ecx
 787:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 78a:	8b 17                	mov    (%edi),%edx
 78c:	8b 45 08             	mov    0x8(%ebp),%eax
 78f:	e8 6e fe ff ff       	call   602 <printint>
        ap++;
 794:	89 f8                	mov    %edi,%eax
 796:	83 c0 04             	add    $0x4,%eax
 799:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 79c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 79f:	bf 00 00 00 00       	mov    $0x0,%edi
 7a4:	e9 28 ff ff ff       	jmp    6d1 <printf+0x45>
        s = (char*)*ap;
 7a9:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
 7ac:	8b 01                	mov    (%ecx),%eax
        ap++;
 7ae:	83 c1 04             	add    $0x4,%ecx
 7b1:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
 7b4:	85 c0                	test   %eax,%eax
 7b6:	74 13                	je     7cb <printf+0x13f>
        s = (char*)*ap;
 7b8:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
 7ba:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
 7bd:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
 7c2:	84 c0                	test   %al,%al
 7c4:	75 0f                	jne    7d5 <printf+0x149>
 7c6:	e9 06 ff ff ff       	jmp    6d1 <printf+0x45>
          s = "(null)";
 7cb:	bb ee 09 00 00       	mov    $0x9ee,%ebx
        while(*s != 0){
 7d0:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
 7d5:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 7d8:	89 75 d0             	mov    %esi,-0x30(%ebp)
 7db:	8b 75 08             	mov    0x8(%ebp),%esi
 7de:	88 45 e3             	mov    %al,-0x1d(%ebp)
 7e1:	83 ec 04             	sub    $0x4,%esp
 7e4:	6a 01                	push   $0x1
 7e6:	57                   	push   %edi
 7e7:	56                   	push   %esi
 7e8:	e8 85 fd ff ff       	call   572 <write>
          s++;
 7ed:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
 7f0:	0f b6 03             	movzbl (%ebx),%eax
 7f3:	83 c4 10             	add    $0x10,%esp
 7f6:	84 c0                	test   %al,%al
 7f8:	75 e4                	jne    7de <printf+0x152>
 7fa:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 7fd:	bf 00 00 00 00       	mov    $0x0,%edi
 802:	e9 ca fe ff ff       	jmp    6d1 <printf+0x45>
        putc(fd, *ap);
 807:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 80a:	8b 07                	mov    (%edi),%eax
 80c:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 80f:	83 ec 04             	sub    $0x4,%esp
 812:	6a 01                	push   $0x1
 814:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 817:	50                   	push   %eax
 818:	ff 75 08             	pushl  0x8(%ebp)
 81b:	e8 52 fd ff ff       	call   572 <write>
        ap++;
 820:	83 c7 04             	add    $0x4,%edi
 823:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 826:	83 c4 10             	add    $0x10,%esp
      state = 0;
 829:	bf 00 00 00 00       	mov    $0x0,%edi
 82e:	e9 9e fe ff ff       	jmp    6d1 <printf+0x45>
 833:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
 836:	83 ec 04             	sub    $0x4,%esp
 839:	6a 01                	push   $0x1
 83b:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 83e:	50                   	push   %eax
 83f:	ff 75 08             	pushl  0x8(%ebp)
 842:	e8 2b fd ff ff       	call   572 <write>
 847:	83 c4 10             	add    $0x10,%esp
      state = 0;
 84a:	bf 00 00 00 00       	mov    $0x0,%edi
 84f:	e9 7d fe ff ff       	jmp    6d1 <printf+0x45>
    }
  }
}
 854:	8d 65 f4             	lea    -0xc(%ebp),%esp
 857:	5b                   	pop    %ebx
 858:	5e                   	pop    %esi
 859:	5f                   	pop    %edi
 85a:	5d                   	pop    %ebp
 85b:	c3                   	ret    

0000085c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 85c:	55                   	push   %ebp
 85d:	89 e5                	mov    %esp,%ebp
 85f:	57                   	push   %edi
 860:	56                   	push   %esi
 861:	53                   	push   %ebx
 862:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 865:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 868:	a1 04 0d 00 00       	mov    0xd04,%eax
 86d:	eb 0c                	jmp    87b <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 86f:	8b 10                	mov    (%eax),%edx
 871:	39 c2                	cmp    %eax,%edx
 873:	77 04                	ja     879 <free+0x1d>
 875:	39 ca                	cmp    %ecx,%edx
 877:	77 10                	ja     889 <free+0x2d>
{
 879:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87b:	39 c8                	cmp    %ecx,%eax
 87d:	73 f0                	jae    86f <free+0x13>
 87f:	8b 10                	mov    (%eax),%edx
 881:	39 ca                	cmp    %ecx,%edx
 883:	77 04                	ja     889 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 885:	39 c2                	cmp    %eax,%edx
 887:	77 f0                	ja     879 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
 889:	8b 73 fc             	mov    -0x4(%ebx),%esi
 88c:	8b 10                	mov    (%eax),%edx
 88e:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 891:	39 fa                	cmp    %edi,%edx
 893:	74 19                	je     8ae <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 895:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 898:	8b 50 04             	mov    0x4(%eax),%edx
 89b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 89e:	39 f1                	cmp    %esi,%ecx
 8a0:	74 1b                	je     8bd <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 8a2:	89 08                	mov    %ecx,(%eax)
  freep = p;
 8a4:	a3 04 0d 00 00       	mov    %eax,0xd04
}
 8a9:	5b                   	pop    %ebx
 8aa:	5e                   	pop    %esi
 8ab:	5f                   	pop    %edi
 8ac:	5d                   	pop    %ebp
 8ad:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 8ae:	03 72 04             	add    0x4(%edx),%esi
 8b1:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b4:	8b 10                	mov    (%eax),%edx
 8b6:	8b 12                	mov    (%edx),%edx
 8b8:	89 53 f8             	mov    %edx,-0x8(%ebx)
 8bb:	eb db                	jmp    898 <free+0x3c>
    p->s.size += bp->s.size;
 8bd:	03 53 fc             	add    -0x4(%ebx),%edx
 8c0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8c3:	8b 53 f8             	mov    -0x8(%ebx),%edx
 8c6:	89 10                	mov    %edx,(%eax)
 8c8:	eb da                	jmp    8a4 <free+0x48>

000008ca <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ca:	55                   	push   %ebp
 8cb:	89 e5                	mov    %esp,%ebp
 8cd:	57                   	push   %edi
 8ce:	56                   	push   %esi
 8cf:	53                   	push   %ebx
 8d0:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d3:	8b 45 08             	mov    0x8(%ebp),%eax
 8d6:	8d 58 07             	lea    0x7(%eax),%ebx
 8d9:	c1 eb 03             	shr    $0x3,%ebx
 8dc:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 8df:	8b 15 04 0d 00 00    	mov    0xd04,%edx
 8e5:	85 d2                	test   %edx,%edx
 8e7:	74 20                	je     909 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e9:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 8eb:	8b 48 04             	mov    0x4(%eax),%ecx
 8ee:	39 cb                	cmp    %ecx,%ebx
 8f0:	76 3c                	jbe    92e <malloc+0x64>
 8f2:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
 8f8:	be 00 10 00 00       	mov    $0x1000,%esi
 8fd:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
 900:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
 907:	eb 70                	jmp    979 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
 909:	c7 05 04 0d 00 00 08 	movl   $0xd08,0xd04
 910:	0d 00 00 
 913:	c7 05 08 0d 00 00 08 	movl   $0xd08,0xd08
 91a:	0d 00 00 
    base.s.size = 0;
 91d:	c7 05 0c 0d 00 00 00 	movl   $0x0,0xd0c
 924:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 927:	ba 08 0d 00 00       	mov    $0xd08,%edx
 92c:	eb bb                	jmp    8e9 <malloc+0x1f>
      if(p->s.size == nunits)
 92e:	39 cb                	cmp    %ecx,%ebx
 930:	74 1c                	je     94e <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 932:	29 d9                	sub    %ebx,%ecx
 934:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 937:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 93a:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 93d:	89 15 04 0d 00 00    	mov    %edx,0xd04
      return (void*)(p + 1);
 943:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 946:	8d 65 f4             	lea    -0xc(%ebp),%esp
 949:	5b                   	pop    %ebx
 94a:	5e                   	pop    %esi
 94b:	5f                   	pop    %edi
 94c:	5d                   	pop    %ebp
 94d:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 94e:	8b 08                	mov    (%eax),%ecx
 950:	89 0a                	mov    %ecx,(%edx)
 952:	eb e9                	jmp    93d <malloc+0x73>
  hp->s.size = nu;
 954:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
 957:	83 ec 0c             	sub    $0xc,%esp
 95a:	83 c0 08             	add    $0x8,%eax
 95d:	50                   	push   %eax
 95e:	e8 f9 fe ff ff       	call   85c <free>
  return freep;
 963:	8b 15 04 0d 00 00    	mov    0xd04,%edx
      if((p = morecore(nunits)) == 0)
 969:	83 c4 10             	add    $0x10,%esp
 96c:	85 d2                	test   %edx,%edx
 96e:	74 2b                	je     99b <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 970:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 972:	8b 48 04             	mov    0x4(%eax),%ecx
 975:	39 d9                	cmp    %ebx,%ecx
 977:	73 b5                	jae    92e <malloc+0x64>
 979:	89 c2                	mov    %eax,%edx
    if(p == freep)
 97b:	39 05 04 0d 00 00    	cmp    %eax,0xd04
 981:	75 ed                	jne    970 <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
 983:	83 ec 0c             	sub    $0xc,%esp
 986:	57                   	push   %edi
 987:	e8 4e fc ff ff       	call   5da <sbrk>
  if(p == (char*)-1)
 98c:	83 c4 10             	add    $0x10,%esp
 98f:	83 f8 ff             	cmp    $0xffffffff,%eax
 992:	75 c0                	jne    954 <malloc+0x8a>
        return 0;
 994:	b8 00 00 00 00       	mov    $0x0,%eax
 999:	eb ab                	jmp    946 <malloc+0x7c>
 99b:	b8 00 00 00 00       	mov    $0x0,%eax
 9a0:	eb a4                	jmp    946 <malloc+0x7c>
