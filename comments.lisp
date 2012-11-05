(in-package #:motoinf)

(defparameter *comments* ())

(defmacro bprint (var)
  `(subseq (with-output-to-string (*standard-output*)
             (pprint ,var)) 1))

(defun save-comments-to-file ()
  (alexandria:write-string-into-file
   (bprint *comments*)
   "/home/feolan/motoinf.ru/comments.txt"
   :if-exists :supersede))

(defun load-comments-from-file ()
  (setf *comments*
        (read-from-string
         (alexandria:read-file-into-string "/home/feolan/motoinf.ru/comments.txt" ))))

(load-comments-from-file)
