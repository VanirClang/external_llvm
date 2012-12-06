; RUN: llc -o - -march thumb \
; RUN:     -arm-enable-ehabi -arm-enable-ehabi-descriptors %s\
; RUN:   | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:64:128-a0:0:32-n32-S64"
target triple = "thumb-none-linux-androideabi"

%class.Stream = type { i8 }

define zeroext i1 @_Z8is_errori(i32 %ch) nounwind readnone {
entry:
  %cmp = icmp eq i32 %ch, -1
  ret i1 %cmp
}

define zeroext i1 @_Z4testP6StreamS0_(%class.Stream* %f, %class.Stream* %t) {
entry:
  br label %for.cond

for.cond:                                         ; preds = %invoke.cont9, %entry
  %result.0 = phi i8 [ 0, %entry ], [ 1, %invoke.cont9 ]
  %call3 = invoke i32 @_ZN6Stream4getcEv(%class.Stream* %f)
          to label %invoke.cont2 unwind label %lpad1

invoke.cont2:                                     ; preds = %for.cond
  %cmp.i = icmp eq i32 %call3, -1
  br i1 %cmp.i, label %for.end.thread, label %if.end

lpad:                                             ; preds = %if.then.i.i
  %0 = landingpad { i8*, i32 } personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*)
          catch i8* null
  %1 = extractvalue { i8*, i32 } %0, 0
  br label %catch20

lpad1:                                            ; preds = %for.cond
  %2 = landingpad { i8*, i32 } personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*)
          catch i8* null
  %3 = extractvalue { i8*, i32 } %2, 0
  %4 = tail call i8* @__cxa_begin_catch(i8* %3) nounwind
  invoke void @__cxa_end_catch()
          to label %for.end.thread unwind label %lpad4.thread

lpad4.thread:                                     ; preds = %lpad1
  %5 = landingpad { i8*, i32 } personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*)
          catch i8* null
  %6 = extractvalue { i8*, i32 } %5, 0
  %extract.t2541 = icmp ne i8 %result.0, 0
  br label %catch20

; CHECK: lpad4.thread
; CHECK: ands r7, r1
; CHECK: movs r4, #1
; CHECK: cmp r7
; CHECK: bne
; CHECK: mov r4, r7

if.then.i.i37:                                    ; preds = %if.end
  %7 = landingpad { i8*, i32 } personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*)
          catch i8* null
  %8 = extractvalue { i8*, i32 } %7, 0
  %extract.t2545 = icmp ne i8 %result.0, 0
  %call.i.i39 = invoke i32 @_ZN6Stream4putcEi(%class.Stream* %f, i32 %call3)
          to label %catch20 unwind label %terminate.lpad

if.end:                                           ; preds = %invoke.cont2
  %call10 = invoke i32 @_ZN6Stream4putcEi(%class.Stream* %t, i32 %call3)
          to label %invoke.cont9 unwind label %if.then.i.i37

invoke.cont9:                                     ; preds = %if.end
  %cmp.i31 = icmp eq i32 %call10, -1
  br i1 %cmp.i31, label %if.then.i.i, label %for.cond

for.end.thread:                                   ; preds = %invoke.cont2, %lpad1
  %extract.t48 = icmp ne i8 %result.0, 0
  br label %try.cont22

if.then.i.i:                                      ; preds = %invoke.cont9
  %extract.t52 = icmp ne i8 %result.0, 0
  %call.i.i30 = invoke i32 @_ZN6Stream4putcEi(%class.Stream* %f, i32 %call3)
          to label %try.cont22 unwind label %lpad

catch20:                                          ; preds = %lpad4.thread, %if.then.i.i37, %lpad
  %result.2.off0 = phi i1 [ %extract.t52, %lpad ], [ %extract.t2541, %lpad4.thread ], [ %extract.t2545, %if.then.i.i37 ]
  %exn.slot.0 = phi i8* [ %1, %lpad ], [ %6, %lpad4.thread ], [ %8, %if.then.i.i37 ]
  %9 = tail call i8* @__cxa_begin_catch(i8* %exn.slot.0) nounwind
  tail call void @__cxa_end_catch()
  br label %try.cont22

try.cont22:                                       ; preds = %for.end.thread, %if.then.i.i, %catch20
  %result.3.off0 = phi i1 [ %result.2.off0, %catch20 ], [ %extract.t48, %for.end.thread ], [ %extract.t52, %if.then.i.i ]
  ret i1 %result.3.off0

terminate.lpad:                                   ; preds = %if.then.i.i37
  %10 = landingpad { i8*, i32 } personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*)
          catch i8* null
  tail call void @_ZSt9terminatev() noreturn nounwind
  unreachable
}

declare i32 @__gxx_personality_v0(...)

declare i32 @_ZN6Stream4getcEv(%class.Stream*)

declare i8* @__cxa_begin_catch(i8*)

declare void @__cxa_end_catch()

declare i32 @_ZN6Stream4putcEi(%class.Stream*, i32)

declare void @_ZSt9terminatev()
