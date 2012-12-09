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
  (tpl:root (list :content
                  (alexandria:read-file-into-string (path filename)))))

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

;; comments

(defun comment-page ()
  (tpl:root
   (list :content
         (concatenate 'string
                      (tpl:commentblock (list :messages *comments*))
                      (tpl:commentform)))))

(defun add-comment-page (redirect)
  (progn
    (setf *comments*
          (append *comments* (list
                              (list :name (hunchentoot:post-parameter "name")
                                    :msg  (hunchentoot:post-parameter "msg")))))
    (save-comments-to-file)
    (hunchentoot:redirect redirect)))


(defmacro def/comments (name param &body body)
  `(progn
     (cons
      (def/route ,name ,param
        (concatenate 'string ,@body
                     (comment-page)))
      (def/route addcomment ("addcomment" :method :post)
        (add-comment-page
         (concatenate 'string "/"
                      ,(symbol-name name)))))))

;; *ГЛАВНАЯ СТРАНИЦА*

(def/route index ("index")
  (old-page "content/index.htm"))

;; (print (macroexpand-1 '(...)))

;; *ВЕРХНЕЕ МЕНЮ*

;; Новости

(def/route news ("news")
  (old-page "content/news/news.htm"))

(def/comments 01_10_12_1 ("01_10_12_1")
  (old-page "content/news/2012/10/01_10_12_1.htm"))
(def/comments 01_10_12_2 ("01_10_12_2")
  (old-page "content/news/2012/10/01_10_12_2.htm"))
(def/route 02_10_12 ("02_10_12")
  (old-page "content/news/2012/10/02_10_12.htm"))
(def/route 03_10_12 ("03_10_12")
  (old-page "content/news/2012/10/03_10_12.htm"))
(def/route 08_10_12 ("08_10_12")
  (old-page "content/news/2012/10/08_10_12.htm"))
(def/route 16_10_12 ("16_10_12")
  (old-page "content/news/2012/10/16_10_12.htm"))
(def/route 27_10_12 ("27_10_12")
  (old-page "content/news/2012/10/27_10_12.htm"))
(def/route 17_11_12 ("17_11_12")
  (old-page "content/news/2012/11/17_11_12.htm"))

;; Галерея

(def/route gallery ("gallery")
  (old-page "content/gallery/gallery.htm"))

(def/route humor ("humor")
  (old-page "content/gallery/humor.htm"))
(def/route retro ("retro")
  (old-page "content/gallery/retro.htm"))
(def/route gal_voen ("gal_voen")
  (old-page "content/gallery/gal_voen.htm"))
(def/route gal_neobych ("gal_neobych")
  (old-page "content/gallery/gal_neobych.htm"))
(def/route gal_class ("gal_class")
  (old-page "content/gallery/gal_class.htm"))
(def/route gal_sport ("gal_sport")
  (old-page "content/gallery/gal_sport.htm"))
(def/route gal_enduro ("gal_enduro")
  (old-page "content/gallery/gal_enduro.htm"))
(def/route gal_kross ("gal_kross")
  (old-page "content/gallery/gal_kross.htm"))
(def/route gal_tur ("gal_tur")
  (old-page "content/gallery/gal_tur.htm"))
(def/route gal_trial ("gal_trial")
  (old-page "content/gallery/gal_trial.htm"))
(def/route gal_chopp ("gal_chopp")
  (old-page "content/gallery/gal_chopp.htm"))
(def/route gal_mini ("gal_mini")
  (old-page "content/gallery/gal_mini.htm"))

;; Поиск

(def/route formsearch ("formsearch")
  (old-page "content/formsearch.htm"))

;; Контакты

(def/route contacts ("contacts")
  (old-page "content/contacts.htm"))

;; Форум

(def/route forum ("forum")
  (old-page "content/forum.htm"))

;; *БОКОВОЕ МЕНЮ*

;; История

(def/route history ("history")
  (old-page "content/history/history.htm"))

(def/route history_world ("history_world")
  (old-page "content/history/history_world.htm"))
(def/route history_russia ("history_russia")
  (old-page "content/history/history_russia.htm"))
(def/route history_voen ("history_voen")
  (old-page "content/history/history_voen.htm"))

;; Устройство

(def/route construct ("construct")
  (old-page "content/construct/construct.htm"))

;; Виды

(def/route types ("types")
  (old-page "content/types/types.htm"))

;; Производители

(def/route makers ("makers")
  (old-page "content/makers/makers.htm"))

(def/route aprilia ("aprilia")
  (old-page "content/makers/aprilia.htm"))
(def/route benelli ("benelli")
  (old-page "content/makers/benelli.htm"))
(def/route beta ("beta")
  (old-page "content/makers/beta.htm"))
(def/route bmw ("bmw")
  (old-page "content/makers/bmw.htm"))
(def/route cagiva ("cagiva")
  (old-page "content/makers/cagiva.htm"))
(def/route derbi ("derbi")
  (old-page "content/makers/derbi.htm"))
(def/route ducati ("ducati")
  (old-page "content/makers/ducati.htm"))
(def/route enfield ("enfield")
  (old-page "content/makers/enfield.htm"))
(def/route gasgas ("gasgas")
  (old-page "content/makers/gasgas.htm"))
(def/route gilera ("gilera")
  (old-page "content/makers/gilera.htm"))
(def/route harley ("harley")
  (old-page "content/makers/harley.htm"))
(def/route honda ("honda")
  (old-page "content/makers/honda.htm"))
(def/route husaberg ("husaberg")
  (old-page "content/makers/husaberg.htm"))
(def/route husqvarna ("husqvarna")
  (old-page "content/makers/husqvarna.htm"))
(def/route hyosung ("hyosung")
  (old-page "content/makers/hyosung.htm"))
(def/route kawasaki ("kawasaki")
  (old-page "content/makers/kawasaki.htm"))
(def/route keeway ("keeway")
  (old-page "content/makers/keeway.htm"))
(def/route ktm ("ktm")
  (old-page "content/makers/ktm.htm"))
(def/route kymco ("kymco")
  (old-page "content/makers/kymco.htm"))
(def/route laverda ("laverda")
  (old-page "content/makers/laverda.htm"))
(def/route malaguti ("malaguti")
  (old-page "content/makers/malaguti.htm"))
(def/route motog ("motoguzzi")
  (old-page "content/makers/motoguzzi.htm"))
(def/route motomorini ("motomorini")
  (old-page "content/makers/motomorini.htm"))
(def/route mbk ("mbk")
  (old-page "content/makers/mbk.htm"))
(def/route mz ("mz")
  (old-page "content/makers/mz.htm"))
(def/route mvagusta ("mvagusta")
  (old-page "content/makers/mvagusta.htm"))
(def/route peugeot ("peugeot")
  (old-page "content/makers/peugeot.htm"))
(def/route pgo ("pgo")
  (old-page "content/makers/pgo.htm"))
(def/route piaggio ("piaggio")
  (old-page "content/makers/piaggio.htm"))
(def/route rieju ("rieju")
  (old-page "content/makers/rieju.htm"))
(def/route sherco ("sherco")
  (old-page "content/makers/sherco.htm"))
(def/route suzuki ("suzuki")
  (old-page "content/makers/suzuki.htm"))
(def/route sym ("sym")
  (old-page "content/makers/sym.htm"))
(def/route tmracing ("tmracing")
  (old-page "content/makers/tmracing.htm"))
(def/route tgb ("tgb")
  (old-page "content/makers/tgb.htm"))
(def/route triumph ("triumph")
  (old-page "content/makers/triumph.htm"))
(def/route veli ("veli")
  (old-page "content/makers/veli.htm"))
(def/route vespa ("vespa")
  (old-page "content/makers/vespa.htm"))
(def/route victory ("victory")
  (old-page "content/makers/victory.htm"))
(def/route yamaha ("yamaha")
  (old-page "content/makers/yamaha.htm"))

;; Выбор

(def/route select ("select")
  (old-page "content/select/select.htm"))

;; Права

(def/route licence ("license")
  (old-page "content/license/license.htm"))

;; Экипировка

(def/route equip ("equip")
  (old-page "content/equip/equip.htm"))

;; Вождение

(def/route driving ("driving")
  (old-page "content/driving/driving.htm"))

(def/route dr_stseplenie ("dr_stseplenie")
  (old-page "content/driving/dr_stseplenie.htm"))
(def/route dr_rulenie ("dr_rulenie")
  (old-page "content/driving/dr_rulenie.htm"))
(def/route dr_podveska ("dr_podveska")
  (old-page "content/driving/dr_podveska.htm"))
(def/route dr_passagir ("dr_passagir")
  (old-page "content/driving/dr_passagir.htm"))
(def/route dr_group ("dr_group")
  (old-page "content/driving/dr_group.htm"))
(def/route dr_group_1 ("dr_group_1")
  (old-page "content/driving/dr_group_1.htm"))
(def/route dr_group_2 ("dr_group_2")
  (old-page "content/driving/dr_group_2.htm"))
(def/route dr_group_3 ("dr_group_3")
  (old-page "content/driving/dr_group_3.htm"))
(def/route dr_group_4 ("dr_group_4")
  (old-page "content/driving/dr_group_4.htm"))
(def/route dr_group_5 ("dr_group_5")
  (old-page "content/driving/dr_group_5.htm"))
(def/route dr_group_6 ("dr_group_6")
  (old-page "content/driving/dr_group_6.htm"))
(def/route dr_group_7 ("dr_group_7")
  (old-page "content/driving/dr_group_7.htm"))
(def/route dr_group_8 ("dr_group_8")
  (old-page "content/driving/dr_group_8.htm"))

;; Ремонт

(def/route repair ("repair")
  (old-page "content/repair/repair.htm"))

;; Мотоспорт

(def/route sport ("sport")
  (old-page "content/sport/sport.htm"))

;; Мототуризм

(def/route travels ("travels")
  (old-page "content/travels/travels.htm"))

;; Фильмы книги песни

(def/route fbs ("fbs")
  (old-page "content/fbs.htm"))

;; Фильмы

(def/route films ("films")
  (old-page "content/films/films.htm"))

(def/route dikar ("dikar")
  (old-page "content/films/dikar.htm"))
(def/route wildangels ("wildangels")
  (old-page "content/films/wildangels.htm"))
(def/route theleather ("theleather")
  (old-page "content/films/theleather.htm"))
(def/route motorpsycho ("motorpsycho")
  (old-page "content/films/motorpsycho.htm"))
(def/route hellsangels ("hellsangels")
  (old-page "content/films/hellsangels.htm"))
(def/route theborn ("theborn")
  (old-page "content/films/theborn.htm"))
(def/route girlon ("girlon")
  (old-page "content/films/girlon.htm"))
(def/route easyrider ("easyrider")
  (old-page "content/films/easyrider.htm"))
(def/route runangel ("runangel")
  (old-page "content/films/runangel.htm"))
(def/route hellsangels69 ("hellsangels69")
  (old-page "content/films/hellsangels69.htm"))
(def/route cyclesavages ("cyclesavages")
  (old-page "content/films/cyclesavages.htm"))
(def/route angelunch ("angelunch")
  (old-page "content/films/angelunch.htm"))
(def/route ccand ("ccand")
  (old-page "content/films/ccand.htm"))
(def/route chrom ("chrom")
  (old-page "content/films/chrom.htm"))
(def/route angelshard ("angelshard")
  (old-page "content/films/angelshard.htm"))
(def/route angelswild ("angelswild")
  (old-page "content/films/angelswild.htm"))
(def/route electra ("electra")
  (old-page "content/films/electra.htm"))
(def/route stone ("stone")
  (old-page "content/films/stone.htm"))
(def/route madmax ("madmax")
  (old-page "content/films/madmax.htm"))
(def/route spetters ("spetters")
  (old-page "content/films/spetters.htm"))
(def/route silverdream ("silverdream")
  (old-page "content/films/silverdream.htm"))
(def/route madfoxes ("madfoxes")
  (old-page "content/films/madfoxes.htm"))
(def/route kinghtriders ("kinghtriders")
  (old-page "content/films/kinghtriders.htm"))
(def/route loveless ("loveless")
  (old-page "content/films/loveless.htm"))
(def/route eyeof ("eyeof")
  (old-page "content/films/eyeof.htm"))
(def/route thelostboys ("thelostboys")
  (old-page "content/films/thelostboys.htm"))
(def/route chopperchicks ("chopperchicks")
  (old-page "content/films/chopperchicks.htm"))
(def/route easywheels ("easywheels")
  (old-page "content/films/easywheels.htm"))
(def/route masters ("masters")
  (old-page "content/films/masters.htm"))
(def/route vampiremoto ("vampiremoto")
  (old-page "content/films/vampiremoto.htm"))
(def/route stonecold ("stonecold")
  (old-page "content/films/stonecold.htm"))
(def/route harleyand ("harleyand")
  (old-page "content/films/harleyand.htm"))
(def/route coolasice ("coolasice")
  (old-page "content/films/coolasice.htm"))
(def/route fixingthe ("fixingthe")
  (old-page "content/films/fixingthe.htm"))
(def/route runningcool ("runningcool")
  (old-page "content/films/runningcool.htm"))
(def/route rebelrun ("rebelrun")
  (old-page "content/films/rebelrun.htm"))
(def/route deathriders ("deathriders")
  (old-page "content/films/deathriders.htm"))
(def/route motogang ("motogang")
  (old-page "content/films/motogang.htm"))
(def/route trustinme ("trustinme")
  (old-page "content/films/trustinme.htm"))
(def/route irongirl ("irongirl")
  (old-page "content/films/irongirl.htm"))
(def/route stranger ("stranger")
  (old-page "content/films/stranger.htm"))
(def/route murdercycle ("murdercycle")
  (old-page "content/films/murdercycle.htm"))
(def/route meandwill ("meandwill")
  (old-page "content/films/meandwill.htm"))
(def/route hochelaga ("hochelaga")
  (old-page "content/films/hochelaga.htm"))
(def/route screaming ("screaming")
  (old-page "content/films/screaming.htm"))
(def/route lonehero ("lonehero")
  (old-page "content/films/lonehero.htm"))
(def/route brownbunny ("brownbunny")
  (old-page "content/films/brownbunny.htm"))
(def/route bikerboyz ("bikerboyz")
  (old-page "content/films/bikerboyz.htm"))
(def/route torque ("torque")
  (old-page "content/films/torque.htm"))
(def/route motokids ("motokids")
  (old-page "content/films/motokids.htm"))
(def/route silverhawk ("silverhawk")
  (old-page "content/films/silverhawk.htm"))
(def/route roadkings ("roadkings")
  (old-page "content/films/roadkings.htm"))
(def/route diarios ("diarios")
  (old-page "content/films/diarios.htm"))
(def/route supercross ("supercross")
  (old-page "content/films/supercross.htm"))
(def/route fastestind ("fastestind")
  (old-page "content/films/fastestind.htm"))
(def/route rainmakers ("rainmakers")
  (old-page "content/films/rainmakers.htm"))
(def/route motozombies ("motozombies")
  (old-page "content/films/motozombies.htm"))
(def/route ghostrider ("ghostrider")
  (old-page "content/films/ghostrider.htm"))
(def/route hotrod ("hotrod")
  (old-page "content/films/hotrod.htm"))
(def/route wildhogs ("wildhogs")
  (old-page "content/films/wildhogs.htm"))
(def/route oneweek ("oneweek")
  (old-page "content/films/oneweek.htm"))
(def/route hellride ("hellride")
  (old-page "content/films/hellride.htm"))
(def/route exitspeed ("exitspeed")
  (old-page "content/films/exitspeed.htm"))

;; Книги

(def/route books ("books")
  (old-page "content/books/books.htm"))

;; Песни

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
(def/route john ("john")
  (old-page "content/songs/john.htm"))
(def/route lonnie ("lonnie")
  (old-page "content/songs/lonnie.htm"))
(def/route lesbaxter ("lesbaxter")
  (old-page "content/songs/lesbaxter.htm"))
(def/route manowar1 ("manowar1")
  (old-page "content/songs/manowar1.htm"))
(def/route manowar2 ("manowar2")
  (old-page "content/songs/manowar2.htm"))
(def/route megadeth ("megadeth")
  (old-page "content/songs/megadeth.htm"))
(def/route metall1 ("metall1")
  (old-page "content/songs/metall1.htm"))
(def/route metall2  ("metall2")
  (old-page "content/songs/metall2.htm"))
(def/route motor ("motor")
  (old-page "content/songs/motor.htm"))
(def/route rammst1 ("rammst1")
  (old-page "content/songs/rammst1.htm"))
(def/route  rammst2 ("rammst2")
  (old-page "content/songs/rammst2.htm"))
(def/route sonseals ("sonseals")
  (old-page "content/songs/sonseals.htm"))
(def/route steppen ("steppen")
  (old-page "content/songs/steppen.htm"))
(def/route  thebyrds ("thebyrds")
  (old-page "content/songs/thebyrds.htm"))
(def/route themeatmen ("themeatmen")
  (old-page "content/songs/themeatmen.htm"))
(def/route thetroggs ("thetroggs")
  (old-page "content/songs/thetroggs.htm"))
(def/route twins ("twins")
  (old-page "content/songs/twins.htm"))
(def/route wolver ("wolver")
  (old-page "content/songs/wolver.htm"))
(def/route ugly ("ugly")
  (old-page "content/songs/ugly.htm"))

(def/route agata ("agata")
  (old-page "content/songs/agata.htm"))
(def/route arava ("arava")
  (old-page "content/songs/arava.htm"))
(def/route aria1 ("aria1")
  (old-page "content/songs/aria1.htm"))
(def/route aria2 ("aria2")
  (old-page "content/songs/aria2.htm"))
(def/route aria3 ("aria3")
  (old-page "content/songs/aria3.htm"))
(def/route aria4 ("aria4")
  (old-page "content/songs/aria4.htm"))
(def/route astra ("astra")
  (old-page "content/songs/astra.htm"))
(def/route bezdna ("bezdna")
  (old-page "content/songs/bezdna.htm"))
(def/route vavilon ("vavilon")
  (old-page "content/songs/vavilon.htm"))
(def/route velikie ("velikie")
  (old-page "content/songs/velikie.htm"))
(def/route gvozdi ("gvozdi")
  (old-page "content/songs/gvozdi.htm"))
(def/route kanal ("kanal")
  (old-page "content/songs/kanal.htm"))
(def/route korol ("korol")
  (old-page "content/songs/korol.htm"))
(def/route kruger1 ("kruger1")
  (old-page "content/songs/kruger1.htm"))
(def/route kruger2 ("kruger2")
  (old-page "content/songs/kruger2.htm"))
(def/route leningrad ("leningrad")
  (old-page "content/songs/leningrad.htm"))
(def/route lys ("lys")
  (old-page "content/songs/lys.htm"))
(def/route natisk1 ("natisk1")
  (old-page "content/songs/natisk1.htm"))
(def/route natisk2 ("natisk2")
  (old-page "content/songs/natisk2.htm"))
(def/route nol ("nol")
  (old-page "content/songs/nol.htm"))
(def/route piligrim ("piligrim")
  (old-page "content/songs/piligrim.htm"))
(def/route poehali ("poehali")
  (old-page "content/songs/poehali.htm"))
(def/route polnolun ("polnolun")
  (old-page "content/songs/polnolun.htm"))
(def/route post ("post")
  (old-page "content/songs/post.htm"))
(def/route retriem ("retriem")
  (old-page "content/songs/retriem.htm"))
(def/route rocksind ("rocksind")
  (old-page "content/songs/rocksind.htm"))
(def/route secret ("secret")
  (old-page "content/songs/secret.htm"))
(def/route sector ("sector")
  (old-page "content/songs/sector.htm"))
(def/route teatr ("teatr")
  (old-page "content/songs/teatr.htm"))
(def/route chizh ("chizh")
  (old-page "content/songs/chizh.htm"))
(def/route erotika ("erotika")
  (old-page "content/songs/erotika.htm"))


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


