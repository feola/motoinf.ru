(in-package #:motoinf)

(define-condition pattern-not-found-error (error) (()))

(defun extract (cortege html)
  (loop :for (begin end regexp) :in cortege :collect
     (multiple-value-bind (start fin)
         (ppcre:scan regexp html)
       (when (null start)
         (error 'pattern-not-found-error))
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
(loop :for item :in (ppcre:all-matches-as-strings "message_\\d*_id" (drakma:http-request "http://www.motobratan.ru/voice/")) :collect
   (let ((id-str (subseq item 8 (- (length item) 3))))
     (progn
       (print id-str)
       (print (extract-voice-elt id-str)))))
