
.globl main
main: 
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
movl %eax, %ebx 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %esi 
addl $4, %esp 
pushl %edi 
pushl %esi 
pushl %ebx 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
movl %ebx, %esi 
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
movl %eax, %ebx 
addl $4, %esp 
pushl -4(%ebp) 
pushl %ebx 
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
movl %eax, -8(%ebp) 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl $2 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
call create_list
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
call inject_big
movl %eax, -12(%ebp) 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl -4(%ebp) 
pushl %ebx 
pushl -12(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $1 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl %esi 
pushl %ebx 
pushl -12(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
movl -12(%ebp), %eax 
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
pushl %esi 
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
movl %eax, %edi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl -4(%ebp) 
pushl %ebx 
pushl %edi 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
movl %edi, %eax 
pushl %eax 
pushl $__func3 
call create_closure
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, %edi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
pushl %esi 
call get_subscript
movl %eax, %esi 
addl $8, %esp 
pushl $3 
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
pushl $0 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl -8(%ebp) 
pushl -4(%ebp) 
pushl %ebx 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $1 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl %esi 
pushl -4(%ebp) 
pushl %ebx 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $2 
call inject_int
movl %eax, %esi 
addl $4, %esp 
pushl %edi 
pushl %esi 
pushl %ebx 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl %ebx 
call get_subscript
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call get_fun_ptr
movl %eax, -8(%ebp) 
addl $4, %esp 
pushl $1 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl $2 
call inject_int
movl %eax, %esi 
addl $4, %esp 
pushl %edi 
call get_free_vars
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl %esi 
pushl -4(%ebp) 
call *-8(%ebp)
movl %eax, %edi 
addl $12, %esp 
pushl %edi 
call print_any 
addl $4, %esp 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl %ebx 
call get_subscript
movl %eax, -4(%ebp) 
addl $8, %esp 
pushl -4(%ebp) 
call get_fun_ptr
movl %eax, -8(%ebp) 
addl $4, %esp 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl $2 
call inject_int
movl %eax, %esi 
addl $4, %esp 
pushl -4(%ebp) 
call get_free_vars
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl -4(%ebp) 
pushl %esi 
pushl %edi 
call *-8(%ebp)
movl %eax, %edi 
addl $12, %esp 
pushl %edi 
call print_any 
addl $4, %esp 
pushl $2 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl %ebx 
call get_subscript
movl %eax, %ebx 
addl $8, %esp 
pushl %ebx 
call get_fun_ptr
movl %eax, %esi 
addl $4, %esp 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl $2 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl %ebx 
call get_free_vars
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
pushl -4(%ebp) 
pushl %edi 
call *%esi
movl %eax, %edi 
addl $12, %esp 
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
movl %eax, %esi 
addl $4, %esp 
pushl %edi 
pushl 16(%ebp) 
call get_subscript
movl %eax, %edi 
addl $8, %esp 
pushl %esi 
pushl %edi 
call get_subscript
movl %eax, %esi 
addl $8, %esp 
pushl %esi 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else100 
if100: 
pushl 12(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else101 
if101: 
pushl %esi 
call project_int
movl %eax, %edi 
addl $4, %esp 
pushl 12(%ebp) 
call project_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
jmp endif101 
else101: 
pushl 12(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else102 
if102: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif102 
else102: 
pushl 12(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else103 
if103: 
pushl %esi 
call project_int
movl %eax, %ebx 
addl $4, %esp 
pushl 12(%ebp) 
call project_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
addl %ebx, %eax 
pushl %eax 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
jmp endif103 
else103: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif103: 
endif102: 
endif101: 
jmp endif100 
else100: 
pushl %esi 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else104 
if104: 
pushl 12(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else105 
if105: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif105 
else105: 
pushl 12(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else106 
if106: 
pushl %esi 
call project_big
movl %eax, %ebx 
addl $4, %esp 
pushl 12(%ebp) 
call project_big
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl %ebx 
call add
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, %ebx 
addl $4, %esp 
jmp endif106 
else106: 
pushl 12(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else107 
if107: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif107 
else107: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif107: 
endif106: 
endif105: 
jmp endif104 
else104: 
pushl %esi 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else108 
if108: 
pushl 12(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else109 
if109: 
pushl %esi 
call project_bool
movl %eax, %ebx 
addl $4, %esp 
pushl 12(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
addl %ebx, %eax 
pushl %eax 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
jmp endif109 
else109: 
pushl 12(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else110 
if110: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif110 
else110: 
pushl 12(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else111 
if111: 
pushl %esi 
call project_bool
movl %eax, %ebx 
addl $4, %esp 
pushl 12(%ebp) 
call project_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
addl %ebx, %eax 
pushl %eax 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif111 
else111: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif111: 
endif110: 
endif109: 
jmp endif108 
else108: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif108: 
endif104: 
endif100: 
movl %ebx, %eax

popl %edi 
popl %esi
popl %ebx
movl %ebp, %esp 
popl %ebp 
ret


__func2: 
pushl %ebp 
movl %esp, %ebp 
subl $16, %esp 
pushl %ebx 
pushl %esi
pushl %edi
    
pushl $0 
call inject_int
movl %eax, -8(%ebp) 
addl $4, %esp 
pushl 12(%ebp) 
call is_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else213 
if213: 
pushl -8(%ebp) 
call is_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else214 
if214: 
movl 12(%ebp), %ecx 
movl -8(%ebp), %eax 
cmpl %ecx, %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif214 
else214: 
endif214: 
pushl -8(%ebp) 
call is_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else215 
if215: 
pushl 12(%ebp) 
call project_int
movl %eax, %ebx 
addl $4, %esp 
pushl -8(%ebp) 
call project_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
movl -4(%ebp), %eax 
cmpl %ebx, %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif215 
else215: 
endif215: 
pushl -8(%ebp) 
call is_big
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else216 
if216: 
pushl $0 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif216 
else216: 
endif216: 
jmp endif213 
else213: 
pushl 12(%ebp) 
call is_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else217 
if217: 
pushl -8(%ebp) 
call is_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else218 
if218: 
pushl 12(%ebp) 
call project_bool
movl %eax, %ebx 
addl $4, %esp 
pushl -8(%ebp) 
call project_int
movl %eax, -4(%ebp) 
addl $4, %esp 
movl -4(%ebp), %eax 
cmpl %ebx, %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif218 
else218: 
endif218: 
pushl -8(%ebp) 
call is_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else219 
if219: 
movl 12(%ebp), %ecx 
movl -8(%ebp), %eax 
cmpl %ecx, %eax 
sete %al 
movzbl %al, %eax 
and $3, %eax 
movl %eax, %ecx 
movl %ecx, %eax 
pushl %eax 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif219 
else219: 
endif219: 
pushl -8(%ebp) 
call is_big
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else220 
if220: 
pushl $0 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif220 
else220: 
endif220: 
jmp endif217 
else217: 
pushl 12(%ebp) 
call is_big
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else221 
if221: 
pushl -8(%ebp) 
call is_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else222 
if222: 
pushl $0 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif222 
else222: 
endif222: 
pushl -8(%ebp) 
call is_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else223 
if223: 
pushl $0 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif223 
else223: 
endif223: 
pushl -8(%ebp) 
call is_big
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else224 
if224: 
pushl 12(%ebp) 
call project_big
movl %eax, %ebx 
addl $4, %esp 
pushl -8(%ebp) 
call project_big
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl -4(%ebp) 
pushl %ebx 
call equal
movl %eax, %ebx 
addl $8, %esp 
pushl %ebx 
call inject_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif224 
else224: 
endif224: 
jmp endif221 
else221: 
endif221: 
endif217: 
endif213: 
movl -4(%ebp), %eax 
movl %eax, -4(%ebp) 
pushl -4(%ebp) 
call is_true
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
call is_true
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else225 
if225: 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
jmp endif225 
else225: 
pushl $1 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
negl %eax 
movl %eax, -4(%ebp) 
pushl 12(%ebp) 
call is_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else226 
if226: 
pushl -4(%ebp) 
call is_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else227 
if227: 
pushl 12(%ebp) 
call project_int
movl %eax, %ebx 
addl $4, %esp 
pushl -4(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
addl %ebx, %eax 
pushl %eax 
call inject_int
movl %eax, %edi 
addl $4, %esp 
jmp endif227 
else227: 
pushl -4(%ebp) 
call is_big
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else228 
if228: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif228 
else228: 
pushl -4(%ebp) 
call is_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else229 
if229: 
pushl 12(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
pushl -4(%ebp) 
call project_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, %edi 
addl $4, %esp 
jmp endif229 
else229: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif229: 
endif228: 
endif227: 
jmp endif226 
else226: 
pushl 12(%ebp) 
call is_big
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else230 
if230: 
pushl -4(%ebp) 
call is_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else231 
if231: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif231 
else231: 
pushl -4(%ebp) 
call is_big
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else232 
if232: 
pushl 12(%ebp) 
call project_big
movl %eax, %ebx 
addl $4, %esp 
pushl -4(%ebp) 
call project_big
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl %ebx 
call add
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, %edi 
addl $4, %esp 
jmp endif232 
else232: 
pushl -4(%ebp) 
call is_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else233 
if233: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif233 
else233: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif233: 
endif232: 
endif231: 
jmp endif230 
else230: 
pushl 12(%ebp) 
call is_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else234 
if234: 
pushl -4(%ebp) 
call is_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else235 
if235: 
pushl 12(%ebp) 
call project_bool
movl %eax, %edi 
addl $4, %esp 
pushl -4(%ebp) 
call project_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, %edi 
addl $4, %esp 
jmp endif235 
else235: 
pushl -4(%ebp) 
call is_big
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else236 
if236: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif236 
else236: 
pushl -4(%ebp) 
call is_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else237 
if237: 
pushl 12(%ebp) 
call project_bool
movl %eax, %edi 
addl $4, %esp 
pushl -4(%ebp) 
call project_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
addl %edi, %eax 
pushl %eax 
call inject_bool
movl %eax, %edi 
addl $4, %esp 
jmp endif237 
else237: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif237: 
endif236: 
endif235: 
jmp endif234 
else234: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif234: 
endif230: 
endif226: 
pushl $1 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl -4(%ebp) 
pushl 16(%ebp) 
call get_subscript
movl %eax, -4(%ebp) 
addl $8, %esp 
pushl %ebx 
pushl -4(%ebp) 
call get_subscript
movl %eax, -16(%ebp) 
addl $8, %esp 
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
movl %eax, -12(%ebp) 
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
pushl 16(%ebp) 
call get_subscript
movl %eax, %ebx 
addl $8, %esp 
pushl -4(%ebp) 
pushl %ebx 
call get_subscript
movl %eax, %ebx 
addl $8, %esp 
pushl -16(%ebp) 
call get_fun_ptr
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl -8(%ebp) 
pushl -12(%ebp) 
call get_subscript
movl %eax, -8(%ebp) 
addl $8, %esp 
pushl %ebx 
call get_free_vars
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
pushl %edi 
pushl -8(%ebp) 
call *-4(%ebp)
movl %eax, %ebx 
addl $12, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl %edi 
pushl 16(%ebp) 
call get_subscript
movl %eax, %edi 
addl $8, %esp 
pushl -4(%ebp) 
pushl %edi 
call get_subscript
movl %eax, -4(%ebp) 
addl $8, %esp 
pushl -4(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else238 
if238: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else239 
if239: 
pushl -4(%ebp) 
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
jmp endif239 
else239: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else240 
if240: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif240 
else240: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else241 
if241: 
pushl -4(%ebp) 
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
jmp endif241 
else241: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif241: 
endif240: 
endif239: 
jmp endif238 
else238: 
pushl -4(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else242 
if242: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else243 
if243: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif243 
else243: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else244 
if244: 
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
call add
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, %esi 
addl $4, %esp 
jmp endif244 
else244: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else245 
if245: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif245 
else245: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif245: 
endif244: 
endif243: 
jmp endif242 
else242: 
pushl -4(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else246 
if246: 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else247 
if247: 
pushl -4(%ebp) 
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
jmp endif247 
else247: 
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else248 
if248: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif248 
else248: 
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else249 
if249: 
pushl -4(%ebp) 
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
jmp endif249 
else249: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif249: 
endif248: 
endif247: 
jmp endif246 
else246: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif246: 
endif242: 
endif238: 
movl %esi, %edi 
endif225: 
movl %edi, %eax

popl %edi 
popl %esi
popl %ebx
movl %ebp, %esp 
popl %ebp 
ret


__func3: 
pushl %ebp 
movl %esp, %ebp 
subl $4, %esp 
pushl %ebx 
pushl %esi
pushl %edi
    
movl 12(%ebp), %eax 
negl %eax 
movl %eax, %edi 
pushl $0 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl -4(%ebp) 
pushl 16(%ebp) 
call get_subscript
movl %eax, -4(%ebp) 
addl $8, %esp 
pushl %ebx 
pushl -4(%ebp) 
call get_subscript
movl %eax, -4(%ebp) 
addl $8, %esp 
pushl -4(%ebp) 
call is_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else464 
if464: 
pushl %edi 
call is_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else465 
if465: 
pushl -4(%ebp) 
call project_int
movl %eax, %ebx 
addl $4, %esp 
pushl %edi 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
addl %ebx, %eax 
pushl %eax 
call inject_int
movl %eax, %esi 
addl $4, %esp 
jmp endif465 
else465: 
pushl %edi 
call is_big
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else466 
if466: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif466 
else466: 
pushl %edi 
call is_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else467 
if467: 
pushl -4(%ebp) 
call project_int
movl %eax, %ebx 
addl $4, %esp 
pushl %edi 
call project_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
addl %ebx, %eax 
pushl %eax 
call inject_int
movl %eax, %esi 
addl $4, %esp 
jmp endif467 
else467: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif467: 
endif466: 
endif465: 
jmp endif464 
else464: 
pushl -4(%ebp) 
call is_big
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else468 
if468: 
pushl %edi 
call is_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else469 
if469: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif469 
else469: 
pushl %edi 
call is_big
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else470 
if470: 
pushl -4(%ebp) 
call project_big
movl %eax, %ebx 
addl $4, %esp 
pushl %edi 
call project_big
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl %ebx 
call add
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, %esi 
addl $4, %esp 
jmp endif470 
else470: 
pushl %edi 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else471 
if471: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif471 
else471: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif471: 
endif470: 
endif469: 
jmp endif468 
else468: 
pushl -4(%ebp) 
call is_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else472 
if472: 
pushl %edi 
call is_int
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else473 
if473: 
pushl -4(%ebp) 
call project_bool
movl %eax, %ebx 
addl $4, %esp 
pushl %edi 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
addl %ebx, %eax 
pushl %eax 
call inject_int
movl %eax, %esi 
addl $4, %esp 
jmp endif473 
else473: 
pushl %edi 
call is_big
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else474 
if474: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif474 
else474: 
pushl %edi 
call is_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else475 
if475: 
pushl -4(%ebp) 
call project_bool
movl %eax, %ebx 
addl $4, %esp 
pushl %edi 
call project_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
addl %ebx, %eax 
pushl %eax 
call inject_bool
movl %eax, %esi 
addl $4, %esp 
jmp endif475 
else475: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif475: 
endif474: 
endif473: 
jmp endif472 
else472: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
endif472: 
endif468: 
endif464: 
movl %esi, %eax

popl %edi 
popl %esi
popl %ebx
movl %ebp, %esp 
popl %ebp 
ret

