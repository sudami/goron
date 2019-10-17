; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

declare void @llvm.experimental.guard(i1, ...)

; Regression test. If %flag is false then %s == 0 and guard should be triggered.
define i32 @a(i1 %flag, i32 %X) nounwind readnone {
; CHECK-LABEL: @a(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ne i32 [[X:%.*]], 0
; CHECK-NEXT:    [[CMP:%.*]] = and i1 [[CMP1]], [[FLAG:%.*]]
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[CMP]]) #1 [ "deopt"() ]
; CHECK-NEXT:    [[R:%.*]] = sdiv i32 100, [[X]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %s = select i1 %flag, i32 %X, i32 0
  %cmp = icmp ne i32 %s, 0
  call void(i1, ...) @llvm.experimental.guard( i1 %cmp )[ "deopt"() ]
  %r = sdiv i32 100, %s
  ret i32 %r
}
