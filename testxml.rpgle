      // in general, pretty simple.
      //  use whatever binding directory you usually use

       // for the to create...you need wxml, a regular db2 file
       // if you use textxmlc with this, you can send the results in .xml

       // use of the process....note there's a certain required sequence...
       //  open a workbook
       //  start a sheet
       //  set column widths (or not)
       //  start a row
       //  add as many cells / columns as required
       //  end a row....
       //  repeat startrow, addcell, endrow as often as necessary
       //  end the sheet.

       //  then you can add another sheet (tab) and repeat.

       //  finally end the workbook.

       ctl-opt dftactgrp(*no) actgrp('QILE') bnddir('STSOBJ/SERVICE');
       ctl-opt option(*srcstmt);

      *-------------------------------------------------------
      *  procedure prototypes
      *-------------------------------------------------------

      /COPY STSSRC/SERVICE,HXML

       //-------------------------------------------------------
       // Entry Parms
       //-------------------------------------------------------

       dcl-pr testXML extpgm('TESTXML');
       end-pr;
       dcl-pi testXML;
       end-pi;

       //------------------------------------------------------- 

       dcl-s SheetName      char(30);
       dcl-s ColWidth      zoned(3:0) dim(100);

       dcl-s Cell           char(30);
       dcl-s type           char(1);
       dcl-s style          char(2);
       dcl-s index         zoned(3:0);

       dcl-s ErrorRtn        ind;

       //-------------------------------------------------------

       dcl-c YES '1';
       dcl-c NO  '0';
       dcl-c ON  '1';
       dcl-c OFF '0';
       dcl-c Bad  '!@#$%&*+/\,';
       dcl-c Good '-----------';
       dcl-c Apostrophe '''';

       //-------------------------------------------------------

       ErrorRtn = #StartWorkBook;

       ExSR FirstPage;
       ExSR SecondPage;

       ErrorRtn = #EndWorkBook;

       *inlr = ON;
       Return;

       // -- Subroutines -------------------------------

       BegSR FirstPage;

       SheetName = 'First Sheet-A';
       ErrorRtn = #StartSheet(SheetName);

       colwidth(1) = 120;
       colwidth(2) = 80;
       colwidth(3) = 40;
       ErrorRtn = #SetColWidths(ColWidth) ;

       ErrorRtn = #StartRow;
       cell = 'Hello There';
       type = 's';
       style = 'H1';
       ErrorRtn = #WriteCell(cell : type : style);
       cell = 'New here?';
       type = 's';
       style = 'H1';
       ErrorRtn = #WriteCell(cell : type : style);
       cell = '3.00';
       type = 'n';
       style = 'H1';
       ErrorRtn = #WriteCell(cell : type : style);

       ErrorRtn = #EndRow;

       ErrorRtn = #StartRow;
       cell = 'john';
       type = 's';
       style = 'D1';
       ErrorRtn = #WriteCell(cell : type : style);
       cell = 'linda';
       type = 's';
       style = 'D1';
       ErrorRtn = #WriteCell(cell : type : style);
       cell = '3.00';
       type = 'n';
       style = 'D1';
       ErrorRtn = #WriteCell(cell : type : style);

       ErrorRtn = #EndRow;

       ErrorRtn = #EndSheet;
       ENDSR;

       // ----------------------------------------------

       BegSR SecondPage;

       SheetName = 'Second Sheet-B';
       ErrorRtn = #StartSheet(SheetName);
       colwidth(1) = 10;
       colwidth(2) = 75;
       colwidth(3) = 25;
       ErrorRtn = #SetColWidths(ColWidth);
       ErrorRtn = #StartRow;

       cell = 'A';
       type = 's';
       style = 'H1';
       ErrorRtn = #WriteCell(cell : type : style);
       cell = 'Second Sheet';
       type = 's';
       style = 'H1';
       ErrorRtn = #WriteCell(cell : type : style);

       ErrorRtn = #EndRow;

       ErrorRtn = #StartRow;
       cell = '*';
       type = 's';
       style = 'D1';
       ErrorRtn = #WriteCell(cell : type : style);
       cell = 'aint it purty';
       type = 's';
       style = 'D1';
       ErrorRtn = #WriteCell(cell : type : style);

       ErrorRtn = #EndRow;
       ErrorRtn = #EndSheet;

       ENDSR;
