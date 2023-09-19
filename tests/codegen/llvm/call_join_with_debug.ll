; ModuleID = 'bpftrace'
source_filename = "bpftrace"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf-pc-linux"

; Function Attrs: nounwind
declare i64 @llvm.bpf.pseudo(i64 %0, i64 %1) #0

define i64 @"kprobe:f"(i8* %0) section "s_kprobe:f_1" {
entry:
  %key = alloca i32, align 4
  %join_r0 = alloca i64, align 8
  %fmt_str = alloca [70 x i8], align 1
  %lookup_join_key = alloca i32, align 4
  %"struct arg.argv" = alloca i64, align 8
  %lookup_elem_val = alloca i64, align 8
  %"@x_key1" = alloca i64, align 8
  %"@x_ptr" = alloca i64, align 8
  %"@x_key" = alloca i64, align 8
  %1 = bitcast i64* %"@x_key" to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %1)
  store i64 0, i64* %"@x_key", align 8
  %2 = bitcast i64* %"@x_ptr" to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %2)
  store i64 0, i64* %"@x_ptr", align 8
  %pseudo = call i64 @llvm.bpf.pseudo(i64 1, i64 0)
  %update_elem = call i64 inttoptr (i64 2 to i64 (i64, i64*, i64*, i64)*)(i64 %pseudo, i64* %"@x_key", i64* %"@x_ptr", i64 0)
  %3 = bitcast i64* %"@x_ptr" to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %3)
  %4 = bitcast i64* %"@x_key" to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %4)
  %5 = bitcast i64* %"@x_key1" to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %5)
  store i64 0, i64* %"@x_key1", align 8
  %pseudo2 = call i64 @llvm.bpf.pseudo(i64 1, i64 0)
  %lookup_elem = call i8* inttoptr (i64 1 to i8* (i64, i64*)*)(i64 %pseudo2, i64* %"@x_key1")
  %6 = bitcast i64* %lookup_elem_val to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %6)
  %map_lookup_cond = icmp ne i8* %lookup_elem, null
  br i1 %map_lookup_cond, label %lookup_success, label %lookup_failure

lookup_success:                                   ; preds = %entry
  %cast = bitcast i8* %lookup_elem to i64*
  %7 = load i64, i64* %cast, align 8
  store i64 %7, i64* %lookup_elem_val, align 8
  br label %lookup_merge

lookup_failure:                                   ; preds = %entry
  store i64 0, i64* %lookup_elem_val, align 8
  br label %lookup_merge

lookup_merge:                                     ; preds = %lookup_failure, %lookup_success
  %8 = load i64, i64* %lookup_elem_val, align 8
  %9 = bitcast i64* %lookup_elem_val to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %9)
  %10 = bitcast i64* %"@x_key1" to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %10)
  %11 = add i64 %8, 0
  %12 = bitcast i64* %"struct arg.argv" to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %12)
  %probe_read_kernel = call i64 inttoptr (i64 113 to i64 (i64*, i32, i64)*)(i64* %"struct arg.argv", i32 8, i64 %11)
  %13 = load i64, i64* %"struct arg.argv", align 8
  %14 = bitcast i64* %"struct arg.argv" to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %14)
  %15 = bitcast i32* %lookup_join_key to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %15)
  store i32 0, i32* %lookup_join_key, align 4
  %pseudo3 = call i64 @llvm.bpf.pseudo(i64 1, i64 1)
  %lookup_join_map = call i8* inttoptr (i64 1 to i8* (i64, i32*)*)(i64 %pseudo3, i32* %lookup_join_key)
  %16 = bitcast i32* %lookup_join_key to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %16)
  %lookup_join_cond = icmp ne i8* %lookup_join_map, null
  br i1 %lookup_join_cond, label %lookup_joinsuccess, label %lookup_joinfailure

failure_callback:                                 ; preds = %counter_merge, %lookup_joinfailure
  ret i64 0

lookup_joinsuccess:                               ; preds = %lookup_merge
  br label %lookup_join_merge

lookup_joinfailure:                               ; preds = %lookup_merge
  %17 = bitcast [70 x i8]* %fmt_str to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %17)
  %18 = bitcast [70 x i8]* %fmt_str to i8*
  call void @llvm.memset.p0i8.i64(i8* align 1 %18, i8 0, i64 70, i1 false)
  store [70 x i8] c"[BPFTRACE_DEBUG_OUTPUT] unable to find the scratch map value for join\00", [70 x i8]* %fmt_str, align 1
  %19 = bitcast [70 x i8]* %fmt_str to i8*
  %trace_printk = call i64 (i8*, i32, ...) inttoptr (i64 6 to i64 (i8*, i32, ...)*)(i8* %19, i32 70)
  br label %failure_callback

