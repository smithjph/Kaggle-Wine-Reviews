* read in data;
DATA WORK.wine;
    LENGTH
        F1                 8
        country          $ 22
        description      $ 829
        designation      $ 95
        points             8
        price              8
        province         $ 31
        region_1         $ 50
        region_2         $ 17
        taster_name      $ 18
        taster_twitter_handle $ 16
        title            $ 140
        variety          $ 35
        winery           $ 56 ;
    FORMAT
        F1               BEST6.
        country          $CHAR22.
        description      $CHAR829.
        designation      $CHAR95.
        points           BEST3.
        price            BEST6.
        province         $CHAR31.
        region_1         $CHAR50.
        region_2         $CHAR17.
        taster_name      $CHAR18.
        taster_twitter_handle $CHAR16.
        title            $CHAR140.
        variety          $CHAR35.
        winery           $CHAR56. ;
    INFORMAT
        F1               BEST6.
        country          $CHAR22.
        description      $CHAR829.
        designation      $CHAR95.
        points           BEST3.
        price            BEST6.
        province         $CHAR31.
        region_1         $CHAR50.
        region_2         $CHAR17.
        taster_name      $CHAR18.
        taster_twitter_handle $CHAR16.
        title            $CHAR140.
        variety          $CHAR35.
        winery           $CHAR56. ;
    INFILE 'C:\Users\smithjoe\AppData\Local\Temp\21\SEG12560\winemag-data-130k-v2-aed5d78e4ef946d3bbb77f30f8b76d83.txt'
        LRECL=976
        ENCODING="WLATIN1"
        TERMSTR=CRLF
        DLM='7F'x
        MISSOVER
        DSD ;
    INPUT
        F1               : ?? BEST6.
        country          : $CHAR22.
        description      : $CHAR829.
        designation      : $CHAR95.
        points           : ?? BEST3.
        price            : ?? COMMA6.
        province         : $CHAR31.
        region_1         : $CHAR50.
        region_2         : $CHAR17.
        taster_name      : $CHAR18.
        taster_twitter_handle : $CHAR16.
        title            : $CHAR140.
        variety          : $CHAR35.
        winery           : $CHAR56. ;
RUN;

* create vintage variable - does vintage help? we won't know how old the wine is;
data wine;
set wine;
vintage = input(compress(title, '',"kd"),best.);
run;

proc freq data=wine nlevels;
*table vintage;
table variety;
table country;
*table designation;    * do not use;
*table price;
table taster_name;
run;


* remove any vintage with with <1% of observations: <2005 or after 2016;
* remove any tasters with <1% of observations: Christina Pickard, Fiona Adams, Alexander Peartree, 
*	Carrie Dykes, Susan Kostrzewa;
* remove observations where taster_name is missing;
* remove wines from countries with <1% of observations from proc freq, including: 
* 	Armenia, Bosnia and Herzegovina, China, Egypt, India, Luxembourg, Slovakia, Switzerland, Ukraine,
*	Brazil, Bulgaria, Canada, Croatia, Cyprus, Czech Republic, England, Georgia, Greece, Hungary,
*	Israel, Lebanon, Macedonia, Mexico, Moldova, Morocco, Peru, Romania, Serbia, Slovenia, Turkey, Uruguay;
* create dummy variables for if the description uses the words:
*	cherry, spice, rich, fresh, oak, dry, berry, plum;
* keep the top 10 most frequent wine varities:
*	Pinot Noir, Chardonnay, Cabernet Sauvignon, Red Blend, Bordeaux-style Red Blend,
* 	Riesling, Sauvignon Blanc, Syrah, Rosé, Merlot;
data wine;
set wine (keep=country description points price province taster_name vintage variety);
logprice = log(price);
if vintage < 2005 then delete;
if vintage > 2016 then delete;
if scan(taster_name, 1) = 'Christina' then delete;
if scan(taster_name, 1) = 'Fiona' then delete;
if scan(taster_name, 1) = 'Alexander' then delete;
if scan(taster_name, 1) = 'Carrie' then delete;
if scan(taster_name, 1) = 'Susan' then delete;
if scan(country, 1) = 'Armenia' then delete;
if scan(country, 1) = 'Bosnia' then delete;
if scan(country, 1) = 'China' then delete;
if scan(country, 1) = 'Egypt' then delete;
if scan(country, 1) = 'India' then delete;
if scan(country, 1) = 'Luxembourg' then delete;
if scan(country, 1) = 'Slovakia' then delete;
if scan(country, 1) = 'Switzerland' then delete;
if scan(country, 1) = 'Ukraine' then delete;
if scan(country, 1) = 'Brazil' then delete;
if scan(country, 1) = 'Bulgaria' then delete;
if scan(country, 1) = 'Canada' then delete;
if scan(country, 1) = 'Croatia' then delete;
if scan(country, 1) = 'Cyprus' then delete;
if scan(country, 1) = 'Czech' then delete;
if scan(country, 1) = 'England' then delete;
if scan(country, 1) = 'Georgia' then delete;
if scan(country, 1) = 'Greece' then delete;
if scan(country, 1) = 'Hungary' then delete;
if scan(country, 1) = 'Israel' then delete;
if scan(country, 1) = 'Lebanon' then delete;
if scan(country, 1) = 'Macedonia' then delete;
if scan(country, 1) = 'Mexico' then delete;
if scan(country, 1) = 'Moldova' then delete;
if scan(country, 1) = 'Morocco' then delete;
if scan(country, 1) = 'Peru' then delete;
if scan(country, 1) = 'Romania' then delete;
if scan(country, 1) = 'Serbia' then delete;
if scan(country, 1) = 'Slovenia' then delete;
if scan(country, 1) = 'Turkey' then delete;
if scan(country, 1) = 'Uruguay' then delete;
if scan(country, 1) = 'Portugal' then delete;
if country = '' then delete;
if taster_name = '' then delete;
if price = . then delete;
cherry = not not findw(description, 'cherry', 1, , 'TSIEP');
spice = not not findw(description, 'spice', 1, , 'TSIEP');
rich = not not findw(description, 'rich', 1, , 'TSIEP');
fresh = not not findw(description, 'fresh', 1, , 'TSIEP');
oak = not not findw(description, 'oak', 1, , 'TSIEP');
dry = not not findw(description, 'dry', 1, , 'TSIEP');
berry = not not findw(description, 'berry', 1, , 'TSIEP');
plum = not not findw(description, 'plum', 1, , 'TSIEP');
if variety = 'Pinot Noir' then output;
if variety = 'Chardonnay' then output;
if variety = 'Cabernet Sauvignon' then output;
if variety = 'Red Blend' then output;
if variety = 'Bordeaux-style Red Blend' then output;
if variety = 'Riesling' then output;
if variety = 'Sauvignon Blanc' then output;
if variety = 'Syrah' then output;
if variety = 'Rosé' then output;
if variety = 'Merlot' then output;
run;

