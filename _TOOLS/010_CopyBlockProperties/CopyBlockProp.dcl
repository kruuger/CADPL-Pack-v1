CopyBlockProp : dialog {
  label = "CopyBlockProp";
  :column {
    : boxed_column {
      label = "Select properties:" ;
      : toggle { key = "TOG_01"; label = "X scale factor"; }
      : toggle { key = "TOG_02"; label = "Y scale factor"; }
      : toggle { key = "TOG_03"; label = "Z scale factor"; }
      : toggle { key = "TOG_04"; label = "Rotation"; }
      : toggle { key = "TOG_05"; label = "Color"; }
      : toggle { key = "TOG_06"; label = "Linetype"; }
      : toggle { key = "TOG_07"; label = "Layer"; }
      : toggle { key = "TOG_08"; label = "Linetype scale"; }
      : toggle { key = "TOG_09"; label = "Lineweight"; }
      : toggle { key = "TOG_ALL"; label = "Select all"; }
    }
    : boxed_column {
      label = "Select block to modify:";
      : text { label = "Name: ..."; }
      : row {
        : B13 { key = "SELECT"; label = "&Select"; }
        : B13 { key = "CHANGE"; label = "C&hange"; }
      }
    }
    OK_CANCEL;
  }
}
B13 : button { width = 13; fixed_width = true; horizontal_margin = none; }
OK_CANCEL : row { fixed_width = true; alignment = centered;
   : B13 { key = "OK"; is_default = true; label = "&Ok"; }
   : B13 { key = "CANCEL"; is_cancel = true; label = "&Cancel"; }}