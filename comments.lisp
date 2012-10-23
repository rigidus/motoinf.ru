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

(defparameter *comments* (list ()))

(defun comments ()
  (tpl:root
   (list :content
         (concatenate 'string
                      (tpl:commentblock (list :messages
                                              (mapcar #'(lambda (x)
                                                          (list :msg x))
                                                      *comments*)))
                      (tpl:commentform)))))