proc contents data=wine;
run;

proc print data=wine;
where points = 98;
run;

/* ------------- exploratory analysis ------------- */
* log transform price;
ods graphics on;
proc sgscatter data=wine;
plot points*price;
proc sgplot data=wine;
histogram price;
proc sgscatter data=wine;
plot points*logprice;
proc sgplot data=wine;
histogram logprice;
run;

proc freq data=wine ;
table berry / nocum;
table cherry / nocum;
table dry / nocum;
table fresh / nocum;
table oak / nocum;
table plum / nocum;
table rich / nocum;
table spice / nocum;
run;

proc sgplot data=wine;
vbox points / group=berry;
proc sgplot data=wine;
vbox points / group=cherry;
proc sgplot data=wine;
vbox points / group=dry;
proc sgplot data=wine;
vbox points / group=fresh;
proc sgplot data=wine;
vbox points / group=oak;
proc sgplot data=wine;
vbox points / group=plum;
proc sgplot data=wine;
vbox points / group=rich;
proc sgplot data=wine;
vbox points / group=spice;
run;

proc sgplot data=wine;
vbox points / group=country;
proc sgplot data=wine;
vbox points / group=taster_name;
proc sgplot data=wine;
vbox points / group=variety;
run;

proc sgplot data=wine;
vbox points / group=vintage;
run;


* we have no missing data in the wine dataset;
/* 
proc means data=wine nmiss;
run;
*/

* proc freq for some variables;
/*
proc freq data=wine;
*table vintage*country / nocol nocum norow;
*table vintage*taster_name / nocol nocum norow;
table country;
*table price;
*table logprice;
table taster_name;
*table berry;
*table cherry;
*table dry;
*table fresh;
*table oak;
*table plum;
*table points;
*table rich;
*table spice;
table variety;
table vintage;
run;
*/


* histogram of y;
proc sgplot data=wine;
histogram points;
run;


* model selection;
ods graphics on;
proc glmselect data=wine plots=all;
class country taster_name vintage cherry spice 
	  rich fresh oak dry berry plum variety / ref=first;
model points = logprice country taster_name vintage cherry spice rich fresh oak dry berry plum variety
			   taster_name*variety 
			   taster_name*logprice
			   taster_name*country
			   taster_name*vintage
			   taster_name|cherry|spice|rich|fresh|oak|dry|berry|plum @2 
			   logprice|cherry|spice|rich|fresh|oak|dry|berry|plum @2 / selection=backward slstay=0.05;
output out=glmout resid=res pred=predict;
run;

/*
proc glmselect data=wine plots=all;
class country taster_name vintage cherry spice 
	  rich fresh oak dry berry plum variety / ref=first;
model points = logprice|country|taster_name|vintage|cherry|spice|rich|fresh|oak|dry|berry|plum|variety @2 / selection=backward slstay=0.05;
output out=glmout resid=res pred=predict;
run;
*/

proc sgscatter data=glmout;
plot res*points;
run;






* PART III;



* create training and testing set;
proc surveyselect data=wine n=10000 reps=100 method=srs outall out=wineout seed=87954;
run;
data winetrain (drop=Selected);
set wineout;
where Selected = 0;
data winetest;
set wineout;
where Selected = 1;
run;

* regression for part 3;
ods graphics on;
proc glm data=winetrain plots=all;
class country taster_name vintage cherry spice 
	  rich fresh oak dry berry plum variety;
model points = logprice country vintage plum 
			   taster_name*variety 
			   taster_name*logprice
			   taster_name*cherry taster_name*rich taster_name*fresh spice*fresh taster_name*oak spice*berry
			   dry*berry logprice*rich logprice*oak logprice*dry logprice*plum;
output out=glmoutall residual=resid;
run;

* square the residuals;
data glmoutall;
set glmoutall;
residsq = resid**2;
run;

* proc means to get the sum of the squared residuals;
proc means data=glmoutall sum noprint;
by Replicate;
var residsq;
output out=meansout sum=SSsum;
run;

* proc means to get the average across the 100 replicates;
proc means data=meansout;
var SSsum;
run;



* build the tree using the original dataset with all variables and no interactions;
ods graphics on;
proc hpsplit data=wine maxdepth=10;
input country vintage dry plum taster_name cherry spice rich fresh oak dry berry plum variety / level = nom;
input logprice / level = int;
target points;
*partition fraction(validate=0.2);
criterion entropy;
prune none;
*output nodestats=nodes importance=import / subtreestats=sse;
run;

