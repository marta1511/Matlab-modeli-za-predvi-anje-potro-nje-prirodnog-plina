clear all
close all
clc


% - ucitavanje xlsx datoteke: cca 136.64 sec = 2min i 16 sec
% - ucitavanje svih csv datoteka: cca 0.09 sec = 90 ms

tic
display('Loading database...');
% b_0910=[xlsread('baza.xlsx','2009-2010','E:E') xlsread('baza.xlsx','2009-2010','B:B')];
% b_1011=[xlsread('baza.xlsx','2010-2011','E:E') xlsread('baza.xlsx','2010-2011','B:B')];
% b_1112=[xlsread('baza.xlsx','2011-2012','E:E') xlsread('baza.xlsx','2011-2012','B:B')];
% b_1213=[xlsread('baza.xlsx','2012-2013','E:E') xlsread('baza.xlsx','2012-2013','B:B')];
% b_1314=[xlsread('baza.xlsx','2013-2014','E:E') xlsread('baza.xlsx','2013-2014','B:B')];
% b_1415=[xlsread('baza.xlsx','2014-2015','E:E') xlsread('baza.xlsx','2014-2015','B:B')];
% b_1516=[xlsread('baza.xlsx','2015-2016','E:E') xlsread('baza.xlsx','2015-2016','B:B')];
% b_1617=[xlsread('baza.xlsx','2016-2017','E:E') xlsread('baza.xlsx','2016-2017','B:B')];
% b_17=[xlsread('baza.xlsx','2017','E:E') xlsread('baza.xlsx','2017','B:B')];

b_0910=readtable('baza.xlsx','sheet','2009-2010');
b_1011=readtable('baza.xlsx','sheet','2010-2011');
b_1112=readtable('baza.xlsx','sheet','2011-2012');
b_1213=readtable('baza.xlsx','sheet','2012-2013');
b_1314=readtable('baza.xlsx','sheet','2013-2014');
b_1415=readtable('baza.xlsx','sheet','2014-2015');
b_1516=readtable('baza.xlsx','sheet','2015-2016');
b_1617=readtable('baza.xlsx','sheet','2016-2017');
b_17=readtable('baza.xlsx','sheet','2017');
display('Loading database finished');
toc

%datetime(godina,mjesec,dan)
% from=datetime(2009,11,5);
% until=datetime(2010,4,26);
from=datetime(2009,10,1);
until=datetime(2010,4,10);

range1=b_0910.datum>=from & b_0910.datum<=until;
range2=b_1011.datum>=datetime(2010,from.Month,from.Day) & b_1011.datum<=datetime(2011,until.Month,until.Day);
range3=b_1112.datum>=datetime(2011,from.Month,from.Day) & b_1112.datum<=datetime(2012,until.Month,until.Day);
range4=b_1213.datum>=datetime(2012,from.Month,from.Day) & b_1213.datum<=datetime(2013,until.Month,until.Day);
range5=b_1314.datum>=datetime(2013,from.Month,from.Day) & b_1314.datum<=datetime(2014,until.Month,until.Day);
range6=b_1415.datum>=datetime(2014,from.Month,from.Day) & b_1415.datum<=datetime(2015,until.Month,until.Day);
range7=b_1516.datum>=datetime(2015,from.Month,from.Day) & b_1516.datum<=datetime(2016,until.Month,until.Day);
range8=b_1617.datum>=datetime(2016,from.Month,from.Day) & b_1617.datum<=datetime(2017,until.Month,until.Day);
range9=b_17.datum>=datetime(2017,until.Month,until.Day);

