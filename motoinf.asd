(require 'swank)

(asdf:defsystem #:motoinf
    :version      "0.0.2"
    :author       "rigidus <i.am.rigidus@gmail.com>"
    :licence      "GPLv3"
    :description  "site motoinf.ru"
    :depends-on   (#:closer-mop
                   #:cl-ppcre
                   #:restas-directory-publisher
                   #:closure-template
                   #:cl-json
                   #:postmodern)
    :serial       t
    :components   ((:static-file "templates.htm")
                   (:file "motoinf")
                   (:file "db")
                   (:module "lib"
                            :serial t
                            :pathname "lib"
                            :components ((:file "entity") ;; depends-on "db"
                                         (:file "datetime")
                                         (:file "view")))
                   (:module "usr"
                            :serial t
                            :pathname "mod/usr"
                            :components ((:static-file "js/enter.js")
                                         (:static-file "js/jquery.fancybox.pack.js")
                                         (:file "usr")
                                         (:file "routes")))
                   (:file "render")
                   (:file "routes")
                   (:file "init")))
