; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686--   -mattr=sse2 | FileCheck %s --check-prefixes=CHECK,X86-SSE2
; RUN: llc < %s -mtriple=x86_64-- -mattr=avx2 | FileCheck %s --check-prefixes=CHECK,X64-AVX2

declare i8 @llvm.fshl.i8(i8, i8, i8)
declare i16 @llvm.fshl.i16(i16, i16, i16)
declare i32 @llvm.fshl.i32(i32, i32, i32)
declare i64 @llvm.fshl.i64(i64, i64, i64)
declare <4 x i32> @llvm.fshl.v4i32(<4 x i32>, <4 x i32>, <4 x i32>)

declare i8 @llvm.fshr.i8(i8, i8, i8)
declare i16 @llvm.fshr.i16(i16, i16, i16)
declare i32 @llvm.fshr.i32(i32, i32, i32)
declare i64 @llvm.fshr.i64(i64, i64, i64)
declare <4 x i32> @llvm.fshr.v4i32(<4 x i32>, <4 x i32>, <4 x i32>)

; When first 2 operands match, it's a rotate.

define i8 @rotl_i8_const_shift(i8 %x) nounwind {
; X86-SSE2-LABEL: rotl_i8_const_shift:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-SSE2-NEXT:    rolb $3, %al
; X86-SSE2-NEXT:    retl
;
; X64-AVX2-LABEL: rotl_i8_const_shift:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    movl %edi, %eax
; X64-AVX2-NEXT:    rolb $3, %al
; X64-AVX2-NEXT:    # kill: def $al killed $al killed $eax
; X64-AVX2-NEXT:    retq
  %f = call i8 @llvm.fshl.i8(i8 %x, i8 %x, i8 3)
  ret i8 %f
}

define i8 @rotl_i8_const_shift1(i8 %x) nounwind {
; X86-SSE2-LABEL: rotl_i8_const_shift1:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-SSE2-NEXT:    rolb %al
; X86-SSE2-NEXT:    retl
;
; X64-AVX2-LABEL: rotl_i8_const_shift1:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    movl %edi, %eax
; X64-AVX2-NEXT:    rolb %al
; X64-AVX2-NEXT:    # kill: def $al killed $al killed $eax
; X64-AVX2-NEXT:    retq
  %f = call i8 @llvm.fshl.i8(i8 %x, i8 %x, i8 1)
  ret i8 %f
}

define i8 @rotl_i8_const_shift7(i8 %x) nounwind {
; X86-SSE2-LABEL: rotl_i8_const_shift7:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-SSE2-NEXT:    rorb %al
; X86-SSE2-NEXT:    retl
;
; X64-AVX2-LABEL: rotl_i8_const_shift7:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    movl %edi, %eax
; X64-AVX2-NEXT:    rorb %al
; X64-AVX2-NEXT:    # kill: def $al killed $al killed $eax
; X64-AVX2-NEXT:    retq
  %f = call i8 @llvm.fshl.i8(i8 %x, i8 %x, i8 7)
  ret i8 %f
}

define i64 @rotl_i64_const_shift(i64 %x) nounwind {
; X86-SSE2-LABEL: rotl_i64_const_shift:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-SSE2-NEXT:    movl %ecx, %eax
; X86-SSE2-NEXT:    shldl $3, %edx, %eax
; X86-SSE2-NEXT:    shldl $3, %ecx, %edx
; X86-SSE2-NEXT:    retl
;
; X64-AVX2-LABEL: rotl_i64_const_shift:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    movq %rdi, %rax
; X64-AVX2-NEXT:    rolq $3, %rax
; X64-AVX2-NEXT:    retq
  %f = call i64 @llvm.fshl.i64(i64 %x, i64 %x, i64 3)
  ret i64 %f
}

define i16 @rotl_i16(i16 %x, i16 %z) nounwind {
; X86-SSE2-LABEL: rotl_i16:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-SSE2-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-SSE2-NEXT:    rolw %cl, %ax
; X86-SSE2-NEXT:    retl
;
; X64-AVX2-LABEL: rotl_i16:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    movl %esi, %ecx
; X64-AVX2-NEXT:    movl %edi, %eax
; X64-AVX2-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-AVX2-NEXT:    rolw %cl, %ax
; X64-AVX2-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-AVX2-NEXT:    retq
  %f = call i16 @llvm.fshl.i16(i16 %x, i16 %x, i16 %z)
  ret i16 %f
}

