; =========================================================================================== ;
; Tworzy koniec definicji bloku / Creates a block definition end                              ;
; =========================================================================================== ;
(defun cd:ENT_MakeBlockEnd ()
  (entmake
    (list
      (cons 0 "ENDBLK")
      (cons 8 "0")
    )
  )
)