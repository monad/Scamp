#!/usr/bin/env guile
!#
(use-modules (mpd client))
(display (with-mpd mpd-trackinfo))
