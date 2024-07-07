
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
movl %eax, %esi 
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
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl %esi 
pushl -4(%ebp) 
pushl %edi 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
movl %edi, %esi 
pushl $0 
call inject_int
movl %eax, -4(%ebp) 
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
pushl -4(%ebp) 
pushl %edi 
pushl -12(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
movl -12(%ebp), %eax 
movl %eax, -12(%ebp) 
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
movl %eax, %edi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl %esi 
pushl -4(%ebp) 
pushl %edi 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $1 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl %ebx 
pushl -4(%ebp) 
pushl %edi 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
movl %edi, %eax 
pushl %eax 
pushl $__func1 
call create_closure
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, -4(%ebp) 
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
movl %eax, -16(%ebp) 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl -12(%ebp) 
pushl %edi 
pushl -16(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
movl -16(%ebp), %eax 
pushl %eax 
pushl $__func2 
call create_closure
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, %eax 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, -20(%ebp) 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, -16(%ebp) 
addl $4, %esp 
pushl -8(%ebp) 
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
movl -8(%ebp), %ecx 
movl -16(%ebp), %eax 
cmpl %ecx, %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, %ebx 
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
pushl -8(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
pushl -16(%ebp) 
call project_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl %edi, %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, %ebx 
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
movl %eax, %ebx 
addl $4, %esp 
jmp endif3 
else3: 
endif3: 
jmp endif0 
else0: 
pushl -8(%ebp) 
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
pushl -8(%ebp) 
call project_bool
movl %eax, %ebx 
addl $4, %esp 
pushl -16(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl %ebx, %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, %ebx 
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
movl -8(%ebp), %ecx 
movl -16(%ebp), %eax 
cmpl %ecx, %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, %ebx 
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
movl %eax, %ebx 
addl $4, %esp 
jmp endif7 
else7: 
endif7: 
jmp endif4 
else4: 
pushl -8(%ebp) 
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
movl %eax, %ebx 
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
movl %eax, %ebx 
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
pushl -8(%ebp) 
call project_big
movl %eax, %edi 
addl $4, %esp 
pushl -16(%ebp) 
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
movl %eax, %ebx 
addl $4, %esp 
jmp endif11 
else11: 
endif11: 
jmp endif8 
else8: 
endif8: 
endif4: 
endif0: 
pushl %ebx 
pushl -20(%ebp) 
pushl %esi 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl -4(%ebp) 
pushl %edi 
pushl -12(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl -12(%ebp) 
call get_subscript
movl %eax, %edi 
addl $8, %esp 
pushl $0 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
pushl -12(%ebp) 
call get_subscript
movl %eax, %ebx 
addl $8, %esp 
pushl %edi 
call get_fun_ptr
movl %eax, %edi 
addl $4, %esp 
pushl $23 
call inject_int
movl %eax, %esi 
addl $4, %esp 
pushl %ebx 
call get_free_vars
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
pushl %esi 
call *%edi
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
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
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call is_true
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else100 
if100: 
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
movl %edi, %eax 
jmp endif100 
else100: 
pushl $0 
call inject_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
endif100: 
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
subl $4, %esp 
pushl %ebx 
pushl %esi
pushl %edi
    
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl 8(%ebp) 
call is_int
movl %eax, %esi 
addl $4, %esp 
movl %esi, %eax 
cmpl $0, %eax 
je else202 
if202: 
pushl %edi 
call is_int
movl %eax, %esi 
addl $4, %esp 
movl %esi, %eax 
cmpl $0, %eax 
je else203 
if203: 
movl %edi, %eax 
cmpl 8(%ebp), %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif203 
else203: 
endif203: 
pushl %edi 
call is_bool
movl %eax, %esi 
addl $4, %esp 
movl %esi, %eax 
cmpl $0, %eax 
je else204 
if204: 
pushl 8(%ebp) 
call project_int
movl %eax, %esi 
addl $4, %esp 
pushl %edi 
call project_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
movl -4(%ebp), %eax 
cmpl %esi, %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif204 
else204: 
endif204: 
pushl %edi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else205 
if205: 
pushl $1 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif205 
else205: 
endif205: 
jmp endif202 
else202: 
pushl 8(%ebp) 
call is_bool
movl %eax, %esi 
addl $4, %esp 
movl %esi, %eax 
cmpl $0, %eax 
je else206 
if206: 
pushl %edi 
call is_int
movl %eax, %esi 
addl $4, %esp 
movl %esi, %eax 
cmpl $0, %eax 
je else207 
if207: 
pushl 8(%ebp) 
call project_bool
movl %eax, %esi 
addl $4, %esp 
pushl %edi 
call project_int
movl %eax, -4(%ebp) 
addl $4, %esp 
movl -4(%ebp), %eax 
cmpl %esi, %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif207 
else207: 
endif207: 
pushl %edi 
call is_bool
movl %eax, %esi 
addl $4, %esp 
movl %esi, %eax 
cmpl $0, %eax 
je else208 
if208: 
movl %edi, %eax 
cmpl 8(%ebp), %eax 
setne %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif208 
else208: 
endif208: 
pushl %edi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else209 
if209: 
pushl $1 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif209 
else209: 
endif209: 
jmp endif206 
else206: 
pushl 8(%ebp) 
call is_big
movl %eax, %esi 
addl $4, %esp 
movl %esi, %eax 
cmpl $0, %eax 
je else210 
if210: 
pushl %edi 
call is_int
movl %eax, %esi 
addl $4, %esp 
movl %esi, %eax 
cmpl $0, %eax 
je else211 
if211: 
pushl $1 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif211 
else211: 
endif211: 
pushl %edi 
call is_bool
movl %eax, %esi 
addl $4, %esp 
movl %esi, %eax 
cmpl $0, %eax 
je else212 
if212: 
pushl $1 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif212 
else212: 
endif212: 
pushl %edi 
call is_big
movl %eax, %esi 
addl $4, %esp 
movl %esi, %eax 
cmpl $0, %eax 
je else213 
if213: 
pushl 8(%ebp) 
call project_big
movl %eax, %esi 
addl $4, %esp 
pushl %edi 
call project_big
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl %esi 
call not_equal
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif213 
else213: 
endif213: 
jmp endif210 
else210: 
endif210: 
endif206: 
endif202: 
movl -4(%ebp), %eax 
movl %eax, -4(%ebp) 
pushl -4(%ebp) 
call is_true
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call is_true
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else214 
if214: 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
negl %eax 
movl %eax, %esi 
pushl 8(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else215 
if215: 
pushl %esi 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else216 
if216: 
pushl 8(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
call project_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
jmp endif216 
else216: 
pushl %esi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else217 
if217: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif217 
else217: 
pushl %esi 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else218 
if218: 
pushl 8(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
call project_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
jmp endif218 
else218: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif218: 
endif217: 
endif216: 
jmp endif215 
else215: 
pushl 8(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else219 
if219: 
pushl %esi 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else220 
if220: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif220 
else220: 
pushl %esi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else221 
if221: 
pushl 8(%ebp) 
call project_big
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
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
movl %eax, %ebx 
addl $4, %esp 
jmp endif221 
else221: 
pushl %esi 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else222 
if222: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif222 
else222: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif222: 
endif221: 
endif220: 
jmp endif219 
else219: 
pushl 8(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else223 
if223: 
pushl %esi 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else224 
if224: 
pushl 8(%ebp) 
call project_bool
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
call project_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
jmp endif224 
else224: 
pushl %esi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else225 
if225: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif225 
else225: 
pushl %esi 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else226 
if226: 
pushl 8(%ebp) 
call project_bool
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
call project_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
addl %edi, %eax 
pushl %eax 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif226 
else226: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif226: 
endif225: 
endif224: 
jmp endif223 
else223: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif223: 
endif219: 
endif215: 
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
movl %eax, -4(%ebp) 
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
pushl -4(%ebp) 
call get_fun_ptr
movl %eax, %esi 
addl $4, %esp 
pushl %edi 
call get_free_vars
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl %ebx 
call *%esi
movl %eax, %edi 
addl $8, %esp 
jmp endif214 
else214: 
pushl $1 
call inject_bool
movl %eax, %edi 
addl $4, %esp 
endif214: 
movl %edi, %eax

popl %edi 
popl %esi
popl %ebx
movl %ebp, %esp 
popl %ebp 
ret