lookup_join_merge:                                ; preds = %lookup_joinsuccess
  %20 = bitcast i8* %lookup_join_map to i64*
  store i64 30005, i64* %20, align 8
  %21 = getelementptr i8, i8* %lookup_join_map, i64 8
  %22 = bitcast i8* %21 to i64*
  store i64 0, i64* %22, align 8
  %23 = bitcast i64* %join_r0 to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %23)
  %probe_read_kernel4 = call i64 inttoptr (i64 113 to i64 (i64*, i32, i64)*)(i64* %join_r0, i32 8, i64 %13)
  %24 = load i64, i64* %join_r0, align 8
  %25 = getelementptr i8, i8* %lookup_join_map, i64 16
  %probe_read_kernel_str = call i64 inttoptr (i64 115 to i64 (i8*, i32, i64)*)(i8* %25, i32 1024, i64 %24)
  %26 = add i64 %13, 8
  %probe_read_kernel5 = call i64 inttoptr (i64 113 to i64 (i64*, i32, i64)*)(i64* %join_r0, i32 8, i64 %26)
  %27 = load i64, i64* %join_r0, align 8
  %28 = getelementptr i8, i8* %lookup_join_map, i64 1040
  %probe_read_kernel_str6 = call i64 inttoptr (i64 115 to i64 (i8*, i32, i64)*)(i8* %28, i32 1024, i64 %27)
  %29 = add i64 %26, 8
  %probe_read_kernel7 = call i64 inttoptr (i64 113 to i64 (i64*, i32, i64)*)(i64* %join_r0, i32 8, i64 %29)
  %30 = load i64, i64* %join_r0, align 8
  %31 = getelementptr i8, i8* %lookup_join_map, i64 2064
  %probe_read_kernel_str8 = call i64 inttoptr (i64 115 to i64 (i8*, i32, i64)*)(i8* %31, i32 1024, i64 %30)
  %32 = add i64 %29, 8
  %probe_read_kernel9 = call i64 inttoptr (i64 113 to i64 (i64*, i32, i64)*)(i64* %join_r0, i32 8, i64 %32)
  %33 = load i64, i64* %join_r0, align 8
  %34 = getelementptr i8, i8* %lookup_join_map, i64 3088
  %probe_read_kernel_str10 = call i64 inttoptr (i64 115 to i64 (i8*, i32, i64)*)(i8* %34, i32 1024, i64 %33)
  %35 = add i64 %32, 8
  %probe_read_kernel11 = call i64 inttoptr (i64 113 to i64 (i64*, i32, i64)*)(i64* %join_r0, i32 8, i64 %35)
  %36 = load i64, i64* %join_r0, align 8
  %37 = getelementptr i8, i8* %lookup_join_map, i64 4112
  %probe_read_kernel_str12 = call i64 inttoptr (i64 115 to i64 (i8*, i32, i64)*)(i8* %37, i32 1024, i64 %36)
  %38 = add i64 %35, 8
  %probe_read_kernel13 = call i64 inttoptr (i64 113 to i64 (i64*, i32, i64)*)(i64* %join_r0, i32 8, i64 %38)
  %39 = load i64, i64* %join_r0, align 8
  %40 = getelementptr i8, i8* %lookup_join_map, i64 5136
  %probe_read_kernel_str14 = call i64 inttoptr (i64 115 to i64 (i8*, i32, i64)*)(i8* %40, i32 1024, i64 %39)
  %41 = add i64 %38, 8
  %probe_read_kernel15 = call i64 inttoptr (i64 113 to i64 (i64*, i32, i64)*)(i64* %join_r0, i32 8, i64 %41)
  %42 = load i64, i64* %join_r0, align 8
  %43 = getelementptr i8, i8* %lookup_join_map, i64 6160
  %probe_read_kernel_str16 = call i64 inttoptr (i64 115 to i64 (i8*, i32, i64)*)(i8* %43, i32 1024, i64 %42)
  %44 = add i64 %41, 8
  %probe_read_kernel17 = call i64 inttoptr (i64 113 to i64 (i64*, i32, i64)*)(i64* %join_r0, i32 8, i64 %44)
  %45 = load i64, i64* %join_r0, align 8
  %46 = getelementptr i8, i8* %lookup_join_map, i64 7184
  %probe_read_kernel_str18 = call i64 inttoptr (i64 115 to i64 (i8*, i32, i64)*)(i8* %46, i32 1024, i64 %45)
  %47 = add i64 %44, 8
  %probe_read_kernel19 = call i64 inttoptr (i64 113 to i64 (i64*, i32, i64)*)(i64* %join_r0, i32 8, i64 %47)
  %48 = load i64, i64* %join_r0, align 8
  %49 = getelementptr i8, i8* %lookup_join_map, i64 8208
  %probe_read_kernel_str20 = call i64 inttoptr (i64 115 to i64 (i8*, i32, i64)*)(i8* %49, i32 1024, i64 %48)
  %50 = add i64 %47, 8
  %probe_read_kernel21 = call i64 inttoptr (i64 113 to i64 (i64*, i32, i64)*)(i64* %join_r0, i32 8, i64 %50)
  %51 = load i64, i64* %join_r0, align 8
  %52 = getelementptr i8, i8* %lookup_join_map, i64 9232
  %probe_read_kernel_str22 = call i64 inttoptr (i64 115 to i64 (i8*, i32, i64)*)(i8* %52, i32 1024, i64 %51)
  %53 = add i64 %50, 8
  %probe_read_kernel23 = call i64 inttoptr (i64 113 to i64 (i64*, i32, i64)*)(i64* %join_r0, i32 8, i64 %53)
  %54 = load i64, i64* %join_r0, align 8
  %55 = getelementptr i8, i8* %lookup_join_map, i64 10256
  %probe_read_kernel_str24 = call i64 inttoptr (i64 115 to i64 (i8*, i32, i64)*)(i8* %55, i32 1024, i64 %54)
  %56 = add i64 %53, 8
  %probe_read_kernel25 = call i64 inttoptr (i64 113 to i64 (i64*, i32, i64)*)(i64* %join_r0, i32 8, i64 %56)
  %57 = load i64, i64* %join_r0, align 8
  %58 = getelementptr i8, i8* %lookup_join_map, i64 11280
  %probe_read_kernel_str26 = call i64 inttoptr (i64 115 to i64 (i8*, i32, i64)*)(i8* %58, i32 1024, i64 %57)
  %59 = add i64 %56, 8
  %probe_read_kernel27 = call i64 inttoptr (i64 113 to i64 (i64*, i32, i64)*)(i64* %join_r0, i32 8, i64 %59)
  %60 = load i64, i64* %join_r0, align 8
  %61 = getelementptr i8, i8* %lookup_join_map, i64 12304
  %probe_read_kernel_str28 = call i64 inttoptr (i64 115 to i64 (i8*, i32, i64)*)(i8* %61, i32 1024, i64 %60)
  %62 = add i64 %59, 8
  %probe_read_kernel29 = call i64 inttoptr (i64 113 to i64 (i64*, i32, i64)*)(i64* %join_r0, i32 8, i64 %62)
  %63 = load i64, i64* %join_r0, align 8
  %64 = getelementptr i8, i8* %lookup_join_map, i64 13328
  %probe_read_kernel_str30 = call i64 inttoptr (i64 115 to i64 (i8*, i32, i64)*)(i8* %64, i32 1024, i64 %63)
  %65 = add i64 %62, 8
  %probe_read_kernel31 = call i64 inttoptr (i64 113 to i64 (i64*, i32, i64)*)(i64* %join_r0, i32 8, i64 %65)
  %66 = load i64, i64* %join_r0, align 8
  %67 = getelementptr i8, i8* %lookup_join_map, i64 14352
  %probe_read_kernel_str32 = call i64 inttoptr (i64 115 to i64 (i8*, i32, i64)*)(i8* %67, i32 1024, i64 %66)
  %68 = add i64 %65, 8
  %probe_read_kernel33 = call i64 inttoptr (i64 113 to i64 (i64*, i32, i64)*)(i64* %join_r0, i32 8, i64 %68)
  %69 = load i64, i64* %join_r0, align 8
  %70 = getelementptr i8, i8* %lookup_join_map, i64 15376
  %probe_read_kernel_str34 = call i64 inttoptr (i64 115 to i64 (i8*, i32, i64)*)(i8* %70, i32 1024, i64 %69)
  %pseudo35 = call i64 @llvm.bpf.pseudo(i64 1, i64 2)
  %ringbuf_output = call i64 inttoptr (i64 130 to i64 (i64, i8*, i64, i64)*)(i64 %pseudo35, i8* %lookup_join_map, i64 16400, i64 0)
  %ringbuf_loss = icmp slt i64 %ringbuf_output, 0
  br i1 %ringbuf_loss, label %event_loss_counter, label %counter_merge