display('Saving to csv');
csvwrite('csv/b_0910_s1.csv',[b_0910(range1,:).Tsrednja (1:size(b_0910(range1,:).Tsrednja,1))' b_0910(range1,:).potro_nja]);
csvwrite('csv/b_1011_s1.csv',[b_1011(range2,:).Tsrednja (1:size(b_1011(range2,:).Tsrednja,1))' b_1011(range2,:).potro_nja]);
csvwrite('csv/b_1112_s1.csv',[b_1112(range3,:).Tsrednja (1:size(b_1112(range3,:).Tsrednja,1))' b_1112(range3,:).potro_nja]);
csvwrite('csv/b_1213_s1.csv',[b_1213(range4,:).Tsrednja (1:size(b_1213(range4,:).Tsrednja,1))' b_1213(range4,:).potro_nja]);
csvwrite('csv/b_1314_s1.csv',[b_1314(range5,:).Tsrednja (1:size(b_1314(range5,:).Tsrednja,1))' b_1314(range5,:).potro_nja]);
csvwrite('csv/b_1415_s1.csv',[b_1415(range6,:).Tsrednja (1:size(b_1415(range6,:).Tsrednja,1))' b_1415(range6,:).potro_nja]);
csvwrite('csv/b_1516_s1.csv',[b_1516(range7,:).Tsrednja (1:size(b_1516(range7,:).Tsrednja,1))' b_1516(range7,:).potro_nja]);
csvwrite('csv/b_1617_s1.csv',[b_1617(range8,:).Tsrednja (1:size(b_1617(range8,:).Tsrednja,1))' b_1617(range8,:).potro_nja]);
csvwrite('csv/b_17_s1.csv',[b_17(range9,:).Tsrednja (1:size(b_17(range9,:).Tsrednja,1))' b_17(range9,:).potro_nja]);

range1=(b_0910.datum<from | b_0910.datum>until);
range2=b_1011.datum<datetime(2010,from.Month,from.Day) | b_1011.datum>datetime(2011,until.Month,until.Day);
range3=b_1112.datum<datetime(2011,from.Month,from.Day) | b_1112.datum>datetime(2012,until.Month,until.Day);
range4=b_1213.datum<datetime(2012,from.Month,from.Day) | b_1213.datum>datetime(2013,until.Month,until.Day);
range5=b_1314.datum<datetime(2013,from.Month,from.Day) | b_1314.datum>datetime(2014,until.Month,until.Day);
range6=b_1415.datum<datetime(2014,from.Month,from.Day) | b_1415.datum>datetime(2015,until.Month,until.Day);
range7=b_1516.datum<datetime(2015,from.Month,from.Day) | b_1516.datum>datetime(2016,until.Month,until.Day);
range8=b_1617.datum<datetime(2016,from.Month,from.Day) | b_1617.datum>datetime(2017,until.Month,until.Day);
range9=b_17.datum<datetime(2017,until.Month,until.Day);

csvwrite('csv/b_0910_s2.csv',[b_0910(range1,:).Tsrednja (1:size(b_0910(range1,:).Tsrednja,1))' b_0910(range1,:).potro_nja]);
csvwrite('csv/b_1011_s2.csv',[b_1011(range2,:).Tsrednja (1:size(b_1011(range2,:).Tsrednja,1))' b_1011(range2,:).potro_nja]);
csvwrite('csv/b_1112_s2.csv',[b_1112(range3,:).Tsrednja (1:size(b_1112(range3,:).Tsrednja,1))' b_1112(range3,:).potro_nja]);
csvwrite('csv/b_1213_s2.csv',[b_1213(range4,:).Tsrednja (1:size(b_1213(range4,:).Tsrednja,1))' b_1213(range4,:).potro_nja]);
csvwrite('csv/b_1314_s2.csv',[b_1314(range5,:).Tsrednja (1:size(b_1314(range5,:).Tsrednja,1))' b_1314(range5,:).potro_nja]);
csvwrite('csv/b_1415_s2.csv',[b_1415(range6,:).Tsrednja (1:size(b_1415(range6,:).Tsrednja,1))' b_1415(range6,:).potro_nja]);
csvwrite('csv/b_1516_s2.csv',[b_1516(range7,:).Tsrednja (1:size(b_1516(range7,:).Tsrednja,1))' b_1516(range7,:).potro_nja]);
csvwrite('csv/b_1617_s2.csv',[b_1617(range8,:).Tsrednja (1:size(b_1617(range8,:).Tsrednja,1))' b_1617(range8,:).potro_nja]);
csvwrite('csv/b_17_s2.csv',[b_17(range9,:).Tsrednja (1:size(b_17(range9,:).Tsrednja,1))' b_17(range9,:).potro_nja]);

% display('Converting to csv finished');

% display('Saving to csv');
csvwrite('csv/b_0910.csv',[b_0910.Tsrednja (1:size(b_0910.Tsrednja,1))' b_0910.potro_nja]);
csvwrite('csv/b_1011.csv',[b_1011.Tsrednja (1:size(b_1011.Tsrednja,1))' b_1011.potro_nja]);
csvwrite('csv/b_1112.csv',[b_1112.Tsrednja (1:size(b_1112.Tsrednja,1))' b_1112.potro_nja]);
csvwrite('csv/b_1213.csv',[b_1213.Tsrednja (1:size(b_1213.Tsrednja,1))' b_1213.potro_nja]);
csvwrite('csv/b_1314.csv',[b_1314.Tsrednja (1:size(b_1314.Tsrednja,1))' b_1314.potro_nja]);
csvwrite('csv/b_1415.csv',[b_1415.Tsrednja (1:size(b_1415.Tsrednja,1))' b_1415.potro_nja]);
csvwrite('csv/b_1516.csv',[b_1516.Tsrednja (1:size(b_1516.Tsrednja,1))' b_1516.potro_nja]);
csvwrite('csv/b_1617.csv',[b_1617.Tsrednja (1:size(b_1617.Tsrednja,1))' b_1617.potro_nja]);
csvwrite('csv/b_17.csv',[b_17.Tsrednja (1:size(b_17.Tsrednja,1))' b_17.potro_nja]);
display('Converting to csv finished');
