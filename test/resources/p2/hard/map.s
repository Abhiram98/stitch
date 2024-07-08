
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
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl %edi 
pushl %ebx 
pushl -4(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
movl -4(%ebp), %eax 
movl %eax, -8(%ebp) 
pushl $0 
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
movl %edi, %eax 
pushl %eax 
pushl $__func1 
call create_closure
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, %ebx 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, -12(%ebp) 
addl $4, %esp 
pushl $4 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call create_list
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call inject_big
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
pushl %edi 
pushl -4(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl -8(%ebp) 
pushl %edi 
pushl -4(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $2 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
pushl %edi 
pushl -4(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $3 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
pushl %edi 
pushl -4(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
movl -4(%ebp), %eax 
pushl %eax 
pushl $__func2 
call create_closure
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl -12(%ebp) 
pushl -8(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $1 
call inject_int
movl %eax, -16(%ebp) 
addl $4, %esp 
pushl $2 
call inject_int
movl %eax, %esi 
addl $4, %esp 
pushl $3 
call inject_int
movl %eax, -12(%ebp) 
addl $4, %esp 
pushl $4 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl $4 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call create_list
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call inject_big
movl %eax, -20(%ebp) 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl -16(%ebp) 
pushl %edi 
pushl -20(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %esi 
pushl %edi 
pushl -20(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $2 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl -12(%ebp) 
pushl %edi 
pushl -20(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
pushl $3 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl -4(%ebp) 
pushl %edi 
pushl -20(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
movl -20(%ebp), %esi 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl -8(%ebp) 
call get_subscript
movl %eax, %edi 
addl $8, %esp 
pushl $0 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl -4(%ebp) 
pushl -8(%ebp) 
call get_subscript
movl %eax, -4(%ebp) 
addl $8, %esp 
pushl %edi 
call get_fun_ptr
movl %eax, -8(%ebp) 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, -12(%ebp) 
addl $4, %esp 
pushl $4 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl -4(%ebp) 
call get_free_vars
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl -4(%ebp) 
pushl %edi 
pushl -12(%ebp) 
pushl %esi 
pushl %ebx 
call *-8(%ebp)
movl %eax, %edi 
addl $20, %esp 
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
    
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl 8(%ebp) 
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
pushl 8(%ebp) 
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
jmp endif101 
else101: 
pushl %edi 
call is_big
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else102 
if102: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif102 
else102: 
pushl %edi 
call is_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else103 
if103: 
pushl 8(%ebp) 
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
pushl 8(%ebp) 
call is_big
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
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif105 
else105: 
pushl %edi 
call is_big
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else106 
if106: 
pushl 8(%ebp) 
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
jmp endif106 
else106: 
pushl %edi 
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
pushl 8(%ebp) 
call is_bool
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
pushl 8(%ebp) 
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
jmp endif109 
else109: 
pushl %edi 
call is_big
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else110 
if110: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif110 
else110: 
pushl %edi 
call is_bool
movl %eax, %ebx 
addl $4, %esp 
movl %ebx, %eax 
cmpl $0, %eax 
je else111 
if111: 
pushl 8(%ebp) 
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
movl %esi, %eax

popl %edi 
popl %esi
popl %ebx
movl %ebp, %esp 
popl %ebp 
ret


__func2: 
pushl %ebp 
movl %esp, %ebp 
subl $28, %esp 
pushl %ebx 
pushl %esi
pushl %edi
    
pushl $3 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, -8(%ebp) 
addl $4, %esp 
pushl %edi 
pushl 24(%ebp) 
call get_subscript
movl %eax, %edi 
addl $8, %esp 
pushl -8(%ebp) 
pushl %edi 
call get_subscript
movl %eax, -8(%ebp) 
addl $8, %esp 
pushl -8(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else213 
if213: 
pushl 20(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else214 
if214: 
movl -8(%ebp), %ecx 
movl 20(%ebp), %eax 
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
jmp endif214 
else214: 
endif214: 
pushl 20(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else215 
if215: 
pushl -8(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
pushl 20(%ebp) 
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
jmp endif215 
else215: 
endif215: 
pushl 20(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else216 
if216: 
pushl $1 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif216 
else216: 
endif216: 
jmp endif213 
else213: 
pushl -8(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else217 
if217: 
pushl 20(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else218 
if218: 
pushl -8(%ebp) 
call project_bool
movl %eax, %edi 
addl $4, %esp 
pushl 20(%ebp) 
call project_int
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
jmp endif218 
else218: 
endif218: 
pushl 20(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else219 
if219: 
movl -8(%ebp), %ecx 
movl 20(%ebp), %eax 
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
jmp endif219 
else219: 
endif219: 
pushl 20(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else220 
if220: 
pushl $1 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif220 
else220: 
endif220: 
jmp endif217 
else217: 
pushl -8(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else221 
if221: 
pushl 20(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else222 
if222: 
pushl $1 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif222 
else222: 
endif222: 
pushl 20(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else223 
if223: 
pushl $1 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif223 
else223: 
endif223: 
pushl 20(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else224 
if224: 
pushl -8(%ebp) 
call project_big
movl %eax, %ebx 
addl $4, %esp 
pushl 20(%ebp) 
call project_big
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
pushl %ebx 
call not_equal
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_bool
movl %eax, %ebx 
addl $4, %esp 
jmp endif224 
else224: 
endif224: 
jmp endif221 
else221: 
endif221: 
endif217: 
endif213: 
pushl %ebx 
call is_true
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call is_true
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else225 
if225: 
pushl $0 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %ebx 
pushl 24(%ebp) 
call get_subscript
movl %eax, -12(%ebp) 
addl $8, %esp 
pushl $3 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, -8(%ebp) 
addl $4, %esp 
pushl %ebx 
pushl 24(%ebp) 
call get_subscript
movl %eax, %ebx 
addl $8, %esp 
pushl -8(%ebp) 
pushl %ebx 
call get_subscript
movl %eax, %ebx 
addl $8, %esp 
pushl %edi 
pushl -12(%ebp) 
call get_subscript
movl %eax, %edi 
addl $8, %esp 
pushl %ebx 
pushl %edi 
call get_subscript
movl %eax, %edi 
addl $8, %esp 
pushl $2 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, -8(%ebp) 
addl $4, %esp 
pushl %ebx 
pushl 24(%ebp) 
call get_subscript
movl %eax, %ebx 
addl $8, %esp 
pushl -8(%ebp) 
pushl %ebx 
call get_subscript
movl %eax, -12(%ebp) 
addl $8, %esp 
pushl $2 
call inject_int
movl %eax, %ebx 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, -8(%ebp) 
addl $4, %esp 
pushl %ebx 
pushl 24(%ebp) 
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
movl %eax, -8(%ebp) 
addl $4, %esp 
pushl %ebx 
call get_free_vars
movl %eax, %ebx 
addl $4, %esp 
pushl %ebx 
pushl %edi 
call *-8(%ebp)
movl %eax, %ebx 
addl $8, %esp 
pushl $3 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, -8(%ebp) 
addl $4, %esp 
pushl %edi 
pushl 24(%ebp) 
call get_subscript
movl %eax, %edi 
addl $8, %esp 
pushl -8(%ebp) 
pushl %edi 
call get_subscript
movl %eax, %edi 
addl $8, %esp 
pushl $1 
call inject_int
movl %eax, -12(%ebp) 
addl $4, %esp 
pushl %edi 
call is_int
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl $0, %eax 
je else226 
if226: 
pushl -12(%ebp) 
call is_int
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl $0, %eax 
je else227 
if227: 
pushl %edi 
call project_int
movl %eax, %edi 
addl $4, %esp 
pushl -12(%ebp) 
call project_int
movl %eax, -4(%ebp) 
addl $4, %esp 
movl -4(%ebp), %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif227 
else227: 
pushl -12(%ebp) 
call is_big
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl $0, %eax 
je else228 
if228: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif228 
else228: 
pushl -12(%ebp) 
call is_bool
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl $0, %eax 
je else229 
if229: 
pushl %edi 
call project_int
movl %eax, %edi 
addl $4, %esp 
pushl -12(%ebp) 
call project_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
movl -4(%ebp), %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, -4(%ebp) 
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
pushl %edi 
call is_big
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl $0, %eax 
je else230 
if230: 
pushl -12(%ebp) 
call is_int
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl $0, %eax 
je else231 
if231: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif231 
else231: 
pushl -12(%ebp) 
call is_big
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl $0, %eax 
je else232 
if232: 
pushl %edi 
call project_big
movl %eax, %edi 
addl $4, %esp 
pushl -12(%ebp) 
call project_big
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl -4(%ebp) 
pushl %edi 
call add
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif232 
else232: 
pushl -12(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
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
pushl %edi 
call is_bool
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl $0, %eax 
je else234 
if234: 
pushl -12(%ebp) 
call is_int
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl $0, %eax 
je else235 
if235: 
pushl %edi 
call project_bool
movl %eax, %edi 
addl $4, %esp 
pushl -12(%ebp) 
call project_int
movl %eax, -4(%ebp) 
addl $4, %esp 
movl -4(%ebp), %eax 
addl %edi, %eax 
pushl %eax 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
jmp endif235 
else235: 
pushl -12(%ebp) 
call is_big
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl $0, %eax 
je else236 
if236: 
call error_pyobj
movl %eax, %eax 
addl $0, %esp 
jmp endif236 
else236: 
pushl -12(%ebp) 
call is_bool
movl %eax, -8(%ebp) 
addl $4, %esp 
movl -8(%ebp), %eax 
cmpl $0, %eax 
je else237 
if237: 
pushl %edi 
call project_bool
movl %eax, %edi 
addl $4, %esp 
pushl -12(%ebp) 
call project_bool
movl %eax, -4(%ebp) 
addl $4, %esp 
movl -4(%ebp), %eax 
addl %edi, %eax 
pushl %eax 
call inject_bool
movl %eax, -4(%ebp) 
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
movl -4(%ebp), %eax 
movl %eax, -4(%ebp) 
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
movl %eax, -8(%ebp) 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %ebx 
pushl %edi 
pushl -8(%ebp) 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
movl -8(%ebp), %ebx 
pushl $1 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, -8(%ebp) 
addl $4, %esp 
pushl %edi 
pushl 24(%ebp) 
call get_subscript
movl %eax, %edi 
addl $8, %esp 
pushl -8(%ebp) 
pushl %edi 
call get_subscript
movl %eax, -20(%ebp) 
addl $8, %esp 
pushl $2 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, -8(%ebp) 
addl $4, %esp 
pushl %edi 
pushl 24(%ebp) 
call get_subscript
movl %eax, -16(%ebp) 
addl $8, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, -12(%ebp) 
addl $4, %esp 
pushl %edi 
pushl 24(%ebp) 
call get_subscript
movl %eax, %edi 
addl $8, %esp 
pushl $1 
call inject_int
movl %eax, -24(%ebp) 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, -28(%ebp) 
addl $4, %esp 
pushl -24(%ebp) 
pushl 24(%ebp) 
call get_subscript
movl %eax, -24(%ebp) 
addl $8, %esp 
pushl -28(%ebp) 
pushl -24(%ebp) 
call get_subscript
movl %eax, -24(%ebp) 
addl $8, %esp 
pushl -20(%ebp) 
call get_fun_ptr
movl %eax, -20(%ebp) 
addl $4, %esp 
pushl -8(%ebp) 
pushl -16(%ebp) 
call get_subscript
movl %eax, -8(%ebp) 
addl $8, %esp 
pushl -12(%ebp) 
pushl %edi 
call get_subscript
movl %eax, %edi 
addl $8, %esp 
pushl -24(%ebp) 
call get_free_vars
movl %eax, -12(%ebp) 
addl $4, %esp 
pushl -12(%ebp) 
pushl 20(%ebp) 
pushl -4(%ebp) 
pushl %edi 
pushl -8(%ebp) 
call *-20(%ebp)
movl %eax, -4(%ebp) 
addl $20, %esp 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else238 
if238: 
pushl -4(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else239 
if239: 
pushl %ebx 
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
movl %eax, %esi 
addl $4, %esp 
jmp endif239 
else239: 
pushl -4(%ebp) 
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
pushl -4(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else241 
if241: 
pushl %ebx 
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
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else242 
if242: 
pushl -4(%ebp) 
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
pushl -4(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else244 
if244: 
pushl %ebx 
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
movl %eax, %esi 
addl $4, %esp 
jmp endif244 
else244: 
pushl -4(%ebp) 
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
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else246 
if246: 
pushl -4(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else247 
if247: 
pushl %ebx 
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
movl %eax, %esi 
addl $4, %esp 
jmp endif247 
else247: 
pushl -4(%ebp) 
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
pushl -4(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else249 
if249: 
pushl %ebx 
call project_bool
movl %eax, %ebx 
addl $4, %esp 
pushl -4(%ebp) 
call project_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
addl %ebx, %eax 
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
movl %esi, %eax 
jmp endif225 
else225: 
pushl $0 
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
movl %edi, %eax 
endif225: 
movl %eax, %eax

popl %edi 
popl %esi
popl %ebx
movl %ebp, %esp 
popl %ebp 
ret

