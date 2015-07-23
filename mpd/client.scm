(define-module (mpd client)
	#:version (0 1 0)
	#:use-module (ice-9 rdelim)
	#:export (with-mpd mpd-pause))

(define (with-mpd action)
	(let ((sock (socket PF_INET SOCK_STREAM 0)))
		(connect sock AF_INET (inet-pton AF_INET "127.0.0.1") 6600)
		(read-line sock)
		(action sock)))

(define (mpd-pause port)
	(write-line "pause" port))
