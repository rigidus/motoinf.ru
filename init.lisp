
(in-package #:motoinf)

;; start
(restas:start '#:motoinf :port 8882)
(restas:debug-mode-on)
;; (restas:debug-mode-off)
(setf hunchentoot:*catch-errors-p* t)
