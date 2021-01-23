	.globl	Main_main
Main_main:
	pushl	%ebp
	movl	%esp,%ebp
	subl	$4,%esp
	movl	$1,%eax
	movl	%eax,-4(%ebp)
	movl	$1,%ebx
	cmpl	%ebx,%eax
	jle	l2
	movl	$3,%eax
	movl	-4(%ebp),%ebx
	cmpl	%eax,%ebx
	jnz	l0
l2:
	movl	$0,%eax
	pushl	%eax
	call	print
	addl	$4,%esp
	jmp	l1
l0:
l1:
	movl	%ebp,%esp
	popl	%ebp
	ret