define i32 @rotl_i32(i32 %x, i32 %z) nounwind {
; X86-SSE2-LABEL: rotl_i32:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE2-NEXT:    roll %cl, %eax
; X86-SSE2-NEXT:    retl
;
; X64-AVX2-LABEL: rotl_i32:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    movl %esi, %ecx
; X64-AVX2-NEXT:    movl %edi, %eax
; X64-AVX2-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-AVX2-NEXT:    roll %cl, %eax
; X64-AVX2-NEXT:    retq
  %f = call i32 @llvm.fshl.i32(i32 %x, i32 %x, i32 %z)
  ret i32 %f
}

; Vector rotate.

define <4 x i32> @rotl_v4i32(<4 x i32> %x, <4 x i32> %z) nounwind {
; X86-SSE2-LABEL: rotl_v4i32:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1
; X86-SSE2-NEXT:    pslld $23, %xmm1
; X86-SSE2-NEXT:    paddd {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1
; X86-SSE2-NEXT:    cvttps2dq %xmm1, %xmm1
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; X86-SSE2-NEXT:    pmuludq %xmm1, %xmm0
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,3,2,3]
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; X86-SSE2-NEXT:    pmuludq %xmm2, %xmm1
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[1,3,2,3]
; X86-SSE2-NEXT:    punpckldq {{.*#+}} xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1]
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; X86-SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; X86-SSE2-NEXT:    por %xmm3, %xmm0
; X86-SSE2-NEXT:    retl
;
; X64-AVX2-LABEL: rotl_v4i32:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [31,31,31,31]
; X64-AVX2-NEXT:    vpand %xmm2, %xmm1, %xmm1
; X64-AVX2-NEXT:    vpsllvd %xmm1, %xmm0, %xmm2
; X64-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm3 = [32,32,32,32]
; X64-AVX2-NEXT:    vpsubd %xmm1, %xmm3, %xmm1
; X64-AVX2-NEXT:    vpsrlvd %xmm1, %xmm0, %xmm0
; X64-AVX2-NEXT:    vpor %xmm0, %xmm2, %xmm0
; X64-AVX2-NEXT:    retq
  %f = call <4 x i32> @llvm.fshl.v4i32(<4 x i32> %x, <4 x i32> %x, <4 x i32> %z)
  ret <4 x i32> %f
}

; Vector rotate by constant splat amount.

define <4 x i32> @rotl_v4i32_const_shift(<4 x i32> %x) nounwind {
; X86-SSE2-LABEL: rotl_v4i32_const_shift:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movdqa %xmm0, %xmm1
; X86-SSE2-NEXT:    psrld $29, %xmm1
; X86-SSE2-NEXT:    pslld $3, %xmm0
; X86-SSE2-NEXT:    por %xmm1, %xmm0
; X86-SSE2-NEXT:    retl
;
; X64-AVX2-LABEL: rotl_v4i32_const_shift:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vpsrld $29, %xmm0, %xmm1
; X64-AVX2-NEXT:    vpslld $3, %xmm0, %xmm0
; X64-AVX2-NEXT:    vpor %xmm1, %xmm0, %xmm0
; X64-AVX2-NEXT:    retq
  %f = call <4 x i32> @llvm.fshl.v4i32(<4 x i32> %x, <4 x i32> %x, <4 x i32> <i32 3, i32 3, i32 3, i32 3>)
  ret <4 x i32> %f
}

; Repeat everything for funnel shift right.

define i8 @rotr_i8_const_shift(i8 %x) nounwind {
; X86-SSE2-LABEL: rotr_i8_const_shift:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-SSE2-NEXT:    rorb $3, %al
; X86-SSE2-NEXT:    retl
;
; X64-AVX2-LABEL: rotr_i8_const_shift:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    movl %edi, %eax
; X64-AVX2-NEXT:    rorb $3, %al
; X64-AVX2-NEXT:    # kill: def $al killed $al killed $eax
; X64-AVX2-NEXT:    retq
  %f = call i8 @llvm.fshr.i8(i8 %x, i8 %x, i8 3)
  ret i8 %f
}

define i8 @rotr_i8_const_shift1(i8 %x) nounwind {
; X86-SSE2-LABEL: rotr_i8_const_shift1:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-SSE2-NEXT:    rorb %al
; X86-SSE2-NEXT:    retl
;
; X64-AVX2-LABEL: rotr_i8_const_shift1:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    movl %edi, %eax
; X64-AVX2-NEXT:    rorb %al
; X64-AVX2-NEXT:    # kill: def $al killed $al killed $eax
; X64-AVX2-NEXT:    retq
  %f = call i8 @llvm.fshr.i8(i8 %x, i8 %x, i8 1)
  ret i8 %f
}

define i8 @rotr_i8_const_shift7(i8 %x) nounwind {
; X86-SSE2-LABEL: rotr_i8_const_shift7:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-SSE2-NEXT:    rolb %al
; X86-SSE2-NEXT:    retl
;
; X64-AVX2-LABEL: rotr_i8_const_shift7:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    movl %edi, %eax
; X64-AVX2-NEXT:    rolb %al
; X64-AVX2-NEXT:    # kill: def $al killed $al killed $eax
; X64-AVX2-NEXT:    retq
  %f = call i8 @llvm.fshr.i8(i8 %x, i8 %x, i8 7)
  ret i8 %f
}

define i32 @rotr_i32_const_shift(i32 %x) nounwind {
; X86-SSE2-LABEL: rotr_i32_const_shift:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE2-NEXT:    rorl $3, %eax
; X86-SSE2-NEXT:    retl
;
; X64-AVX2-LABEL: rotr_i32_const_shift:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    movl %edi, %eax
; X64-AVX2-NEXT:    rorl $3, %eax
; X64-AVX2-NEXT:    retq
  %f = call i32 @llvm.fshr.i32(i32 %x, i32 %x, i32 3)
  ret i32 %f
}

; When first 2 operands match, it's a rotate (by variable amount).

define i16 @rotr_i16(i16 %x, i16 %z) nounwind {
; X86-SSE2-LABEL: rotr_i16:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-SSE2-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-SSE2-NEXT:    rorw %cl, %ax
; X86-SSE2-NEXT:    retl
;
; X64-AVX2-LABEL: rotr_i16:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    movl %esi, %ecx
; X64-AVX2-NEXT:    movl %edi, %eax
; X64-AVX2-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-AVX2-NEXT:    rorw %cl, %ax
; X64-AVX2-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-AVX2-NEXT:    retq
  %f = call i16 @llvm.fshr.i16(i16 %x, i16 %x, i16 %z)
  ret i16 %f
}

define i64 @rotr_i64(i64 %x, i64 %z) nounwind {
; X86-SSE2-LABEL: rotr_i64:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    pushl %esi
; X86-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-SSE2-NEXT:    testb $32, %cl
; X86-SSE2-NEXT:    movl %eax, %edx
; X86-SSE2-NEXT:    cmovel %esi, %edx
; X86-SSE2-NEXT:    cmovel %eax, %esi
; X86-SSE2-NEXT:    movl %esi, %eax
; X86-SSE2-NEXT:    shrdl %cl, %edx, %eax
; X86-SSE2-NEXT:    # kill: def $cl killed $cl killed $ecx
; X86-SSE2-NEXT:    shrdl %cl, %esi, %edx
; X86-SSE2-NEXT:    popl %esi
; X86-SSE2-NEXT:    retl
;
; X64-AVX2-LABEL: rotr_i64:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    movq %rsi, %rcx
; X64-AVX2-NEXT:    movq %rdi, %rax
; X64-AVX2-NEXT:    # kill: def $cl killed $cl killed $rcx
; X64-AVX2-NEXT:    rorq %cl, %rax
; X64-AVX2-NEXT:    retq
  %f = call i64 @llvm.fshr.i64(i64 %x, i64 %x, i64 %z)
  ret i64 %f
}

; Vector rotate.

define <4 x i32> @rotr_v4i32(<4 x i32> %x, <4 x i32> %z) nounwind {
; X86-SSE2-LABEL: rotr_v4i32:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    pxor %xmm2, %xmm2
; X86-SSE2-NEXT:    psubd %xmm1, %xmm2
; X86-SSE2-NEXT:    pand {{\.?LCPI[0-9]+_[0-9]+}}, %xmm2
; X86-SSE2-NEXT:    pslld $23, %xmm2
; X86-SSE2-NEXT:    paddd {{\.?LCPI[0-9]+_[0-9]+}}, %xmm2
; X86-SSE2-NEXT:    cvttps2dq %xmm2, %xmm1
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[1,1,3,3]
; X86-SSE2-NEXT:    pmuludq %xmm1, %xmm0
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[1,3,2,3]
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[1,1,3,3]
; X86-SSE2-NEXT:    pmuludq %xmm2, %xmm1
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm2 = xmm1[1,3,2,3]
; X86-SSE2-NEXT:    punpckldq {{.*#+}} xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1]
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; X86-SSE2-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; X86-SSE2-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; X86-SSE2-NEXT:    por %xmm3, %xmm0
; X86-SSE2-NEXT:    retl
;
; X64-AVX2-LABEL: rotr_v4i32:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm2 = [31,31,31,31]
; X64-AVX2-NEXT:    vpand %xmm2, %xmm1, %xmm1
; X64-AVX2-NEXT:    vpsrlvd %xmm1, %xmm0, %xmm2
; X64-AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm3 = [32,32,32,32]
; X64-AVX2-NEXT:    vpsubd %xmm1, %xmm3, %xmm1
; X64-AVX2-NEXT:    vpsllvd %xmm1, %xmm0, %xmm0
; X64-AVX2-NEXT:    vpor %xmm0, %xmm2, %xmm0
; X64-AVX2-NEXT:    retq
  %f = call <4 x i32> @llvm.fshr.v4i32(<4 x i32> %x, <4 x i32> %x, <4 x i32> %z)
  ret <4 x i32> %f
}

; Vector rotate by constant splat amount.

define <4 x i32> @rotr_v4i32_const_shift(<4 x i32> %x) nounwind {
; X86-SSE2-LABEL: rotr_v4i32_const_shift:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movdqa %xmm0, %xmm1
; X86-SSE2-NEXT:    psrld $3, %xmm1
; X86-SSE2-NEXT:    pslld $29, %xmm0
; X86-SSE2-NEXT:    por %xmm1, %xmm0
; X86-SSE2-NEXT:    retl
;
; X64-AVX2-LABEL: rotr_v4i32_const_shift:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    vpsrld $3, %xmm0, %xmm1
; X64-AVX2-NEXT:    vpslld $29, %xmm0, %xmm0
; X64-AVX2-NEXT:    vpor %xmm1, %xmm0, %xmm0
; X64-AVX2-NEXT:    retq
  %f = call <4 x i32> @llvm.fshr.v4i32(<4 x i32> %x, <4 x i32> %x, <4 x i32> <i32 3, i32 3, i32 3, i32 3>)
  ret <4 x i32> %f
}

define i32 @rotl_i32_shift_by_bitwidth(i32 %x) nounwind {
; X86-SSE2-LABEL: rotl_i32_shift_by_bitwidth:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE2-NEXT:    retl
;
; X64-AVX2-LABEL: rotl_i32_shift_by_bitwidth:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    movl %edi, %eax
; X64-AVX2-NEXT:    retq
  %f = call i32 @llvm.fshl.i32(i32 %x, i32 %x, i32 32)
  ret i32 %f
}

define i32 @rotr_i32_shift_by_bitwidth(i32 %x) nounwind {
; X86-SSE2-LABEL: rotr_i32_shift_by_bitwidth:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE2-NEXT:    retl
;
; X64-AVX2-LABEL: rotr_i32_shift_by_bitwidth:
; X64-AVX2:       # %bb.0:
; X64-AVX2-NEXT:    movl %edi, %eax
; X64-AVX2-NEXT:    retq
  %f = call i32 @llvm.fshr.i32(i32 %x, i32 %x, i32 32)
  ret i32 %f
}

define <4 x i32> @rotl_v4i32_shift_by_bitwidth(<4 x i32> %x) nounwind {
; CHECK-LABEL: rotl_v4i32_shift_by_bitwidth:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret{{[l|q]}}
  %f = call <4 x i32> @llvm.fshl.v4i32(<4 x i32> %x, <4 x i32> %x, <4 x i32> <i32 32, i32 32, i32 32, i32 32>)
  ret <4 x i32> %f
}

define <4 x i32> @rotr_v4i32_shift_by_bitwidth(<4 x i32> %x) nounwind {
; CHECK-LABEL: rotr_v4i32_shift_by_bitwidth:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret{{[l|q]}}
  %f = call <4 x i32> @llvm.fshr.v4i32(<4 x i32> %x, <4 x i32> %x, <4 x i32> <i32 32, i32 32, i32 32, i32 32>)
  ret <4 x i32> %f
}

; Non power-of-2 types can't use the negated shift amount to avoid a select.

declare i7 @llvm.fshl.i7(i7, i7, i7)
declare i7 @llvm.fshr.i7(i7, i7, i7)

; extract(concat(0b1110000, 0b1110000) << 9) = 0b1000011
; Try an oversized shift to test modulo functionality.

define i7 @fshl_i7() {
; CHECK-LABEL: fshl_i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movb $67, %al
; CHECK-NEXT:    ret{{[l|q]}}
  %f = call i7 @llvm.fshl.i7(i7 112, i7 112, i7 9)
  ret i7 %f
}

; extract(concat(0b1110001, 0b1110001) >> 16) = 0b0111100
; Try an oversized shift to test modulo functionality.

define i7 @fshr_i7() {
; CHECK-LABEL: fshr_i7:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movb $60, %al
; CHECK-NEXT:    ret{{[l|q]}}
  %f = call i7 @llvm.fshr.i7(i7 113, i7 113, i7 16)
  ret i7 %f
}
