;; NOTE: Assertions have been generated by update_lit_checks.py --all-items and should not be edited.
;; NOTE: This test was ported using port_passes_tests_to_lit.py and could be cleaned up.

;; RUN: foreach %s %t wasm-opt --remove-unused-module-elements --all-features -S -o - | filecheck %s

(module
  (memory 0)
  ;; CHECK:      (type $0 (func))

  ;; CHECK:      (type $1 (func (param i32)))

  ;; CHECK:      (type $2 (func (param i32) (result i32)))

  ;; CHECK:      (memory $0 0)

  ;; CHECK:      (table $0 1 1 funcref)

  ;; CHECK:      (elem $0 (i32.const 0) $called_indirect)

  ;; CHECK:      (export "memory" (memory $0))

  ;; CHECK:      (export "exported" (func $exported))

  ;; CHECK:      (export "other1" (func $other1))

  ;; CHECK:      (export "other2" (func $other2))

  ;; CHECK:      (start $start)
  (start $start)
  (type $0 (func))
  (type $0-dupe (func))
  (type $1 (func (param i32)))
  (type $1-dupe (func (param i32)))
  (type $2 (func (param i32) (result i32)))
  (type $2-dupe (func (param i32) (result i32)))
  (type $2-thrupe (func (param i32) (result i32)))
  (export "memory" (memory $0))
  (export "exported" $exported)
  (export "other1" $other1)
  (export "other2" $other2)
  (table 1 1 funcref)
  (elem (i32.const 0) $called_indirect)
  ;; CHECK:      (func $start (type $0)
  ;; CHECK-NEXT:  (call $called0)
  ;; CHECK-NEXT: )
  (func $start (type $0)
    (call $called0)
  )
  ;; CHECK:      (func $called0 (type $0)
  ;; CHECK-NEXT:  (call $called1)
  ;; CHECK-NEXT: )
  (func $called0 (type $0)
    (call $called1)
  )
  ;; CHECK:      (func $called1 (type $0)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $called1 (type $0)
    (nop)
  )
  ;; CHECK:      (func $called_indirect (type $0)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $called_indirect (type $0)
    (nop)
  )
  ;; CHECK:      (func $exported (type $0)
  ;; CHECK-NEXT:  (call $called2)
  ;; CHECK-NEXT: )
  (func $exported (type $0-dupe)
    (call $called2)
  )
  ;; CHECK:      (func $called2 (type $0)
  ;; CHECK-NEXT:  (call $called2)
  ;; CHECK-NEXT:  (call $called3)
  ;; CHECK-NEXT: )
  (func $called2 (type $0-dupe)
    (call $called2)
    (call $called3)
  )
  ;; CHECK:      (func $called3 (type $0)
  ;; CHECK-NEXT:  (call $called4)
  ;; CHECK-NEXT: )
  (func $called3 (type $0-dupe)
    (call $called4)
  )
  ;; CHECK:      (func $called4 (type $0)
  ;; CHECK-NEXT:  (call $called3)
  ;; CHECK-NEXT: )
  (func $called4 (type $0-dupe)
    (call $called3)
  )
  (func $remove0 (type $0-dupe)
    (call $remove1)
  )
  (func $remove1 (type $0-dupe)
    (nop)
  )
  (func $remove2 (type $0-dupe)
    (call $remove2)
  )
  (func $remove3 (type $0)
    (call $remove4)
  )
  (func $remove4 (type $0)
    (call $remove3)
  )
  ;; CHECK:      (func $other1 (type $1) (param $0 i32)
  ;; CHECK-NEXT:  (call_indirect $0 (type $0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_indirect $0 (type $0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_indirect $0 (type $0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_indirect $0 (type $0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_indirect $0 (type $1)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_indirect $0 (type $1)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (call_indirect $0 (type $2)
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (call_indirect $0 (type $2)
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (call_indirect $0 (type $2)
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $other1 (type $1) (param i32)
    (call_indirect (type $0) (i32.const 0))
    (call_indirect (type $0) (i32.const 0))
    (call_indirect (type $0-dupe) (i32.const 0))
    (call_indirect (type $0-dupe) (i32.const 0))
    (call_indirect (type $1) (i32.const 0) (i32.const 0))
    (call_indirect (type $1-dupe) (i32.const 0) (i32.const 0))
    (drop (call_indirect (type $2) (i32.const 0) (i32.const 0)))
    (drop (call_indirect (type $2-dupe) (i32.const 0) (i32.const 0)))
    (drop (call_indirect (type $2-thrupe) (i32.const 0) (i32.const 0)))
  )
  ;; CHECK:      (func $other2 (type $1) (param $0 i32)
  ;; CHECK-NEXT:  (unreachable)
  ;; CHECK-NEXT: )
  (func $other2 (type $1-dupe) (param i32)
    (unreachable)
  )
)
(module ;; remove the table and memory
  (import "env" "memory" (memory $0 256))
  (import "env" "table" (table 0 funcref))
)
(module ;; remove all tables and the memory
  (import "env" "memory" (memory $0 256))
  (import "env" "table" (table 0 funcref))
  (import "env" "table2" (table $1 1 2 funcref))
  (elem (table $1) (offset (i32.const 0)) func)
  (elem (table $1) (offset (i32.const 1)) func)
)
(module ;; remove the first table and memory, but not the second one
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (import "env" "table2" (table $1 1 1 funcref))
  (import "env" "memory" (memory $0 256))
  (import "env" "table" (table 0 funcref))
  (import "env" "table2" (table $1 1 1 funcref))
  (elem (table $1) (offset (i32.const 0)) func)
  (elem (table $1) (offset (i32.const 0)) func $f)
  ;; CHECK:      (elem $1 (i32.const 0) $f)

  ;; CHECK:      (func $f (type $none_=>_none)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $f)
)
(module ;; also when not imported
  (memory 256)
  (table 1 funcref)
)
(module ;; also with multiple tables
  (memory 256)
  (table $0 1 funcref)
  (table $1 1 funcref)
  (elem (table $1) (i32.const 0) func)
)
(module ;; but not when exported
  ;; CHECK:      (import "env" "memory" (memory $0 256))
  (import "env" "memory" (memory $0 256))
  ;; CHECK:      (import "env" "table" (table $timport$0 1 funcref))
  (import "env" "table" (table 1 funcref))
  ;; CHECK:      (export "mem" (memory $0))
  (export "mem" (memory 0))
  ;; CHECK:      (export "tab" (table $timport$0))
  (export "tab" (table 0))
)
(module ;; and not when there are segments
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (import "env" "memory" (memory $0 256))
  (import "env" "memory" (memory $0 256))
  ;; CHECK:      (import "env" "table" (table $timport$0 1 funcref))
  (import "env" "table" (table 1 funcref))
  (data (i32.const 1) "hello, world!")
  (elem (i32.const 0) $waka)
  ;; CHECK:      (data $0 (i32.const 1) "hello, world!")

  ;; CHECK:      (elem $0 (i32.const 0) $waka)

  ;; CHECK:      (func $waka (type $none_=>_none)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $waka)
)
(module ;; and not when used
  ;; CHECK:      (type $0 (func))
  (type $0 (func))
  ;; CHECK:      (import "env" "memory" (memory $0 256))
  (import "env" "memory" (memory $0 256))
  ;; CHECK:      (import "env" "table" (table $timport$0 0 funcref))
  (import "env" "table" (table 0 funcref))
  ;; CHECK:      (export "user" (func $user))
  (export "user" $user)
  ;; CHECK:      (func $user (type $0)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.load
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (call_indirect $timport$0 (type $0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $user
    (drop (i32.load (i32.const 0)))
    (call_indirect (type $0) (i32.const 0))
  )
)
(module ;; more use checks
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (memory $0 (shared 23 256))
  (memory $0 (shared 23 256))
  ;; CHECK:      (export "user" (func $user))
  (export "user" $user)
  ;; CHECK:      (func $user (type $none_=>_none)
  ;; CHECK-NEXT:  (i32.store
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $user
    (i32.store (i32.const 0) (i32.const 0))
  )
)
(module ;; more use checks
  ;; CHECK:      (type $none_=>_i32 (func (result i32)))

  ;; CHECK:      (memory $0 (shared 23 256))
  (memory $0 (shared 23 256))
  ;; CHECK:      (export "user" (func $user))
  (export "user" $user)
  ;; CHECK:      (func $user (type $none_=>_i32) (result i32)
  ;; CHECK-NEXT:  (i32.atomic.rmw.add
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $user (result i32)
    (i32.atomic.rmw.add (i32.const 0) (i32.const 0))
  )
)
(module ;; more use checks
  ;; CHECK:      (type $none_=>_i32 (func (result i32)))

  ;; CHECK:      (memory $0 (shared 23 256))
  (memory $0 (shared 23 256))
  ;; CHECK:      (export "user" (func $user))
  (export "user" $user)
  ;; CHECK:      (func $user (type $none_=>_i32) (result i32)
  ;; CHECK-NEXT:  (i32.atomic.rmw8.cmpxchg_u
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $user (result i32)
    (i32.atomic.rmw8.cmpxchg_u (i32.const 0) (i32.const 0) (i32.const 0))
  )
)
(module ;; more use checks
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (memory $0 (shared 23 256))
  (memory $0 (shared 23 256))
  ;; CHECK:      (export "user" (func $user))
  (export "user" $user)
  ;; CHECK:      (func $user (type $none_=>_none)
  ;; CHECK-NEXT:  (local $0 i32)
  ;; CHECK-NEXT:  (local $1 i64)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (memory.atomic.wait32
  ;; CHECK-NEXT:    (local.get $0)
  ;; CHECK-NEXT:    (local.get $0)
  ;; CHECK-NEXT:    (local.get $1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $user
    (local $0 i32)
    (local $1 i64)
    (drop
     (memory.atomic.wait32
      (local.get $0)
      (local.get $0)
      (local.get $1)
     )
    )
  )
)
(module ;; more use checks
  ;; CHECK:      (type $none_=>_i32 (func (result i32)))

  ;; CHECK:      (memory $0 (shared 23 256))
  (memory $0 (shared 23 256))
  ;; CHECK:      (export "user" (func $user))
  (export "user" $user)
  ;; CHECK:      (func $user (type $none_=>_i32) (result i32)
  ;; CHECK-NEXT:  (memory.atomic.notify
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $user (result i32)
    (memory.atomic.notify (i32.const 0) (i32.const 0))
  )
)
(module ;; atomic.fence and data.drop do not use a memory, so should not keep the memory alive.
  (memory $0 (shared 1 1))
  (data "")
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (data $0 "")

  ;; CHECK:      (export "fake-user" (func $user))
  (export "fake-user" $user)
  ;; CHECK:      (func $user (type $none_=>_none)
  ;; CHECK-NEXT:  (atomic.fence)
  ;; CHECK-NEXT:  (data.drop $0)
  ;; CHECK-NEXT: )
  (func $user
    (atomic.fence)
    (data.drop 0)
  )
)
(module ;; more use checks
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (import "env" "mem" (memory $0 256))
  (import "env" "mem" (memory $0 256))
  ;; CHECK:      (memory $1 23 256)
  (memory $1 23 256)
  (memory $unused 1 1)

  ;; CHECK:      (export "user" (func $user))
  (export "user" $user)
  ;; CHECK:      (func $user (type $none_=>_none)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (memory.grow $0
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (memory.grow $1
  ;; CHECK-NEXT:    (i32.const 0)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $user
    (drop (memory.grow $0 (i32.const 0)))
    (drop (memory.grow $1 (i32.const 0)))
  )
)
(module ;; more use checks
  ;; CHECK:      (type $none_=>_i32 (func (result i32)))

  ;; CHECK:      (memory $0 23 256)
  (memory $0 23 256)
  ;; CHECK:      (export "user" (func $user))
  (export "user" $user)
  ;; CHECK:      (func $user (type $none_=>_i32) (result i32)
  ;; CHECK-NEXT:  (memory.size)
  ;; CHECK-NEXT: )
  (func $user (result i32)
    (memory.size)
  )
)
(module ;; memory.copy should keep both memories alive
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (memory $0 1 1)
  (memory $0 1 1)
  ;; CHECK:      (memory $1 1 1)
  (memory $1 1 1)
  (memory $unused 1 1)
  ;; CHECK:      (export "user" (func $user))
  (export "user" $user)
  ;; CHECK:      (func $user (type $none_=>_none)
  ;; CHECK-NEXT:  (memory.copy $0 $1
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $user
    (memory.copy $0 $1
      (i32.const 0)
      (i32.const 0)
      (i32.const 0)
    )
  )
)
(module
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (import "env" "memory" (memory $0 256))
  (import "env" "memory" (memory $0 256))
  ;; CHECK:      (import "env" "table" (table $timport$0 0 funcref))
  (import "env" "table" (table 0 funcref))
  ;; CHECK:      (import "env" "memoryBase" (global $memoryBase i32))
  (import "env" "memoryBase" (global $memoryBase i32)) ;; used in init
  ;; CHECK:      (import "env" "tableBase" (global $tableBase i32))
  (import "env" "tableBase" (global $tableBase i32)) ;; used in init
  (data (global.get $memoryBase) "hello, world!")
  (elem (global.get $tableBase) $waka)
  ;; CHECK:      (data $0 (global.get $memoryBase) "hello, world!")

  ;; CHECK:      (elem $0 (global.get $tableBase) $waka)

  ;; CHECK:      (func $waka (type $none_=>_none)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT: )
  (func $waka) ;; used in table
)
(module ;; one is exported, and one->two->int global, whose init->imported
  ;; CHECK:      (type $none_=>_i32 (func (result i32)))

  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (type $i32_=>_i32 (func (param i32) (result i32)))

  ;; CHECK:      (import "env" "imported" (global $imported i32))
  (import "env" "imported" (global $imported i32))
  ;; CHECK:      (import "env" "_puts" (func $_puts (type $i32_=>_i32) (param i32) (result i32)))
  (import "env" "forgetme" (global $forgetme i32))
  (import "env" "_puts" (func $_puts (param i32) (result i32)))
  (import "env" "forget_puts" (func $forget_puts (param i32) (result i32)))
  ;; CHECK:      (global $int (mut i32) (global.get $imported))
  (global $int (mut i32) (global.get $imported))
  ;; CHECK:      (global $set (mut i32) (i32.const 100))
  (global $set (mut i32) (i32.const 100))
  (global $forglobal.get (mut i32) (i32.const 500))
  ;; CHECK:      (global $exp_glob i32 (i32.const 600))
  (global $exp_glob i32 (i32.const 600))
  ;; CHECK:      (export "one" (func $one))
  (export "one" (func $one))
  ;; CHECK:      (export "three" (func $three))
  (export "three" (func $three))
  ;; CHECK:      (export "exp_glob" (global $exp_glob))
  (export "exp_glob" (global $exp_glob))
  (start $starter)
  ;; CHECK:      (func $one (type $none_=>_i32) (result i32)
  ;; CHECK-NEXT:  (call $two)
  ;; CHECK-NEXT: )
  (func $one (result i32)
    (call $two)
  )
  ;; CHECK:      (func $two (type $none_=>_i32) (result i32)
  ;; CHECK-NEXT:  (global.get $int)
  ;; CHECK-NEXT: )
  (func $two (result i32)
    (global.get $int)
  )
  ;; CHECK:      (func $three (type $none_=>_none)
  ;; CHECK-NEXT:  (call $four)
  ;; CHECK-NEXT: )
  (func $three
    (call $four)
  )
  ;; CHECK:      (func $four (type $none_=>_none)
  ;; CHECK-NEXT:  (global.set $set
  ;; CHECK-NEXT:   (i32.const 200)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (call $_puts
  ;; CHECK-NEXT:    (i32.const 300)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $four
    (global.set $set (i32.const 200))
    (drop (call $_puts (i32.const 300)))
  )
  (func $forget_implemented
    (nop)
  )
  (func $starter
    (nop)
  )
)
(module ;; empty start being removed
  (start $starter)
  (func $starter
    (nop)
  )
)
(module ;; non-empty start being kept
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (start $starter)
  (start $starter)
  ;; CHECK:      (func $starter (type $none_=>_none)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 0)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $starter
    (drop (i32.const 0))
  )
)
(module ;; imported start cannot be removed
  ;; CHECK:      (type $none_=>_none (func))

  ;; CHECK:      (import "env" "start" (func $start (type $none_=>_none)))
  (import "env" "start" (func $start))
  ;; CHECK:      (start $start)
  (start $start)
)
(module ;; the function and the table can be removed
 (type $0 (func (param f64) (result f64)))
 (table 6 6 funcref)
 (func $0 (; 0 ;) (type $0) (param $var$0 f64) (result f64)
  (if (result f64)
   (f64.eq
    (f64.const 1)
    (f64.const 1)
   )
   (f64.const 1)
   (f64.const 0)
  )
 )
)
(module ;; the function uses the table, but all are removeable
 (type $0 (func (param f64) (result f64)))
 (table 6 6 funcref)
 (func $0 (; 0 ;) (type $0) (param $var$0 f64) (result f64)
  (if (result f64)
   (f64.eq
    (f64.const 1)
    (f64.const 1)
   )
   (call_indirect (type $0) (f64.const 1) (i32.const 0))
   (f64.const 0)
  )
 )
)
(module
 ;; We import two tables and have an active segment that writes to one of them.
 ;; We must keep that table and the segment, but we can remove the other table.
 ;; CHECK:      (type $0 (func (param f64) (result f64)))
 (type $0 (func (param f64) (result f64)))

 ;; CHECK:      (import "env" "written" (table $written 6 6 funcref))
 (import "env" "written" (table $written 6 6 funcref))

 (import "env" "unwritten" (table $unwritten 6 6 funcref))

 (table $defined-unused 6 6 funcref)

 ;; CHECK:      (table $defined-used 6 6 funcref)
 (table $defined-used 6 6 funcref)

 ;; CHECK:      (elem $active1 (table $written) (i32.const 0) func $0)
 (elem $active1 (table $written) (i32.const 0) $0)

 ;; This empty active segment doesn't keep the unwritten table alive.
 (elem $active2 (table $unwritten) (i32.const 0))

 (elem $active3 (table $defined-unused) (i32.const 0) $0)

 ;; CHECK:      (elem $active4 (table $defined-used) (i32.const 0) func $0)
 (elem $active4 (table $defined-used) (i32.const 0) $0)

 (elem $active5 (table $defined-used) (i32.const 0))
 ;; CHECK:      (func $0 (type $0) (param $var$0 f64) (result f64)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (table.get $defined-used
 ;; CHECK-NEXT:    (i32.const 0)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT:  (if (result f64)
 ;; CHECK-NEXT:   (f64.eq
 ;; CHECK-NEXT:    (f64.const 1)
 ;; CHECK-NEXT:    (f64.const 1)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:   (f64.const 1)
 ;; CHECK-NEXT:   (f64.const 0)
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $0 (; 0 ;) (type $0) (param $var$0 f64) (result f64)
  (drop
   (table.get $defined-used
    (i32.const 0)
   )
  )
  (if (result f64)
   (f64.eq
    (f64.const 1)
    (f64.const 1)
   )
   (f64.const 1)
   (f64.const 0)
  )
 )
)
(module
 ;; The same thing works for memories with active segments.
 ;; CHECK:      (type $none_=>_none (func))

 ;; CHECK:      (import "env" "written" (memory $written 1 1))
 (import "env" "written" (memory $written 1 1))

 (import "env" "unwritten" (memory $unwritten 1 1))

 (memory $defined-unused 1 1)

 ;; CHECK:      (memory $defined-used 1 1)
 (memory $defined-used 1 1)

 ;; CHECK:      (data $active1 (i32.const 0) "foobar")
 (data $active1 (memory $written) (i32.const 0) "foobar")

 (data $active2 (memory $unwritten) (i32.const 0) "")

 (data $active3 (memory $defined-unused) (i32.const 0) "hello")

 ;; CHECK:      (data $active4 (memory $defined-used) (i32.const 0) "hello")
 (data $active4 (memory $defined-used) (i32.const 0) "hello")

 (data $active5 (memory $defined-used) (i32.const 0) "")

 ;; CHECK:      (export "user" (func $user))

 ;; CHECK:      (func $user (type $none_=>_none)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (i32.load $defined-used
 ;; CHECK-NEXT:    (i32.const 0)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $user (export "user")
  (drop
   (i32.load $defined-used
    (i32.const 0)
   )
  )
 )
)
(module
 ;; Nothing should break if the unused segments precede the used segments.
 ;; CHECK:      (type $none_=>_none (func))

 ;; CHECK:      (type $array (array funcref))
 (type $array (array funcref))

 (memory $mem 1 1)
 (table $tab 1 1 funcref)

 (data $unused "")
 (elem $unused func)

 ;; CHECK:      (data $used "")
 (data $used "")
 ;; CHECK:      (elem $used func)
 (elem $used func)

 ;; CHECK:      (export "user" (func $user))

 ;; CHECK:      (func $user (type $none_=>_none)
 ;; CHECK-NEXT:  (data.drop $used)
 ;; CHECK-NEXT:  (drop
 ;; CHECK-NEXT:   (array.new_elem $array $used
 ;; CHECK-NEXT:    (i32.const 0)
 ;; CHECK-NEXT:    (i32.const 0)
 ;; CHECK-NEXT:   )
 ;; CHECK-NEXT:  )
 ;; CHECK-NEXT: )
 (func $user (export "user")
  (data.drop 1)
  (drop
   (array.new_elem $array 1
    (i32.const 0)
    (i32.const 0)
    (i32.const 0)
   )
  )
 )
)
;; SIMD operations can keep memories alive
(module
 ;; CHECK:      (type $none_=>_none (func))

 ;; CHECK:      (memory $A 1 1)
 (memory $A 1 1)
 ;; CHECK:      (memory $B 1 1)
 (memory $B 1 1)
 (memory $C-unused 1 1)

 (func "func"
  (drop
   (v128.load64_splat $A
    (i32.const 0)
   )
  )
  (drop
   (v128.load16_lane $B 0
    (i32.const 0)
    (v128.const i32x4 0 0 0 0)
   )
  )
 )
)
;; CHECK:      (export "func" (func $0))

;; CHECK:      (func $0 (type $none_=>_none)
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (v128.load64_splat $A
;; CHECK-NEXT:    (i32.const 0)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT:  (drop
;; CHECK-NEXT:   (v128.load16_lane $B 0
;; CHECK-NEXT:    (i32.const 0)
;; CHECK-NEXT:    (v128.const i32x4 0x00000000 0x00000000 0x00000000 0x00000000)
;; CHECK-NEXT:   )
;; CHECK-NEXT:  )
;; CHECK-NEXT: )
