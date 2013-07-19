(restas:define-module #:db
    (:use #:closer-mop #:cl #:iter #:alexandria #:anaphora #:postmodern)
  (:shadowing-import-from :closer-mop
                          :defclass
                          :defmethod
                          :standard-class
                          :ensure-generic-function
                          :defgeneric
                          :standard-generic-function
                          :class-name)
  (:export :make-clause-list :*db-name* :*db-user* :*db-pass* :*db-serv* :*db-spec*))

(in-package #:db)

(defparameter *db-name* "motoinf")
(defparameter *db-user* "motoinf")
(defparameter *db-pass* "motoinf")
(defparameter *db-serv* "localhost")
(defparameter *db-spec* (list *db-name* *db-user* *db-pass* *db-serv*))

(defun make-clause-list (glob-rel rel args)
  (append (list glob-rel)
          (loop
             :for i
             :in args
             :when (and (symbolp i)
                        (getf args i)
                        (not (symbolp (getf args i))))
             :collect (list rel i (getf args i)))))

;; (make-clause-list ':and ':= (list 'id 1 'name "name"))
