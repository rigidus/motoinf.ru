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


(defun save-comments (filename)
  (with-open-file (out filename
                       :direction :output
                       :if-exists :supersede)
    (with-standard-io-syntax
      (print *comments* out))))


(defun load-comments (filename)
    (with-open-file (in filename)
          (with-standard-io-syntax
                  (setf *comments* (read in)))))

(setf filename "comments.txt")

