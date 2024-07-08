
.globl main
main: 
pushl %ebp 
movl %esp, %ebp 
subl $0, %esp 
pushl %ebx 
pushl %esi
pushl %edi
    
pushl $7 
call inject_int
movl %eax, %eax 
addl $4, %esp 
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
movl %eax, %eax 
addl $4, %esp 
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
pushl $__func3 
call create_closure
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call get_fun_ptr
movl %eax, %ebx 
addl $4, %esp 
pushl %edi 
call get_free_vars
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call *%ebx
movl %eax, %edi 
addl $4, %esp 
pushl %edi 
call get_fun_ptr
movl %eax, %esi 
addl $4, %esp 
pushl $3 
call inject_int
movl %eax, %ebx 
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
    
pushl $7 
call inject_int
movl %eax, %eax 
addl $4, %esp 
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
movl %eax, %ebx 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl %ebx 
pushl 12(%ebp) 
call get_subscript
movl %eax, %ebx 
addl $8, %esp 
pushl %edi 
pushl %ebx 
call get_subscript
movl %eax, %ebx 
addl $8, %esp 
pushl %ebx 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else201 
if201: 
pushl 8(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else202 
if202: 
pushl %ebx 
call project_int
movl %eax, %edi 
addl $4, %esp 
pushl 8(%ebp) 
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
pushl 8(%ebp) 
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
pushl 8(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else204 
if204: 
pushl %ebx 
call project_int
movl %eax, %ebx 
addl $4, %esp 
pushl 8(%ebp) 
call project_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
addl %ebx, %eax 
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
pushl %ebx 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else205 
if205: 
pushl 8(%ebp) 
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
pushl 8(%ebp) 
call is_big
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else207 
if207: 
pushl %ebx 
call project_big
movl %eax, %ebx 
addl $4, %esp 
pushl 8(%ebp) 
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
jmp endif207 
else207: 
pushl 8(%ebp) 
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
pushl %ebx 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else209 
if209: 
pushl 8(%ebp) 
call is_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else210 
if210: 
pushl %ebx 
call project_bool
movl %eax, %ebx 
addl $4, %esp 
pushl 8(%ebp) 
call project_int
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
addl %ebx, %eax 
pushl %eax 
call inject_int
movl %eax, %esi 
addl $4, %esp 
jmp endif210 
else210: 
pushl 8(%ebp) 
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
pushl 8(%ebp) 
call is_bool
movl %eax, %edi 
addl $4, %esp 
movl %edi, %eax 
cmpl $0, %eax 
je else212 
if212: 
pushl %ebx 
call project_bool
movl %eax, %edi 
addl $4, %esp 
pushl 8(%ebp) 
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
subl $4, %esp 
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
movl %edi, %eax 
pushl %eax 
pushl $__func2 
call create_closure
movl %eax, %edi 
addl $8, %esp 
pushl %edi 
call inject_big
movl %eax, %esi 
addl $4, %esp 
pushl $0 
call inject_int
movl %eax, %edi 
addl $4, %esp 
pushl $2 
call inject_int
movl %eax, -4(%ebp) 
addl $4, %esp 
pushl -4(%ebp) 
pushl %edi 
pushl %ebx 
call set_subscript
movl %eax, %eax 
addl $12, %esp 
movl %esi, %eax

popl %edi 
popl %esi
popl %ebx
movl %ebp, %esp 
popl %ebp 
ret

