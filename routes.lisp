(in-package #:motoinf)


;; 404

(defun page-404 (&optional (title "404 Not Found") (content "Страница не найдена"))
  "404")

(restas:define-route not-found-route ("*any")
  (restas:abort-route-handler
   (page-404)
   :return-code hunchentoot:+http-not-found+
   :content-type "text/html"))

(defun old-page (filename)
  (tpl:root (list :content (alexandria:read-file-into-string filename))))

;; main

(restas:define-route main ("/")
  (old-page "content/index.htm"))


;; plan file pages

(defmacro def/route (name param &body body)
  `(progn
     (restas:define-route ,name ,param
       ,@body)
     (restas:define-route
         ,(intern (concatenate 'string (symbol-name name) "/"))
         ,(cons (concatenate 'string (car param) "/") (cdr param))
       ,@body)))

;;; главная страница

(def/route index ("index")
  (old-page "content/index.htm"))

;;; верхнее меню

(def/route news ("news")
  (old-page "content/news/news.htm"))

(def/route galery ("galery")
  (old-page "content/galery.htm"))

(def/route formsearch ("formsearch")
  (old-page "content/formsearch.htm"))

(def/route contacts ("contacts")
  (old-page "content/contacts.htm"))

(def/route forum ("forum")
  (old-page "content/forum.htm"))

;;; боковое меню

(def/route history ("history")
  (old-page "content/history/history.htm"))

(def/route construct ("construct")
  (old-page "content/construct/construct.htm"))

(def/route types ("types")
  (old-page "content/types/types.htm"))

(def/route makers ("makers")
  (old-page "content/makers/makers.htm"))

(def/route select ("select")
  (old-page "content/select/select.htm"))

(def/route licence ("license")
  (old-page "content/license/license.htm"))

(def/route equip ("equip")
  (old-page "content/equip/equip.htm"))

(def/route driving ("driving")
  (old-page "content/driving/driving.htm"))

(def/route races ("races")
  (old-page "content/races/races.htm"))

(def/route travels ("travels")
  (old-page "content/travels/travels.htm"))

(def/route fbs ("fbs")
  (old-page "content/fbs.htm"))

;; фильмы

(def/route films ("films")
  (old-page "content/films/films.htm"))

(def/route dikar ("dikar")
  (old-page "content/films/dikar.htm"))
(def/route wildangels ("wildangels")
  (old-page "content/films/wildangels.htm"))

;; книги

(def/route books ("books")
  (old-page "content/books/books.htm"))

;; песни

(def/route songs ("songs")
  (old-page "content/songs/songs.htm"))


;; submodules

(restas:mount-submodule -css- (#:restas.directory-publisher)
                        (restas.directory-publisher:*baseurl* '("css"))
                        (restas.directory-publisher:*directory* (path "css/")))

(restas:mount-submodule -js- (#:restas.directory-publisher)
                        (restas.directory-publisher:*baseurl* '("js"))
                        (restas.directory-publisher:*directory* (path "js/")))

(restas:mount-submodule -img- (#:restas.directory-publisher)
                        (restas.directory-publisher:*baseurl* '("img"))
                        (restas.directory-publisher:*directory* (path "img/")))

(restas:mount-submodule -resources- (#:restas.directory-publisher)
                        (restas.directory-publisher:*baseurl* '("resources"))
                        (restas.directory-publisher:*directory* (path "resources/")))
