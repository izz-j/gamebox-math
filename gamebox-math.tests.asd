(in-package :cl-user)

(asdf:defsystem #:gamebox-math.tests
  :description "Tests for gamebox-math."
  :author "Michael Fiano <michael.fiano@gmail.com>"
  :maintainer "Michael Fiano <michael.fiano@gmail.com>"
  :license "MIT"
  :homepage "https://github.com/mfiano/gamebox-math"
  :bug-tracker "https://github.com/mfiano/gamebox-math/issues"
  :source-control (:git "git@github.com:mfiano/gamebox-math.git")
  :version "0.1.0"
  :encoding :utf-8
  :defsystem-depends-on (:prove-asdf)
  :depends-on (#:gamebox-math
               #:prove)
  :pathname "t"
  :serial t
  :components
  ((:test-file "test-vector")))
