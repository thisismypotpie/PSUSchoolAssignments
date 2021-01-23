
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <getcmd>:
  exit();
}

int
getcmd(char *buf, int nbuf)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	56                   	push   %esi
       4:	53                   	push   %ebx
       5:	8b 5d 08             	mov    0x8(%ebp),%ebx
       8:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
       b:	83 ec 08             	sub    $0x8,%esp
       e:	68 80 10 00 00       	push   $0x1080
      13:	6a 02                	push   $0x2
      15:	e8 4f 0d 00 00       	call   d69 <printf>
  memset(buf, 0, nbuf);
      1a:	83 c4 0c             	add    $0xc,%esp
      1d:	56                   	push   %esi
      1e:	6a 00                	push   $0x0
      20:	53                   	push   %ebx
      21:	e8 1f 0a 00 00       	call   a45 <memset>
  gets(buf, nbuf);
      26:	83 c4 08             	add    $0x8,%esp
      29:	56                   	push   %esi
      2a:	53                   	push   %ebx
      2b:	e8 62 0a 00 00       	call   a92 <gets>
  if(buf[0] == 0) // EOF
      30:	83 c4 10             	add    $0x10,%esp
      33:	80 3b 00             	cmpb   $0x0,(%ebx)
      36:	0f 94 c0             	sete   %al
      39:	0f b6 c0             	movzbl %al,%eax
      3c:	f7 d8                	neg    %eax
    return -1;
  return 0;
}
      3e:	8d 65 f8             	lea    -0x8(%ebp),%esp
      41:	5b                   	pop    %ebx
      42:	5e                   	pop    %esi
      43:	5d                   	pop    %ebp
      44:	c3                   	ret    

00000045 <panic>:
  exit();
}

void
panic(char *s)
{
      45:	55                   	push   %ebp
      46:	89 e5                	mov    %esp,%ebp
      48:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
      4b:	ff 75 08             	pushl  0x8(%ebp)
      4e:	68 1d 11 00 00       	push   $0x111d
      53:	6a 02                	push   $0x2
      55:	e8 0f 0d 00 00       	call   d69 <printf>
  exit();
      5a:	e8 d0 0b 00 00       	call   c2f <exit>

0000005f <fork1>:
}

int
fork1(void)
{
      5f:	55                   	push   %ebp
      60:	89 e5                	mov    %esp,%ebp
      62:	83 ec 08             	sub    $0x8,%esp
  int pid;

  pid = fork();
      65:	e8 bd 0b 00 00       	call   c27 <fork>
  if(pid == -1)
      6a:	83 f8 ff             	cmp    $0xffffffff,%eax
      6d:	74 02                	je     71 <fork1+0x12>
    panic("fork");
  return pid;
}
      6f:	c9                   	leave  
      70:	c3                   	ret    
    panic("fork");
      71:	83 ec 0c             	sub    $0xc,%esp
      74:	68 83 10 00 00       	push   $0x1083
      79:	e8 c7 ff ff ff       	call   45 <panic>

