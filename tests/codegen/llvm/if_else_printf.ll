; ModuleID = 'bpftrace'
source_filename = "bpftrace"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf-pc-linux"

%printf_t.0 = type { i64 }
%printf_t = type { i64 }

; Function Attrs: nounwind
declare i64 @llvm.bpf.pseudo(i64 %0, i64 %1) #0

define i64 @"kprobe:f"(i8* %0) section "s_kprobe:f_1" {
entry:
  %key8 = alloca i32, align 4
  %printf_args2 = alloca %printf_t.0, align 8
  %key = alloca i32, align 4
  %printf_args = alloca %printf_t, align 8
  %get_pid_tgid = call i64 inttoptr (i64 14 to i64 ()*)()
  %1 = lshr i64 %get_pid_tgid, 32
  %2 = icmp ugt i64 %1, 10
  %3 = zext i1 %2 to i64
  %true_cond = icmp ne i64 %3, 0
  br i1 %true_cond, label %if_body, label %else_body

if_body:                                          ; preds = %entry
  %4 = bitcast %printf_t* %printf_args to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %4)
  %5 = bitcast %printf_t* %printf_args to i8*
  call void @llvm.memset.p0i8.i64(i8* align 1 %5, i8 0, i64 8, i1 false)
  %6 = getelementptr %printf_t, %printf_t* %printf_args, i32 0, i32 0
  store i64 0, i64* %6, align 8
  %pseudo = call i64 @llvm.bpf.pseudo(i64 1, i64 0)
  %ringbuf_output = call i64 inttoptr (i64 130 to i64 (i64, %printf_t*, i64, i64)*)(i64 %pseudo, %printf_t* %printf_args, i64 8, i64 0)
  %if_negative = icmp slt i64 %ringbuf_output, 0
  br i1 %if_negative, label %event_loss_counter, label %counter_merge

if_end:                                           ; preds = %counter_merge6, %counter_merge
  ret i64 0

else_body:                                        ; preds = %entry
  %7 = bitcast %printf_t.0* %printf_args2 to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %7)
  %8 = bitcast %printf_t.0* %printf_args2 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 1 %8, i8 0, i64 8, i1 false)
  %9 = getelementptr %printf_t.0, %printf_t.0* %printf_args2, i32 0, i32 0
  store i64 1, i64* %9, align 8
  %pseudo3 = call i64 @llvm.bpf.pseudo(i64 1, i64 0)
  %ringbuf_output4 = call i64 inttoptr (i64 130 to i64 (i64, %printf_t.0*, i64, i64)*)(i64 %pseudo3, %printf_t.0* %printf_args2, i64 8, i64 0)
  %if_negative7 = icmp slt i64 %ringbuf_output4, 0
  br i1 %if_negative7, label %event_loss_counter5, label %counter_merge6

event_loss_counter:                               ; preds = %if_body
  %10 = bitcast i32* %key to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %10)
  store i32 0, i32* %key, align 4
  %pseudo1 = call i64 @llvm.bpf.pseudo(i64 1, i64 1)
  %lookup_elem = call i8* inttoptr (i64 1 to i8* (i64, i32*)*)(i64 %pseudo1, i32* %key)
  %map_lookup_cond = icmp ne i8* %lookup_elem, null
  br i1 %map_lookup_cond, label %lookup_success, label %lookup_failure

counter_merge:                                    ; preds = %lookup_merge, %if_body
  %11 = bitcast %printf_t* %printf_args to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %11)
  br label %if_end

lookup_success:                                   ; preds = %event_loss_counter
  %12 = bitcast i8* %lookup_elem to i64*
  %13 = atomicrmw add i64* %12, i64 1 seq_cst
  br label %lookup_merge

lookup_failure:                                   ; preds = %event_loss_counter
  br label %lookup_merge

lookup_merge:                                     ; preds = %lookup_failure, %lookup_success
  %14 = bitcast i32* %key to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %14)
  br label %counter_merge

event_loss_counter5:                              ; preds = %else_body
  %15 = bitcast i32* %key8 to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %15)
  store i32 0, i32* %key8, align 4
  %pseudo9 = call i64 @llvm.bpf.pseudo(i64 1, i64 1)
  %lookup_elem10 = call i8* inttoptr (i64 1 to i8* (i64, i32*)*)(i64 %pseudo9, i32* %key8)
  %map_lookup_cond14 = icmp ne i8* %lookup_elem10, null
  br i1 %map_lookup_cond14, label %lookup_success11, label %lookup_failure12

counter_merge6:                                   ; preds = %lookup_merge13, %else_body
  %16 = bitcast %printf_t.0* %printf_args2 to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %16)
  br label %if_end

lookup_success11:                                 ; preds = %event_loss_counter5
  %17 = bitcast i8* %lookup_elem10 to i64*
  %18 = atomicrmw add i64* %17, i64 1 seq_cst
  br label %lookup_merge13

lookup_failure12:                                 ; preds = %event_loss_counter5
  br label %lookup_merge13

lookup_merge13:                                   ; preds = %lookup_failure12, %lookup_success11
  %19 = bitcast i32* %key8 to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %19)
  br label %counter_merge6
}

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg %0, i8* nocapture %1) #1

; Function Attrs: argmemonly nofree nosync nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly %0, i8 %1, i64 %2, i1 immarg %3) #2

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg %0, i8* nocapture %1) #1

attributes #0 = { nounwind }
attributes #1 = { argmemonly nofree nosync nounwind willreturn }
attributes #2 = { argmemonly nofree nosync nounwind willreturn writeonly }
