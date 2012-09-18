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

(def/route acdc  ("acdc")
  (old-page "content/songs/acdc.htm"))
(def/route abcd ("abcd")
    (old-page "content/songs/abcd.htm"))
(def/route billyidol ("billyidol")
    (old-page "content/songs/billyidol.htm"))
(def/route bonjovi ("bonjovi")
    (old-page "content/songs/bonjovi.htm"))
(def/route bonnie ("bonnie")
    (old-page "content/songs/bonnie.htm"))
(def/route buddy ("buddy")
    (old-page "content/songs/buddy.htm"))
(def/route brownie ("brownie")
    (old-page "content/songs/brownie.htm"))
(def/route chris ("chris")
    (old-page "content/songs/chris.htm"))
(def/route diesel ("diesel")
    (old-page "content/songs/diesel.htm"))
(def/route freddie ("freddie")
    (old-page "content/songs/freddie.htm"))
(def/route george ("george")
    (old-page "content/songs/george.htm"))
(def/route golden ("golden")
    (old-page "content/songs/golden.htm"))
(def/route greg ("greg")
    (old-page "content/songs/greg.htm"))
(def/route jeff ("jeff")
    (old-page "content/songs/jeff.htm"))
(def/route john ("john")
    (old-page "content/songs/john.htm"))
(def/route kruger ("kruger")
    (old-page "content/songs/kruger.htm"))
(def/route lonnie ("lonnie")
    (old-page "content/songs/lonnie.htm"))
(def/route lesbaxter ("lesbaxter")
    (old-page "content/songs/lesbaxter.htm"))
(def/route lesreed ("lesreed")
    (old-page "content/songs/lesreed.htm"))
(def/route manowar1 ("manowar1")
    (old-page "content/songs/manovar1.htm"))
(def/route manovar2 ("manovar2")
    (old-page "content/songs/manovar2.htm"))
(def/route metall1 ("metall1")
    (old-page "content/songs/metall1.htm"))
(def/route metall2  ("metall2")
    (old-page "content/songs/metall2.htm"))
(def/route sonseals ("sonseals")
    (old-page "content/songs/sonseals.htm"))
(def/route steppen ("steppen")
    (old-page "content/songs/steppen.htm"))
(def/route  thebyrds ("thebyrds")
    (old-page "content/songs/thebyrds.htm"))
(def/route themeatmen ("themeatmen")
    (old-page "content/songs/themeatmen.htm"))
(def/route twins ("twins")
    (old-page "content/songs/twins.htm"))
(def/route molver ("molver")
    (old-page "content/songs/molver.htm"))
(def/route ugly ("ugly")
    (old-page "content/songs/ugly.htm"))


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
