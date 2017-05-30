(defpackage #:gamebox-math.test
  (:use #:cl
        #:gamebox-math
        #:prove))

(in-package :gamebox-math.test)

(plan nil)

(diag "vector structure")
(is-type +zero-vector+ '(simple-array single-float (3)) "zero vector (constant) type check")
(is-type (vec) '(simple-array single-float (3)) "zero vector type check")
(is-type (vec 1) '(simple-array single-float (3)) "vec1 type check")
(is-type (vec 1 2) '(simple-array single-float (3)) "vec2 type check")
(is-type (vec 1 2 3) '(simple-array single-float (3)) "vec3 type check")

(diag "vector accessors")
(is (vref (vec) 0) 0.0 "zero vector virtualized read X component")
(is (vref (vec) 1) 0.0 "zero vector virtualized read Y component")
(is (vref (vec) 2) 0.0 "zero vector virtualized read Z component")
(is (vref (vec 1) 0) 1.0 "vec1 virtualized read X component")
(is (vref (vec 1) 1) 0.0 "vec1 virtualized read Y component")
(is (vref (vec 1) 2) 0.0 "vec1 virtualized read Z component")
(is (vref (vec 1 2) 0) 1.0 "vec2 virtualized read X component")
(is (vref (vec 1 2) 1) 2.0 "vec2 virtualized read Y component")
(is (vref (vec 1 2) 2) 0.0 "vec2 virtualized read Z component")
(is (vref (vec 1 2 3) 0) 1.0 "vec3 virtualized read X component")
(is (vref (vec 1 2 3) 1) 2.0 "vec3 virtualized read Y component")
(is (vref (vec 1 2 3) 2) 3.0 "vec3 virtualized read Z component")
(let ((v (vec)))
  (setf (vref v 0) 10.0 (vref v 1) 11.0 (vref v 2) 12.0)
  (is (vref v 0) 10.0 "virtualized write X component")
  (is (vref v 1) 11.0 "virtualized write Y component")
  (is (vref v 2) 12.0 "virtualized write Z component"))
(with-vector (v (vec 1 2 3))
  (is vx 1.0 "with-vector read X component")
  (is vy 2.0 "with-vector read Y component")
  (is vz 3.0 "with-vector read Z component")
  (psetf vx 10.0 vy 11.0 vz 12.0)
  (is vx 10.0 "with-vector write X component")
  (is vy 11.0 "with-vector write Y component")
  (is vz 12.0 "with-vector write Z component"))
(with-vectors ((v1 (vec 1 2 3)) (v2 (vec 4 5 6)))
  (is v1x 1.0 "with-vectors read first X component")
  (is v1y 2.0 "with-vectors read first Y component")
  (is v1z 3.0 "with-vectors read first Z component")
  (is v2x 4.0 "with-vectors read second X component")
  (is v2y 5.0 "with-vectors read second Y component")
  (is v2z 6.0 "with-vectors read second Z component")
  (psetf v1x 10.0 v1y 11.0 v1z 12.0 v2x 13.0 v2y 14.0 v2z 15.0)
  (is v1x 10.0 "with-vectors write first X component")
  (is v1y 11.0 "with-vectors write first Y component")
  (is v1z 12.0 "with-vectors write first Z component")
  (is v2x 13.0 "with-vectors write second X component")
  (is v2y 14.0 "with-vectors write second Y component")
  (is v2z 15.0 "with-vectors write second Z component"))

(diag "vector test")
(is (gamebox-math::vtest) #(1 2 3) :test #'equalp "test-vector read components")
(isnt (gamebox-math::vtest) #(0 0 0) :test #'equalp "test-vector read components")

(diag "vector copy")
(with-vectors ((i (vec 1 2 3)) (o (vec)))
  (ok (v= (vcp! o i) (vec 1 2 3)) "copy in-place return value")
  (ok (v= o (vec 1 2 3)) "copy in-place output")
  (setf ox 10.0)
  (is ix 1.0 "copy in-place no shared structure"))
(with-vector (i (vec 1 2 3))
  (ok (v= (vcp i) (vec 1 2 3)) "copy return value")
  (isnt i (vcp i) :test #'eq "copy no shared structure"))

(diag "vector clamp")
(with-vectors ((i (vec -3 2 -3)) (o (vec)))
  (ok (v= (vclamp! o i :min -1.0 :max 1.0) (vec -1 1 -1)) "clamp in-place return value")
  (ok (v= o (vec -1 1 -1)) "clamp in-place output")
  (setf ox 10.0)
  (is ix -3.0 "clamp in-place no shared structure"))
(with-vector (i (vec -3 2 -3))
  (ok (v= (vclamp i :min -1.0 :max 1.0) (vec -1 1 -1)) "clamp return value")
  (ok (v= i (vec -3 2 -3)) "clamp no shared structure"))

(diag "vector stabilize")
(with-vectors ((i (vec 1e-8 1e-8 1e-8)) (o (vec)))
  (ok (v= (vstab! o i) (vec 0 0 0)) "stabilize in-place return value")
  (ok (v= o (vec 0 0 0)) "stabilize in-place output")
  (setf ox 10.0)
  (is ix 1e-8 "stabilize in-place no shared structure"))
(with-vector (i (vec 1e-8 1e-8 1e-8))
  (ok (v= (vstab i) (vec 0 0 0)) "stabilize return value")
  (ok (v= i (vec 1e-8 1e-8 1e-8)) "stabilize no shared structure"))

(diag "vector zero")
(with-vector (v (vec 1 2 3))
  (ok (v= (vzero! v) (vec 0 0 0)) "zero in-place return value")
  (ok (v= v (vec 0 0 0)) "zero in-place output"))
(ok (v= (vec-zero) (vec 0 0 0)) "zero return value")

(diag "vector list conversion")
(is (v->list (vec 1 2 3)) '(1.0 2.0 3.0) :test #'equal "convert to list")
(ok (v= (list->v '(1 2 3)) (vec 1 2 3)) "convert from list")

(diag "vector equality")
(ok (v= (vec 1 2 3) (vec 1 2 3)) "equal components")
(ok (v~ (vec (+ 1 1e-8) (+ 2 1e-8) (+ 3 1e-8)) (vec 1 2 3)) "approximately equal components")

(diag "addition")
(with-vectors ((i (vec 1 2 3)) (o (vec)))
  (ok (v= (v+! o i i) (vec 2 4 6)) "addition in-place return value")
  (ok (v= o (vec 2 4 6)) "addition in-place output")
  (setf ox 10.0)
  (is ix 1.0 "addition in-place no shared structure"))
(with-vector (i (vec 1 2 3))
  (ok (v= (v+ i i) (vec 2 4 6)) "addition return value")
  (ok (v= i (vec 1 2 3)) "addition no shared structure"))

(diag "subtraction")
(with-vectors ((i1 (vec 3 5 7)) (i2 (vec 1 2 3)) (o (vec)))
  (ok (v= (v-! o i1 i2) (vec 2 3 4)) "subtraction in-place return value")
  (ok (v= o (vec 2 3 4)) "subtraction in-place output")
  (setf ox 10.0)
  (ok (and (= i1x 3.0) (= i2x 1.0)) "subtraction in-place no shared structure"))
(with-vectors ((i1 (vec 3 5 7)) (i2 (vec 1 2 3)))
  (ok (v= (v- i1 i2) (vec 2 3 4)) "subtraction return value")
  (ok (and (v= i1 (vec 3 5 7)) (v= i2 (vec 1 2 3))) "subtraction no shared structure"))

(diag "hadamard product")
(with-vectors ((i1 (vec 1 2 3)) (i2 (vec 2 3 4)) (o (vec)))
  (ok (v= (vhad*! o i1 i2) (vec 2 6 12)) "hadamard product in-place return value")
  (ok (v= o (vec 2 6 12)) "hadamard product in-place output")
  (setf ox 10.0)
  (ok (and (= i1x 1.0) (= i2x 2.0)) "hadamard product in-place no shared structure"))
(with-vectors ((i1 (vec 1 2 3)) (i2 (vec 2 3 4)))
  (ok (v= (vhad* i1 i2) (vec 2 6 12)) "hadamard product return value")
  (ok (and (v= i1 (vec 1 2 3)) (v= i2 (vec 2 3 4))) "hadanard product no shared structure"))

(diag "hadamard quotient")
(with-vectors ((i1 (vec 6 6 8)) (i2 (vec 2 3 8)) (o (vec)))
  (ok (v= (vhad/! o i1 i2) (vec 3 2 1)) "hadamard quotient in-place return value")
  (ok (v= o (vec 3 2 1)) "hadamard quotient in-place return value")
  (setf ox 10.0)
  (ok (and (= i1x 6.0) (= i2x 2.0)) "hadamard quotient no shared structure"))
(with-vectors ((i1 (vec 6 6 8)) (i2 (vec 2 3 8)))
  (ok (v= (vhad/ i1 i2) (vec 3 2 1)) "hadamard quotient return value")
  (ok (and (v= i1 (vec 6 6 8)) (v= i2 (vec 2 3 8))) "hadamard quotient no shared structure"))

(diag "scalar product")
(with-vectors ((i (vec 1 2 3)) (o (vec)))
  (ok (v= (vscale! o i 5.0) (vec 5 10 15)) "scalar product in-place return value")
  (ok (v= o (vec 5 10 15)) "scalar product in-place output")
  (setf ox 10.0)
  (is ix 1.0 "scalar product in-place no shared structure"))
(with-vector (i (vec 1 2 3))
  (ok (v= (vscale i 5.0) (vec 5 10 15)) "scalar product return value")
  (ok (v= i (vec 1 2 3)) "scalar product no shared structure"))

(diag "dot product")
(is (vec-dot (vec 1 0 0) (vec 1 0 0)) 1.0)
(is (vec-dot (vec 1 0 0) (vec -1 0 0)) -1.0)
(is (vec-dot (vec 1 0 0) (vec 0 1 0)) 0.0)
(is (vec-dot (vec 1 0 0) (vec 0 0 1)) 0.0)
(is (vec-dot (vec 0 1 0) (vec 0 0 1)) 0.0)

(finalize)
