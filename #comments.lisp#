(require 'swank)

(asdf:defsystem #:motoinf
  :version      "0.0.2"
  :author       "rigidus <i.am.rigidus@gmail.com>"
  :licence      "GPLv3"
  :description  "site http://rigidus.ru"
  :depends-on   (#:closer-mop
                 #:cl-ppcre
                 #:restas-directory-publisher
                 #:closure-template
                 #:cl-json
                 #:postmodern)
  :serial       t
  :components   ((:static-file "templates.htm")
                 (:file "defmodule")
                 (:file "render")
                 (:file "routes")
                 (:file "comments")
                 (:file "init")))
(in-package #:motoinf)

(defparameter *comments* nil)

(defun comments ()
  (tpl:root
   (list :content
         (concatenate 'string
                      (tpl:commentblock (list :messages *comments*))
                      (tpl:commentform)))))


(with-open-file (stream "/home/feolan/motoinf.ru/comments.txt"
                        :direction :output
                        :if-exists :supersede)
  (format stream
          (let ((comment-1 (list :name "rrr" :msg "65748464")))
            (format nil "~A,~A"
                    (getf comment-1 :name)
                    (getf comment-1 :msg)))))


(with-open-file (stream "/home/feolan/motoinf.ru/comments.txt"
                        :direction :input
                        :if-exists :supersede)
  (format nil (read-line stream)))




