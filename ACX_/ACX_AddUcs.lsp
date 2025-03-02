; =========================================================================================== ;
; Tworzy obiekt typu UCS / Creates a UCS object                                               ;
;   Name     [STR]  - nazwa ukladu wspolrzednych / coordinate system name                     ;
;   Origin   [LIST] - punkt bazowy / base point                                               ;
;   X-Vector [LIST] - wektor x / x-vector                                                     ;
;   Y-Vector [LIST] - wektor y / y-vector                                                     ;
; ------------------------------------------------------------------------------------------- ;
; (cd:ACX_AddUcs "Up" '(0. 0. 0.) '(1. 0. 0.) '(0. 1. 0.))                                    ;
; =========================================================================================== ;
(defun cd:ACX_AddUcs (Name Origin X-Vector Y-Vector) 
  (vla-add 
    (cd:ACX_Ucss)
    (vlax-3D-Point Origin)
    (vlax-3D-Point X-Vector)
    (vlax-3D-Point Y-Vector)
    Name
  )
)