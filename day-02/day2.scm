#!/usr/local/bin/guile -s
!#
(use-modules (ice-9 textual-ports))

(define outcomes (call-with-input-file "./resources/input"
		   (lambda (port)
		     (string-split (get-string-all port) #\newline))))

(define-syntax define-rps
  (syntax-rules ()
    ((_ rps a-v b-v c-v v a b c)
     (define (rps opp)
       (let ((vals `((,a . ,a-v)
		     (,b . ,b-v)
		     (,c . ,c-v))))
	 (+ v (cdr (assq opp vals))))))))

(define (parse-rps rps-string get-fun get-var)
  (let* ((split-rps (string-split rps-string #\space))
	 (rps-fun (string->symbol (string-downcase (get-fun split-rps))))
	 (rps-val (string->symbol (string-downcase (get-var split-rps)))))
     ((eval rps-fun (interaction-environment)) rps-val)))

(define-rps x 3 0 6 1 'a 'b 'c)
(define-rps y 6 3 0 2 'a 'b 'c)
(define-rps z 0 6 3 3 'a 'b 'c)

(define (part1)
  (apply + (map (lambda (x) (parse-rps x cadr car)) outcomes)))

(define-rps a 3 4 8 0 'x 'y 'z)
(define-rps b 1 5 9 0 'x 'y 'z)
(define-rps c 2 6 7 0 'x 'y 'z)

(define (part2)
  (apply + (map (lambda (x) (parse-rps x car cadr)) outcomes)))

(newline)
(display (part1))
(newline)
(display (part2))
(newline)
