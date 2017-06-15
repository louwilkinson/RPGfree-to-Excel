
       //  create xml file from W02440

       ctl-opt dftactgrp(*no) actgrp('QILE') bnddir('STSOBJ/SERVICE');
       ctl-opt option(*srcstmt);

       dcl-f W02440  keyed usage(*input );     // workfile of balances
       dcl-f F20050  keyed usage(*input );     // user names
       dcl-f F02100  keyed usage(*input );     // customer names

      *-------------------------------------------------------
      *  procedure prototypes
      *-------------------------------------------------------

      /COPY STSSRC/SERVICE,HXML

       //-------------------------------------------------------
       // Entry Parms
       //-------------------------------------------------------

       dcl-pr R02441  extpgm('R02441');
       end-pr;
       dcl-pi R02441;
       end-pi;

       //-------------------------------------------------------

       dcl-s cpy           zoned(2:0) inz(1);
       dcl-s LastSalesman  zoned(5:0);
       dcl-s CustName       char(30);
       dcl-s SheetName      char(30);
       dcl-s ColWidth      zoned(3:0) dim(100);

       dcl-s tCurrent      zoned(11:2);
       dcl-s tover00       zoned(11:2);
       dcl-s tover30       zoned(11:2);
       dcl-s tover60       zoned(11:2);
       dcl-s tover90       zoned(11:2);

       dcl-s total         zoned(11:2);

       dcl-s Cell           char(30);
       dcl-s type           char(1);
       dcl-s style          char(2);
       dcl-s index         zoned(2:0) inz(1);

       dcl-s ErrorRtn        ind;

       //-------------------------------------------------------

       dcl-c YES '1';
       dcl-c NO  '0';
       dcl-c ON  '1';
       dcl-c OFF '0';
       dcl-c Bad  '!@#$%&*+/\,';
       dcl-c Good '-----------';
       dcl-c Apostrophe '''';

       // Mainline Code -----------------------------------------

       ErrorRtn = #StartWorkBook;

       SetLL *loval F02w1;
       Read F02W1;
       DoW NOT(%eof( w02440));

         if w1Slsm <> LastSalesman;

           if LastSalesman <> 99999;
             exsr printTotals;
             ErrorRtn = #EndSheet;
           EndIf;

           ExSr CreatePage;

         endIf;

         ExSr CreateRow;

         tcurrent = tcurrent + w1curd;
         tover00 = tover00 + w1ov00;
         tover30 = tover30 + w1ov30;
         tover60 = tover60 + w1ov60;
         tover90 = tover90 + w1ov90;

         LastSalesman = w1Slsm;

         Read F02W1;
       EndDo;

       exsr printTotals;
       ErrorRtn = #EndSheet;
       ErrorRtn = #EndWorkBook;

       *inlr = ON;
       Return;

       // -- Subroutines -------------------------------


       // -- print totals ------------------------------

       begsr PrintTotals;

       ErrorRtn = #StartRow;

         cell = '.';
         type = 's';
         style = 'D1';
         ErrorRtn = #WriteCell(cell : type : style);

        ErrorRtn = #EndRow;

       ErrorRtn = #StartRow;

         cell = 'TOTALS';
         type = 's';
         style = 'H2';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = ' ';
         type = 's';
         style = 'H2';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = %char(tcurrent);
         type = 'n';
         style = 'M2';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = %char(tover00);
         type = 'n';
         style = 'M3';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = %char(tover30);
         type = 'n';
         style = 'M4';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = %char(tover60);
         type = 'n';
         style = 'M5';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = %char(tover90);
         type = 'n';
         style = 'M6';
         ErrorRtn = #WriteCell(cell : type : style);

         ErrorRtn = #EndRow;
       // print %s

       total = tcurrent + tover00 + tover30 + tover60 + tover90;

       ErrorRtn = #StartRow;

         cell = '%';
         type = 's';
         style = 'H2';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = ' ';
         type = 's';
         style = 'H2';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = %subst(%char(tcurrent / total * 100) : 1 : 5) + ' %';
         type = 's';
         style = 'H2';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = %subst(%char(tover00 / total * 100) : 1 : 5) + ' %';
         type = 's';
         style = 'H2';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = %subst(%char(tover30 / total * 100) : 1 : 5) + ' %';
         type = 's';
         style = 'H2';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = %subst(%char(tover60 / total * 100) : 1 : 5) + ' %';
         type = 's';
         style = 'H2';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = %subst(%char(tover90 / total * 100) : 1 : 5) + ' %';
         type = 's';
         style = 'H2';
         ErrorRtn = #WriteCell(cell : type : style);

         ErrorRtn = #EndRow;
       tcurrent = 0;
       tover00 = 0;
       tover30 = 0;
       tover60 = 0;
       tover90 = 0;

       EndSr;

       // -- Create a new Page -------------------------

       BegSR CreatePage;

       chain (w1slsm) F20OP;
       If %found(F20050) and w1slsm <> 0 and opalnm <> *blanks;
          SheetName = %trim(opafnm) + ' ' + %trim(opalnm);
       else;
          SheetName = 'Unknown Salesman' + %editc(w1slsm:'X');
          index = index + 1;
       endIf;

        ErrorRtn = #StartSheet(SheetName);

         colwidth(1) = 50;
         colwidth(2) = 180;
         colwidth(3) = 75;
         colwidth(4) = 75;
         colwidth(5) = 75;
         colwidth(6) = 75;
         colwidth(7) = 75;
         ErrorRtn = #SetColWidths(ColWidth) ;

       ErrorRtn = #StartRow;

         cell = 'Cust#';
         type = 's';
         style = 'H1';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = 'CustName';
         type = 's';
         style = 'H1';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = 'Current';
         type = 'S';
         style = 'H2';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = '00-30Dys';
         type = 's';
         style = 'H2';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = '31-60Dys';
         type = 's';
         style = 'H2';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = '61-90dys';
         type = 's';
         style = 'H2';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = 'Ovr90dys';
         type = 's';
         style = 'H2';
         ErrorRtn = #WriteCell(cell : type : style);

         ErrorRtn = #EndRow;

       endSR;


       // -- Create a new Page -------------------------

       BegSR CreateRow;

       chain (cpy : w1cust) f02sh;
       If %found(F02100);
          CustName = shasnm;
       else;
          CustName = 'Unknown Customer';
       endIf;

       ErrorRtn = #StartRow;

         cell = %char(w1cust);
         type = 'n';
         style = 'D1';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = CustName;
         type = 's';
         style = 'D1';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = %char(w1curd);
         type = 'n';
         style = 'M1';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = %char(w1ov00);
         type = 'n';
         style = 'M1';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = %char(w1ov30);
         type = 'n';
         style = 'M1';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = %char(w1ov60);
         type = 'n';
         style = 'M1';
         ErrorRtn = #WriteCell(cell : type : style);
         cell = %char(w1ov90);
         type = 'n';
         style = 'M1';
         ErrorRtn = #WriteCell(cell : type : style);

         ErrorRtn = #EndRow;

       endSR;

       // -----------------------------------------------------------

       begsr *inzSR;
         LastSalesman = 99999;
       endSR;
