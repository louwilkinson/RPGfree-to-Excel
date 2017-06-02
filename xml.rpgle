       ctl-opt  nomain;
       ctl-opt option(*srcstmt);

      *-------------------------------------------------------

      *  global file access

      *-------------------------------------------------------

       dcl-f wXML usropn usage(*output);

      *-------------------------------------------------------
      *  procedure prototypes

      *-------------------------------------------------------
      /COPY STSSRC/Service,HXML
      *-------------------------------------------------------

      *  procedure definitions
      *-------------------------------------------------------

       dcl-proc #dummy   EXPORT;

         dcl-pi #dummy ind;
         end-pi;

         dcl-s errors ind;

         return errors;

       end-proc #dummy;

      *-------------------------------------------------------

       dcl-proc #WriteCell   EXPORT;

         dcl-pi #WriteCell ind;
           Data        char(30);
           CellType    char(1);
           CellStyle   char(2);
         end-pi;

         dcl-s errors ind;

         Open wXML;

         line = '<ss:Cell ss:StyleID="' + CellStyle + '">';
         write xmlR;

         select;
           when celltype = 's' or celltype = 'S';
         line = '<ss:Data ss:Type="String">' + %trim(Data) + '</ss:Data> ';
           when celltype = 'n' or celltype = 'N';
         line = '<ss:Data ss:Type="Number">' + %trim(Data) + '</ss:Data> ';
         ENDSL;
         write xmlR;

         line = '</ss:Cell>';
         write xmlR;

         Close wXML;
         return errors;

       end-proc #WriteCell;

      *-------------------------------------------------------

       dcl-proc #StartRow   EXPORT;

         dcl-pi #StartRow ind;
         end-pi;

         dcl-s errors ind;

         Open wXML;
         line = '<ss:Row>';
         write xmlR;
         Close wXML;

         return errors;

       end-proc #StartRow;

      *-------------------------------------------------------

       dcl-proc #EndRow   EXPORT;

         dcl-pi #EndRow ind;
         end-pi;

         dcl-s errors ind;

         Open wXML;
         line = '</ss:Row>';
         write xmlR;
         Close wXML;

         return errors;

       end-proc #EndRow;

      *-------------------------------------------------------

       dcl-proc #SetColWidths   EXPORT;

         dcl-pi #SetColWidths ind;
           Widths  zoned(3:0) dim(100);
         end-pi;

         dcl-s index         zoned(3:0);
         dcl-s errors ind;

         Open wXML;
         // note excel will autofitwidth for only
         //  numeric and date cells

         for index = 1 to 100;
           if Widths(index) <> 0;
             line =  '<ss:Column ss:Width="' +
                            %trim(%char(Widths(index))) + '" />';
             write xmlR;
           endif;
         endfor;

         Close wXML;

         return errors;

       end-proc #SetColWidths;

      *-------------------------------------------------------

       dcl-proc #StartSheet   EXPORT;

         dcl-pi #StartSheet ind;
           SheetName  char(30);
         end-pi;

         dcl-s errors ind;

         Open wXML;

         line = '<ss:Worksheet ss:Name="' + %trim(SheetName) + '">';
         write xmlR;
         line = '<ss:Table>';
         write xmlR;


         Close wXML;

         return errors;

       end-proc #StartSheet;

      *-------------------------------------------------------

       dcl-proc #EndSheet   EXPORT;

         dcl-pi #EndSheet ind;
         end-pi;

         dcl-s errors ind;

         Open wXML;
         line = '</ss:Table>';
         write xmlR;
         line = '</ss:Worksheet>';
         write xmlR;

         Close wXML;

         return errors;

       end-proc #EndSheet;

      *-------------------------------------------------------

       dcl-proc #EndWorkBook   EXPORT;

         dcl-pi #EndWorkBook ind;
         end-pi;

         dcl-s errors ind;

         Open wXML;

         line = '</ss:Workbook>';
         write xmlR;

         Close wXML;

         return errors;

       end-proc #EndWorkBook;

      *-------------------------------------------------------

       dcl-proc #StartWorkBook   EXPORT;

         dcl-pi #StartWorkBook ind;
         end-pi;

         dcl-s errors ind;

         Open wXML;

         // write xml header

         line = '<?xml version="1.0"?>';
         write xmlR;
         line = '<ss:Workbook ';
         write xmlR;
         line = 'xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">';
         write xmlR;

         // some style choices...more can be added.

         line = '<ss:Styles>';
         write xmlR;

         line = '<ss:Style ss:ID="H1">';
         write xmlR;
         line = '<ss:Font ss:FontName="Calibri" ';
         write xmlR;
         line = 'ss:Size="14" ss:Color="#222222"/>';
         write xmlR;
         line = '<ss:Interior ss:Color="#CCFFCC" ss:Pattern="Solid"/>';
         write xmlR;
         line = '</ss:Style>';
         write xmlR;

         line = '<ss:Style ss:ID="D1">';
         write xmlR;
         line = '<ss:Font ss:FontName="Calibri" ';
         write xmlR;
         line = 'ss:Size="12" ss:Color="#000000"/>';
         write xmlR;
         line = '</ss:Style>';
         write xmlR;

         line = '</ss:Styles>';
         write xmlR;

         Close wXML;

         return errors;

       end-proc #StartWorkBook;

      *-------------------------------------------------------
