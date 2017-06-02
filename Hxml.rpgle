
      *  procedure prototypes 

      *-------------------------------------------------------
       Dcl-PR #StartWorkBook  ind;
       End-PR;

      *-------------------------------------------------------
       Dcl-PR #EndWorkBook  ind;
       End-PR;

      *-------------------------------------------------------
       Dcl-PR #StartSheet  ind;
         SheetName    char(30);
       End-PR;

      *-------------------------------------------------------
       Dcl-PR #EndSheet  ind;
       End-PR;

      *-------------------------------------------------------

       Dcl-PR #SetColWidths  ind;
         Widths    zoned(3:0) dim(100);
       End-PR;

      *-------------------------------------------------------
       Dcl-PR #StartRow  ind;
       End-PR;

      *-------------------------------------------------------
       Dcl-PR #EndRow  ind;
       End-PR;

      *-------------------------------------------------------

       Dcl-PR #WriteCell  ind;
         Data        char(30);
         CellType    char(1);
         CellStyle   char(2);
       End-PR;
