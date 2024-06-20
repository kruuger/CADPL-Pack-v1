(defun c:CopyBlockProp  ( / sob dt act
                            
                        )
  
  (if (setq sob (entsel "\nSelect source block: "))
    (progn
      (setq dt (entget (car sob)))
      (if (= (cdr (assoc 0 dt)) "INSERT")
        (if (vlax-write-enabled-p (car sob))
          (progn
            (CBP_Dialog)
          )
          (princ "\nObject on a locked layer. ")
        )
        (princ "\nSelected item not an INSERT. ")
      )
    )
    (princ "\nNothing selected. ")
  )
  (princ)
)

(defun CBP_Dialog (/ $Tgset $Tgsel $Bitok bit bitt und dcl act)
  (defun $Bitok ()
    (mode_tile "accept"
      (if (zerop bit) 1 0)
    )
  )
  (defun $Tgset ()
    (foreach % (if (= 128 bit)(cons 128 lr)(cd:CAL_BitList bit))
      (set_tile (itoa %) "1")
    )
    ($Bitok)
    (foreach % lr
      (mode_tile (itoa %)(if (= 128 bit) 1 0))
    )
  )
  (defun $Tgsel (Key Val)
    (setq bit
      (if (zerop (read Val))
        (- bit (read Key))
        (+ bit (read Key))
      )
    )
    ($Bitok)
  )
  
  (setq dcl (load_dialog "CopyBlockProp.dcl"))
  (if (not (new_dialog "CopyBlockProp" dcl))
    (alert "Can't find CopyBlockProp.dcl")
    (progn
      
      (action_tile "TOH_ALL" "(done_dialog 1)")
      (action_tile "OK" "(done_dialog 1)")
      (action_tile "CANCEL" "(done_dialog 0)")
      (setq act (start_dialog))
      (unload_dialog dcl)
      (cond
        ( (zerop act)
          (princ "\nNo. ")
        )
        ( (= act 1)
          (princ "\nOK. ")
        )
      )
    )
  )
)

(princ)