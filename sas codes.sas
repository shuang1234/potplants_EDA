* Three sample sheets have been imported in POTPLANTS library as S1, S2 and S3;
* Clean the data

* Change the first column name of S2;
DATA POTPLANT.S2;
SET POTPLANT.S2;
Sample_Name=SampleName;
RUN;

DATA POTPLANT.S2;
SET POTPLANT.S2(drop=SampleName);
RUN;

* Delete the mean row and variance row in S2;
DATA POTPLANT.S2; 
SET POTPLANT.S2;
IF GROUP = 'mean' THEN DELETE; 
RUN;

DATA POTPLANT.S2; 
SET POTPLANT.S2;
IF GROUP = 'variance' THEN DELETE; 
RUN;

* Replace 'potting mix' with 'pm';
DATA POTPLANT.S2; 
SET POTPLANT.S2;
IF GROUP = 'potting mix' THEN GROUP = 'pm';
RUN;

* Combine three data sets;
DATA POTPLANT.POTPLANTS;
SET POTPLANT.S1 POTPLANT.S2 POTPLANT.S3; 
RUN;

* Select elements;
DATA Potplant.POTPLANTS; 
SET Potplant.POTPLANTS;
KEEP SAMPLE_NAME GROUP TI CA GA BA ZN;
RUN;

* Remove missing values;
DATA Potplant.POTPLANTS; 
SET Potplant.POTPLANTS;
IF TI =. THEN DELETE; 
RUN;
* Finish cleaning data;

PROC CONTENTS DATA = POTPLANT.POTPLANTS;
RUN;

* Code for Q1

* Compute means for each group;
PROC SUMMARY DATA = POTPLANT.POTPLANTS;
CLASS GROUP;
VAR TI;
OUTPUT OUT = A(DROP=_:) MEAN = TI_MEAN VAR = TI_VAR;
RUN;

PROC PRINT;
RUN;

* Compute variances for each group;
PROC SUMMARY DATA = POTPLANT.POTPLANTS;
CLASS GROUP;
VAR CA;
OUTPUT OUT = A(DROP=_:) MEAN = CA_MEAN VAR = CA_VAR;
RUN;

PROC PRINT;
RUN;

* ANOVA for Ti;
PROC ANOVA DATA = POTPLANT.POTPLANTS;
CLASS GROUP;
MODEL TI = GROUP;
RUN;

* ANOVA for Ca;
PROC ANOVA DATA = POTPLANT.POTPLANTS;
CLASS GROUP;
MODEL CA = GROUP;
RUN;


* Code for Q2;

* Calculate the correlation coefficient between elements;
* Significance of correlation;
PROC CORR DATA = POTPLANT.POTPLANTS;
VAR TI CA BA GA ZN;
RUN;

* Make plot about correlation between Ga and Ba;
proc template;
define statgraph sgdesign;
dynamic _GA _BA;
begingraph;
   entrytitle halign=center 'CORRELATION BETWEEN GA AND BA';
   entryfootnote halign=left 'Type in your footnote...';
   layout lattice / rowdatarange=data columndatarange=data rowgutter=10 columngutter=10;
      layout overlay;
         scatterplot x=_GA y=_BA / name='scatter' datatransparency=0.3 markerattrs=(symbol=CIRCLE );
      endlayout;
   endlayout;
endgraph;
end;
run;

proc sgrender data=POTPLANT.POTPLANTS template=sgdesign;
dynamic _GA="GA" _BA="BA";
run;

* Make plot about correlation between Ba and Zn;
proc template;
define statgraph Graph;
dynamic _BA _ZN;
begingraph;
   layout lattice / rowdatarange=data columndatarange=data rowgutter=10 columngutter=10;
      layout overlay;
         scatterplot x=_BA y=_ZN / name='scatter' datatransparency=0.3;
      endlayout;
   endlayout;
endgraph;
end;
run;

proc sgrender data=POTPLANT.POTPLANTS template=Graph;
dynamic _BA="BA" _ZN="ZN";
run;

* Make plot about correlation between Ga and Zn;
proc template;
define statgraph Graph;
dynamic _GA _ZN;
begingraph;
   layout lattice / rowdatarange=data columndatarange=data rowgutter=10 columngutter=10;
      layout overlay;
         scatterplot x=_GA y=_ZN / name='scatter' datatransparency=0.3;
      endlayout;
   endlayout;
endgraph;
end;
run;

proc sgrender data=POTPLANT.POTPLANTS template=Graph;
dynamic _GA="GA" _ZN="ZN";
run;


* Code for Q3;

* Make boxplot for Ti;
proc template;
define statgraph Graph;
dynamic _GROUP _TI;
begingraph;
   layout lattice / rowdatarange=data columndatarange=data rowgutter=10 columngutter=10;
      layout overlay / xaxisopts=( discreteopts=( tickvaluefitpolicy=splitrotate));
         boxplot x=_GROUP y=_TI / name='box' groupdisplay=Cluster clusterwidth=1.0;
      endlayout;
   endlayout;
endgraph;
end;
run;

proc sgrender data=POTPLANT.POTPLANTS template=Graph;
dynamic _GROUP="GROUP" _TI="TI";
run;

* Make boxplot for Ca;
proc template;
define statgraph Graph;
dynamic _GROUP _CA;
begingraph;
   layout lattice / rowdatarange=data columndatarange=data rowgutter=10 columngutter=10;
      layout overlay / xaxisopts=( discreteopts=( tickvaluefitpolicy=splitrotate));
         boxplot x=_GROUP y=_CA / name='box' groupdisplay=Cluster clusterwidth=1.0;
      endlayout;
   endlayout;
endgraph;
end;
run;

proc sgrender data=POTPLANT.POTPLANTS template=Graph;
dynamic _GROUP="GROUP" _CA="CA";
run;
