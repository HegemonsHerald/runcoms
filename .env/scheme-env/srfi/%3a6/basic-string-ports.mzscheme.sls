#!r6rs #!r6rs
;; Copyright 2009 Derick Eddington.  My MIT-style license is in the file named
;; LICENSE from the original collection this file is distributed with.

(library (srfi :6 basic-string-ports)
  (export
    (rename (open-string-input-port open-input-string))
    open-output-string
    get-output-string)
  (import
    (rnrs)
    (only (scheme base) make-weak-hasheq hash-ref hash-set!))
  
  (define accumed-ht (make-weak-hasheq))
  
  (define (open-output-string)
    (letrec ((sop
              (make-custom-textual-output-port
               "string-output-port"
               (lambda (string start count)  ; write!
                 (when (positive? count)
                   (let ((al (hash-ref accumed-ht sop)))
                     (hash-set! accumed-ht sop 
                       (cons (substring string start (+ start count)) al))))
                 count)
               #F  ; get-position  TODO?
               #F  ; set-position!  TODO?
               #F  #| closed  TODO? |# )))
      (hash-set! accumed-ht sop '())
      sop))
  
  (define (get-output-string sop)
    (if (output-port? sop)
      (cond ((hash-ref accumed-ht sop #F)
             => (lambda (al) (apply string-append (reverse al))))
            (else
             (assertion-violation 'get-output-string "not a string-output-port" sop)))
      (assertion-violation 'get-output-string "not an output-port" sop)))

)
