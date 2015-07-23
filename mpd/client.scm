(define-module (mpd client)
  #:version (0 1 0)
  #:use-module (ice-9 rdelim)
  #:use-module (rnrs io ports) 
  #:export (with-mpd mpd-pause mpd-trackinfo))

(define (with-mpd action)
  (let ((sock (socket PF_INET SOCK_STREAM 0)))
    (connect sock AF_INET (inet-pton AF_INET "127.0.0.1") 6600)
    (read-line sock)
    (action sock)))

(define (mpd-pause port)
  (write-line "pause" port))

(define (mpd-trackinfo port)
  (write-line "currentsong" port)
    (while #t
           (when (char-ready? port)
                 (break (mpd-read port)))))

;; helpers

(define (mpd-read! port collection)
  (let ((line (read-line port)))
    (if (string-ci=? "OK" line)
        (string-join (reverse collection) "\n")
        (mpd-read! port (cons line collection)))))

(define (mpd-read port) (mpd-read! port '()))
