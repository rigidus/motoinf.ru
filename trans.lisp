(in-package #:motoinf)

(define-condition pattern-not-found-error (error)
  ((text :initarg :text :reader text)))

(defun extract (cortege html)
  (loop :for (begin end regexp) :in cortege :collect
     (multiple-value-bind (start fin)
         (ppcre:scan regexp html)
       (when (null start)
         (error 'pattern-not-found-error :text regexp))
       (subseq html (+ start begin) (- fin end)))))

(defun extract-voice-elt (id-str)
  (destructuring-bind (title user msg)
      (extract '((4 5 "<h1>.*</h1>")
                 (16 6 "<a href=\\\"/(users|members).*\.html\\\".*")
                 (50 47 "(?s)<div id=\\\"details_id\\\" class=\\\"understandBlock\\\">.*<div class=\\\"classUnderstand"))
               (drakma:http-request
                (concatenate 'string "http://www.motobratan.ru/voice/" id-str ".html")))
    (list
     :title title
     :user-id (extract '((0 5 "\\d*.html")) user)
     :user-name (extract '((1 4 ">.*</a>")) user)
     :date (extract '((2 13 ",.*&nbsp;.*в.*&nbsp;")) user)
     :hour (extract '((22 3 ",.*&nbsp;.*в.*&nbsp;.*")) user)
     :min  (extract '((25 0 ",.*&nbsp;.*в.*&nbsp;.*")) user)
     :link (handler-case
               (extract '((9 8 "<a href=\\\".*\\\" target")) msg)
             (pattern-not-found-error () nil)))))

;; test
;; (loop :for item :in (ppcre:all-matches-as-strings "message_\\d*_id" (drakma:http-request "http://www.motobratan.ru/voice/")) :collect
;;    (let ((id-str (subseq item 8 (- (length item) 3))))
;;      (progn
;;        (print id-str)
;;        (print (extract-voice-elt id-str)))))


(defun grab-user (id-str)
  (let ((page (drakma:http-request (format nil "http://www.motobratan.ru/users/~A.html" id-str)))
        age
        exp-raw
        birthday
        exp)
    (if (ppcre:all-matches-as-strings "анкета удалена" page)
        nil
        (destructuring-bind (name flow)
            (extract '((4 5 "<h1>.*</h1>")
                       (23 6 "<div class=\"item flow\">.*</div>"))
                     page)
          (handler-case
              (let ((raw (extract '((9 4 "Возраст: .* (лет|год|года)")
                                    (9 4 "(?s)Возраст: .*"))
                                  page)))
                (setf age (car raw))
                (let ((raw2 (extract '((26 7 "<span class=\\\"small gray\\\">.*</span>")
                                      (11 4 "Мото-стаж: .* лет" ))
                                    (cadr raw))))
                  (setf birthday (car raw2))
                  (setf exp (cadr raw2))))
            ;; error handler ignore
            (pattern-not-found-error (err)
              (format t "~%! pattern-not-found-warn: '~A'" (text err))))
          (list :name name
                :flow flow
                :age age
                :birthday birthday
                :exp exp
                :motorcycles (mapcar #'(lambda (x)
                                         (car (extract '((0 5 "\\d*.html")) x)))
                                     (remove-duplicates
                                      (ppcre:all-matches-as-strings
                                       "<a href=\\\"/users/.*/motorcycles/.*html"
                                       page)
                                      :test #'equal)))))))

(loop :for item :from 10001 :to 19110 :do
   (print item)
   (print (grab-user (format nil "~A" item))))

;; (grab-user 10004)
(loop :for item :from 1 :to 10001 :do
   (print item)
   (print (grab-user (format nil "~A" item))))


(defun grab-user-moto (user-id-str moto-id-str)
  (let ((page (drakma:http-request (format nil "http://www.motobratan.ru/members/~A/motorcycles/~A.html" user-id-str moto-id-str))))
    (if (ppcre:all-matches-as-strings "Array" page)
        nil
        (destructuring-bind (name descr)
            (extract '((4 5 "<h1>.*</h1>")
                       (0 0 "(?s)</h1>.*<div id=\\\"motorcycle_photos_id\\\">"))
                     page)
          (ppcre:all-matches-as-strings "http://img.motorussia.ru/images/thumbnail/.*/.*\.jpg" page)
          ;; descr
          ))))

;; (grab-user-moto "18601" "1")

(print
(let* ((idx 0)
       (src (drakma:http-request "http://www.motobratan.ru/modules/comments/comments.php"
                                 :method :post
                                 :parameters '(("flood" . "0")
                                               ("operation" . "page")
                                               ("order" . "ASC")
                                               ("page" . "1")
                                               ("table" . "voice")
                                               ("topic_id" . "13506")
                                               ("type" . "comments")
                                               )))
       (pos (ppcre:all-matches "<div class=\\\"item flow understandBlock\\\" id=\\\"comment.*" src)))
  (loop :for item :in pos :collect
     (prog1 (subseq src idx item)
       (setf idx item)))))


(print (drakma:http-request "http://www.motobratan.ru/modules/comments/comments.php"
                     :method :post
                     :parameters '(("flood" . "0")
                                   ("operation" . "page")
                                   ("order" . "ASC")
                                   ("page" . "1")
                                   ("table" . "voice")
                                   ("topic_id" . "13506")
                                   ("type" . "comments")
                                   )))

(defun get-voice-comments (topic-id-str)
  (let* ((current-page "1")
         (params (list (cons "flood" "0")
                       (cons "operation" "page")
                       (cons "order" "ASC")
                       (cons "table" "voice")
                       (cons "topic_id" topic-id-str)
                       (cons "type" "comments")))
         (page1 (drakma:http-request "http://www.motobratan.ru/modules/comments/comments.php"
                                    :method :post
                                    :parameters (append params (list (cons "page" current-page)))))
         (next-pages (remove-duplicates
                      (mapcar #'(lambda (x)
                                  (subseq x 16))
                              (ppcre:all-matches-as-strings "getCommentsPage\.\\d*" page1))
                      :test #'equal)))
    next-pages))

(get-voice-comments "13506")
