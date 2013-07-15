(in-package #:motoinf)

(defmacro bprint (var)
  `(subseq (with-output-to-string (*standard-output*)
             (pprint ,var)) 1))


;; 404

(defun page-404 (&optional (title "404 Not Found") (content "Страница не найдена"))
  "404")

(restas:define-route not-found-route ("*any")
  (restas:abort-route-handler
   (page-404)
   :return-code hunchentoot:+http-not-found+
   :content-type "text/html"))

(defun op (filename)
  (tpl:root (list :content
                  (alexandria:read-file-into-string (path filename)))))

;; main

(restas:define-route main ("/")
  (op "content/index.htm"))


;; plan file pages

(defmacro def/route (name param &body body)
  `(progn
     (restas:define-route ,name ,param
       ,@body)
     (restas:define-route
         ,(intern (concatenate 'string (symbol-name name) "/"))
         ,(cons (concatenate 'string (car param) "/") (cdr param))
       ,@body)))


(restas:define-route addcomment ("addcomment" :method :post)
  (progn
    (let* ((pattern (hunchentoot:referer))
           (pos (position #\/ pattern :from-end t))
           (match (subseq pattern (+ pos 1)))
           (variable (intern (concatenate 'string "*" match  "*") (find-package "MOTOINF")))
           (filename (concatenate 'string *comment-path* match ".txt")))
      (setf (symbol-value variable)
            (append (symbol-value variable) (list
                                             (list :name (hunchentoot:post-parameter "name")
                                                   :msg  (hunchentoot:post-parameter "msg")))))

      (alexandria:write-string-into-file
       (bprint (symbol-value variable))
       filename
       :if-exists :supersede)
      (hunchentoot:redirect (hunchentoot:referer)))))



(defmacro def/comments (name &body body)
  (let* ((str-name (symbol-name name))
         (filename (concatenate 'string *comment-path* str-name ".txt"))
         (variable (intern (concatenate 'string "*" str-name "*"))))
    `(progn
       ;; create dynamic variable
       (defparameter ,variable nil)
       ;; if not exists file - create empty
       (unless (probe-file ,filename)
         (alexandria:write-string-into-file
          (bprint ,variable)
          ,filename
          :if-exists :supersede))
       ;; read comments from file to variable
       (setf ,variable
         (read-from-string
          (alexandria:read-file-into-string
           ,(concatenate 'string *comment-path* str-name ".txt"))))
       ;; create route for show comments
       (def/route ,(intern (concatenate 'string "ROUTE_" str-name)) (,str-name)
         (concatenate 'string
                      ,@body
                      (tpl:root
                       (list :content
                             (concatenate 'string
                                          (tpl:commentblock (list :messages ,variable))
                                          (tpl:commentform)))))))))


;; *ГЛАВНАЯ СТРАНИЦА*

(def/route index ("index")
  (op "content/index.htm"))

;; *ВЕРХНЕЕ МЕНЮ*

;; Новости

(def/route news ("news") (op "content/news/news.htm"))

(def/comments 01_10_12_1  (op "content/news/2012/10/01_10_12_1.htm"))
(def/comments 01_10_12_2  (op "content/news/2012/10/01_10_12_2.htm"))
(def/comments 02_10_12  (op "content/news/2012/10/02_10_12.htm"))
(def/comments 03_10_12  (op "content/news/2012/10/03_10_12.htm"))
(def/comments 08_10_12  (op "content/news/2012/10/08_10_12.htm"))
(def/comments 16_10_12  (op "content/news/2012/10/16_10_12.htm"))
(def/comments 27_10_12  (op "content/news/2012/10/27_10_12.htm"))
(def/comments 17_11_12  (op "content/news/2012/11/17_11_12.htm"))

;; Галерея

(def/route gallery ("gallery")
  (op "content/gallery/gallery.htm"))

(def/route humor ("humor")
  (op "content/gallery/humor.htm"))
(def/route retro ("retro")
  (op "content/gallery/retro.htm"))
(def/route gal_voen ("gal_voen")
  (op "content/gallery/gal_voen.htm"))
(def/route gal_neobych ("gal_neobych")
  (op "content/gallery/gal_neobych.htm"))
(def/route gal_class ("gal_class")
  (op "content/gallery/gal_class.htm"))
(def/route gal_sport ("gal_sport")
  (op "content/gallery/gal_sport.htm"))
(def/route gal_enduro ("gal_enduro")
  (op "content/gallery/gal_enduro.htm"))
(def/route gal_kross ("gal_kross")
  (op "content/gallery/gal_kross.htm"))
(def/route gal_tur ("gal_tur")
  (op "content/gallery/gal_tur.htm"))
(def/route gal_trial ("gal_trial")
  (op "content/gallery/gal_trial.htm"))
(def/route gal_chopp ("gal_chopp")
  (op "content/gallery/gal_chopp.htm"))
(def/route gal_mini ("gal_mini")
  (op "content/gallery/gal_mini.htm"))

;; Поиск

(def/route formsearch ("formsearch")
  (op "content/formsearch.htm"))

;; Контакты

(def/route contacts ("contacts")
  (op "content/contacts.htm"))

;; Форум

(def/route forum ("forum")
  (op "content/forum.htm"))

;; *БОКОВОЕ МЕНЮ*

;; История

(def/route history ("history")
  (op "content/history/history.htm"))

(def/route history_world ("history_world")
  (op "content/history/history_world.htm"))
(def/route history_russia ("history_russia")
  (op "content/history/history_russia.htm"))
(def/route history_voen ("history_voen")
  (op "content/history/history_voen.htm"))

;; Устройство

(def/route construct ("construct")
  (op "content/construct/construct.htm"))

;; Виды

(def/route types ("types")
  (op "content/types/types.htm"))

;; Производители

(def/route makers ("makers")
  (op "content/makers/makers.htm"))

(def/route aprilia ("aprilia")
  (op "content/makers/aprilia.htm"))
(def/route benelli ("benelli")
  (op "content/makers/benelli.htm"))
(def/route beta ("beta")
  (op "content/makers/beta.htm"))
(def/route bmw ("bmw")
  (op "content/makers/bmw.htm"))
(def/route cagiva ("cagiva")
  (op "content/makers/cagiva.htm"))
(def/route derbi ("derbi")
  (op "content/makers/derbi.htm"))
(def/route ducati ("ducati")
  (op "content/makers/ducati.htm"))
(def/route enfield ("enfield")
  (op "content/makers/enfield.htm"))
(def/route gasgas ("gasgas")
  (op "content/makers/gasgas.htm"))
(def/route gilera ("gilera")
  (op "content/makers/gilera.htm"))
(def/route harley ("harley")
  (op "content/makers/harley.htm"))
(def/route honda ("honda")
  (op "content/makers/honda.htm"))
(def/route husaberg ("husaberg")
  (op "content/makers/husaberg.htm"))
(def/route husqvarna ("husqvarna")
  (op "content/makers/husqvarna.htm"))
(def/route hyosung ("hyosung")
  (op "content/makers/hyosung.htm"))
(def/route kawasaki ("kawasaki")
  (op "content/makers/kawasaki.htm"))
(def/route keeway ("keeway")
  (op "content/makers/keeway.htm"))
(def/route ktm ("ktm")
  (op "content/makers/ktm.htm"))
(def/route kymco ("kymco")
  (op "content/makers/kymco.htm"))
(def/route laverda ("laverda")
  (op "content/makers/laverda.htm"))
(def/route malaguti ("malaguti")
  (op "content/makers/malaguti.htm"))
(def/route motog ("motoguzzi")
  (op "content/makers/motoguzzi.htm"))
(def/route motomorini ("motomorini")
  (op "content/makers/motomorini.htm"))
(def/route mbk ("mbk")
  (op "content/makers/mbk.htm"))
(def/route mz ("mz")
  (op "content/makers/mz.htm"))
(def/route mvagusta ("mvagusta")
  (op "content/makers/mvagusta.htm"))
(def/route peugeot ("peugeot")
  (op "content/makers/peugeot.htm"))
(def/route pgo ("pgo")
  (op "content/makers/pgo.htm"))
(def/route piaggio ("piaggio")
  (op "content/makers/piaggio.htm"))
(def/route rieju ("rieju")
  (op "content/makers/rieju.htm"))
(def/route sherco ("sherco")
  (op "content/makers/sherco.htm"))
(def/route suzuki ("suzuki")
  (op "content/makers/suzuki.htm"))
(def/route sym ("sym")
  (op "content/makers/sym.htm"))
(def/route tmracing ("tmracing")
  (op "content/makers/tmracing.htm"))
(def/route tgb ("tgb")
  (op "content/makers/tgb.htm"))
(def/route triumph ("triumph")
  (op "content/makers/triumph.htm"))
(def/route veli ("veli")
  (op "content/makers/veli.htm"))
(def/route vespa ("vespa")
  (op "content/makers/vespa.htm"))
(def/route victory ("victory")
  (op "content/makers/victory.htm"))
(def/route yamaha ("yamaha")
  (op "content/makers/yamaha.htm"))

;; Выбор

(def/route select ("select")
  (op "content/select/select.htm"))

;; Права

(def/route licence ("license")
  (op "content/license/license.htm"))

;; Экипировка

(def/route equip ("equip")
  (op "content/equip/equip.htm"))

;; Вождение

(def/route driving ("driving")
  (op "content/driving/driving.htm"))

(def/route dr_stseplenie ("dr_stseplenie")
  (op "content/driving/dr_stseplenie.htm"))
(def/route dr_rulenie ("dr_rulenie")
  (op "content/driving/dr_rulenie.htm"))
(def/route dr_podveska ("dr_podveska")
  (op "content/driving/dr_podveska.htm"))
(def/route dr_passagir ("dr_passagir")
  (op "content/driving/dr_passagir.htm"))
(def/route dr_group ("dr_group")
  (op "content/driving/dr_group.htm"))
(def/route dr_group_1 ("dr_group_1")
  (op "content/driving/dr_group_1.htm"))
(def/route dr_group_2 ("dr_group_2")
  (op "content/driving/dr_group_2.htm"))
(def/route dr_group_3 ("dr_group_3")
  (op "content/driving/dr_group_3.htm"))
(def/route dr_group_4 ("dr_group_4")
  (op "content/driving/dr_group_4.htm"))
(def/route dr_group_5 ("dr_group_5")
  (op "content/driving/dr_group_5.htm"))
(def/route dr_group_6 ("dr_group_6")
  (op "content/driving/dr_group_6.htm"))
(def/route dr_group_7 ("dr_group_7")
  (op "content/driving/dr_group_7.htm"))
(def/route dr_group_8 ("dr_group_8")
  (op "content/driving/dr_group_8.htm"))

;; Ремонт

(def/route repair ("repair")
  (op "content/repair/repair.htm"))

;; Мотоспорт

(def/route sport ("sport")
  (op "content/sport/sport.htm"))

;; Мототуризм

(def/route travels ("travels")
  (op "content/travels/travels.htm"))

;; Фильмы книги песни

(def/route fbs ("fbs")
  (op "content/fbs.htm"))

;; Фильмы

(def/route films ("films")
  (op "content/films/films.htm"))

(def/route dikar ("dikar")
  (op "content/films/dikar.htm"))
(def/route wildangels ("wildangels")
  (op "content/films/wildangels.htm"))
(def/route theleather ("theleather")
  (op "content/films/theleather.htm"))
(def/route motorpsycho ("motorpsycho")
  (op "content/films/motorpsycho.htm"))
(def/route hellsangels ("hellsangels")
  (op "content/films/hellsangels.htm"))
(def/route theborn ("theborn")
  (op "content/films/theborn.htm"))
(def/route girlon ("girlon")
  (op "content/films/girlon.htm"))
(def/route easyrider ("easyrider")
  (op "content/films/easyrider.htm"))
(def/route runangel ("runangel")
  (op "content/films/runangel.htm"))
(def/route hellsangels69 ("hellsangels69")
  (op "content/films/hellsangels69.htm"))
(def/route cyclesavages ("cyclesavages")
  (op "content/films/cyclesavages.htm"))
(def/route angelunch ("angelunch")
  (op "content/films/angelunch.htm"))
(def/route ccand ("ccand")
  (op "content/films/ccand.htm"))
(def/route chrom ("chrom")
  (op "content/films/chrom.htm"))
(def/route angelshard ("angelshard")
  (op "content/films/angelshard.htm"))
(def/route angelswild ("angelswild")
  (op "content/films/angelswild.htm"))
(def/route electra ("electra")
  (op "content/films/electra.htm"))
(def/route stone ("stone")
  (op "content/films/stone.htm"))
(def/route madmax ("madmax")
  (op "content/films/madmax.htm"))
(def/route spetters ("spetters")
  (op "content/films/spetters.htm"))
(def/route silverdream ("silverdream")
  (op "content/films/silverdream.htm"))
(def/route madfoxes ("madfoxes")
  (op "content/films/madfoxes.htm"))
(def/route kinghtriders ("kinghtriders")
  (op "content/films/kinghtriders.htm"))
(def/route loveless ("loveless")
  (op "content/films/loveless.htm"))
(def/route eyeof ("eyeof")
  (op "content/films/eyeof.htm"))
(def/route thelostboys ("thelostboys")
  (op "content/films/thelostboys.htm"))
(def/route chopperchicks ("chopperchicks")
  (op "content/films/chopperchicks.htm"))
(def/route easywheels ("easywheels")
  (op "content/films/easywheels.htm"))
(def/route masters ("masters")
  (op "content/films/masters.htm"))
(def/route vampiremoto ("vampiremoto")
  (op "content/films/vampiremoto.htm"))
(def/route stonecold ("stonecold")
  (op "content/films/stonecold.htm"))
(def/route harleyand ("harleyand")
  (op "content/films/harleyand.htm"))
(def/route coolasice ("coolasice")
  (op "content/films/coolasice.htm"))
(def/route fixingthe ("fixingthe")
  (op "content/films/fixingthe.htm"))
(def/route runningcool ("runningcool")
  (op "content/films/runningcool.htm"))
(def/route rebelrun ("rebelrun")
  (op "content/films/rebelrun.htm"))
(def/route deathriders ("deathriders")
  (op "content/films/deathriders.htm"))
(def/route motogang ("motogang")
  (op "content/films/motogang.htm"))
(def/route trustinme ("trustinme")
  (op "content/films/trustinme.htm"))
(def/route irongirl ("irongirl")
  (op "content/films/irongirl.htm"))
(def/route stranger ("stranger")
  (op "content/films/stranger.htm"))
(def/route murdercycle ("murdercycle")
  (op "content/films/murdercycle.htm"))
(def/route meandwill ("meandwill")
  (op "content/films/meandwill.htm"))
(def/route hochelaga ("hochelaga")
  (op "content/films/hochelaga.htm"))
(def/route screaming ("screaming")
  (op "content/films/screaming.htm"))
(def/route lonehero ("lonehero")
  (op "content/films/lonehero.htm"))
(def/route brownbunny ("brownbunny")
  (op "content/films/brownbunny.htm"))
(def/route bikerboyz ("bikerboyz")
  (op "content/films/bikerboyz.htm"))
(def/route torque ("torque")
  (op "content/films/torque.htm"))
(def/route motokids ("motokids")
  (op "content/films/motokids.htm"))
(def/route silverhawk ("silverhawk")
  (op "content/films/silverhawk.htm"))
(def/route roadkings ("roadkings")
  (op "content/films/roadkings.htm"))
(def/route diarios ("diarios")
  (op "content/films/diarios.htm"))
(def/route supercross ("supercross")
  (op "content/films/supercross.htm"))
(def/route fastestind ("fastestind")
  (op "content/films/fastestind.htm"))
(def/route rainmakers ("rainmakers")
  (op "content/films/rainmakers.htm"))
(def/route motozombies ("motozombies")
  (op "content/films/motozombies.htm"))
(def/route ghostrider ("ghostrider")
  (op "content/films/ghostrider.htm"))
(def/route hotrod ("hotrod")
  (op "content/films/hotrod.htm"))
(def/route wildhogs ("wildhogs")
  (op "content/films/wildhogs.htm"))
(def/route oneweek ("oneweek")
  (op "content/films/oneweek.htm"))
(def/route hellride ("hellride")
  (op "content/films/hellride.htm"))
(def/route exitspeed ("exitspeed")
  (op "content/films/exitspeed.htm"))

;; Книги

(def/route books ("books")
  (op "content/books/books.htm"))

;; Песни

(def/route songs ("songs")
  (op "content/songs/songs.htm"))

(def/route acdc  ("acdc")
  (op "content/songs/acdc.htm"))
(def/route abcd ("abcd")
  (op "content/songs/abcd.htm"))
(def/route billyidol ("billyidol")
  (op "content/songs/billyidol.htm"))
(def/route bonjovi ("bonjovi")
  (op "content/songs/bonjovi.htm"))
(def/route bonnie ("bonnie")
  (op "content/songs/bonnie.htm"))
(def/route buddy ("buddy")
  (op "content/songs/buddy.htm"))
(def/route brownie ("brownie")
  (op "content/songs/brownie.htm"))
(def/route chris ("chris")
  (op "content/songs/chris.htm"))
(def/route diesel ("diesel")
  (op "content/songs/diesel.htm"))
(def/route freddie ("freddie")
  (op "content/songs/freddie.htm"))
(def/route george ("george")
  (op "content/songs/george.htm"))
(def/route golden ("golden")
  (op "content/songs/golden.htm"))
(def/route greg ("greg")
  (op "content/songs/greg.htm"))
(def/route john ("john")
  (op "content/songs/john.htm"))
(def/route lonnie ("lonnie")
  (op "content/songs/lonnie.htm"))
(def/route lesbaxter ("lesbaxter")
  (op "content/songs/lesbaxter.htm"))
(def/route manowar1 ("manowar1")
  (op "content/songs/manowar1.htm"))
(def/route manowar2 ("manowar2")
  (op "content/songs/manowar2.htm"))
(def/route megadeth ("megadeth")
  (op "content/songs/megadeth.htm"))
(def/route metall1 ("metall1")
  (op "content/songs/metall1.htm"))
(def/route metall2  ("metall2")
  (op "content/songs/metall2.htm"))
(def/route motor ("motor")
  (op "content/songs/motor.htm"))
(def/route rammst1 ("rammst1")
  (op "content/songs/rammst1.htm"))
(def/route  rammst2 ("rammst2")
  (op "content/songs/rammst2.htm"))
(def/route sonseals ("sonseals")
  (op "content/songs/sonseals.htm"))
(def/route steppen ("steppen")
  (op "content/songs/steppen.htm"))
(def/route  thebyrds ("thebyrds")
  (op "content/songs/thebyrds.htm"))
(def/route themeatmen ("themeatmen")
  (op "content/songs/themeatmen.htm"))
(def/route thetroggs ("thetroggs")
  (op "content/songs/thetroggs.htm"))
(def/route twins ("twins")
  (op "content/songs/twins.htm"))
(def/route wolver ("wolver")
  (op "content/songs/wolver.htm"))
(def/route ugly ("ugly")
  (op "content/songs/ugly.htm"))

(def/route agata ("agata")
  (op "content/songs/agata.htm"))
(def/route arava ("arava")
  (op "content/songs/arava.htm"))
(def/route aria1 ("aria1")
  (op "content/songs/aria1.htm"))
(def/route aria2 ("aria2")
  (op "content/songs/aria2.htm"))
(def/route aria3 ("aria3")
  (op "content/songs/aria3.htm"))
(def/route aria4 ("aria4")
  (op "content/songs/aria4.htm"))
(def/route astra ("astra")
  (op "content/songs/astra.htm"))
(def/route bezdna ("bezdna")
  (op "content/songs/bezdna.htm"))
(def/route vavilon ("vavilon")
  (op "content/songs/vavilon.htm"))
(def/route velikie ("velikie")
  (op "content/songs/velikie.htm"))
(def/route gvozdi ("gvozdi")
  (op "content/songs/gvozdi.htm"))
(def/route kanal ("kanal")
  (op "content/songs/kanal.htm"))
(def/route korol ("korol")
  (op "content/songs/korol.htm"))
(def/route kruger1 ("kruger1")
  (op "content/songs/kruger1.htm"))
(def/route kruger2 ("kruger2")
  (op "content/songs/kruger2.htm"))
(def/route leningrad ("leningrad")
  (op "content/songs/leningrad.htm"))
(def/route lys ("lys")
  (op "content/songs/lys.htm"))
(def/route natisk1 ("natisk1")
  (op "content/songs/natisk1.htm"))
(def/route natisk2 ("natisk2")
  (op "content/songs/natisk2.htm"))
(def/route nol ("nol")
  (op "content/songs/nol.htm"))
(def/route piligrim ("piligrim")
  (op "content/songs/piligrim.htm"))
(def/route poehali ("poehali")
  (op "content/songs/poehali.htm"))
(def/route polnolun ("polnolun")
  (op "content/songs/polnolun.htm"))
(def/route post ("post")
  (op "content/songs/post.htm"))
(def/route retriem ("retriem")
  (op "content/songs/retriem.htm"))
(def/route rocksind ("rocksind")
  (op "content/songs/rocksind.htm"))
(def/route secret ("secret")
  (op "content/songs/secret.htm"))
(def/route sector ("sector")
  (op "content/songs/sector.htm"))
(def/route teatr ("teatr")
  (op "content/songs/teatr.htm"))
(def/route chizh ("chizh")
  (op "content/songs/chizh.htm"))
(def/route erotika ("erotika")
  (op "content/songs/erotika.htm"))


;; trans
(def/route trans ("trans")
  "wefewf")



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