0000007e <runcmd>:
{
      7e:	55                   	push   %ebp
      7f:	89 e5                	mov    %esp,%ebp
      81:	53                   	push   %ebx
      82:	83 ec 14             	sub    $0x14,%esp
      85:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
      88:	85 db                	test   %ebx,%ebx
      8a:	74 0e                	je     9a <runcmd+0x1c>
  switch(cmd->type){
      8c:	83 3b 05             	cmpl   $0x5,(%ebx)
      8f:	77 0e                	ja     9f <runcmd+0x21>
      91:	8b 03                	mov    (%ebx),%eax
      93:	ff 24 85 38 11 00 00 	jmp    *0x1138(,%eax,4)
    exit();
      9a:	e8 90 0b 00 00       	call   c2f <exit>
    panic("runcmd");
      9f:	83 ec 0c             	sub    $0xc,%esp
      a2:	68 88 10 00 00       	push   $0x1088
      a7:	e8 99 ff ff ff       	call   45 <panic>
    if(ecmd->argv[0] == 0)
      ac:	8b 43 04             	mov    0x4(%ebx),%eax
      af:	85 c0                	test   %eax,%eax
      b1:	74 27                	je     da <runcmd+0x5c>
    exec(ecmd->argv[0], ecmd->argv);
      b3:	83 ec 08             	sub    $0x8,%esp
      b6:	8d 53 04             	lea    0x4(%ebx),%edx
      b9:	52                   	push   %edx
      ba:	50                   	push   %eax
      bb:	e8 a7 0b 00 00       	call   c67 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      c0:	83 c4 0c             	add    $0xc,%esp
      c3:	ff 73 04             	pushl  0x4(%ebx)
      c6:	68 8f 10 00 00       	push   $0x108f
      cb:	6a 02                	push   $0x2
      cd:	e8 97 0c 00 00       	call   d69 <printf>
    break;
      d2:	83 c4 10             	add    $0x10,%esp
      d5:	e9 3a 01 00 00       	jmp    214 <runcmd+0x196>
      exit();
      da:	e8 50 0b 00 00       	call   c2f <exit>
    close(rcmd->fd);
      df:	83 ec 0c             	sub    $0xc,%esp
      e2:	ff 73 14             	pushl  0x14(%ebx)
      e5:	e8 6d 0b 00 00       	call   c57 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      ea:	83 c4 08             	add    $0x8,%esp
      ed:	ff 73 10             	pushl  0x10(%ebx)
      f0:	ff 73 08             	pushl  0x8(%ebx)
      f3:	e8 77 0b 00 00       	call   c6f <open>
      f8:	83 c4 10             	add    $0x10,%esp
      fb:	85 c0                	test   %eax,%eax
      fd:	79 17                	jns    116 <runcmd+0x98>
      printf(2, "open %s failed\n", rcmd->file);
      ff:	83 ec 04             	sub    $0x4,%esp
     102:	ff 73 08             	pushl  0x8(%ebx)
     105:	68 9f 10 00 00       	push   $0x109f
     10a:	6a 02                	push   $0x2
     10c:	e8 58 0c 00 00       	call   d69 <printf>
      exit();
     111:	e8 19 0b 00 00       	call   c2f <exit>
    runcmd(rcmd->cmd);
     116:	83 ec 0c             	sub    $0xc,%esp
     119:	ff 73 04             	pushl  0x4(%ebx)
     11c:	e8 5d ff ff ff       	call   7e <runcmd>
    if(fork1() == 0)
     121:	e8 39 ff ff ff       	call   5f <fork1>
     126:	85 c0                	test   %eax,%eax
     128:	74 10                	je     13a <runcmd+0xbc>
    wait();
     12a:	e8 08 0b 00 00       	call   c37 <wait>
    runcmd(lcmd->right);
     12f:	83 ec 0c             	sub    $0xc,%esp
     132:	ff 73 08             	pushl  0x8(%ebx)
     135:	e8 44 ff ff ff       	call   7e <runcmd>
      runcmd(lcmd->left);
     13a:	83 ec 0c             	sub    $0xc,%esp
     13d:	ff 73 04             	pushl  0x4(%ebx)
     140:	e8 39 ff ff ff       	call   7e <runcmd>
    if(pipe(p) < 0)
     145:	83 ec 0c             	sub    $0xc,%esp
     148:	8d 45 f0             	lea    -0x10(%ebp),%eax
     14b:	50                   	push   %eax
     14c:	e8 ee 0a 00 00       	call   c3f <pipe>
     151:	83 c4 10             	add    $0x10,%esp
     154:	85 c0                	test   %eax,%eax
     156:	78 3a                	js     192 <runcmd+0x114>
    if(fork1() == 0){
     158:	e8 02 ff ff ff       	call   5f <fork1>
     15d:	85 c0                	test   %eax,%eax
     15f:	74 3e                	je     19f <runcmd+0x121>
    if(fork1() == 0){
     161:	e8 f9 fe ff ff       	call   5f <fork1>
     166:	85 c0                	test   %eax,%eax
     168:	74 6b                	je     1d5 <runcmd+0x157>
    close(p[0]);
     16a:	83 ec 0c             	sub    $0xc,%esp
     16d:	ff 75 f0             	pushl  -0x10(%ebp)
     170:	e8 e2 0a 00 00       	call   c57 <close>
    close(p[1]);
     175:	83 c4 04             	add    $0x4,%esp
     178:	ff 75 f4             	pushl  -0xc(%ebp)
     17b:	e8 d7 0a 00 00       	call   c57 <close>
    wait();
     180:	e8 b2 0a 00 00       	call   c37 <wait>
    wait();
     185:	e8 ad 0a 00 00       	call   c37 <wait>
    break;
     18a:	83 c4 10             	add    $0x10,%esp
     18d:	e9 82 00 00 00       	jmp    214 <runcmd+0x196>
      panic("pipe");
     192:	83 ec 0c             	sub    $0xc,%esp
     195:	68 af 10 00 00       	push   $0x10af
     19a:	e8 a6 fe ff ff       	call   45 <panic>
      close(1);
     19f:	83 ec 0c             	sub    $0xc,%esp
     1a2:	6a 01                	push   $0x1
     1a4:	e8 ae 0a 00 00       	call   c57 <close>
      dup(p[1]);
     1a9:	83 c4 04             	add    $0x4,%esp
     1ac:	ff 75 f4             	pushl  -0xc(%ebp)
     1af:	e8 f3 0a 00 00       	call   ca7 <dup>
      close(p[0]);
     1b4:	83 c4 04             	add    $0x4,%esp
     1b7:	ff 75 f0             	pushl  -0x10(%ebp)
     1ba:	e8 98 0a 00 00       	call   c57 <close>
      close(p[1]);
     1bf:	83 c4 04             	add    $0x4,%esp
     1c2:	ff 75 f4             	pushl  -0xc(%ebp)
     1c5:	e8 8d 0a 00 00       	call   c57 <close>
      runcmd(pcmd->left);
     1ca:	83 c4 04             	add    $0x4,%esp
     1cd:	ff 73 04             	pushl  0x4(%ebx)
     1d0:	e8 a9 fe ff ff       	call   7e <runcmd>
      close(0);
     1d5:	83 ec 0c             	sub    $0xc,%esp
     1d8:	6a 00                	push   $0x0
     1da:	e8 78 0a 00 00       	call   c57 <close>
      dup(p[0]);
     1df:	83 c4 04             	add    $0x4,%esp
     1e2:	ff 75 f0             	pushl  -0x10(%ebp)
     1e5:	e8 bd 0a 00 00       	call   ca7 <dup>
      close(p[0]);
     1ea:	83 c4 04             	add    $0x4,%esp
     1ed:	ff 75 f0             	pushl  -0x10(%ebp)
     1f0:	e8 62 0a 00 00       	call   c57 <close>
      close(p[1]);
     1f5:	83 c4 04             	add    $0x4,%esp
     1f8:	ff 75 f4             	pushl  -0xc(%ebp)
     1fb:	e8 57 0a 00 00       	call   c57 <close>
      runcmd(pcmd->right);
     200:	83 c4 04             	add    $0x4,%esp
     203:	ff 73 08             	pushl  0x8(%ebx)
     206:	e8 73 fe ff ff       	call   7e <runcmd>
    if(fork1() == 0)
     20b:	e8 4f fe ff ff       	call   5f <fork1>
     210:	85 c0                	test   %eax,%eax
     212:	74 05                	je     219 <runcmd+0x19b>
  exit();
     214:	e8 16 0a 00 00       	call   c2f <exit>
      runcmd(bcmd->cmd);
     219:	83 ec 0c             	sub    $0xc,%esp
     21c:	ff 73 04             	pushl  0x4(%ebx)
     21f:	e8 5a fe ff ff       	call   7e <runcmd>

00000224 <execcmd>:

// Constructors

struct cmd*
execcmd(void)
{
     224:	55                   	push   %ebp
     225:	89 e5                	mov    %esp,%ebp
     227:	53                   	push   %ebx
     228:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     22b:	6a 54                	push   $0x54
     22d:	e8 75 0d 00 00       	call   fa7 <malloc>
     232:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     234:	83 c4 0c             	add    $0xc,%esp
     237:	6a 54                	push   $0x54
     239:	6a 00                	push   $0x0
     23b:	50                   	push   %eax
     23c:	e8 04 08 00 00       	call   a45 <memset>
  cmd->type = EXEC;
     241:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     247:	89 d8                	mov    %ebx,%eax
     249:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     24c:	c9                   	leave  
     24d:	c3                   	ret    

0000024e <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     24e:	55                   	push   %ebp
     24f:	89 e5                	mov    %esp,%ebp
     251:	53                   	push   %ebx
     252:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     255:	6a 18                	push   $0x18
     257:	e8 4b 0d 00 00       	call   fa7 <malloc>
     25c:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     25e:	83 c4 0c             	add    $0xc,%esp
     261:	6a 18                	push   $0x18
     263:	6a 00                	push   $0x0
     265:	50                   	push   %eax
     266:	e8 da 07 00 00       	call   a45 <memset>
  cmd->type = REDIR;
     26b:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     271:	8b 45 08             	mov    0x8(%ebp),%eax
     274:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     277:	8b 45 0c             	mov    0xc(%ebp),%eax
     27a:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     27d:	8b 45 10             	mov    0x10(%ebp),%eax
     280:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     283:	8b 45 14             	mov    0x14(%ebp),%eax
     286:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     289:	8b 45 18             	mov    0x18(%ebp),%eax
     28c:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     28f:	89 d8                	mov    %ebx,%eax
     291:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     294:	c9                   	leave  
     295:	c3                   	ret    

00000296 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     296:	55                   	push   %ebp
     297:	89 e5                	mov    %esp,%ebp
     299:	53                   	push   %ebx
     29a:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     29d:	6a 0c                	push   $0xc
     29f:	e8 03 0d 00 00       	call   fa7 <malloc>
     2a4:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     2a6:	83 c4 0c             	add    $0xc,%esp
     2a9:	6a 0c                	push   $0xc
     2ab:	6a 00                	push   $0x0
     2ad:	50                   	push   %eax
     2ae:	e8 92 07 00 00       	call   a45 <memset>
  cmd->type = PIPE;
     2b3:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     2b9:	8b 45 08             	mov    0x8(%ebp),%eax
     2bc:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     2bf:	8b 45 0c             	mov    0xc(%ebp),%eax
     2c2:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     2c5:	89 d8                	mov    %ebx,%eax
     2c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     2ca:	c9                   	leave  
     2cb:	c3                   	ret    

000002cc <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     2cc:	55                   	push   %ebp
     2cd:	89 e5                	mov    %esp,%ebp
     2cf:	53                   	push   %ebx
     2d0:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2d3:	6a 0c                	push   $0xc
     2d5:	e8 cd 0c 00 00       	call   fa7 <malloc>
     2da:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     2dc:	83 c4 0c             	add    $0xc,%esp
     2df:	6a 0c                	push   $0xc
     2e1:	6a 00                	push   $0x0
     2e3:	50                   	push   %eax
     2e4:	e8 5c 07 00 00       	call   a45 <memset>
  cmd->type = LIST;
     2e9:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     2ef:	8b 45 08             	mov    0x8(%ebp),%eax
     2f2:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     2f5:	8b 45 0c             	mov    0xc(%ebp),%eax
     2f8:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     2fb:	89 d8                	mov    %ebx,%eax
     2fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     300:	c9                   	leave  
     301:	c3                   	ret    

00000302 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     302:	55                   	push   %ebp
     303:	89 e5                	mov    %esp,%ebp
     305:	53                   	push   %ebx
     306:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     309:	6a 08                	push   $0x8
     30b:	e8 97 0c 00 00       	call   fa7 <malloc>
     310:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     312:	83 c4 0c             	add    $0xc,%esp
     315:	6a 08                	push   $0x8
     317:	6a 00                	push   $0x0
     319:	50                   	push   %eax
     31a:	e8 26 07 00 00       	call   a45 <memset>
  cmd->type = BACK;
     31f:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     325:	8b 45 08             	mov    0x8(%ebp),%eax
     328:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     32b:	89 d8                	mov    %ebx,%eax
     32d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     330:	c9                   	leave  
     331:	c3                   	ret    

00000332 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     332:	55                   	push   %ebp
     333:	89 e5                	mov    %esp,%ebp
     335:	57                   	push   %edi
     336:	56                   	push   %esi
     337:	53                   	push   %ebx
     338:	83 ec 0c             	sub    $0xc,%esp
     33b:	8b 75 0c             	mov    0xc(%ebp),%esi
     33e:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *s;
  int ret;

  s = *ps;
     341:	8b 45 08             	mov    0x8(%ebp),%eax
     344:	8b 18                	mov    (%eax),%ebx
  while(s < es && strchr(whitespace, *s))
     346:	39 f3                	cmp    %esi,%ebx
     348:	73 1f                	jae    369 <gettoken+0x37>
     34a:	83 ec 08             	sub    $0x8,%esp
     34d:	0f be 03             	movsbl (%ebx),%eax
     350:	50                   	push   %eax
     351:	68 e8 16 00 00       	push   $0x16e8
     356:	e8 01 07 00 00       	call   a5c <strchr>
     35b:	83 c4 10             	add    $0x10,%esp
     35e:	85 c0                	test   %eax,%eax
     360:	74 07                	je     369 <gettoken+0x37>
    s++;
     362:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     365:	39 de                	cmp    %ebx,%esi
     367:	75 e1                	jne    34a <gettoken+0x18>
  if(q)
     369:	85 ff                	test   %edi,%edi
     36b:	74 02                	je     36f <gettoken+0x3d>
    *q = s;
     36d:	89 1f                	mov    %ebx,(%edi)
  ret = *s;
     36f:	0f b6 03             	movzbl (%ebx),%eax
     372:	0f be f8             	movsbl %al,%edi
  switch(*s){
     375:	3c 29                	cmp    $0x29,%al
     377:	0f 8f 99 00 00 00    	jg     416 <gettoken+0xe4>
     37d:	3c 28                	cmp    $0x28,%al
     37f:	0f 8d a0 00 00 00    	jge    425 <gettoken+0xf3>
     385:	84 c0                	test   %al,%al
     387:	75 3d                	jne    3c6 <gettoken+0x94>
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     389:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     38d:	74 05                	je     394 <gettoken+0x62>
    *eq = s;
     38f:	8b 45 14             	mov    0x14(%ebp),%eax
     392:	89 18                	mov    %ebx,(%eax)

  while(s < es && strchr(whitespace, *s))
     394:	39 f3                	cmp    %esi,%ebx
     396:	73 1f                	jae    3b7 <gettoken+0x85>
     398:	83 ec 08             	sub    $0x8,%esp
     39b:	0f be 03             	movsbl (%ebx),%eax
     39e:	50                   	push   %eax
     39f:	68 e8 16 00 00       	push   $0x16e8
     3a4:	e8 b3 06 00 00       	call   a5c <strchr>
     3a9:	83 c4 10             	add    $0x10,%esp
     3ac:	85 c0                	test   %eax,%eax
     3ae:	74 07                	je     3b7 <gettoken+0x85>
    s++;
     3b0:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     3b3:	39 de                	cmp    %ebx,%esi
     3b5:	75 e1                	jne    398 <gettoken+0x66>
  *ps = s;
     3b7:	8b 45 08             	mov    0x8(%ebp),%eax
     3ba:	89 18                	mov    %ebx,(%eax)
  return ret;
}
     3bc:	89 f8                	mov    %edi,%eax
     3be:	8d 65 f4             	lea    -0xc(%ebp),%esp
     3c1:	5b                   	pop    %ebx
     3c2:	5e                   	pop    %esi
     3c3:	5f                   	pop    %edi
     3c4:	5d                   	pop    %ebp
     3c5:	c3                   	ret    
  switch(*s){
     3c6:	3c 26                	cmp    $0x26,%al
     3c8:	74 5b                	je     425 <gettoken+0xf3>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     3ca:	39 de                	cmp    %ebx,%esi
     3cc:	76 37                	jbe    405 <gettoken+0xd3>
     3ce:	83 ec 08             	sub    $0x8,%esp
     3d1:	0f be 03             	movsbl (%ebx),%eax
     3d4:	50                   	push   %eax
     3d5:	68 e8 16 00 00       	push   $0x16e8
     3da:	e8 7d 06 00 00       	call   a5c <strchr>
     3df:	83 c4 10             	add    $0x10,%esp
     3e2:	85 c0                	test   %eax,%eax
     3e4:	75 79                	jne    45f <gettoken+0x12d>
     3e6:	83 ec 08             	sub    $0x8,%esp
     3e9:	0f be 03             	movsbl (%ebx),%eax
     3ec:	50                   	push   %eax
     3ed:	68 e0 16 00 00       	push   $0x16e0
     3f2:	e8 65 06 00 00       	call   a5c <strchr>
     3f7:	83 c4 10             	add    $0x10,%esp
     3fa:	85 c0                	test   %eax,%eax
     3fc:	75 57                	jne    455 <gettoken+0x123>
      s++;
     3fe:	83 c3 01             	add    $0x1,%ebx
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     401:	39 de                	cmp    %ebx,%esi
     403:	75 c9                	jne    3ce <gettoken+0x9c>
  if(eq)
     405:	bf 61 00 00 00       	mov    $0x61,%edi
     40a:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     40e:	0f 85 7b ff ff ff    	jne    38f <gettoken+0x5d>
     414:	eb a1                	jmp    3b7 <gettoken+0x85>
  switch(*s){
     416:	3c 3e                	cmp    $0x3e,%al
     418:	74 19                	je     433 <gettoken+0x101>
     41a:	3c 3e                	cmp    $0x3e,%al
     41c:	7f 0f                	jg     42d <gettoken+0xfb>
     41e:	83 e8 3b             	sub    $0x3b,%eax
     421:	3c 01                	cmp    $0x1,%al
     423:	77 a5                	ja     3ca <gettoken+0x98>
    s++;
     425:	83 c3 01             	add    $0x1,%ebx
    break;
     428:	e9 5c ff ff ff       	jmp    389 <gettoken+0x57>
  switch(*s){
     42d:	3c 7c                	cmp    $0x7c,%al
     42f:	74 f4                	je     425 <gettoken+0xf3>
     431:	eb 97                	jmp    3ca <gettoken+0x98>
    s++;
     433:	8d 43 01             	lea    0x1(%ebx),%eax
    if(*s == '>'){
     436:	80 7b 01 3e          	cmpb   $0x3e,0x1(%ebx)
     43a:	74 0c                	je     448 <gettoken+0x116>
    s++;
     43c:	89 c3                	mov    %eax,%ebx
  ret = *s;
     43e:	bf 3e 00 00 00       	mov    $0x3e,%edi
     443:	e9 41 ff ff ff       	jmp    389 <gettoken+0x57>
      s++;
     448:	83 c3 02             	add    $0x2,%ebx
      ret = '+';
     44b:	bf 2b 00 00 00       	mov    $0x2b,%edi
     450:	e9 34 ff ff ff       	jmp    389 <gettoken+0x57>
    ret = 'a';
     455:	bf 61 00 00 00       	mov    $0x61,%edi
     45a:	e9 2a ff ff ff       	jmp    389 <gettoken+0x57>
     45f:	bf 61 00 00 00       	mov    $0x61,%edi
     464:	e9 20 ff ff ff       	jmp    389 <gettoken+0x57>

00000469 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     469:	55                   	push   %ebp
     46a:	89 e5                	mov    %esp,%ebp
     46c:	57                   	push   %edi
     46d:	56                   	push   %esi
     46e:	53                   	push   %ebx
     46f:	83 ec 0c             	sub    $0xc,%esp
     472:	8b 7d 08             	mov    0x8(%ebp),%edi
     475:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     478:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     47a:	39 f3                	cmp    %esi,%ebx
     47c:	73 1f                	jae    49d <peek+0x34>
     47e:	83 ec 08             	sub    $0x8,%esp
     481:	0f be 03             	movsbl (%ebx),%eax
     484:	50                   	push   %eax
     485:	68 e8 16 00 00       	push   $0x16e8
     48a:	e8 cd 05 00 00       	call   a5c <strchr>
     48f:	83 c4 10             	add    $0x10,%esp
     492:	85 c0                	test   %eax,%eax
     494:	74 07                	je     49d <peek+0x34>
    s++;
     496:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     499:	39 de                	cmp    %ebx,%esi
     49b:	75 e1                	jne    47e <peek+0x15>
  *ps = s;
     49d:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     49f:	0f b6 13             	movzbl (%ebx),%edx
     4a2:	b8 00 00 00 00       	mov    $0x0,%eax
     4a7:	84 d2                	test   %dl,%dl
     4a9:	75 08                	jne    4b3 <peek+0x4a>
}
     4ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
     4ae:	5b                   	pop    %ebx
     4af:	5e                   	pop    %esi
     4b0:	5f                   	pop    %edi
     4b1:	5d                   	pop    %ebp
     4b2:	c3                   	ret    
  return *s && strchr(toks, *s);
     4b3:	83 ec 08             	sub    $0x8,%esp
     4b6:	0f be d2             	movsbl %dl,%edx
     4b9:	52                   	push   %edx
     4ba:	ff 75 10             	pushl  0x10(%ebp)
     4bd:	e8 9a 05 00 00       	call   a5c <strchr>
     4c2:	83 c4 10             	add    $0x10,%esp
     4c5:	85 c0                	test   %eax,%eax
     4c7:	0f 95 c0             	setne  %al
     4ca:	0f b6 c0             	movzbl %al,%eax
     4cd:	eb dc                	jmp    4ab <peek+0x42>

000004cf <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     4cf:	55                   	push   %ebp
     4d0:	89 e5                	mov    %esp,%ebp
     4d2:	57                   	push   %edi
     4d3:	56                   	push   %esi
     4d4:	53                   	push   %ebx
     4d5:	83 ec 1c             	sub    $0x1c,%esp
     4d8:	8b 75 0c             	mov    0xc(%ebp),%esi
     4db:	8b 7d 10             	mov    0x10(%ebp),%edi
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     4de:	eb 28                	jmp    508 <parseredirs+0x39>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
     4e0:	83 ec 0c             	sub    $0xc,%esp
     4e3:	68 b4 10 00 00       	push   $0x10b4
     4e8:	e8 58 fb ff ff       	call   45 <panic>
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4ed:	83 ec 0c             	sub    $0xc,%esp
     4f0:	6a 00                	push   $0x0
     4f2:	6a 00                	push   $0x0
     4f4:	ff 75 e0             	pushl  -0x20(%ebp)
     4f7:	ff 75 e4             	pushl  -0x1c(%ebp)
     4fa:	ff 75 08             	pushl  0x8(%ebp)
     4fd:	e8 4c fd ff ff       	call   24e <redircmd>
     502:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     505:	83 c4 20             	add    $0x20,%esp
  while(peek(ps, es, "<>")){
     508:	83 ec 04             	sub    $0x4,%esp
     50b:	68 d1 10 00 00       	push   $0x10d1
     510:	57                   	push   %edi
     511:	56                   	push   %esi
     512:	e8 52 ff ff ff       	call   469 <peek>
     517:	83 c4 10             	add    $0x10,%esp
     51a:	85 c0                	test   %eax,%eax
     51c:	74 76                	je     594 <parseredirs+0xc5>
    tok = gettoken(ps, es, 0, 0);
     51e:	6a 00                	push   $0x0
     520:	6a 00                	push   $0x0
     522:	57                   	push   %edi
     523:	56                   	push   %esi
     524:	e8 09 fe ff ff       	call   332 <gettoken>
     529:	89 c3                	mov    %eax,%ebx
    if(gettoken(ps, es, &q, &eq) != 'a')
     52b:	8d 45 e0             	lea    -0x20(%ebp),%eax
     52e:	50                   	push   %eax
     52f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     532:	50                   	push   %eax
     533:	57                   	push   %edi
     534:	56                   	push   %esi
     535:	e8 f8 fd ff ff       	call   332 <gettoken>
     53a:	83 c4 20             	add    $0x20,%esp
     53d:	83 f8 61             	cmp    $0x61,%eax
     540:	75 9e                	jne    4e0 <parseredirs+0x11>
    switch(tok){
     542:	83 fb 3c             	cmp    $0x3c,%ebx
     545:	74 a6                	je     4ed <parseredirs+0x1e>
     547:	83 fb 3e             	cmp    $0x3e,%ebx
     54a:	74 25                	je     571 <parseredirs+0xa2>
     54c:	83 fb 2b             	cmp    $0x2b,%ebx
     54f:	75 b7                	jne    508 <parseredirs+0x39>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     551:	83 ec 0c             	sub    $0xc,%esp
     554:	6a 01                	push   $0x1
     556:	68 01 02 00 00       	push   $0x201
     55b:	ff 75 e0             	pushl  -0x20(%ebp)
     55e:	ff 75 e4             	pushl  -0x1c(%ebp)
     561:	ff 75 08             	pushl  0x8(%ebp)
     564:	e8 e5 fc ff ff       	call   24e <redircmd>
     569:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     56c:	83 c4 20             	add    $0x20,%esp
     56f:	eb 97                	jmp    508 <parseredirs+0x39>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     571:	83 ec 0c             	sub    $0xc,%esp
     574:	6a 01                	push   $0x1
     576:	68 01 02 00 00       	push   $0x201
     57b:	ff 75 e0             	pushl  -0x20(%ebp)
     57e:	ff 75 e4             	pushl  -0x1c(%ebp)
     581:	ff 75 08             	pushl  0x8(%ebp)
     584:	e8 c5 fc ff ff       	call   24e <redircmd>
     589:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     58c:	83 c4 20             	add    $0x20,%esp
     58f:	e9 74 ff ff ff       	jmp    508 <parseredirs+0x39>
    }
  }
  return cmd;
}
     594:	8b 45 08             	mov    0x8(%ebp),%eax
     597:	8d 65 f4             	lea    -0xc(%ebp),%esp
     59a:	5b                   	pop    %ebx
     59b:	5e                   	pop    %esi
     59c:	5f                   	pop    %edi
     59d:	5d                   	pop    %ebp
     59e:	c3                   	ret    

0000059f <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     59f:	55                   	push   %ebp
     5a0:	89 e5                	mov    %esp,%ebp
     5a2:	57                   	push   %edi
     5a3:	56                   	push   %esi
     5a4:	53                   	push   %ebx
     5a5:	83 ec 30             	sub    $0x30,%esp
     5a8:	8b 75 08             	mov    0x8(%ebp),%esi
     5ab:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     5ae:	68 d4 10 00 00       	push   $0x10d4
     5b3:	57                   	push   %edi
     5b4:	56                   	push   %esi
     5b5:	e8 af fe ff ff       	call   469 <peek>
     5ba:	83 c4 10             	add    $0x10,%esp
     5bd:	85 c0                	test   %eax,%eax
     5bf:	75 7a                	jne    63b <parseexec+0x9c>
     5c1:	89 c3                	mov    %eax,%ebx
    return parseblock(ps, es);

  ret = execcmd();
     5c3:	e8 5c fc ff ff       	call   224 <execcmd>
     5c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     5cb:	83 ec 04             	sub    $0x4,%esp
     5ce:	57                   	push   %edi
     5cf:	56                   	push   %esi
     5d0:	50                   	push   %eax
     5d1:	e8 f9 fe ff ff       	call   4cf <parseredirs>
     5d6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     5d9:	83 c4 10             	add    $0x10,%esp
     5dc:	83 ec 04             	sub    $0x4,%esp
     5df:	68 eb 10 00 00       	push   $0x10eb
     5e4:	57                   	push   %edi
     5e5:	56                   	push   %esi
     5e6:	e8 7e fe ff ff       	call   469 <peek>
     5eb:	83 c4 10             	add    $0x10,%esp
     5ee:	85 c0                	test   %eax,%eax
     5f0:	75 7e                	jne    670 <parseexec+0xd1>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     5f2:	8d 45 e0             	lea    -0x20(%ebp),%eax
     5f5:	50                   	push   %eax
     5f6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     5f9:	50                   	push   %eax
     5fa:	57                   	push   %edi
     5fb:	56                   	push   %esi
     5fc:	e8 31 fd ff ff       	call   332 <gettoken>
     601:	83 c4 10             	add    $0x10,%esp
     604:	85 c0                	test   %eax,%eax
     606:	74 68                	je     670 <parseexec+0xd1>
      break;
    if(tok != 'a')
     608:	83 f8 61             	cmp    $0x61,%eax
     60b:	75 49                	jne    656 <parseexec+0xb7>
      panic("syntax");
    cmd->argv[argc] = q;
     60d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     610:	8b 55 d0             	mov    -0x30(%ebp),%edx
     613:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     617:	8b 45 e0             	mov    -0x20(%ebp),%eax
     61a:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     61e:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     621:	83 fb 0a             	cmp    $0xa,%ebx
     624:	74 3d                	je     663 <parseexec+0xc4>
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     626:	83 ec 04             	sub    $0x4,%esp
     629:	57                   	push   %edi
     62a:	56                   	push   %esi
     62b:	ff 75 d4             	pushl  -0x2c(%ebp)
     62e:	e8 9c fe ff ff       	call   4cf <parseredirs>
     633:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     636:	83 c4 10             	add    $0x10,%esp
     639:	eb a1                	jmp    5dc <parseexec+0x3d>
    return parseblock(ps, es);
     63b:	83 ec 08             	sub    $0x8,%esp
     63e:	57                   	push   %edi
     63f:	56                   	push   %esi
     640:	e8 30 01 00 00       	call   775 <parseblock>
     645:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     648:	83 c4 10             	add    $0x10,%esp
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     64b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     64e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     651:	5b                   	pop    %ebx
     652:	5e                   	pop    %esi
     653:	5f                   	pop    %edi
     654:	5d                   	pop    %ebp
     655:	c3                   	ret    
      panic("syntax");
     656:	83 ec 0c             	sub    $0xc,%esp
     659:	68 d6 10 00 00       	push   $0x10d6
     65e:	e8 e2 f9 ff ff       	call   45 <panic>
      panic("too many args");
     663:	83 ec 0c             	sub    $0xc,%esp
     666:	68 dd 10 00 00       	push   $0x10dd
     66b:	e8 d5 f9 ff ff       	call   45 <panic>
     670:	8b 45 d0             	mov    -0x30(%ebp),%eax
     673:	8d 04 98             	lea    (%eax,%ebx,4),%eax
  cmd->argv[argc] = 0;
     676:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  cmd->eargv[argc] = 0;
     67d:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
  return ret;
     684:	eb c5                	jmp    64b <parseexec+0xac>

00000686 <parsepipe>:
{
     686:	55                   	push   %ebp
     687:	89 e5                	mov    %esp,%ebp
     689:	57                   	push   %edi
     68a:	56                   	push   %esi
     68b:	53                   	push   %ebx
     68c:	83 ec 14             	sub    $0x14,%esp
     68f:	8b 5d 08             	mov    0x8(%ebp),%ebx
     692:	8b 75 0c             	mov    0xc(%ebp),%esi
  cmd = parseexec(ps, es);
     695:	56                   	push   %esi
     696:	53                   	push   %ebx
     697:	e8 03 ff ff ff       	call   59f <parseexec>
     69c:	89 c7                	mov    %eax,%edi
  if(peek(ps, es, "|")){
     69e:	83 c4 0c             	add    $0xc,%esp
     6a1:	68 f0 10 00 00       	push   $0x10f0
     6a6:	56                   	push   %esi
     6a7:	53                   	push   %ebx
     6a8:	e8 bc fd ff ff       	call   469 <peek>
     6ad:	83 c4 10             	add    $0x10,%esp
     6b0:	85 c0                	test   %eax,%eax
     6b2:	75 0a                	jne    6be <parsepipe+0x38>
}
     6b4:	89 f8                	mov    %edi,%eax
     6b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
     6b9:	5b                   	pop    %ebx
     6ba:	5e                   	pop    %esi
     6bb:	5f                   	pop    %edi
     6bc:	5d                   	pop    %ebp
     6bd:	c3                   	ret    
    gettoken(ps, es, 0, 0);
     6be:	6a 00                	push   $0x0
     6c0:	6a 00                	push   $0x0
     6c2:	56                   	push   %esi
     6c3:	53                   	push   %ebx
     6c4:	e8 69 fc ff ff       	call   332 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6c9:	83 c4 08             	add    $0x8,%esp
     6cc:	56                   	push   %esi
     6cd:	53                   	push   %ebx
     6ce:	e8 b3 ff ff ff       	call   686 <parsepipe>
     6d3:	83 c4 08             	add    $0x8,%esp
     6d6:	50                   	push   %eax
     6d7:	57                   	push   %edi
     6d8:	e8 b9 fb ff ff       	call   296 <pipecmd>
     6dd:	89 c7                	mov    %eax,%edi
     6df:	83 c4 10             	add    $0x10,%esp
  return cmd;
     6e2:	eb d0                	jmp    6b4 <parsepipe+0x2e>

000006e4 <parseline>:
{
     6e4:	55                   	push   %ebp
     6e5:	89 e5                	mov    %esp,%ebp
     6e7:	57                   	push   %edi
     6e8:	56                   	push   %esi
     6e9:	53                   	push   %ebx
     6ea:	83 ec 14             	sub    $0x14,%esp
     6ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
     6f0:	8b 75 0c             	mov    0xc(%ebp),%esi
  cmd = parsepipe(ps, es);
     6f3:	56                   	push   %esi
     6f4:	53                   	push   %ebx
     6f5:	e8 8c ff ff ff       	call   686 <parsepipe>
     6fa:	89 c7                	mov    %eax,%edi
  while(peek(ps, es, "&")){
     6fc:	83 c4 10             	add    $0x10,%esp
     6ff:	eb 18                	jmp    719 <parseline+0x35>
    gettoken(ps, es, 0, 0);
     701:	6a 00                	push   $0x0
     703:	6a 00                	push   $0x0
     705:	56                   	push   %esi
     706:	53                   	push   %ebx
     707:	e8 26 fc ff ff       	call   332 <gettoken>
    cmd = backcmd(cmd);
     70c:	89 3c 24             	mov    %edi,(%esp)
     70f:	e8 ee fb ff ff       	call   302 <backcmd>
     714:	89 c7                	mov    %eax,%edi
     716:	83 c4 10             	add    $0x10,%esp
  while(peek(ps, es, "&")){
     719:	83 ec 04             	sub    $0x4,%esp
     71c:	68 f2 10 00 00       	push   $0x10f2
     721:	56                   	push   %esi
     722:	53                   	push   %ebx
     723:	e8 41 fd ff ff       	call   469 <peek>
     728:	83 c4 10             	add    $0x10,%esp
     72b:	85 c0                	test   %eax,%eax
     72d:	75 d2                	jne    701 <parseline+0x1d>
  if(peek(ps, es, ";")){
     72f:	83 ec 04             	sub    $0x4,%esp
     732:	68 ee 10 00 00       	push   $0x10ee
     737:	56                   	push   %esi
     738:	53                   	push   %ebx
     739:	e8 2b fd ff ff       	call   469 <peek>
     73e:	83 c4 10             	add    $0x10,%esp
     741:	85 c0                	test   %eax,%eax
     743:	75 0a                	jne    74f <parseline+0x6b>
}
     745:	89 f8                	mov    %edi,%eax
     747:	8d 65 f4             	lea    -0xc(%ebp),%esp
     74a:	5b                   	pop    %ebx
     74b:	5e                   	pop    %esi
     74c:	5f                   	pop    %edi
     74d:	5d                   	pop    %ebp
     74e:	c3                   	ret    
    gettoken(ps, es, 0, 0);
     74f:	6a 00                	push   $0x0
     751:	6a 00                	push   $0x0
     753:	56                   	push   %esi
     754:	53                   	push   %ebx
     755:	e8 d8 fb ff ff       	call   332 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     75a:	83 c4 08             	add    $0x8,%esp
     75d:	56                   	push   %esi
     75e:	53                   	push   %ebx
     75f:	e8 80 ff ff ff       	call   6e4 <parseline>
     764:	83 c4 08             	add    $0x8,%esp
     767:	50                   	push   %eax
     768:	57                   	push   %edi
     769:	e8 5e fb ff ff       	call   2cc <listcmd>
     76e:	89 c7                	mov    %eax,%edi
     770:	83 c4 10             	add    $0x10,%esp
  return cmd;
     773:	eb d0                	jmp    745 <parseline+0x61>

00000775 <parseblock>:
{
     775:	55                   	push   %ebp
     776:	89 e5                	mov    %esp,%ebp
     778:	57                   	push   %edi
     779:	56                   	push   %esi
     77a:	53                   	push   %ebx
     77b:	83 ec 10             	sub    $0x10,%esp
     77e:	8b 5d 08             	mov    0x8(%ebp),%ebx
     781:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
     784:	68 d4 10 00 00       	push   $0x10d4
     789:	56                   	push   %esi
     78a:	53                   	push   %ebx
     78b:	e8 d9 fc ff ff       	call   469 <peek>
     790:	83 c4 10             	add    $0x10,%esp
     793:	85 c0                	test   %eax,%eax
     795:	74 4b                	je     7e2 <parseblock+0x6d>
  gettoken(ps, es, 0, 0);
     797:	6a 00                	push   $0x0
     799:	6a 00                	push   $0x0
     79b:	56                   	push   %esi
     79c:	53                   	push   %ebx
     79d:	e8 90 fb ff ff       	call   332 <gettoken>
  cmd = parseline(ps, es);
     7a2:	83 c4 08             	add    $0x8,%esp
     7a5:	56                   	push   %esi
     7a6:	53                   	push   %ebx
     7a7:	e8 38 ff ff ff       	call   6e4 <parseline>
     7ac:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     7ae:	83 c4 0c             	add    $0xc,%esp
     7b1:	68 10 11 00 00       	push   $0x1110
     7b6:	56                   	push   %esi
     7b7:	53                   	push   %ebx
     7b8:	e8 ac fc ff ff       	call   469 <peek>
     7bd:	83 c4 10             	add    $0x10,%esp
     7c0:	85 c0                	test   %eax,%eax
     7c2:	74 2b                	je     7ef <parseblock+0x7a>
  gettoken(ps, es, 0, 0);
     7c4:	6a 00                	push   $0x0
     7c6:	6a 00                	push   $0x0
     7c8:	56                   	push   %esi
     7c9:	53                   	push   %ebx
     7ca:	e8 63 fb ff ff       	call   332 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     7cf:	83 c4 0c             	add    $0xc,%esp
     7d2:	56                   	push   %esi
     7d3:	53                   	push   %ebx
     7d4:	57                   	push   %edi
     7d5:	e8 f5 fc ff ff       	call   4cf <parseredirs>
}
     7da:	8d 65 f4             	lea    -0xc(%ebp),%esp
     7dd:	5b                   	pop    %ebx
     7de:	5e                   	pop    %esi
     7df:	5f                   	pop    %edi
     7e0:	5d                   	pop    %ebp
     7e1:	c3                   	ret    
    panic("parseblock");
     7e2:	83 ec 0c             	sub    $0xc,%esp
     7e5:	68 f4 10 00 00       	push   $0x10f4
     7ea:	e8 56 f8 ff ff       	call   45 <panic>
    panic("syntax - missing )");
     7ef:	83 ec 0c             	sub    $0xc,%esp
     7f2:	68 ff 10 00 00       	push   $0x10ff
     7f7:	e8 49 f8 ff ff       	call   45 <panic>

000007fc <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     7fc:	55                   	push   %ebp
     7fd:	89 e5                	mov    %esp,%ebp
     7ff:	53                   	push   %ebx
     800:	83 ec 04             	sub    $0x4,%esp
     803:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     806:	85 db                	test   %ebx,%ebx
     808:	74 3c                	je     846 <nulterminate+0x4a>
    return 0;

  switch(cmd->type){
     80a:	83 3b 05             	cmpl   $0x5,(%ebx)
     80d:	77 37                	ja     846 <nulterminate+0x4a>
     80f:	8b 03                	mov    (%ebx),%eax
     811:	ff 24 85 50 11 00 00 	jmp    *0x1150(,%eax,4)
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     818:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
     81c:	74 28                	je     846 <nulterminate+0x4a>
     81e:	8d 43 08             	lea    0x8(%ebx),%eax
      *ecmd->eargv[i] = 0;
     821:	8b 50 24             	mov    0x24(%eax),%edx
     824:	c6 02 00             	movb   $0x0,(%edx)
     827:	83 c0 04             	add    $0x4,%eax
    for(i=0; ecmd->argv[i]; i++)
     82a:	83 78 fc 00          	cmpl   $0x0,-0x4(%eax)
     82e:	75 f1                	jne    821 <nulterminate+0x25>
     830:	eb 14                	jmp    846 <nulterminate+0x4a>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     832:	83 ec 0c             	sub    $0xc,%esp
     835:	ff 73 04             	pushl  0x4(%ebx)
     838:	e8 bf ff ff ff       	call   7fc <nulterminate>
    *rcmd->efile = 0;
     83d:	8b 43 0c             	mov    0xc(%ebx),%eax
     840:	c6 00 00             	movb   $0x0,(%eax)
    break;
     843:	83 c4 10             	add    $0x10,%esp
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     846:	89 d8                	mov    %ebx,%eax
     848:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     84b:	c9                   	leave  
     84c:	c3                   	ret    
    nulterminate(pcmd->left);
     84d:	83 ec 0c             	sub    $0xc,%esp
     850:	ff 73 04             	pushl  0x4(%ebx)
     853:	e8 a4 ff ff ff       	call   7fc <nulterminate>
    nulterminate(pcmd->right);
     858:	83 c4 04             	add    $0x4,%esp
     85b:	ff 73 08             	pushl  0x8(%ebx)
     85e:	e8 99 ff ff ff       	call   7fc <nulterminate>
    break;
     863:	83 c4 10             	add    $0x10,%esp
     866:	eb de                	jmp    846 <nulterminate+0x4a>
    nulterminate(lcmd->left);
     868:	83 ec 0c             	sub    $0xc,%esp
     86b:	ff 73 04             	pushl  0x4(%ebx)
     86e:	e8 89 ff ff ff       	call   7fc <nulterminate>
    nulterminate(lcmd->right);
     873:	83 c4 04             	add    $0x4,%esp
     876:	ff 73 08             	pushl  0x8(%ebx)
     879:	e8 7e ff ff ff       	call   7fc <nulterminate>
    break;
     87e:	83 c4 10             	add    $0x10,%esp
     881:	eb c3                	jmp    846 <nulterminate+0x4a>
    nulterminate(bcmd->cmd);
     883:	83 ec 0c             	sub    $0xc,%esp
     886:	ff 73 04             	pushl  0x4(%ebx)
     889:	e8 6e ff ff ff       	call   7fc <nulterminate>
    break;
     88e:	83 c4 10             	add    $0x10,%esp
     891:	eb b3                	jmp    846 <nulterminate+0x4a>

00000893 <parsecmd>:
{
     893:	55                   	push   %ebp
     894:	89 e5                	mov    %esp,%ebp
     896:	56                   	push   %esi
     897:	53                   	push   %ebx
  es = s + strlen(s);
     898:	8b 5d 08             	mov    0x8(%ebp),%ebx
     89b:	83 ec 0c             	sub    $0xc,%esp
     89e:	53                   	push   %ebx
     89f:	e8 7d 01 00 00       	call   a21 <strlen>
     8a4:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     8a6:	83 c4 08             	add    $0x8,%esp
     8a9:	53                   	push   %ebx
     8aa:	8d 45 08             	lea    0x8(%ebp),%eax
     8ad:	50                   	push   %eax
     8ae:	e8 31 fe ff ff       	call   6e4 <parseline>
     8b3:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     8b5:	83 c4 0c             	add    $0xc,%esp
     8b8:	68 9e 10 00 00       	push   $0x109e
     8bd:	53                   	push   %ebx
     8be:	8d 45 08             	lea    0x8(%ebp),%eax
     8c1:	50                   	push   %eax
     8c2:	e8 a2 fb ff ff       	call   469 <peek>
  if(s != es){
     8c7:	8b 45 08             	mov    0x8(%ebp),%eax
     8ca:	83 c4 10             	add    $0x10,%esp
     8cd:	39 d8                	cmp    %ebx,%eax
     8cf:	75 12                	jne    8e3 <parsecmd+0x50>
  nulterminate(cmd);
     8d1:	83 ec 0c             	sub    $0xc,%esp
     8d4:	56                   	push   %esi
     8d5:	e8 22 ff ff ff       	call   7fc <nulterminate>
}
     8da:	89 f0                	mov    %esi,%eax
     8dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
     8df:	5b                   	pop    %ebx
     8e0:	5e                   	pop    %esi
     8e1:	5d                   	pop    %ebp
     8e2:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
     8e3:	83 ec 04             	sub    $0x4,%esp
     8e6:	50                   	push   %eax
     8e7:	68 12 11 00 00       	push   $0x1112
     8ec:	6a 02                	push   $0x2
     8ee:	e8 76 04 00 00       	call   d69 <printf>
    panic("syntax");
     8f3:	c7 04 24 d6 10 00 00 	movl   $0x10d6,(%esp)
     8fa:	e8 46 f7 ff ff       	call   45 <panic>

000008ff <main>:
{
     8ff:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     903:	83 e4 f0             	and    $0xfffffff0,%esp
     906:	ff 71 fc             	pushl  -0x4(%ecx)
     909:	55                   	push   %ebp
     90a:	89 e5                	mov    %esp,%ebp
     90c:	51                   	push   %ecx
     90d:	83 ec 04             	sub    $0x4,%esp
  while((fd = open("console", O_RDWR)) >= 0){
     910:	83 ec 08             	sub    $0x8,%esp
     913:	6a 02                	push   $0x2
     915:	68 21 11 00 00       	push   $0x1121
     91a:	e8 50 03 00 00       	call   c6f <open>
     91f:	83 c4 10             	add    $0x10,%esp
     922:	85 c0                	test   %eax,%eax
     924:	78 21                	js     947 <main+0x48>
    if(fd >= 3){
     926:	83 f8 02             	cmp    $0x2,%eax
     929:	7e e5                	jle    910 <main+0x11>
      close(fd);
     92b:	83 ec 0c             	sub    $0xc,%esp
     92e:	50                   	push   %eax
     92f:	e8 23 03 00 00       	call   c57 <close>
      break;
     934:	83 c4 10             	add    $0x10,%esp
     937:	eb 0e                	jmp    947 <main+0x48>
    if(fork1() == 0)
     939:	e8 21 f7 ff ff       	call   5f <fork1>
     93e:	85 c0                	test   %eax,%eax
     940:	74 76                	je     9b8 <main+0xb9>
    wait();
     942:	e8 f0 02 00 00       	call   c37 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     947:	83 ec 08             	sub    $0x8,%esp
     94a:	6a 64                	push   $0x64
     94c:	68 00 17 00 00       	push   $0x1700
     951:	e8 aa f6 ff ff       	call   0 <getcmd>
     956:	83 c4 10             	add    $0x10,%esp
     959:	85 c0                	test   %eax,%eax
     95b:	78 70                	js     9cd <main+0xce>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     95d:	80 3d 00 17 00 00 63 	cmpb   $0x63,0x1700
     964:	75 d3                	jne    939 <main+0x3a>
     966:	80 3d 01 17 00 00 64 	cmpb   $0x64,0x1701
     96d:	75 ca                	jne    939 <main+0x3a>
     96f:	80 3d 02 17 00 00 20 	cmpb   $0x20,0x1702
     976:	75 c1                	jne    939 <main+0x3a>
      buf[strlen(buf)-1] = 0;  // chop \n
     978:	83 ec 0c             	sub    $0xc,%esp
     97b:	68 00 17 00 00       	push   $0x1700
     980:	e8 9c 00 00 00       	call   a21 <strlen>
     985:	c6 80 ff 16 00 00 00 	movb   $0x0,0x16ff(%eax)
      if(chdir(buf+3) < 0)
     98c:	c7 04 24 03 17 00 00 	movl   $0x1703,(%esp)
     993:	e8 07 03 00 00       	call   c9f <chdir>
     998:	83 c4 10             	add    $0x10,%esp
     99b:	85 c0                	test   %eax,%eax
     99d:	79 a8                	jns    947 <main+0x48>
        printf(2, "cannot cd %s\n", buf+3);
     99f:	83 ec 04             	sub    $0x4,%esp
     9a2:	68 03 17 00 00       	push   $0x1703
     9a7:	68 29 11 00 00       	push   $0x1129
     9ac:	6a 02                	push   $0x2
     9ae:	e8 b6 03 00 00       	call   d69 <printf>
     9b3:	83 c4 10             	add    $0x10,%esp
     9b6:	eb 8f                	jmp    947 <main+0x48>
      runcmd(parsecmd(buf));
     9b8:	83 ec 0c             	sub    $0xc,%esp
     9bb:	68 00 17 00 00       	push   $0x1700
     9c0:	e8 ce fe ff ff       	call   893 <parsecmd>
     9c5:	89 04 24             	mov    %eax,(%esp)
     9c8:	e8 b1 f6 ff ff       	call   7e <runcmd>
  exit();
     9cd:	e8 5d 02 00 00       	call   c2f <exit>

000009d2 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     9d2:	55                   	push   %ebp
     9d3:	89 e5                	mov    %esp,%ebp
     9d5:	53                   	push   %ebx
     9d6:	8b 45 08             	mov    0x8(%ebp),%eax
     9d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     9dc:	89 c2                	mov    %eax,%edx
     9de:	83 c1 01             	add    $0x1,%ecx
     9e1:	83 c2 01             	add    $0x1,%edx
     9e4:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
     9e8:	88 5a ff             	mov    %bl,-0x1(%edx)
     9eb:	84 db                	test   %bl,%bl
     9ed:	75 ef                	jne    9de <strcpy+0xc>
    ;
  return os;
}
     9ef:	5b                   	pop    %ebx
     9f0:	5d                   	pop    %ebp
     9f1:	c3                   	ret    

000009f2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9f2:	55                   	push   %ebp
     9f3:	89 e5                	mov    %esp,%ebp
     9f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
     9f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
     9fb:	0f b6 01             	movzbl (%ecx),%eax
     9fe:	84 c0                	test   %al,%al
     a00:	74 15                	je     a17 <strcmp+0x25>
     a02:	3a 02                	cmp    (%edx),%al
     a04:	75 11                	jne    a17 <strcmp+0x25>
    p++, q++;
     a06:	83 c1 01             	add    $0x1,%ecx
     a09:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
     a0c:	0f b6 01             	movzbl (%ecx),%eax
     a0f:	84 c0                	test   %al,%al
     a11:	74 04                	je     a17 <strcmp+0x25>
     a13:	3a 02                	cmp    (%edx),%al
     a15:	74 ef                	je     a06 <strcmp+0x14>
  return (uchar)*p - (uchar)*q;
     a17:	0f b6 c0             	movzbl %al,%eax
     a1a:	0f b6 12             	movzbl (%edx),%edx
     a1d:	29 d0                	sub    %edx,%eax
}
     a1f:	5d                   	pop    %ebp
     a20:	c3                   	ret    

00000a21 <strlen>:

uint
strlen(char *s)
{
     a21:	55                   	push   %ebp
     a22:	89 e5                	mov    %esp,%ebp
     a24:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
     a27:	80 39 00             	cmpb   $0x0,(%ecx)
     a2a:	74 12                	je     a3e <strlen+0x1d>
     a2c:	ba 00 00 00 00       	mov    $0x0,%edx
     a31:	83 c2 01             	add    $0x1,%edx
     a34:	89 d0                	mov    %edx,%eax
     a36:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
     a3a:	75 f5                	jne    a31 <strlen+0x10>
    ;
  return n;
}
     a3c:	5d                   	pop    %ebp
     a3d:	c3                   	ret    
  for(n = 0; s[n]; n++)
     a3e:	b8 00 00 00 00       	mov    $0x0,%eax
  return n;
     a43:	eb f7                	jmp    a3c <strlen+0x1b>

00000a45 <memset>:

void*
memset(void *dst, int c, uint n)
{
     a45:	55                   	push   %ebp
     a46:	89 e5                	mov    %esp,%ebp
     a48:	57                   	push   %edi
     a49:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     a4c:	89 d7                	mov    %edx,%edi
     a4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
     a51:	8b 45 0c             	mov    0xc(%ebp),%eax
     a54:	fc                   	cld    
     a55:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     a57:	89 d0                	mov    %edx,%eax
     a59:	5f                   	pop    %edi
     a5a:	5d                   	pop    %ebp
     a5b:	c3                   	ret    

00000a5c <strchr>:

char*
strchr(const char *s, char c)
{
     a5c:	55                   	push   %ebp
     a5d:	89 e5                	mov    %esp,%ebp
     a5f:	53                   	push   %ebx
     a60:	8b 45 08             	mov    0x8(%ebp),%eax
     a63:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
     a66:	0f b6 10             	movzbl (%eax),%edx
     a69:	84 d2                	test   %dl,%dl
     a6b:	74 1e                	je     a8b <strchr+0x2f>
     a6d:	89 d9                	mov    %ebx,%ecx
    if(*s == c)
     a6f:	38 d3                	cmp    %dl,%bl
     a71:	74 15                	je     a88 <strchr+0x2c>
  for(; *s; s++)
     a73:	83 c0 01             	add    $0x1,%eax
     a76:	0f b6 10             	movzbl (%eax),%edx
     a79:	84 d2                	test   %dl,%dl
     a7b:	74 06                	je     a83 <strchr+0x27>
    if(*s == c)
     a7d:	38 ca                	cmp    %cl,%dl
     a7f:	75 f2                	jne    a73 <strchr+0x17>
     a81:	eb 05                	jmp    a88 <strchr+0x2c>
      return (char*)s;
  return 0;
     a83:	b8 00 00 00 00       	mov    $0x0,%eax
}
     a88:	5b                   	pop    %ebx
     a89:	5d                   	pop    %ebp
     a8a:	c3                   	ret    
  return 0;
     a8b:	b8 00 00 00 00       	mov    $0x0,%eax
     a90:	eb f6                	jmp    a88 <strchr+0x2c>

00000a92 <gets>:

char*
gets(char *buf, int max)
{
     a92:	55                   	push   %ebp
     a93:	89 e5                	mov    %esp,%ebp
     a95:	57                   	push   %edi
     a96:	56                   	push   %esi
     a97:	53                   	push   %ebx
     a98:	83 ec 1c             	sub    $0x1c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a9b:	be 00 00 00 00       	mov    $0x0,%esi
    cc = read(0, &c, 1);
     aa0:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
     aa3:	8d 5e 01             	lea    0x1(%esi),%ebx
     aa6:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     aa9:	7d 2b                	jge    ad6 <gets+0x44>
    cc = read(0, &c, 1);
     aab:	83 ec 04             	sub    $0x4,%esp
     aae:	6a 01                	push   $0x1
     ab0:	57                   	push   %edi
     ab1:	6a 00                	push   $0x0
     ab3:	e8 8f 01 00 00       	call   c47 <read>
    if(cc < 1)
     ab8:	83 c4 10             	add    $0x10,%esp
     abb:	85 c0                	test   %eax,%eax
     abd:	7e 17                	jle    ad6 <gets+0x44>
      break;
    buf[i++] = c;
     abf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     ac3:	8b 55 08             	mov    0x8(%ebp),%edx
     ac6:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
  for(i=0; i+1 < max; ){
     aca:	89 de                	mov    %ebx,%esi
    if(c == '\n' || c == '\r')
     acc:	3c 0a                	cmp    $0xa,%al
     ace:	74 04                	je     ad4 <gets+0x42>
     ad0:	3c 0d                	cmp    $0xd,%al
     ad2:	75 cf                	jne    aa3 <gets+0x11>
  for(i=0; i+1 < max; ){
     ad4:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
     ad6:	8b 45 08             	mov    0x8(%ebp),%eax
     ad9:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
     add:	8d 65 f4             	lea    -0xc(%ebp),%esp
     ae0:	5b                   	pop    %ebx
     ae1:	5e                   	pop    %esi
     ae2:	5f                   	pop    %edi
     ae3:	5d                   	pop    %ebp
     ae4:	c3                   	ret    

00000ae5 <stat>:

int
stat(char *n, struct stat *st)
{
     ae5:	55                   	push   %ebp
     ae6:	89 e5                	mov    %esp,%ebp
     ae8:	56                   	push   %esi
     ae9:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     aea:	83 ec 08             	sub    $0x8,%esp
     aed:	6a 00                	push   $0x0
     aef:	ff 75 08             	pushl  0x8(%ebp)
     af2:	e8 78 01 00 00       	call   c6f <open>
  if(fd < 0)
     af7:	83 c4 10             	add    $0x10,%esp
     afa:	85 c0                	test   %eax,%eax
     afc:	78 24                	js     b22 <stat+0x3d>
     afe:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
     b00:	83 ec 08             	sub    $0x8,%esp
     b03:	ff 75 0c             	pushl  0xc(%ebp)
     b06:	50                   	push   %eax
     b07:	e8 7b 01 00 00       	call   c87 <fstat>
     b0c:	89 c6                	mov    %eax,%esi
  close(fd);
     b0e:	89 1c 24             	mov    %ebx,(%esp)
     b11:	e8 41 01 00 00       	call   c57 <close>
  return r;
     b16:	83 c4 10             	add    $0x10,%esp
}
     b19:	89 f0                	mov    %esi,%eax
     b1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
     b1e:	5b                   	pop    %ebx
     b1f:	5e                   	pop    %esi
     b20:	5d                   	pop    %ebp
     b21:	c3                   	ret    
    return -1;
     b22:	be ff ff ff ff       	mov    $0xffffffff,%esi
     b27:	eb f0                	jmp    b19 <stat+0x34>

00000b29 <atoi>:

#ifdef PDX_XV6
int
atoi(const char *s)
{
     b29:	55                   	push   %ebp
     b2a:	89 e5                	mov    %esp,%ebp
     b2c:	56                   	push   %esi
     b2d:	53                   	push   %ebx
     b2e:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
     b31:	0f b6 0a             	movzbl (%edx),%ecx
     b34:	80 f9 20             	cmp    $0x20,%cl
     b37:	75 0b                	jne    b44 <atoi+0x1b>
     b39:	83 c2 01             	add    $0x1,%edx
     b3c:	0f b6 0a             	movzbl (%edx),%ecx
     b3f:	80 f9 20             	cmp    $0x20,%cl
     b42:	74 f5                	je     b39 <atoi+0x10>
  sign = (*s == '-') ? -1 : 1;
     b44:	80 f9 2d             	cmp    $0x2d,%cl
     b47:	74 3b                	je     b84 <atoi+0x5b>
  if (*s == '+'  || *s == '-')
     b49:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
     b4c:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
     b51:	f6 c1 fd             	test   $0xfd,%cl
     b54:	74 33                	je     b89 <atoi+0x60>
    s++;
  while('0' <= *s && *s <= '9')
     b56:	0f b6 0a             	movzbl (%edx),%ecx
     b59:	8d 41 d0             	lea    -0x30(%ecx),%eax
     b5c:	3c 09                	cmp    $0x9,%al
     b5e:	77 2e                	ja     b8e <atoi+0x65>
     b60:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*10 + *s++ - '0';
     b65:	83 c2 01             	add    $0x1,%edx
     b68:	8d 04 80             	lea    (%eax,%eax,4),%eax
     b6b:	0f be c9             	movsbl %cl,%ecx
     b6e:	8d 44 41 d0          	lea    -0x30(%ecx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
     b72:	0f b6 0a             	movzbl (%edx),%ecx
     b75:	8d 59 d0             	lea    -0x30(%ecx),%ebx
     b78:	80 fb 09             	cmp    $0x9,%bl
     b7b:	76 e8                	jbe    b65 <atoi+0x3c>
  return sign*n;
     b7d:	0f af c6             	imul   %esi,%eax
}
     b80:	5b                   	pop    %ebx
     b81:	5e                   	pop    %esi
     b82:	5d                   	pop    %ebp
     b83:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
     b84:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
     b89:	83 c2 01             	add    $0x1,%edx
     b8c:	eb c8                	jmp    b56 <atoi+0x2d>
  while('0' <= *s && *s <= '9')
     b8e:	b8 00 00 00 00       	mov    $0x0,%eax
     b93:	eb e8                	jmp    b7d <atoi+0x54>

00000b95 <atoo>:

int
atoo(const char *s)
{
     b95:	55                   	push   %ebp
     b96:	89 e5                	mov    %esp,%ebp
     b98:	56                   	push   %esi
     b99:	53                   	push   %ebx
     b9a:	8b 55 08             	mov    0x8(%ebp),%edx
  int n, sign;

  n = 0;
  while (*s == ' ') s++;
     b9d:	0f b6 0a             	movzbl (%edx),%ecx
     ba0:	80 f9 20             	cmp    $0x20,%cl
     ba3:	75 0b                	jne    bb0 <atoo+0x1b>
     ba5:	83 c2 01             	add    $0x1,%edx
     ba8:	0f b6 0a             	movzbl (%edx),%ecx
     bab:	80 f9 20             	cmp    $0x20,%cl
     bae:	74 f5                	je     ba5 <atoo+0x10>
  sign = (*s == '-') ? -1 : 1;
     bb0:	80 f9 2d             	cmp    $0x2d,%cl
     bb3:	74 38                	je     bed <atoo+0x58>
  if (*s == '+'  || *s == '-')
     bb5:	83 e9 2b             	sub    $0x2b,%ecx
  sign = (*s == '-') ? -1 : 1;
     bb8:	be 01 00 00 00       	mov    $0x1,%esi
  if (*s == '+'  || *s == '-')
     bbd:	f6 c1 fd             	test   $0xfd,%cl
     bc0:	74 30                	je     bf2 <atoo+0x5d>
    s++;
  while('0' <= *s && *s <= '7')
     bc2:	0f b6 0a             	movzbl (%edx),%ecx
     bc5:	8d 41 d0             	lea    -0x30(%ecx),%eax
     bc8:	3c 07                	cmp    $0x7,%al
     bca:	77 2b                	ja     bf7 <atoo+0x62>
     bcc:	b8 00 00 00 00       	mov    $0x0,%eax
    n = n*8 + *s++ - '0';
     bd1:	83 c2 01             	add    $0x1,%edx
     bd4:	0f be c9             	movsbl %cl,%ecx
     bd7:	8d 44 c1 d0          	lea    -0x30(%ecx,%eax,8),%eax
  while('0' <= *s && *s <= '7')
     bdb:	0f b6 0a             	movzbl (%edx),%ecx
     bde:	8d 59 d0             	lea    -0x30(%ecx),%ebx
     be1:	80 fb 07             	cmp    $0x7,%bl
     be4:	76 eb                	jbe    bd1 <atoo+0x3c>
  return sign*n;
     be6:	0f af c6             	imul   %esi,%eax
}
     be9:	5b                   	pop    %ebx
     bea:	5e                   	pop    %esi
     beb:	5d                   	pop    %ebp
     bec:	c3                   	ret    
  sign = (*s == '-') ? -1 : 1;
     bed:	be ff ff ff ff       	mov    $0xffffffff,%esi
    s++;
     bf2:	83 c2 01             	add    $0x1,%edx
     bf5:	eb cb                	jmp    bc2 <atoo+0x2d>
  while('0' <= *s && *s <= '7')
     bf7:	b8 00 00 00 00       	mov    $0x0,%eax
     bfc:	eb e8                	jmp    be6 <atoo+0x51>

00000bfe <memmove>:
}
#endif // PDX_XV6

void*
memmove(void *vdst, void *vsrc, int n)
{
     bfe:	55                   	push   %ebp
     bff:	89 e5                	mov    %esp,%ebp
     c01:	56                   	push   %esi
     c02:	53                   	push   %ebx
     c03:	8b 45 08             	mov    0x8(%ebp),%eax
     c06:	8b 75 0c             	mov    0xc(%ebp),%esi
     c09:	8b 5d 10             	mov    0x10(%ebp),%ebx
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     c0c:	85 db                	test   %ebx,%ebx
     c0e:	7e 13                	jle    c23 <memmove+0x25>
     c10:	ba 00 00 00 00       	mov    $0x0,%edx
    *dst++ = *src++;
     c15:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
     c19:	88 0c 10             	mov    %cl,(%eax,%edx,1)
     c1c:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
     c1f:	39 d3                	cmp    %edx,%ebx
     c21:	75 f2                	jne    c15 <memmove+0x17>
  return vdst;
}
     c23:	5b                   	pop    %ebx
     c24:	5e                   	pop    %esi
     c25:	5d                   	pop    %ebp
     c26:	c3                   	ret    

00000c27 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     c27:	b8 01 00 00 00       	mov    $0x1,%eax
     c2c:	cd 40                	int    $0x40
     c2e:	c3                   	ret    

00000c2f <exit>:
SYSCALL(exit)
     c2f:	b8 02 00 00 00       	mov    $0x2,%eax
     c34:	cd 40                	int    $0x40
     c36:	c3                   	ret    

00000c37 <wait>:
SYSCALL(wait)
     c37:	b8 03 00 00 00       	mov    $0x3,%eax
     c3c:	cd 40                	int    $0x40
     c3e:	c3                   	ret    

00000c3f <pipe>:
SYSCALL(pipe)
     c3f:	b8 04 00 00 00       	mov    $0x4,%eax
     c44:	cd 40                	int    $0x40
     c46:	c3                   	ret    

00000c47 <read>:
SYSCALL(read)
     c47:	b8 05 00 00 00       	mov    $0x5,%eax
     c4c:	cd 40                	int    $0x40
     c4e:	c3                   	ret    

00000c4f <write>:
SYSCALL(write)
     c4f:	b8 10 00 00 00       	mov    $0x10,%eax
     c54:	cd 40                	int    $0x40
     c56:	c3                   	ret    

00000c57 <close>:
SYSCALL(close)
     c57:	b8 15 00 00 00       	mov    $0x15,%eax
     c5c:	cd 40                	int    $0x40
     c5e:	c3                   	ret    

00000c5f <kill>:
SYSCALL(kill)
     c5f:	b8 06 00 00 00       	mov    $0x6,%eax
     c64:	cd 40                	int    $0x40
     c66:	c3                   	ret    

00000c67 <exec>:
SYSCALL(exec)
     c67:	b8 07 00 00 00       	mov    $0x7,%eax
     c6c:	cd 40                	int    $0x40
     c6e:	c3                   	ret    

00000c6f <open>:
SYSCALL(open)
     c6f:	b8 0f 00 00 00       	mov    $0xf,%eax
     c74:	cd 40                	int    $0x40
     c76:	c3                   	ret    

00000c77 <mknod>:
SYSCALL(mknod)
     c77:	b8 11 00 00 00       	mov    $0x11,%eax
     c7c:	cd 40                	int    $0x40
     c7e:	c3                   	ret    

00000c7f <unlink>:
SYSCALL(unlink)
     c7f:	b8 12 00 00 00       	mov    $0x12,%eax
     c84:	cd 40                	int    $0x40
     c86:	c3                   	ret    

00000c87 <fstat>:
SYSCALL(fstat)
     c87:	b8 08 00 00 00       	mov    $0x8,%eax
     c8c:	cd 40                	int    $0x40
     c8e:	c3                   	ret    

00000c8f <link>:
SYSCALL(link)
     c8f:	b8 13 00 00 00       	mov    $0x13,%eax
     c94:	cd 40                	int    $0x40
     c96:	c3                   	ret    

00000c97 <mkdir>:
SYSCALL(mkdir)
     c97:	b8 14 00 00 00       	mov    $0x14,%eax
     c9c:	cd 40                	int    $0x40
     c9e:	c3                   	ret    

00000c9f <chdir>:
SYSCALL(chdir)
     c9f:	b8 09 00 00 00       	mov    $0x9,%eax
     ca4:	cd 40                	int    $0x40
     ca6:	c3                   	ret    

00000ca7 <dup>:
SYSCALL(dup)
     ca7:	b8 0a 00 00 00       	mov    $0xa,%eax
     cac:	cd 40                	int    $0x40
     cae:	c3                   	ret    

00000caf <getpid>:
SYSCALL(getpid)
     caf:	b8 0b 00 00 00       	mov    $0xb,%eax
     cb4:	cd 40                	int    $0x40
     cb6:	c3                   	ret    

00000cb7 <sbrk>:
SYSCALL(sbrk)
     cb7:	b8 0c 00 00 00       	mov    $0xc,%eax
     cbc:	cd 40                	int    $0x40
     cbe:	c3                   	ret    

00000cbf <sleep>:
SYSCALL(sleep)
     cbf:	b8 0d 00 00 00       	mov    $0xd,%eax
     cc4:	cd 40                	int    $0x40
     cc6:	c3                   	ret    

00000cc7 <uptime>:
SYSCALL(uptime)
     cc7:	b8 0e 00 00 00       	mov    $0xe,%eax
     ccc:	cd 40                	int    $0x40
     cce:	c3                   	ret    

00000ccf <halt>:
SYSCALL(halt)
     ccf:	b8 16 00 00 00       	mov    $0x16,%eax
     cd4:	cd 40                	int    $0x40
     cd6:	c3                   	ret    

00000cd7 <date>:
SYSCALL(date)
     cd7:	b8 17 00 00 00       	mov    $0x17,%eax
     cdc:	cd 40                	int    $0x40
     cde:	c3                   	ret    

00000cdf <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     cdf:	55                   	push   %ebp
     ce0:	89 e5                	mov    %esp,%ebp
     ce2:	57                   	push   %edi
     ce3:	56                   	push   %esi
     ce4:	53                   	push   %ebx
     ce5:	83 ec 3c             	sub    $0x3c,%esp
     ce8:	89 c6                	mov    %eax,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     cea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     cee:	74 14                	je     d04 <printint+0x25>
     cf0:	85 d2                	test   %edx,%edx
     cf2:	79 10                	jns    d04 <printint+0x25>
    neg = 1;
    x = -xx;
     cf4:	f7 da                	neg    %edx
    neg = 1;
     cf6:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
     cfd:	bf 00 00 00 00       	mov    $0x0,%edi
     d02:	eb 0b                	jmp    d0f <printint+0x30>
  neg = 0;
     d04:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
     d0b:	eb f0                	jmp    cfd <printint+0x1e>
  do{
    buf[i++] = digits[x % base];
     d0d:	89 df                	mov    %ebx,%edi
     d0f:	8d 5f 01             	lea    0x1(%edi),%ebx
     d12:	89 d0                	mov    %edx,%eax
     d14:	ba 00 00 00 00       	mov    $0x0,%edx
     d19:	f7 f1                	div    %ecx
     d1b:	0f b6 92 70 11 00 00 	movzbl 0x1170(%edx),%edx
     d22:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
     d26:	89 c2                	mov    %eax,%edx
     d28:	85 c0                	test   %eax,%eax
     d2a:	75 e1                	jne    d0d <printint+0x2e>
  if(neg)
     d2c:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
     d30:	74 08                	je     d3a <printint+0x5b>
    buf[i++] = '-';
     d32:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
     d37:	8d 5f 02             	lea    0x2(%edi),%ebx

  while(--i >= 0)
     d3a:	83 eb 01             	sub    $0x1,%ebx
     d3d:	78 22                	js     d61 <printint+0x82>
  write(fd, &c, 1);
     d3f:	8d 7d d7             	lea    -0x29(%ebp),%edi
     d42:	0f b6 44 1d d8       	movzbl -0x28(%ebp,%ebx,1),%eax
     d47:	88 45 d7             	mov    %al,-0x29(%ebp)
     d4a:	83 ec 04             	sub    $0x4,%esp
     d4d:	6a 01                	push   $0x1
     d4f:	57                   	push   %edi
     d50:	56                   	push   %esi
     d51:	e8 f9 fe ff ff       	call   c4f <write>
  while(--i >= 0)
     d56:	83 eb 01             	sub    $0x1,%ebx
     d59:	83 c4 10             	add    $0x10,%esp
     d5c:	83 fb ff             	cmp    $0xffffffff,%ebx
     d5f:	75 e1                	jne    d42 <printint+0x63>
    putc(fd, buf[i]);
}
     d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d64:	5b                   	pop    %ebx
     d65:	5e                   	pop    %esi
     d66:	5f                   	pop    %edi
     d67:	5d                   	pop    %ebp
     d68:	c3                   	ret    

00000d69 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     d69:	55                   	push   %ebp
     d6a:	89 e5                	mov    %esp,%ebp
     d6c:	57                   	push   %edi
     d6d:	56                   	push   %esi
     d6e:	53                   	push   %ebx
     d6f:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     d72:	8b 75 0c             	mov    0xc(%ebp),%esi
     d75:	0f b6 1e             	movzbl (%esi),%ebx
     d78:	84 db                	test   %bl,%bl
     d7a:	0f 84 b1 01 00 00    	je     f31 <printf+0x1c8>
     d80:	83 c6 01             	add    $0x1,%esi
  ap = (uint*)(void*)&fmt + 1;
     d83:	8d 45 10             	lea    0x10(%ebp),%eax
     d86:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  state = 0;
     d89:	bf 00 00 00 00       	mov    $0x0,%edi
     d8e:	eb 2d                	jmp    dbd <printf+0x54>
     d90:	88 5d e2             	mov    %bl,-0x1e(%ebp)
  write(fd, &c, 1);
     d93:	83 ec 04             	sub    $0x4,%esp
     d96:	6a 01                	push   $0x1
     d98:	8d 45 e2             	lea    -0x1e(%ebp),%eax
     d9b:	50                   	push   %eax
     d9c:	ff 75 08             	pushl  0x8(%ebp)
     d9f:	e8 ab fe ff ff       	call   c4f <write>
     da4:	83 c4 10             	add    $0x10,%esp
     da7:	eb 05                	jmp    dae <printf+0x45>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     da9:	83 ff 25             	cmp    $0x25,%edi
     dac:	74 22                	je     dd0 <printf+0x67>
     dae:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
     db1:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
     db5:	84 db                	test   %bl,%bl
     db7:	0f 84 74 01 00 00    	je     f31 <printf+0x1c8>
    c = fmt[i] & 0xff;
     dbd:	0f be d3             	movsbl %bl,%edx
     dc0:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
     dc3:	85 ff                	test   %edi,%edi
     dc5:	75 e2                	jne    da9 <printf+0x40>
      if(c == '%'){
     dc7:	83 f8 25             	cmp    $0x25,%eax
     dca:	75 c4                	jne    d90 <printf+0x27>
        state = '%';
     dcc:	89 c7                	mov    %eax,%edi
     dce:	eb de                	jmp    dae <printf+0x45>
      if(c == 'd'){
     dd0:	83 f8 64             	cmp    $0x64,%eax
     dd3:	74 59                	je     e2e <printf+0xc5>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
     dd5:	81 e2 f7 00 00 00    	and    $0xf7,%edx
     ddb:	83 fa 70             	cmp    $0x70,%edx
     dde:	74 7a                	je     e5a <printf+0xf1>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
     de0:	83 f8 73             	cmp    $0x73,%eax
     de3:	0f 84 9d 00 00 00    	je     e86 <printf+0x11d>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     de9:	83 f8 63             	cmp    $0x63,%eax
     dec:	0f 84 f2 00 00 00    	je     ee4 <printf+0x17b>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
     df2:	83 f8 25             	cmp    $0x25,%eax
     df5:	0f 84 15 01 00 00    	je     f10 <printf+0x1a7>
     dfb:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
  write(fd, &c, 1);
     dff:	83 ec 04             	sub    $0x4,%esp
     e02:	6a 01                	push   $0x1
     e04:	8d 45 e7             	lea    -0x19(%ebp),%eax
     e07:	50                   	push   %eax
     e08:	ff 75 08             	pushl  0x8(%ebp)
     e0b:	e8 3f fe ff ff       	call   c4f <write>
     e10:	88 5d e6             	mov    %bl,-0x1a(%ebp)
     e13:	83 c4 0c             	add    $0xc,%esp
     e16:	6a 01                	push   $0x1
     e18:	8d 45 e6             	lea    -0x1a(%ebp),%eax
     e1b:	50                   	push   %eax
     e1c:	ff 75 08             	pushl  0x8(%ebp)
     e1f:	e8 2b fe ff ff       	call   c4f <write>
     e24:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     e27:	bf 00 00 00 00       	mov    $0x0,%edi
     e2c:	eb 80                	jmp    dae <printf+0x45>
        printint(fd, *ap, 10, 1);
     e2e:	83 ec 0c             	sub    $0xc,%esp
     e31:	6a 01                	push   $0x1
     e33:	b9 0a 00 00 00       	mov    $0xa,%ecx
     e38:	8b 7d d4             	mov    -0x2c(%ebp),%edi
     e3b:	8b 17                	mov    (%edi),%edx
     e3d:	8b 45 08             	mov    0x8(%ebp),%eax
     e40:	e8 9a fe ff ff       	call   cdf <printint>
        ap++;
     e45:	89 f8                	mov    %edi,%eax
     e47:	83 c0 04             	add    $0x4,%eax
     e4a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     e4d:	83 c4 10             	add    $0x10,%esp
      state = 0;
     e50:	bf 00 00 00 00       	mov    $0x0,%edi
     e55:	e9 54 ff ff ff       	jmp    dae <printf+0x45>
        printint(fd, *ap, 16, 0);
     e5a:	83 ec 0c             	sub    $0xc,%esp
     e5d:	6a 00                	push   $0x0
     e5f:	b9 10 00 00 00       	mov    $0x10,%ecx
     e64:	8b 7d d4             	mov    -0x2c(%ebp),%edi
     e67:	8b 17                	mov    (%edi),%edx
     e69:	8b 45 08             	mov    0x8(%ebp),%eax
     e6c:	e8 6e fe ff ff       	call   cdf <printint>
        ap++;
     e71:	89 f8                	mov    %edi,%eax
     e73:	83 c0 04             	add    $0x4,%eax
     e76:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     e79:	83 c4 10             	add    $0x10,%esp
      state = 0;
     e7c:	bf 00 00 00 00       	mov    $0x0,%edi
     e81:	e9 28 ff ff ff       	jmp    dae <printf+0x45>
        s = (char*)*ap;
     e86:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
     e89:	8b 01                	mov    (%ecx),%eax
        ap++;
     e8b:	83 c1 04             	add    $0x4,%ecx
     e8e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
        if(s == 0)
     e91:	85 c0                	test   %eax,%eax
     e93:	74 13                	je     ea8 <printf+0x13f>
        s = (char*)*ap;
     e95:	89 c3                	mov    %eax,%ebx
        while(*s != 0){
     e97:	0f b6 00             	movzbl (%eax),%eax
      state = 0;
     e9a:	bf 00 00 00 00       	mov    $0x0,%edi
        while(*s != 0){
     e9f:	84 c0                	test   %al,%al
     ea1:	75 0f                	jne    eb2 <printf+0x149>
     ea3:	e9 06 ff ff ff       	jmp    dae <printf+0x45>
          s = "(null)";
     ea8:	bb 68 11 00 00       	mov    $0x1168,%ebx
        while(*s != 0){
     ead:	b8 28 00 00 00       	mov    $0x28,%eax
  write(fd, &c, 1);
     eb2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
     eb5:	89 75 d0             	mov    %esi,-0x30(%ebp)
     eb8:	8b 75 08             	mov    0x8(%ebp),%esi
     ebb:	88 45 e3             	mov    %al,-0x1d(%ebp)
     ebe:	83 ec 04             	sub    $0x4,%esp
     ec1:	6a 01                	push   $0x1
     ec3:	57                   	push   %edi
     ec4:	56                   	push   %esi
     ec5:	e8 85 fd ff ff       	call   c4f <write>
          s++;
     eca:	83 c3 01             	add    $0x1,%ebx
        while(*s != 0){
     ecd:	0f b6 03             	movzbl (%ebx),%eax
     ed0:	83 c4 10             	add    $0x10,%esp
     ed3:	84 c0                	test   %al,%al
     ed5:	75 e4                	jne    ebb <printf+0x152>
     ed7:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
     eda:	bf 00 00 00 00       	mov    $0x0,%edi
     edf:	e9 ca fe ff ff       	jmp    dae <printf+0x45>
        putc(fd, *ap);
     ee4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
     ee7:	8b 07                	mov    (%edi),%eax
     ee9:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
     eec:	83 ec 04             	sub    $0x4,%esp
     eef:	6a 01                	push   $0x1
     ef1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     ef4:	50                   	push   %eax
     ef5:	ff 75 08             	pushl  0x8(%ebp)
     ef8:	e8 52 fd ff ff       	call   c4f <write>
        ap++;
     efd:	83 c7 04             	add    $0x4,%edi
     f00:	89 7d d4             	mov    %edi,-0x2c(%ebp)
     f03:	83 c4 10             	add    $0x10,%esp
      state = 0;
     f06:	bf 00 00 00 00       	mov    $0x0,%edi
     f0b:	e9 9e fe ff ff       	jmp    dae <printf+0x45>
     f10:	88 5d e5             	mov    %bl,-0x1b(%ebp)
  write(fd, &c, 1);
     f13:	83 ec 04             	sub    $0x4,%esp
     f16:	6a 01                	push   $0x1
     f18:	8d 45 e5             	lea    -0x1b(%ebp),%eax
     f1b:	50                   	push   %eax
     f1c:	ff 75 08             	pushl  0x8(%ebp)
     f1f:	e8 2b fd ff ff       	call   c4f <write>
     f24:	83 c4 10             	add    $0x10,%esp
      state = 0;
     f27:	bf 00 00 00 00       	mov    $0x0,%edi
     f2c:	e9 7d fe ff ff       	jmp    dae <printf+0x45>
    }
  }
}
     f31:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f34:	5b                   	pop    %ebx
     f35:	5e                   	pop    %esi
     f36:	5f                   	pop    %edi
     f37:	5d                   	pop    %ebp
     f38:	c3                   	ret    

00000f39 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     f39:	55                   	push   %ebp
     f3a:	89 e5                	mov    %esp,%ebp
     f3c:	57                   	push   %edi
     f3d:	56                   	push   %esi
     f3e:	53                   	push   %ebx
     f3f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
     f42:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f45:	a1 64 17 00 00       	mov    0x1764,%eax
     f4a:	eb 0c                	jmp    f58 <free+0x1f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f4c:	8b 10                	mov    (%eax),%edx
     f4e:	39 c2                	cmp    %eax,%edx
     f50:	77 04                	ja     f56 <free+0x1d>
     f52:	39 ca                	cmp    %ecx,%edx
     f54:	77 10                	ja     f66 <free+0x2d>
{
     f56:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f58:	39 c8                	cmp    %ecx,%eax
     f5a:	73 f0                	jae    f4c <free+0x13>
     f5c:	8b 10                	mov    (%eax),%edx
     f5e:	39 ca                	cmp    %ecx,%edx
     f60:	77 04                	ja     f66 <free+0x2d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f62:	39 c2                	cmp    %eax,%edx
     f64:	77 f0                	ja     f56 <free+0x1d>
      break;
  if(bp + bp->s.size == p->s.ptr){
     f66:	8b 73 fc             	mov    -0x4(%ebx),%esi
     f69:	8b 10                	mov    (%eax),%edx
     f6b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
     f6e:	39 fa                	cmp    %edi,%edx
     f70:	74 19                	je     f8b <free+0x52>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
     f72:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
     f75:	8b 50 04             	mov    0x4(%eax),%edx
     f78:	8d 34 d0             	lea    (%eax,%edx,8),%esi
     f7b:	39 f1                	cmp    %esi,%ecx
     f7d:	74 1b                	je     f9a <free+0x61>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
     f7f:	89 08                	mov    %ecx,(%eax)
  freep = p;
     f81:	a3 64 17 00 00       	mov    %eax,0x1764
}
     f86:	5b                   	pop    %ebx
     f87:	5e                   	pop    %esi
     f88:	5f                   	pop    %edi
     f89:	5d                   	pop    %ebp
     f8a:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
     f8b:	03 72 04             	add    0x4(%edx),%esi
     f8e:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
     f91:	8b 10                	mov    (%eax),%edx
     f93:	8b 12                	mov    (%edx),%edx
     f95:	89 53 f8             	mov    %edx,-0x8(%ebx)
     f98:	eb db                	jmp    f75 <free+0x3c>
    p->s.size += bp->s.size;
     f9a:	03 53 fc             	add    -0x4(%ebx),%edx
     f9d:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     fa0:	8b 53 f8             	mov    -0x8(%ebx),%edx
     fa3:	89 10                	mov    %edx,(%eax)
     fa5:	eb da                	jmp    f81 <free+0x48>

00000fa7 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     fa7:	55                   	push   %ebp
     fa8:	89 e5                	mov    %esp,%ebp
     faa:	57                   	push   %edi
     fab:	56                   	push   %esi
     fac:	53                   	push   %ebx
     fad:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     fb0:	8b 45 08             	mov    0x8(%ebp),%eax
     fb3:	8d 58 07             	lea    0x7(%eax),%ebx
     fb6:	c1 eb 03             	shr    $0x3,%ebx
     fb9:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
     fbc:	8b 15 64 17 00 00    	mov    0x1764,%edx
     fc2:	85 d2                	test   %edx,%edx
     fc4:	74 20                	je     fe6 <malloc+0x3f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fc6:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
     fc8:	8b 48 04             	mov    0x4(%eax),%ecx
     fcb:	39 cb                	cmp    %ecx,%ebx
     fcd:	76 3c                	jbe    100b <malloc+0x64>
     fcf:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
     fd5:	be 00 10 00 00       	mov    $0x1000,%esi
     fda:	0f 43 f3             	cmovae %ebx,%esi
  p = sbrk(nu * sizeof(Header));
     fdd:	8d 3c f5 00 00 00 00 	lea    0x0(,%esi,8),%edi
     fe4:	eb 70                	jmp    1056 <malloc+0xaf>
    base.s.ptr = freep = prevp = &base;
     fe6:	c7 05 64 17 00 00 68 	movl   $0x1768,0x1764
     fed:	17 00 00 
     ff0:	c7 05 68 17 00 00 68 	movl   $0x1768,0x1768
     ff7:	17 00 00 
    base.s.size = 0;
     ffa:	c7 05 6c 17 00 00 00 	movl   $0x0,0x176c
    1001:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    1004:	ba 68 17 00 00       	mov    $0x1768,%edx
    1009:	eb bb                	jmp    fc6 <malloc+0x1f>
      if(p->s.size == nunits)
    100b:	39 cb                	cmp    %ecx,%ebx
    100d:	74 1c                	je     102b <malloc+0x84>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    100f:	29 d9                	sub    %ebx,%ecx
    1011:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1014:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    1017:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    101a:	89 15 64 17 00 00    	mov    %edx,0x1764
      return (void*)(p + 1);
    1020:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1023:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1026:	5b                   	pop    %ebx
    1027:	5e                   	pop    %esi
    1028:	5f                   	pop    %edi
    1029:	5d                   	pop    %ebp
    102a:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    102b:	8b 08                	mov    (%eax),%ecx
    102d:	89 0a                	mov    %ecx,(%edx)
    102f:	eb e9                	jmp    101a <malloc+0x73>
  hp->s.size = nu;
    1031:	89 70 04             	mov    %esi,0x4(%eax)
  free((void*)(hp + 1));
    1034:	83 ec 0c             	sub    $0xc,%esp
    1037:	83 c0 08             	add    $0x8,%eax
    103a:	50                   	push   %eax
    103b:	e8 f9 fe ff ff       	call   f39 <free>
  return freep;
    1040:	8b 15 64 17 00 00    	mov    0x1764,%edx
      if((p = morecore(nunits)) == 0)
    1046:	83 c4 10             	add    $0x10,%esp
    1049:	85 d2                	test   %edx,%edx
    104b:	74 2b                	je     1078 <malloc+0xd1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    104d:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    104f:	8b 48 04             	mov    0x4(%eax),%ecx
    1052:	39 d9                	cmp    %ebx,%ecx
    1054:	73 b5                	jae    100b <malloc+0x64>
    1056:	89 c2                	mov    %eax,%edx
    if(p == freep)
    1058:	39 05 64 17 00 00    	cmp    %eax,0x1764
    105e:	75 ed                	jne    104d <malloc+0xa6>
  p = sbrk(nu * sizeof(Header));
    1060:	83 ec 0c             	sub    $0xc,%esp
    1063:	57                   	push   %edi
    1064:	e8 4e fc ff ff       	call   cb7 <sbrk>
  if(p == (char*)-1)
    1069:	83 c4 10             	add    $0x10,%esp
    106c:	83 f8 ff             	cmp    $0xffffffff,%eax
    106f:	75 c0                	jne    1031 <malloc+0x8a>
        return 0;
    1071:	b8 00 00 00 00       	mov    $0x0,%eax
    1076:	eb ab                	jmp    1023 <malloc+0x7c>
    1078:	b8 00 00 00 00       	mov    $0x0,%eax
    107d:	eb a4                	jmp    1023 <malloc+0x7c>
