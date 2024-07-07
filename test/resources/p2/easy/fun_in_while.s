
.globl main
main: 
pushl %ebp 
movl %esp, %ebp 
subl $20, %esp 
pushl %ebx 
pushl %esi
pushl %edi
    
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
movl %eax, %esi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %ebx 
pushl %edi 
pushl %esi 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
movl %esi, -16(%ebp) 
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
movl %eax, %edi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %esi 
addl $4, %esp 
pushl %ebx 
pushl %esi 
pushl %edi 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
movl %edi, %esi 
pushl $2 
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
pushl %esi 
pushl %edi 
pushl %ebx 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl -16(%ebp) 
pushl %edi 
pushl %ebx 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
movl %ebx, %eax 
pushl %eax 
pushl $__func1 
call create_closure
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, -8(%ebp) 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
call create_list
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
call inject_big
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
pushl %eax 
pushl $__func2 
call create_closure
movl %eax, %ebx 
addl $8, %esp 
pushl %ebx 
call inject_big
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
pushl %edi 
pushl -16(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
call create_list
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
call inject_big
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
pushl %eax 
pushl $__func3 
call create_closure
movl %eax, %ebx 
addl $8, %esp 
pushl %ebx 
call inject_big
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
pushl %edi 
pushl %esi 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $5 
call inject_int
movl %eax, %esi 
addl $4, %esp 
pushl %esi 
call print_any 
addl $4, %esp 
pushl -8(%ebp) 
call get_fun_ptr
movl %eax, %ebx 
addl $4, %esp 
pushl -8(%ebp) 
call get_free_vars
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl %esi 
call *%ebx
movl %eax, -4(%ebp) 
addl $8, %esp 
pushl $10 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl -4(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else0 
if0: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else1 
if1: 
movl %ebx, %eax 
cmpl -4(%ebp), %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -12(%ebp) 
addl $4, %esp 
jmp endif1 
else1: 
endif1: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else2 
if2: 
pushl -4(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
pushl %ebx 
call project_bool
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
movl %eax, -12(%ebp) 
addl $4, %esp 
jmp endif2 
else2: 
endif2: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else3 
if3: 
pushl $1 
call inject_bool
movl %eax, -12(%ebp) 
addl $4, %esp 
jmp endif3 
else3: 
endif3: 
jmp endif0 
else0: 
pushl -4(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else4 
if4: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else5 
if5: 
pushl -4(%ebp) 
call project_bool
movl %eax, -12(%ebp) 
addl $4, %esp 
pushl %ebx 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl -12(%ebp), %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -12(%ebp) 
addl $4, %esp 
jmp endif5 
else5: 
endif5: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else6 
if6: 
movl %ebx, %eax 
cmpl -4(%ebp), %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -12(%ebp) 
addl $4, %esp 
jmp endif6 
else6: 
endif6: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else7 
if7: 
pushl $1 
call inject_bool
movl %eax, -12(%ebp) 
addl $4, %esp 
jmp endif7 
else7: 
endif7: 
jmp endif4 
else4: 
pushl -4(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else8 
if8: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else9 
if9: 
pushl $1 
call inject_bool
movl %eax, -12(%ebp) 
addl $4, %esp 
jmp endif9 
else9: 
endif9: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else10 
if10: 
pushl $1 
call inject_bool
movl %eax, -12(%ebp) 
addl $4, %esp 
jmp endif10 
else10: 
endif10: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else11 
if11: 
pushl -4(%ebp) 
call project_big
movl %eax, %edi 
addl $4, %esp 
pushl %ebx 
call project_big
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
pushl %edi 
call not_equal
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_bool
movl %eax, -12(%ebp) 
addl $4, %esp 
jmp endif11 
else11: 
endif11: 
jmp endif8 
else8: 
endif8: 
endif4: 
endif0: 
movl -12(%ebp), %eax 
pushl %eax 
call is_true
movl %eax, %edi 
addl $4, %esp 
while0: 
movl %edi, %eax 
cmpl $0, %eax 
je endwhile0
loop0: 
pushl %esi 
call print_any 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl -16(%ebp) 
call get_subscript
movl %eax, %ebx 
addl $8, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl -16(%ebp) 
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
pushl %esi 
call *%ebx
movl %eax, %esi 
addl $8, %esp 
pushl -8(%ebp) 
call get_fun_ptr
movl %eax, %ebx 
addl $4, %esp 
pushl -8(%ebp) 
call get_free_vars
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl %esi 
call *%ebx
movl %eax, -4(%ebp) 
addl $8, %esp 
pushl $10 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl -4(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else12 
if12: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else13 
if13: 
movl %ebx, %eax 
cmpl -4(%ebp), %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -20(%ebp) 
addl $4, %esp 
jmp endif13 
else13: 
endif13: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else14 
if14: 
pushl -4(%ebp) 
call project_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl %ebx 
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
movl %eax, -20(%ebp) 
addl $4, %esp 
jmp endif14 
else14: 
endif14: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else15 
if15: 
pushl $1 
call inject_bool
movl %eax, -20(%ebp) 
addl $4, %esp 
jmp endif15 
else15: 
endif15: 
jmp endif12 
else12: 
pushl -4(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else16 
if16: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else17 
if17: 
pushl -4(%ebp) 
call project_bool
movl %eax, -12(%ebp) 
addl $4, %esp 
pushl %ebx 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl -12(%ebp), %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -20(%ebp) 
addl $4, %esp 
jmp endif17 
else17: 
endif17: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else18 
if18: 
movl %ebx, %eax 
cmpl -4(%ebp), %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -20(%ebp) 
addl $4, %esp 
jmp endif18 
else18: 
endif18: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else19 
if19: 
pushl $1 
call inject_bool
movl %eax, -20(%ebp) 
addl $4, %esp 
jmp endif19 
else19: 
endif19: 
jmp endif16 
else16: 
pushl -4(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else20 
if20: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else21 
if21: 
pushl $1 
call inject_bool
movl %eax, -20(%ebp) 
addl $4, %esp 
jmp endif21 
else21: 
endif21: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else22 
if22: 
pushl $1 
call inject_bool
movl %eax, -20(%ebp) 
addl $4, %esp 
jmp endif22 
else22: 
endif22: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else23 
if23: 
pushl -4(%ebp) 
call project_big
movl %eax, %edi 
addl $4, %esp 
pushl %ebx 
call project_big
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
pushl %edi 
call not_equal
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_bool
movl %eax, -20(%ebp) 
addl $4, %esp 
jmp endif23 
else23: 
endif23: 
jmp endif20 
else20: 
endif20: 
endif16: 
endif12: 
movl -20(%ebp), %eax 
movl %eax, -20(%ebp) 
pushl -20(%ebp) 
call is_true
movl %eax, %edi 
addl $4, %esp 
jmp while0 
endwhile0: 
pushl %esi 
call print_any 
addl $4, %esp 
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
subl $8, %esp 
pushl %ebx 
pushl %esi
pushl %edi
    
pushl $3 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call print_any 
addl $4, %esp 
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
movl %eax, %esi 
addl $8, %esp 
pushl $1 
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
movl %eax, %edi 
addl $8, %esp 
pushl $1 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl %ebx 
pushl 12(%ebp) 
call get_subscript
movl %eax, %ebx 
addl $8, %esp 
pushl -4(%ebp) 
pushl %ebx 
call get_subscript
movl %eax, %ebx 
addl $8, %esp 
pushl %edi 
call get_fun_ptr
movl %eax, %edi 
addl $4, %esp 
pushl %ebx 
call get_free_vars
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, -8(%ebp) 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl -8(%ebp) 
pushl 12(%ebp) 
call get_subscript
movl %eax, -8(%ebp) 
addl $8, %esp 
pushl %ebx 
pushl -8(%ebp) 
call get_subscript
movl %eax, %ebx 
addl $8, %esp 
pushl %esi 
call get_fun_ptr
movl %eax, %esi 
addl $4, %esp 
pushl -4(%ebp) 
pushl 8(%ebp) 
call *%edi
movl %eax, %edi 
addl $8, %esp 
pushl %ebx 
call get_free_vars
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
pushl %edi 
call *%esi
movl %eax, %edi 
addl $8, %esp 
movl %edi, %eax

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
    
pushl $2 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call print_any 
addl $4, %esp 
pushl $2 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl 8(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else201 
if201: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else202 
if202: 
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
jmp endif202 
else202: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else203 
if203: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif203 
else203: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else204 
if204: 
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
jmp endif204 
else204: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif204: 
endif203: 
endif202: 
jmp endif201 
else201: 
pushl 8(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else205 
if205: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else206 
if206: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif206 
else206: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else207 
if207: 
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
jmp endif207 
else207: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else208 
if208: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif208 
else208: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif208: 
endif207: 
endif206: 
jmp endif205 
else205: 
pushl 8(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else209 
if209: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else210 
if210: 
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
jmp endif210 
else210: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else211 
if211: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif211 
else211: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else212 
if212: 
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
jmp endif212 
else212: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif212: 
endif211: 
endif210: 
jmp endif209 
else209: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif209: 
endif205: 
endif201: 
movl %esi, %eax

popl %edi 
popl %esi
popl %ebx
movl %ebp, %esp 
popl %ebp 
ret


__func3: 
pushl %ebp 
movl %esp, %ebp 
subl $0, %esp 
pushl %ebx 
pushl %esi
pushl %edi
    
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call print_any 
addl $4, %esp 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
negl %eax 
movl %eax, %ebx 
pushl 8(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else415 
if415: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else416 
if416: 
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
jmp endif416 
else416: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else417 
if417: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif417 
else417: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else418 
if418: 
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
jmp endif418 
else418: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif418: 
endif417: 
endif416: 
jmp endif415 
else415: 
pushl 8(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else419 
if419: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else420 
if420: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif420 
else420: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else421 
if421: 
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
jmp endif421 
else421: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else422 
if422: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif422 
else422: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif422: 
endif421: 
endif420: 
jmp endif419 
else419: 
pushl 8(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else423 
if423: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else424 
if424: 
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
jmp endif424 
else424: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else425 
if425: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif425 
else425: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else426 
if426: 
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
jmp endif426 
else426: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif426: 
endif425: 
endif424: 
jmp endif423 
else423: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif423: 
endif419: 
endif415: 
movl %esi, %eax

popl %edi 
popl %esi
popl %ebx
movl %ebp, %esp 
popl %ebp 
ret

