
.globl main
main: 
pushl %ebp 
movl %esp, %ebp 
subl $16, %esp 
pushl %ebx 
pushl %esi
pushl %edi
    
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl $1 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
call create_list
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
call inject_big
movl %eax, -8(%ebp) 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl %edi 
pushl %ebx 
pushl -8(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
movl -8(%ebp), %eax 
movl %eax, -8(%ebp) 
pushl $0 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call create_list
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call inject_big
movl %eax, -12(%ebp) 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl -8(%ebp) 
pushl %edi 
pushl -12(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
movl -12(%ebp), %eax 
pushl %eax 
pushl $__func1 
call create_closure
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl %ebx 
pushl -8(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call create_list
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call inject_big
movl %eax, %ebx 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl -8(%ebp) 
pushl %edi 
pushl %ebx 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
movl %ebx, %eax 
pushl %eax 
pushl $__func2 
call create_closure
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, %ebx 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, -8(%ebp) 
addl $4, %esp 
pushl %ebx 
call get_fun_ptr
movl %eax, -12(%ebp) 
addl $4, %esp 
pushl %ebx 
call get_free_vars
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl -8(%ebp) 
call *-12(%ebp)
movl %eax, -12(%ebp) 
addl $8, %esp 
pushl $25 
call inject_int
movl %eax, -16(%ebp) 
addl $4, %esp 
pushl -12(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else0 
if0: 
pushl -16(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else1 
if1: 
movl -12(%ebp), %ecx 
movl -16(%ebp), %eax 
cmpl %ecx, %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif1 
else1: 
endif1: 
pushl -16(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else2 
if2: 
pushl -12(%ebp) 
call project_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl -16(%ebp) 
call project_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl -4(%ebp), %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif2 
else2: 
endif2: 
pushl -16(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else3 
if3: 
pushl $1 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif3 
else3: 
endif3: 
jmp endif0 
else0: 
pushl -12(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else4 
if4: 
pushl -16(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else5 
if5: 
pushl -12(%ebp) 
call project_bool
movl %eax, %edi 
addl $4, %esp 
pushl -16(%ebp) 
call project_int
movl %eax, -4(%ebp) 
addl $4, %esp 
movl -4(%ebp), %eax 
cmpl %edi, %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif5 
else5: 
endif5: 
pushl -16(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else6 
if6: 
movl -12(%ebp), %ecx 
movl -16(%ebp), %eax 
cmpl %ecx, %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif6 
else6: 
endif6: 
pushl -16(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else7 
if7: 
pushl $1 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif7 
else7: 
endif7: 
jmp endif4 
else4: 
pushl -12(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else8 
if8: 
pushl -16(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else9 
if9: 
pushl $1 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif9 
else9: 
endif9: 
pushl -16(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else10 
if10: 
pushl $1 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif10 
else10: 
endif10: 
pushl -16(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else11 
if11: 
pushl -12(%ebp) 
call project_big
movl %eax, %edi 
addl $4, %esp 
pushl -16(%ebp) 
call project_big
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl -4(%ebp) 
pushl %edi 
call not_equal
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif11 
else11: 
endif11: 
jmp endif8 
else8: 
endif8: 
endif4: 
endif0: 
movl -4(%ebp), %eax 
pushl %eax 
call is_true
movl %eax, %edi 
addl $4, %esp 
while0: 
movl %edi, %eax 
cmpl $0, %eax 
je endwhile0
loop0: 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl -8(%ebp) 
call project_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl %edi 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
addl -4(%ebp), %eax 
pushl %eax 
call inject_int
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
movl %eax, -8(%ebp) 
pushl %ebx 
call get_fun_ptr
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl %ebx 
call get_free_vars
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl -8(%ebp) 
call *-4(%ebp)
movl %eax, -12(%ebp) 
addl $8, %esp 
pushl $25 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl -12(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else12 
if12: 
pushl -4(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else13 
if13: 
movl -12(%ebp), %ecx 
movl -4(%ebp), %eax 
cmpl %ecx, %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, %esi 
addl $4, %esp 
jmp endif13 
else13: 
endif13: 
pushl -4(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else14 
if14: 
pushl -12(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
pushl -4(%ebp) 
call project_bool
movl %eax, %esi 
addl $4, %esp 
movl %esi, %eax 
cmpl %edi, %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, %esi 
addl $4, %esp 
jmp endif14 
else14: 
endif14: 
pushl -4(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else15 
if15: 
pushl $1 
call inject_bool
movl %eax, %esi 
addl $4, %esp 
jmp endif15 
else15: 
endif15: 
jmp endif12 
else12: 
pushl -12(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else16 
if16: 
pushl -4(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else17 
if17: 
pushl -12(%ebp) 
call project_bool
movl %eax, %esi 
addl $4, %esp 
pushl -4(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl %esi, %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, %esi 
addl $4, %esp 
jmp endif17 
else17: 
endif17: 
pushl -4(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else18 
if18: 
movl -12(%ebp), %ecx 
movl -4(%ebp), %eax 
cmpl %ecx, %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, %esi 
addl $4, %esp 
jmp endif18 
else18: 
endif18: 
pushl -4(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else19 
if19: 
pushl $1 
call inject_bool
movl %eax, %esi 
addl $4, %esp 
jmp endif19 
else19: 
endif19: 
jmp endif16 
else16: 
pushl -12(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else20 
if20: 
pushl -4(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else21 
if21: 
pushl $1 
call inject_bool
movl %eax, %esi 
addl $4, %esp 
jmp endif21 
else21: 
endif21: 
pushl -4(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else22 
if22: 
pushl $1 
call inject_bool
movl %eax, %esi 
addl $4, %esp 
jmp endif22 
else22: 
endif22: 
pushl -4(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else23 
if23: 
pushl -12(%ebp) 
call project_big
movl %eax, %edi 
addl $4, %esp 
pushl -4(%ebp) 
call project_big
movl %eax, %esi 
addl $4, %esp 
pushl %esi 
pushl %edi 
call not_equal
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_bool
movl %eax, %esi 
addl $4, %esp 
jmp endif23 
else23: 
endif23: 
jmp endif20 
else20: 
endif20: 
endif16: 
endif12: 
pushl %esi 
call is_true
movl %eax, %edi 
addl $4, %esp 
jmp while0 
endwhile0: 
popl %edi 
popl %esi
popl %ebx
movl $0, %eax 
movl %ebp, %esp 
popl %ebp 
ret


__func1: 
pushl %ebp 
movl %esp, %ebp 
subl $12, %esp 
pushl %ebx 
pushl %esi
pushl %edi
    
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl 12(%ebp) 
call is_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else100 
if100: 
pushl %edi 
call is_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else101 
if101: 
movl %edi, %eax 
cmpl 12(%ebp), %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -8(%ebp) 
addl $4, %esp 
jmp endif101 
else101: 
endif101: 
pushl %edi 
call is_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else102 
if102: 
pushl 12(%ebp) 
call project_int
movl %eax, %ebx 
addl $4, %esp 
pushl %edi 
call project_bool
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl %ebx, %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -8(%ebp) 
addl $4, %esp 
jmp endif102 
else102: 
endif102: 
pushl %edi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else103 
if103: 
pushl $0 
call inject_bool
movl %eax, -8(%ebp) 
addl $4, %esp 
jmp endif103 
else103: 
endif103: 
jmp endif100 
else100: 
pushl 12(%ebp) 
call is_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else104 
if104: 
pushl %edi 
call is_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else105 
if105: 
pushl 12(%ebp) 
call project_bool
movl %eax, %ebx 
addl $4, %esp 
pushl %edi 
call project_int
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl %ebx, %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -8(%ebp) 
addl $4, %esp 
jmp endif105 
else105: 
endif105: 
pushl %edi 
call is_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else106 
if106: 
movl %edi, %eax 
cmpl 12(%ebp), %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -8(%ebp) 
addl $4, %esp 
jmp endif106 
else106: 
endif106: 
pushl %edi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else107 
if107: 
pushl $0 
call inject_bool
movl %eax, -8(%ebp) 
addl $4, %esp 
jmp endif107 
else107: 
endif107: 
jmp endif104 
else104: 
pushl 12(%ebp) 
call is_big
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else108 
if108: 
pushl %edi 
call is_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else109 
if109: 
pushl $0 
call inject_bool
movl %eax, -8(%ebp) 
addl $4, %esp 
jmp endif109 
else109: 
endif109: 
pushl %edi 
call is_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else110 
if110: 
pushl $0 
call inject_bool
movl %eax, -8(%ebp) 
addl $4, %esp 
jmp endif110 
else110: 
endif110: 
pushl %edi 
call is_big
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else111 
if111: 
pushl 12(%ebp) 
call project_big
movl %eax, %ebx 
addl $4, %esp 
pushl %edi 
call project_big
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl %ebx 
call equal
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_bool
movl %eax, -8(%ebp) 
addl $4, %esp 
jmp endif111 
else111: 
endif111: 
jmp endif108 
else108: 
endif108: 
endif104: 
endif100: 
movl -8(%ebp), %eax 
movl %eax, -8(%ebp) 
pushl -8(%ebp) 
call is_true
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else112 
if112: 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
jmp endif112 
else112: 
pushl $0 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %ebx 
pushl 16(%ebp) 
call get_subscript
movl %eax, %ebx 
addl $8, %esp 
pushl %edi 
pushl %ebx 
call get_subscript
movl %eax, -12(%ebp) 
addl $8, %esp 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
negl %eax 
movl %eax, %edi 
pushl $0 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, -8(%ebp) 
addl $4, %esp 
pushl %ebx 
pushl 16(%ebp) 
call get_subscript
movl %eax, %ebx 
addl $8, %esp 
pushl -8(%ebp) 
pushl %ebx 
call get_subscript
movl %eax, %ebx 
addl $8, %esp 
pushl -12(%ebp) 
call get_fun_ptr
movl %eax, -12(%ebp) 
addl $4, %esp 
pushl 12(%ebp) 
call is_int
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl $0, %eax 
je else113 
if113: 
pushl %edi 
call is_int
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl $0, %eax 
je else114 
if114: 
pushl 12(%ebp) 
call project_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl %edi 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
addl -4(%ebp), %eax 
pushl %eax 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif114 
else114: 
pushl %edi 
call is_big
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl $0, %eax 
je else115 
if115: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif115 
else115: 
pushl %edi 
call is_bool
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl $0, %eax 
je else116 
if116: 
pushl 12(%ebp) 
call project_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl %edi 
call project_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
addl -4(%ebp), %eax 
pushl %eax 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif116 
else116: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif116: 
endif115: 
endif114: 
jmp endif113 
else113: 
pushl 12(%ebp) 
call is_big
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl $0, %eax 
je else117 
if117: 
pushl %edi 
call is_int
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl $0, %eax 
je else118 
if118: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif118 
else118: 
pushl %edi 
call is_big
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl $0, %eax 
je else119 
if119: 
pushl 12(%ebp) 
call project_big
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl %edi 
call project_big
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl -4(%ebp) 
call add
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif119 
else119: 
pushl %edi 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else120 
if120: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif120 
else120: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif120: 
endif119: 
endif118: 
jmp endif117 
else117: 
pushl 12(%ebp) 
call is_bool
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl $0, %eax 
je else121 
if121: 
pushl %edi 
call is_int
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl $0, %eax 
je else122 
if122: 
pushl 12(%ebp) 
call project_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl %edi 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
addl -4(%ebp), %eax 
pushl %eax 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif122 
else122: 
pushl %edi 
call is_big
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl $0, %eax 
je else123 
if123: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif123 
else123: 
pushl %edi 
call is_bool
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl $0, %eax 
je else124 
if124: 
pushl 12(%ebp) 
call project_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl %edi 
call project_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
addl -4(%ebp), %eax 
pushl %eax 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif124 
else124: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif124: 
endif123: 
endif122: 
jmp endif121 
else121: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif121: 
endif117: 
endif113: 
movl -4(%ebp), %eax 
movl %eax, -4(%ebp) 
pushl %ebx 
call get_free_vars
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl -4(%ebp) 
pushl 8(%ebp) 
call *-12(%ebp)
movl %eax, %ebx 
addl $12, %esp 
pushl 8(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else125 
if125: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else126 
if126: 
pushl 8(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
pushl %ebx 
call project_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, %esi 
addl $4, %esp 
jmp endif126 
else126: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else127 
if127: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif127 
else127: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else128 
if128: 
pushl 8(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
pushl %ebx 
call project_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, %esi 
addl $4, %esp 
jmp endif128 
else128: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif128: 
endif127: 
endif126: 
jmp endif125 
else125: 
pushl 8(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else129 
if129: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else130 
if130: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif130 
else130: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else131 
if131: 
pushl 8(%ebp) 
call project_big
movl %eax, %edi 
addl $4, %esp 
pushl %ebx 
call project_big
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
pushl %edi 
call add
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, %esi 
addl $4, %esp 
jmp endif131 
else131: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else132 
if132: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif132 
else132: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif132: 
endif131: 
endif130: 
jmp endif129 
else129: 
pushl 8(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else133 
if133: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else134 
if134: 
pushl 8(%ebp) 
call project_bool
movl %eax, %edi 
addl $4, %esp 
pushl %ebx 
call project_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, %esi 
addl $4, %esp 
jmp endif134 
else134: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else135 
if135: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif135 
else135: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else136 
if136: 
pushl 8(%ebp) 
call project_bool
movl %eax, %edi 
addl $4, %esp 
pushl %ebx 
call project_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
addl %edi, %eax 
pushl %eax 
call inject_bool
movl %eax, %esi 
addl $4, %esp 
jmp endif136 
else136: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif136: 
endif135: 
endif134: 
jmp endif133 
else133: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif133: 
endif129: 
endif125: 
movl %esi, %eax 
endif112: 
movl %eax, %eax

popl %edi 
popl %esi
popl %ebx
movl %ebp, %esp 
popl %ebp 
ret


__func2: 
pushl %ebp 
movl %esp, %ebp 
subl $0, %esp 
pushl %ebx 
pushl %esi
pushl %edi
    
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl %edi 
pushl 12(%ebp) 
call get_subscript
movl %eax, %edi 
addl $8, %esp 
pushl %ebx 
pushl %edi 
call get_subscript
movl %eax, %ebx 
addl $8, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %esi 
addl $4, %esp 
pushl %edi 
pushl 12(%ebp) 
call get_subscript
movl %eax, %edi 
addl $8, %esp 
pushl %esi 
pushl %edi 
call get_subscript
movl %eax, %edi 
addl $8, %esp 
pushl %ebx 
call get_fun_ptr
movl %eax, %ebx 
addl $4, %esp 
pushl %edi 
call get_free_vars
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl 8(%ebp) 
pushl 8(%ebp) 
call *%ebx
movl %eax, %edi 
addl $12, %esp 
movl %edi, %eax

popl %edi 
popl %esi
popl %ebx
movl %ebp, %esp 
popl %ebp 
ret

