.global crcInit
.global crcFast
.global getFromTable
.data
crcTable:
.rept 256
.byte 0
.byte 0
.endr
.text
crcInit:
//char remainder
movq $0,%rax
//int devidend
movq $0,%rcx
//char bit
movq $0,%rdx
movq $8,%rdx
//crctable[]
movq $crcTable,%r8
//POLYNOMIAL
movq $0xD5, %rsi
//using r11 and r9 for later comparisons.
movq $0,%r11
movq $256,%r11
movq $0,%r9
//using rdi to store address 0x80
movq $0, %rdi
movq $0x80, %rdi

jmp .L4
.L1:
movq %rcx,%rax
jmp .L3
.L2:
subq $1,(%rdx)
salq $1,%rax
movq %rax, %r10
movq %rdi, %r15
andq %r15,%r10
je .ELSE
jmp .L3
.ELSE:
xorq %rsi,%rax
.L3:
cmpq %r9,%rdx
jae .L2
addq $1,(%rcx)
mov %ax, (%r8,%rcx,1)
.L4:
movq $8,%rdx
cmpq %rcx,%r11
jbe .L1
ret


//%rdi = char* message, %rsi = long nBytes
crcFast:
//usnigned char data
movq $0, %rdx
//char remainder
movq $0, %rax
//long byte
movq $0, %rcx
//crcTable
movq $crcTable,%r8
jmp .L6
.L5:
movq %rax, %r10
xorq (%rdi,%rcx,1),%r10
movq %r10,%rdx
movq (%r8,%rcx,1),%rax
addq $1, %rcx
.L6:
movq %rsi,%r10
cmpq %rcx,%r10
jbe .L5

ret

getFromTable:

movq $crcTable, %rdx
movq $0 ,%rax
movq (%rdx,%rdi,1), %rax

ret
