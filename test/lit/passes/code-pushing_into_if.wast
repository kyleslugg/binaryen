;; NOTE: Assertions have been generated by update_lit_checks.py and should not be edited.
;; RUN: wasm-opt %s --code-pushing -all -S -o - | filecheck %s

(module
  ;; CHECK:      (import "binaryen-intrinsics" "call.without.effects" (func $call.without.effects (type $i32_funcref_=>_i32) (param i32 funcref) (result i32)))
  (import "binaryen-intrinsics" "call.without.effects" (func $call.without.effects (param i32 funcref) (result i32)))

  ;; CHECK:      (func $if-nop (type $i32_=>_none) (param $p i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:   (nop)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $if-nop (param $p i32)
    (local $x i32)
    ;; The set local is not used in any if arm; do nothing.
    (local.set $x (i32.const 1))
    (if
      (local.get $p)
      (nop)
    )
  )

  ;; CHECK:      (func $if-nop-nop (type $i32_=>_none) (param $p i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:   (nop)
  ;; CHECK-NEXT:   (nop)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $if-nop-nop (param $p i32)
    (local $x i32)
    (local.set $x (i32.const 1))
    (if
      (local.get $p)
      (nop)
      (nop) ;; add a nop here compared to the last testcase (no output change)
    )
  )

  ;; CHECK:      (func $if-use (type $i32_=>_none) (param $p i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:   (block
  ;; CHECK-NEXT:    (local.set $x
  ;; CHECK-NEXT:     (i32.const 1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.get $x)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $if-use (param $p i32)
    (local $x i32)
    ;; The set local is used in one arm and nowhere else; push it there.
    (local.set $x (i32.const 1))
    (if
      (local.get $p)
      (drop (local.get $x))
    )
  )

  ;; CHECK:      (func $if-use-nop (type $i32_=>_none) (param $p i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:   (block
  ;; CHECK-NEXT:    (local.set $x
  ;; CHECK-NEXT:     (i32.const 1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.get $x)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (nop)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $if-use-nop (param $p i32)
    (local $x i32)
    (local.set $x (i32.const 1))
    (if
      (local.get $p)
      (drop (local.get $x))
      (nop) ;; add a nop here compared to the last testcase (no output change)
    )
  )

  ;; CHECK:      (func $if-else-use (type $i32_=>_none) (param $p i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:   (nop)
  ;; CHECK-NEXT:   (block
  ;; CHECK-NEXT:    (local.set $x
  ;; CHECK-NEXT:     (i32.const 1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.get $x)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $if-else-use (param $p i32)
    (local $x i32)
    ;; The set local is used in one arm and nowhere else; push it there.
    (local.set $x (i32.const 1))
    (if
      (local.get $p)
      (nop)
      (drop (local.get $x))
    )
  )

  ;; CHECK:      (func $unpushed-interference (type $i32_=>_none) (param $p i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (local $y i32)
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.set $y
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $unpushed-interference (param $p i32)
    (local $x i32)
    (local $y i32)
    (local.set $x (i32.const 1))
    ;; This set is not pushed (as it is not used in the if) and it will then
    ;; prevent the previous set of $x from being pushed, since we can't push a
    ;; set of $x past a get of it.
    (local.set $y (local.get $x))
    (if
      (local.get $p)
      (drop (local.get $x))
    )
  )

  ;; CHECK:      (func $if-use-use (type $i32_=>_none) (param $p i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $if-use-use (param $p i32)
    (local $x i32)
    ;; The set local is used in both arms, so we can't do anything.
    (local.set $x (i32.const 1))
    (if
      (local.get $p)
      (drop (local.get $x))
      (drop (local.get $x))
    )
  )

  ;; CHECK:      (func $if-use-after (type $i32_=>_none) (param $p i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $if-use-after (param $p i32)
    (local $x i32)
    ;; The use after the if prevents optimization.
    (local.set $x (i32.const 1))
    (if
      (local.get $p)
      (drop (local.get $x))
    )
    (drop (local.get $x))
  )

  ;; CHECK:      (func $if-use-after-nop (type $i32_=>_none) (param $p i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (nop)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $if-use-after-nop (param $p i32)
    (local $x i32)
    (local.set $x (i32.const 1))
    (if
      (local.get $p)
      (drop (local.get $x))
      (nop) ;; add a nop here compared to the last testcase (no output change)
    )
    (drop (local.get $x))
  )

  ;; CHECK:      (func $if-else-use-after (type $i32_=>_none) (param $p i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:   (nop)
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $if-else-use-after (param $p i32)
    (local $x i32)
    (local.set $x (i32.const 1))
    (if
      (local.get $p)
      (nop)
      (drop (local.get $x)) ;; now the use in the if is in the else arm
    )
    (drop (local.get $x))
  )

  ;; CHECK:      (func $if-use-after-unreachable (type $i32_=>_none) (param $p i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:   (block
  ;; CHECK-NEXT:    (local.set $x
  ;; CHECK-NEXT:     (i32.const 1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.get $x)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (return)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $if-use-after-unreachable (param $p i32)
    (local $x i32)
    ;; A use after the if is ok as the other arm is unreachable.
    (local.set $x (i32.const 1))
    (if
      (local.get $p)
      (drop (local.get $x))
      (return)
    )
    (drop (local.get $x))
  )

  ;; CHECK:      (func $if-use-after-unreachable-else (type $i32_=>_none) (param $p i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:   (return)
  ;; CHECK-NEXT:   (block
  ;; CHECK-NEXT:    (local.set $x
  ;; CHECK-NEXT:     (i32.const 1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.get $x)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $if-use-after-unreachable-else (param $p i32)
    (local $x i32)
    (local.set $x (i32.const 1))
    (if
      (local.get $p)
      (return) ;; as above, but with arms flipped
      (drop (local.get $x))
    )
    (drop (local.get $x))
  )

  ;; CHECK:      (func $optimize-many (type $i32_=>_none) (param $p i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (local $y i32)
  ;; CHECK-NEXT:  (local $z i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:   (block
  ;; CHECK-NEXT:    (local.set $x
  ;; CHECK-NEXT:     (i32.const 1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (local.set $z
  ;; CHECK-NEXT:     (i32.const 3)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.get $x)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.get $z)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (block
  ;; CHECK-NEXT:    (local.set $y
  ;; CHECK-NEXT:     (i32.const 2)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.get $y)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $optimize-many (param $p i32)
    (local $x i32)
    (local $y i32)
    (local $z i32)
    ;; Multiple things we can push, to various arms.
    (local.set $x (i32.const 1))
    (local.set $y (i32.const 2))
    (local.set $z (i32.const 3))
    (if
      (local.get $p)
      (block
        (drop (local.get $x))
        (drop (local.get $z))
      )
      (drop (local.get $y))
    )
  )

  ;; CHECK:      (func $past-other (type $i32_=>_none) (param $p i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (local $t i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (i32.const 2)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:   (block
  ;; CHECK-NEXT:    (local.set $x
  ;; CHECK-NEXT:     (local.get $t)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.get $x)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $past-other (param $p i32)
    (local $x i32)
    (local $t i32)
    ;; We can push this past the drop after it.
    (local.set $x (local.get $t))
    (drop (i32.const 2))
    (if
      (local.get $p)
      (drop (local.get $x))
    )
  )

  ;; CHECK:      (func $past-other-no (type $i32_=>_none) (param $p i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (local $t i32)
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (local.get $t)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.tee $t
  ;; CHECK-NEXT:    (i32.const 2)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $past-other-no (param $p i32)
    (local $x i32)
    (local $t i32)
    ;; We cannot push this due to the tee, which interferes with us.
    (local.set $x (local.get $t))
    (drop (local.tee $t (i32.const 2)))
    (if
      (local.get $p)
      (drop (local.get $x))
    )
  )

  ;; CHECK:      (func $past-condition-no (type $i32_=>_none) (param $p i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (local $t i32)
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (local.get $t)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.tee $t
  ;; CHECK-NEXT:    (local.get $p)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $past-condition-no (param $p i32)
    (local $x i32)
    (local $t i32)
    ;; We cannot push this due to the tee in the if condition.
    (local.set $x (local.get $t))
    (if
      (local.tee $t (local.get $p))
      (drop (local.get $x))
    )
  )

  ;; CHECK:      (func $past-condition-no-2 (type $none_=>_none)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (local $t i32)
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (local.get $t)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $past-condition-no-2
    (local $x i32)
    (local $t i32)
    ;; We cannot push this due to the read of $x in the if condition.
    (local.set $x (local.get $t))
    (if
      (local.get $x)
      (drop (local.get $x))
    )
  )

  ;; CHECK:      (func $past-condition-no-3 (type $i32_=>_none) (param $p i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (local $t i32)
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (local.get $t)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.tee $x
  ;; CHECK-NEXT:    (local.get $p)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $past-condition-no-3 (param $p i32)
    (local $x i32)
    (local $t i32)
    ;; We cannot push this due to the write of $x in the if condition.
    (local.set $x (local.get $t))
    (if
      (local.tee $x (local.get $p))
      (drop (local.get $x))
    )
  )

  ;; CHECK:      (func $if-condition-return (type $i32_=>_none) (param $p i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (block (result i32)
  ;; CHECK-NEXT:    (return)
  ;; CHECK-NEXT:    (local.get $p)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (block
  ;; CHECK-NEXT:    (local.set $x
  ;; CHECK-NEXT:     (i32.const 1)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.get $x)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $if-condition-return (param $p i32)
    (local $x i32)
    (local.set $x (i32.const 1))
    (if
      (block (result i32)
        (return) ;; This return does not prevent us from optimizing; if it
                 ;; happens then we don't need the local.set to execute
                 ;; anyhow.
        (local.get $p)
      )
      (drop (local.get $x))
    )
  )

  ;; CHECK:      (func $if-condition-break-used (type $i32_=>_none) (param $p i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (block $out
  ;; CHECK-NEXT:   (if
  ;; CHECK-NEXT:    (block (result i32)
  ;; CHECK-NEXT:     (br $out)
  ;; CHECK-NEXT:     (local.get $p)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.get $x)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (return)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $x)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $if-condition-break-used (param $p i32)
    (local $x i32)
    (local.set $x (i32.const 1))
    ;; As above, but the return is replaced with a break. The break goes to a
    ;; location with a use of the local, which prevents optimization.
    (block $out
      (if
        (block (result i32)
          (br $out)
          (local.get $p)
        )
        (drop (local.get $x))
      )
      (return)
    )
    (drop (local.get $x))
  )

  ;; CHECK:      (func $one-push-prevents-another (type $i32_=>_none) (param $p i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (local $y i32)
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (block
  ;; CHECK-NEXT:    (local.set $y
  ;; CHECK-NEXT:     (local.get $x)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.get $y)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $one-push-prevents-another (param $p i32)
    (local $x i32)
    (local $y i32)
    ;; We will push $y into one arm, and as a result both arms will have a get
    ;; of $x, which prevents pushing $x.
    (local.set $x (i32.const 1))
    (local.set $y (local.get $x))
    (if
      (local.get $p)
      (drop (local.get $x))
      (drop (local.get $y))
    )
  )

  ;; CHECK:      (func $one-push-prevents-another-flipped (type $i32_=>_none) (param $p i32)
  ;; CHECK-NEXT:  (local $x i32)
  ;; CHECK-NEXT:  (local $y i32)
  ;; CHECK-NEXT:  (local.set $x
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:   (block
  ;; CHECK-NEXT:    (local.set $y
  ;; CHECK-NEXT:     (local.get $x)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (local.get $y)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:   (drop
  ;; CHECK-NEXT:    (local.get $x)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $one-push-prevents-another-flipped (param $p i32)
    (local $x i32)
    (local $y i32)
    ;; As above but with if arms flipped. The result should be similar, with
    ;; only $y pushed.
    (local.set $x (i32.const 1))
    (local.set $y (local.get $x))
    (if
      (local.get $p)
      (drop (local.get $y))
      (drop (local.get $x))
    )
  )

  ;; CHECK:      (func $sink-call (type $i32_=>_i32) (param $p i32) (result i32)
  ;; CHECK-NEXT:  (local $temp i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:   (block
  ;; CHECK-NEXT:    (local.set $temp
  ;; CHECK-NEXT:     (call $call.without.effects
  ;; CHECK-NEXT:      (i32.const 1234)
  ;; CHECK-NEXT:      (ref.func $sink-call)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (return
  ;; CHECK-NEXT:     (local.get $temp)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT: )
  (func $sink-call (param $p i32) (result i32)
    (local $temp i32)

    ;; This local has a call, but the call is an intrinsic indicating no
    ;; effects, so it is safe to sink into the if.
    (local.set $temp
      (call $call.without.effects
        (i32.const 1234)
        (ref.func $sink-call)
      )
    )
    (if
      (local.get $p)
      (return
        (local.get $temp)
      )
    )
    (i32.const 0)
  )

  ;; CHECK:      (func $no-sink-call (type $i32_=>_i32) (param $p i32) (result i32)
  ;; CHECK-NEXT:  (local $temp i32)
  ;; CHECK-NEXT:  (local.set $temp
  ;; CHECK-NEXT:   (call $call.without.effects
  ;; CHECK-NEXT:    (i32.const 1234)
  ;; CHECK-NEXT:    (ref.func $no-sink-call)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:   (return
  ;; CHECK-NEXT:    (local.get $temp)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (local.get $temp)
  ;; CHECK-NEXT: )
  (func $no-sink-call (param $p i32) (result i32)
    (local $temp i32)

    ;; As above, but now after the if we have a get of the temp local, so we
    ;; cannot sink. This + the previous testcase show we scan for such local
    ;; uses in exactly the right places.
    (local.set $temp
      (call $call.without.effects
        (i32.const 1234)
        (ref.func $no-sink-call)
      )
    )
    (if
      (local.get $p)
      (return
        (local.get $temp)
      )
    )
    (local.get $temp) ;; this line changed.
  )

  ;; CHECK:      (func $no-sink-call-2 (type $i32_=>_i32) (param $p i32) (result i32)
  ;; CHECK-NEXT:  (local $temp i32)
  ;; CHECK-NEXT:  (local.set $temp
  ;; CHECK-NEXT:   (call $call.without.effects
  ;; CHECK-NEXT:    (i32.const 1234)
  ;; CHECK-NEXT:    (ref.func $no-sink-call-2)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:   (return
  ;; CHECK-NEXT:    (local.get $temp)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (local.get $temp)
  ;; CHECK-NEXT: )
  (func $no-sink-call-2 (param $p i32) (result i32)
    (local $temp i32)

    ;; As above, but add a nop before the final value. We still should not
    ;; optimize.
    (local.set $temp
      (call $call.without.effects
        (i32.const 1234)
        (ref.func $no-sink-call-2)
      )
    )
    (if
      (local.get $p)
      (return
        (local.get $temp)
      )
    )
    (nop) ;; this line was added.
    (local.get $temp)
  )

  ;; CHECK:      (func $no-sink-call-3 (type $i32_=>_i32) (param $p i32) (result i32)
  ;; CHECK-NEXT:  (local $temp i32)
  ;; CHECK-NEXT:  (local.set $temp
  ;; CHECK-NEXT:   (call $call.without.effects
  ;; CHECK-NEXT:    (i32.const 1234)
  ;; CHECK-NEXT:    (ref.func $no-sink-call-3)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:   (return
  ;; CHECK-NEXT:    (local.get $temp)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $temp)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT: )
  (func $no-sink-call-3 (param $p i32) (result i32)
    (local $temp i32)

    ;; As above, but add a nop after the get of the local after the if. We still
    ;; should not optimize.
    (local.set $temp
      (call $call.without.effects
        (i32.const 1234)
        (ref.func $no-sink-call-3)
      )
    )
    (if
      (local.get $p)
      (return
        (local.get $temp)
      )
    )
    (nop)
    (drop
      (local.get $temp) ;; this get is now dropped.
    )
    (nop) ;; this line was added;
    (i32.const 0) ;; this line was added.
  )

  ;; CHECK:      (func $sink-call-3 (type $i32_=>_i32) (param $p i32) (result i32)
  ;; CHECK-NEXT:  (local $temp i32)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:   (block
  ;; CHECK-NEXT:    (local.set $temp
  ;; CHECK-NEXT:     (call $call.without.effects
  ;; CHECK-NEXT:      (i32.const 1234)
  ;; CHECK-NEXT:      (ref.func $no-sink-call-3)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (return
  ;; CHECK-NEXT:     (local.get $temp)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT: )
  (func $sink-call-3 (param $p i32) (result i32)
    (local $temp i32)

    ;; As above, but stop reading the relevant local after the if, keeping the
    ;; number of other items unchanged. This verifies the presence of multiple
    ;; items is not a problem and we can optimize.
    (local.set $temp
      (call $call.without.effects
        (i32.const 1234)
        (ref.func $no-sink-call-3)
      )
    )
    (if
      (local.get $p)
      (return
        (local.get $temp)
      )
    )
    (nop)
    (drop
      (local.get $p) ;; this get now reads $p
    )
    (nop)
    (i32.const 0)
  )

  ;; CHECK:      (func $no-sink-call-sub (type $i32_=>_i32) (param $p i32) (result i32)
  ;; CHECK-NEXT:  (local $temp i32)
  ;; CHECK-NEXT:  (local $other i32)
  ;; CHECK-NEXT:  (local.set $temp
  ;; CHECK-NEXT:   (call $call.without.effects
  ;; CHECK-NEXT:    (local.tee $other
  ;; CHECK-NEXT:     (i32.const 1234)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (ref.func $no-sink-call)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (local.get $p)
  ;; CHECK-NEXT:   (return
  ;; CHECK-NEXT:    (local.get $temp)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (i32.const 0)
  ;; CHECK-NEXT: )
  (func $no-sink-call-sub (param $p i32) (result i32)
    (local $temp i32)
    (local $other i32)

    ;; The call has no effects, but one of the arguments to it does, so we
    ;; cannot optimize.
    (local.set $temp
      (call $call.without.effects
        (local.tee $other ;; an effect
          (i32.const 1234)
        )
        (ref.func $no-sink-call)
      )
    )
    (if
      (local.get $p)
      (return
        (local.get $temp)
      )
    )
    (i32.const 0)
  )

  ;; CHECK:      (func $ref-into-if (type $ref|any|_=>_none) (param $0 (ref any))
  ;; CHECK-NEXT:  (local $1 anyref)
  ;; CHECK-NEXT:  (nop)
  ;; CHECK-NEXT:  (if
  ;; CHECK-NEXT:   (i32.const 1)
  ;; CHECK-NEXT:   (unreachable)
  ;; CHECK-NEXT:   (block $label$3
  ;; CHECK-NEXT:    (local.set $1
  ;; CHECK-NEXT:     (local.get $0)
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:    (drop
  ;; CHECK-NEXT:     (ref.as_non_null
  ;; CHECK-NEXT:      (local.get $1)
  ;; CHECK-NEXT:     )
  ;; CHECK-NEXT:    )
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT:  (drop
  ;; CHECK-NEXT:   (ref.as_non_null
  ;; CHECK-NEXT:    (local.get $1)
  ;; CHECK-NEXT:   )
  ;; CHECK-NEXT:  )
  ;; CHECK-NEXT: )
  (func $ref-into-if (param $0 (ref any))
    (local $1 (ref any))
    ;; This can be pushed into the reachable if arm. After doing so, however,
    ;; the local $1 no longer has a single set that dominates it in the sense of
    ;; the wasm validation rules for non-nullable locals, so the local must be
    ;; turned into a nullable one.
    (local.set $1
      (local.get $0)
    )
    (if
      (i32.const 1)
      (unreachable)
      (block $label$3
        (drop
          (local.get $1)
        )
      )
    )
    (drop
      (local.get $1)
    )
  )

)
