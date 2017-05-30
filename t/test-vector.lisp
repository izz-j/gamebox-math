(defpackage #:gamebox-math.test
  (:use #:cl
        #:gamebox-math
        #:prove))

(in-package :gamebox-math.test)

(diag "Running vector tests.")

(subtest "Vector creation: (vec 1 2 3)"
  (plan nil)
  (is-type (vec 1 2 3) '(simple-array single-float (3))
           "Vector is a Common Lisp vector of 3 single-floats")
  (is (vref (vec 1 2 3) 0) 1.0
      "Vector virtualized reference of X component")
  (is (vref (vec 1 2 3) 1) 2.0
      "Vector virtualized reference of Y component")
  (is (vref (vec 1 2 3) 2) 3.0
      "Vector virtualized reference of Z component")
  (with-vector (v (vec 1 2 3))
    (is vx 1.0 "with-vector reading of X component")
    (is vy 2 "with-vector reading of Y component")
    (is vz 3.0 "with-vector reading of Z component"))
  (finalize))
