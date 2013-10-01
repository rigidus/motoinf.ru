(restas:define-module #:motoinf
  (:use #:closer-mop #:cl #:iter #:alexandria #:anaphora #:postmodern)
  (:shadowing-import-from :closer-mop
                          :defclass
                          :defmethod
                          :standard-class
                          :ensure-generic-function
                          :defgeneric
                          :standard-generic-function
                          :class-name))

(in-package #:motoinf)

(defmacro bprint (var)
  `(subseq (with-output-to-string (*standard-output*)
             (pprint ,var)) 1))

(defmacro err (var)
  `(error (format nil "ERR:[~A]" (bprint ,var))))


(setf asdf:*central-registry*
      (remove-duplicates (append asdf:*central-registry*
                                 (list (make-pathname :directory (list :relative (sb-posix:getcwd)))))
                         :test #'equal))

(defparameter *basedir* (make-pathname :directory (list :relative (sb-posix:getcwd))))

(defun path (relative)
  (merge-pathnames relative *basedir*))

(defparameter *comment-path* (format nil "~A" (path "content/commentsfiles/")))