event_loss_counter:                               ; preds = %lookup_join_merge
  %71 = bitcast i32* %key to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %71)
  store i32 0, i32* %key, align 4
  %pseudo36 = call i64 @llvm.bpf.pseudo(i64 1, i64 3)
  %lookup_elem37 = call i8* inttoptr (i64 1 to i8* (i64, i32*)*)(i64 %pseudo36, i32* %key)
  %map_lookup_cond41 = icmp ne i8* %lookup_elem37, null
  br i1 %map_lookup_cond41, label %lookup_success38, label %lookup_failure39

counter_merge:                                    ; preds = %lookup_merge40, %lookup_join_merge
  br label %failure_callback

lookup_success38:                                 ; preds = %event_loss_counter
  %72 = bitcast i8* %lookup_elem37 to i64*
  %73 = atomicrmw add i64* %72, i64 1 seq_cst
  br label %lookup_merge40

lookup_failure39:                                 ; preds = %event_loss_counter
  br label %lookup_merge40

lookup_merge40:                                   ; preds = %lookup_failure39, %lookup_success38
  %74 = bitcast i32* %key to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %74)
  br label %counter_merge
}

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg %0, i8* nocapture %1) #1

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg %0, i8* nocapture %1) #1

; Function Attrs: argmemonly nofree nosync nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly %0, i8 %1, i64 %2, i1 immarg %3) #2

attributes #0 = { nounwind }
attributes #1 = { argmemonly nofree nosync nounwind willreturn }
attributes #2 = { argmemonly nofree nosync nounwind willreturn writeonly }
