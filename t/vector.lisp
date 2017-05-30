(defpackage #:gamebox-math.test
  (:use #:cl
        #:gamebox-math
        #:prove))

(in-package :gamebox-math.test)

(diag "Running vector tests.")

(subtest "structure"
  (plan 5)
  (is-type +zero-vector+ '(simple-array single-float (3)) "zero vector (constant) type check")
  (is-type (vec) '(simple-array single-float (3)) "zero vector type check")
  (is-type (vec 1) '(simple-array single-float (3)) "vec1 type check")
  (is-type (vec 1 2) '(simple-array single-float (3)) "vec2 type check")
  (is-type (vec 1 2 3) '(simple-array single-float (3)) "vec3 type check")
  (finalize))

(subtest "accessors"
  (plan 34)
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
  (is-print (princ (vec 1 2 3)) "#<1.0 2.0 3.0>" "pretty-printing")
  (finalize))

(subtest "test"
  (plan 2)
  (is (gamebox-math::vtest) #(1 2 3) :test #'equalp "test-vector read components")
  (isnt (gamebox-math::vtest) #(0 0 0) :test #'equalp "test-vector read components")
  (finalize))

(subtest "copy"
  (plan 5)
  (with-vectors ((i (vec 1 2 3)) (o (vec)))
    (ok (v= (vcp! o i) (vec 1 2 3)) "copy in-place return value")
    (ok (v= o (vec 1 2 3)) "copy in-place output")
    (setf ox 4.0)
    (isnt ix 4.0 "copy in-place no shared structure"))
  (with-vector (i (vec 1 2 3))
    (ok (v= (vcp i) (vec 1 2 3)) "copy return value")
    (isnt i (vcp i) :test #'eq "copy no shared structure"))
  (finalize))
