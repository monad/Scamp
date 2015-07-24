(define-module (mpd client)
  #:version (0 1 0)
  #:use-module (ice-9 rdelim)
  #:use-module (rnrs io ports) 
  #:use-module (srfi srfi-1)
  #:use-module (ice-9 regex)
  #:export (with-mpd
            mpd-pause
            mpd-play
            mpd-trackinfo))

(define (with-mpd action)
  (let ((sock (socket PF_INET SOCK_STREAM 0)))
    (connect sock AF_INET (inet-pton AF_INET "127.0.0.1") 6600)
    (read-line sock)
    (action sock)))

(define (mpd-pause port)
  (write-line "pause" port))

(define (mpd-play port)
  (write-line "play" port))

(define (mpd-trackinfo port)
  (write-line "currentsong" port)
  (while #t
         (when (char-ready? port)
               (break (mpd-read port)))))

;; helpers
(define (mpd-read! port collection)
  (let ((line (read-line port)))
    (cond
     ((string-ci=? "OK" line)
      (string-join (reverse collection) "\n"))
     ((string-match "ACK(.*)" line) (mpd-error line))
     (else (mpd-read! port (cons line collection))))))

(define (mpd-read port) (mpd-read! port '()))

;; Processes an error message from MPD.
(define (mpd-error line)
  (let* ((data (string-match "ACK(.*)" line))
         (pos  (vector-ref data 2)))
    (if (eq? data #f)
        "Error: Unknown error."
        (string-append "Error:" (substring line (car pos) (cdr pos))))))
