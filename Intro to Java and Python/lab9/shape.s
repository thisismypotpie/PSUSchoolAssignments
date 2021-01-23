	.globl	Main_main
Main_main:
	pushl	%ebp
	movl	%esp,%ebp
	subl	$16,%esp
	movl	$0,%eax
	movl	%eax,-8(%ebp)
	movl	%eax,-4(%ebp)
	movl	$10,%eax
	movl	-4(%ebp),%ebx
	cmpl	%eax,%ebx
	jnl	l0
	movl	$2,%eax
	movl	-8(%ebp),%ebx
	addl	%ebx,%eax
	movl	%eax,-12(%ebp)
	movl	$1,%eax
	movl	-12(%ebp),%ebx
	cmpl	%eax,%ebx
	jnz	l2
	movl	$1,%eax
	movl	%eax,-16(%ebp)
	jmp	l3
l2:
	movl	$1,%eax
	movl	-12(%ebp),%ebx
	cmpl	%eax,%ebx
	jnl	l4
	movl	$1,%eax
	movl	%eax,-16(%ebp)
	jmp	l5
l4:
	movl	$1,%eax
	movl	%eax,-16(%ebp)
l5:
l3:
	jmp	l1
l0:
	movl	$0,%eax
	movl	-4(%ebp),%ebx
	cmpl	%eax,%ebx
	jnz	l6
	movl	$1,%eax
	movl	-8(%ebp),%ebx
	addl	%ebx,%eax
	movl	%eax,-12(%ebp)
	movl	$0,%eax
	movl	-12(%ebp),%ebx
	cmpl	%eax,%ebx
	jnz	l8
	movl	$1,%eax
	movl	%eax,-16(%ebp)
	jmp	l9
l8:
	movl	$0,%eax
	movl	-12(%ebp),%ebx
	cmpl	%eax,%ebx
	jnl	l10
	movl	$2,%eax
	movl	%eax,-16(%ebp)
	jmp	l11
l10:
	movl	$3,%eax
	movl	%eax,-16(%ebp)
l11:
l9:
	jmp	l7
l6:
l7:
l1:
	movl	%ebp,%esp
	popl	%ebp
	ret
