(require 'swank)
(swank:create-server :dont-close t :port 4555)
(push (pathname (format nil "/home/~A/repo/motoinf.ru/"
                        (sb-posix:passwd-name
                         (sb-posix:getpwuid
                          (sb-posix:stat-uid
                           (sb-posix:stat (format nil "/proc/~A" (sb-posix:getpid)))))))) asdf:*central-registry*)
(asdf:oos 'asdf:load-op :motoinf)
