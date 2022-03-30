; RUN: opt -loop-vectorize -force-vector-width=2 -S < %s | FileCheck %s
;
; Confirm that the DebugLoc info for the instructions in the middle block of a
; vectorized loop are correct. The Cmp and Br instructions should map to the
; same source lines as the Cmp and Br of the scalar loop.

; CHECK-LABEL: middle.block:
; CHECK-NEXT: [[CMP:%.*]] = icmp eq {{.*}}!dbg ![[DL:[0-9]+]]
; CHECK-NEXT: br i1 [[CMP]]{{.*}} !dbg ![[DL]]
; CHECK: ![[DL]] = !DILocation(line: 6,

; This IR can be generated by running:
; clang -g -O2 -emit-llvm -S -mllvm -opt-bisect-limit=68 vec.cpp -o - | opt -loop-vectorize -force-vector-width=2 -S -o vec.ll
;
; Where vec.cpp contains:
;
; extern int x;
; extern int y;
; void a() {
;     const int len = x;
;     int b[len];
;     for(int i = 0; i< len; ++i)
;         b[i] = x;
;
;     y = b[x] + b[x-5];
; }

target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@"?x@@3HA" = external dso_local local_unnamed_addr global i32, align 4
@"?y@@3HA" = external dso_local local_unnamed_addr global i32, align 4

define dso_local void @"?a@@YAXXZ"() local_unnamed_addr #0 !dbg !8 {
entry:
  %0 = load i32, i32* @"?x@@3HA", align 4, !dbg !23, !tbaa !24
  %1 = zext i32 %0 to i64, !dbg !28
  %vla = alloca i32, i64 %1, align 16, !dbg !28
  %cmp10 = icmp sgt i32 %0, 0, !dbg !30
  br i1 %cmp10, label %for.body.preheader, label %for.cond.cleanup, !dbg !30

for.body.preheader:
  br label %for.body, !dbg !31

for.cond.cleanup.loopexit:
  %idxprom1.phi.trans.insert = sext i32 %0 to i64
  %arrayidx2.phi.trans.insert = getelementptr inbounds i32, i32* %vla, i64 %idxprom1.phi.trans.insert
  %.pre = load i32, i32* %arrayidx2.phi.trans.insert, align 4, !dbg !33, !tbaa !24
  br label %for.cond.cleanup, !dbg !33

for.cond.cleanup:
  %2 = phi i32 [ %.pre, %for.cond.cleanup.loopexit ], [ undef, %entry ], !dbg !33
  %sub = add nsw i32 %0, -5, !dbg !33
  %idxprom3 = sext i32 %sub to i64, !dbg !33
  %arrayidx4 = getelementptr inbounds i32, i32* %vla, i64 %idxprom3, !dbg !33
  %3 = load i32, i32* %arrayidx4, align 4, !dbg !33, !tbaa !24
  %add = add nsw i32 %3, %2, !dbg !33
  store i32 %add, i32* @"?y@@3HA", align 4, !dbg !33, !tbaa !24
  ret void, !dbg !34

for.body:
  %indvars.iv = phi i64 [ %indvars.iv.next, %for.body ], [ 0, %for.body.preheader ]
  %arrayidx = getelementptr inbounds i32, i32* %vla, i64 %indvars.iv, !dbg !31
  store i32 %0, i32* %arrayidx, align 4, !dbg !31, !tbaa !24
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !35
  %exitcond = icmp eq i64 %indvars.iv.next, %1, !dbg !30
  br i1 %exitcond, label %for.cond.cleanup.loopexit, label %for.body, !dbg !30, !llvm.loop !36
}

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5, !6}
!llvm.ident = !{!7}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "clang version 9.0.0 (https://github.com/llvm/llvm-project.git 045b8544fd2c4e14f7e72e0df2bc681d823b0838)", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, nameTableKind: None)
!1 = !DIFile(filename: "vec.cpp", directory: "C:\5CUsers\5Cgbhyamso\5Cdev\5Cllvm\5Csamples", checksumkind: CSK_MD5, checksum: "fed997f50117f5514a69caf1c2fb2c49")
!2 = !{}
!3 = !{i32 2, !"CodeView", i32 1}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 2}
!6 = !{i32 7, !"PIC Level", i32 2}
!7 = !{!"clang version 9.0.0 (https://github.com/llvm/llvm-project.git 045b8544fd2c4e14f7e72e0df2bc681d823b0838)"}
!8 = distinct !DISubprogram(name: "a", linkageName: "?a@@YAXXZ", scope: !1, file: !1, line: 3, type: !9, scopeLine: 3, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !11)
!9 = !DISubroutineType(types: !10)
!10 = !{null}
!11 = !{!12, !15, !17, !21}
!12 = !DILocalVariable(name: "len", scope: !8, file: !1, line: 4, type: !13)
!13 = !DIDerivedType(tag: DW_TAG_const_type, baseType: !14)
!14 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!15 = !DILocalVariable(name: "__vla_expr0", scope: !8, type: !16, flags: DIFlagArtificial)
!16 = !DIBasicType(name: "long long unsigned int", size: 64, encoding: DW_ATE_unsigned)
!17 = !DILocalVariable(name: "b", scope: !8, file: !1, line: 5, type: !18)
!18 = !DICompositeType(tag: DW_TAG_array_type, baseType: !14, elements: !19)
!19 = !{!20}
!20 = !DISubrange(count: !15)
!21 = !DILocalVariable(name: "i", scope: !22, file: !1, line: 6, type: !14)
!22 = distinct !DILexicalBlock(scope: !8, file: !1, line: 6)
!23 = !DILocation(line: 4, scope: !8)
!24 = !{!25, !25, i64 0}
!25 = !{!"int", !26, i64 0}
!26 = !{!"omnipotent char", !27, i64 0}
!27 = !{!"Simple C++ TBAA"}
!28 = !DILocation(line: 5, scope: !8)
!29 = !DILocation(line: 0, scope: !8)
!30 = !DILocation(line: 6, scope: !22)
!31 = !DILocation(line: 7, scope: !32)
!32 = distinct !DILexicalBlock(scope: !22, file: !1, line: 6)
!33 = !DILocation(line: 9, scope: !8)
!34 = !DILocation(line: 10, scope: !8)
!35 = !DILocation(line: 6, scope: !32)
!36 = distinct !{!36, !30, !37}
!37 = !DILocation(line: 7, scope: !22)