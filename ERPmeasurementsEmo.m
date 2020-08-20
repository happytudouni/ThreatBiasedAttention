function [] = ERPmeasurementsEmo(cfg)
% put this program to the folder with the ERP data;
% use it as: cfg = []; cfg.age = 36; ERPmeasurementsEmo(cfg); This would do the measurements for 36 mos;
% ****** or: cfg = []; cfg.age = 99; ERPmeasurementsEmo(cfg); This would do the measurements for all infants;
% you can leave the parameters as the default; 
if ~isfield(cfg, 'age'),            cfg.age          = 36;              end
if ~isfield(cfg, 'hz'),             cfg.hz           = 0.3;             end
if ~isfield(cfg, 'chanoperator'),   cfg.chanoperator = '9clusters';     end
if ~isfield(cfg, 'replacearg'),     cfg.replacearg   = 0;               end
age = cfg.age; hz = cfg.hz; chanoperator = cfg.chanoperator; replacearg = cfg.replacearg;

global myALLERP
eeglab;close;
load subjectsmatrix_emotion.mat;
if age == 99 
    participantnumbers = subjectsmatrix_emotion.participantnumbers_ierp;
    ages = subjectsmatrix_emotion.ages_ierp;
elseif age == 36
    participantnumbers = subjectsmatrix_emotion.participantnumbers_36mos;
    ages = subjectsmatrix_emotion.ages_36mos;
else % if age = 5, 7 or 12; this program would only do the measurements for one age group;
    participantnumbers = subjectsmatrix_emotion.participantnumbers_ierp(ages_ierp == age);
    ages = subjectsmatrix_emotion.ages_ierp(ages_ierp == age);
end

% define the output file and folder;
outputpath = 'ERPMeasurements/';
if ~exist(outputpath, 'dir')
   mkdir(outputpath)
end
SegmentAverageFiles = '';
filename   = ['Experiment 1 Age ' num2str(age) ' ' chanoperator ' ERP Measurements_ERPLAB.txt'];

% check if the file already exists. To replace an existing file, do cfg.replacearg = 1;
if exist ([outputpath filename]) & replacearg == 0
    disp([filename ' already exists.'])
    return
end

disp(['ERP measurements will be conducted for ' num2str(length(participantnumbers)) ' subjects.']);

% Load the ERPLAB sets;
for i=1:length(participantnumbers)
    participantnumber = participantnumbers(i);
    age               = ages(i);
    disp([num2str(i) ' Participantnumber ' num2str(participantnumber)]);    
    % load the ERP set;
    erpname=['Experiment 1 Subject ' num2str(participantnumber) ' Age ' num2str(age) ' ' num2str(hz) 'Hz ERPLAB Averaged ERPs.erp'];
    if ~exist([SegmentAverageFiles erpname])
        continue
    end
    disp(['load ' erpname]);
    ERP=pop_loaderp('filename',erpname,'filepath',SegmentAverageFiles);

    ERP = pop_erpchanoperator(ERP, {'nch1 =(ch57+ch58+ch63+ch64+ch50+ch59+ch65+ch68)/8 label TO_L' 'nch2= (ch101+ch95+ch96+ch99+ch100+ch90+ch91+ch94)/8 label TO_R'  'nch3=(ch66+ch69+ch70+ch73+ch74)/5 label OI_L' 'nch4=(ch82+ch83+ch84+ch88+ch89)/5 label OI_R' 'nch5 =(ch71+ch72+ch75+ch76+ch81)/5 label OI_z' 'nch6=(ch7+ch31+ch55+ch80+ch106)/5 label Centralz' 'nch7 =(ch30+ch36+ch37+ch41+ch42)/5 label Central3'  'nch8=(ch87+ch93+ch103+ch104+ch105)/5 label Central4' 'nch9=(ch5+ch10+ch11+ch12+ch16+ch18)/6 label Frontalz'});
    nch = 9;

    ALLERP(i)=ERP;
end                 
myALLERP = ALLERP;

% Do the measurements
if age == 36
    binis = 1:6;
else
    binis = 1:3;
end
% P1 Positive amplitude;
twin = [80 150];polarity='positive';
% 1. local Peak amp
measurement = 'peakampbl';
[junk1 junk2 junk3 codes] = pop_geterpvalues( ALLERP, twin, binis, 1:nch, 'Append', 'off', 'Baseline', 'pre', 'Binlabel', 'on', 'Erpsets', [1:length(ALLERP)], 'FileFormat',...
'long', 'Filename', [outputpath filename], 'Fracreplace','NaN', 'InterpFactor',  1, 'Measure', measurement, 'Neighborhood', 8, 'Peakpolarity',polarity, 'Peakreplace', 'absolute','Resolution',  3 );
fid = fopen([outputpath filename]);
[junk]=textscan(fid,'%f %d %s %d %s %*s %*d %*s %d%*[^\n]','HeaderLines',1);
P1Peakamp = junk{1}; chnum=junk{2}; chname=junk{3}; bin=junk{4}; binlabel=junk{5}; subjects=junk{6};
fclose(fid);

% PreN290 positive component  
if age == 36
    twin = [100 200];polarity='positive'; % this is what we used for Bangladeshi 3YF children;
else
    twin = [120 190];polarity='positive';
end
% 1. local Peak amp
measurement = 'peakampbl';
[junk1 junk2 junk3 codes] = pop_geterpvalues( ALLERP, twin, binis, 1:nch, 'Append', 'off', 'Baseline', 'pre', 'Binlabel', 'on', 'Erpsets', [1:length(ALLERP)], 'FileFormat',...
'long', 'Filename', [outputpath filename], 'Fracreplace','NaN', 'InterpFactor',  1, 'Measure', measurement, 'Neighborhood',  8, 'Peakpolarity',polarity, 'Peakreplace', 'absolute','Resolution',  3 );
fid = fopen([outputpath filename]);
[junk]=textscan(fid,'%f %d %s %d %s %*s %*d %*s %d%*[^\n]','HeaderLines',1);
PreN290Peakamp = junk{1}; chnum=junk{2}; chname=junk{3}; bin=junk{4}; binlabel=junk{5}; subjects=junk{6};
fclose(fid);
% pre-n290 peak latency; 
% preN290 latency to correct the N290 for its cortical source analysis;
measurement = 'peaklatbl';
[junk1 junk2 junk3 codes] = pop_geterpvalues( ALLERP, twin, binis, 1:nch, 'Append', 'off', 'Baseline', 'pre', 'Binlabel', 'on', 'Erpsets', [1:length(ALLERP)], 'FileFormat',...
'long', 'Filename', [outputpath filename], 'Fracreplace','NaN', 'InterpFactor',  1, 'Measure', measurement, 'Neighborhood',  8, 'Peakpolarity', polarity, 'Peakreplace', 'absolute','Resolution',  3 );
fid = fopen([outputpath filename]);
[junk]=textscan(fid,'%f %d %s %d %s %*s %*d %*s %d%*[^\n]','HeaderLines',1);
fclose(fid);
PreN290Peaklat = junk{1};

% N290 component
if age == 36
    twin = [190 350];polarity='negative';
else
    twin = [190 300];polarity='negative';
end
% 1. local Peak amp
measurement = 'peakampbl';
[junk1 junk2 junk3 codes] = pop_geterpvalues( ALLERP, twin, binis, 1:nch, 'Append', 'off', 'Baseline', 'pre', 'Binlabel', 'on', 'Erpsets', [1:length(ALLERP)], 'FileFormat',...
'long', 'Filename', [outputpath filename], 'Fracreplace','NaN', 'InterpFactor',  1, 'Measure', measurement, 'Neighborhood',  8, 'Peakpolarity', polarity, 'Peakreplace', 'absolute','Resolution',  3 );
fid = fopen([outputpath filename]);
[junk]=textscan(fid,'%f %d %s %d %s %*s %*d %*s %d%*[^\n]','HeaderLines',1);
fclose(fid);
N290Peakamp = junk{1};

% 2. local Peak Lat
measurement = 'peaklatbl';
[junk1 junk2 junk3 codes] = pop_geterpvalues( ALLERP, twin, binis, 1:nch, 'Append', 'off', 'Baseline', 'pre', 'Binlabel', 'on', 'Erpsets', [1:length(ALLERP)], 'FileFormat',...
'long', 'Filename', [outputpath filename], 'Fracreplace','NaN', 'InterpFactor',  1, 'Measure', measurement, 'Neighborhood',  8, 'Peakpolarity', polarity, 'Peakreplace', 'absolute','Resolution',  3 );
fid = fopen([outputpath filename]);
[junk]=textscan(fid,'%f %d %s %d %s %*s %*d %*s %d%*[^\n]','HeaderLines',1);
fclose(fid);
N290Peaklat = junk{1};
% 3. Mean amp; In our paper, we did not use the mean N290 amp because the N290 window varies so much among individuals (i.e., difficult to define a good window)
% see Luck, 2015 for the only disadvantage for using the mean amp). A second reason was that we corrected the pre N290 peak amp;
% but I left the codes for mean amp measurement in this program.

measurement = 'meanbl';
[junk1 junk2 junk3 codes] = pop_geterpvalues( ALLERP, twin, binis, 1:nch, 'Append', 'off', 'Baseline', 'pre', 'Binlabel', 'on', 'Erpsets', [1:length(ALLERP)], 'FileFormat',...
'long', 'Filename', [outputpath filename], 'Fracreplace','NaN', 'InterpFactor',  1, 'Measure', measurement, 'Neighborhood',  8, 'Peakpolarity', polarity, 'Peakreplace', 'absolute','Resolution',  3 );
fid = fopen([outputpath filename]);
[junk]=textscan(fid,'%f %d %s %d %s %*s %*d %*s %d%*[^\n]','HeaderLines',1);
fclose(fid);
N290Meanamp = junk{1};

% P400 component
if age == 36
    twin = [350 650];polarity='positive';
else
    twin = [300 650];polarity='positive'; % 5 and 7 infants have double P400 peaks; I don't know why, but I have seen this in multiple infant ERP studies. This should be further studied;
end
% 1. Mean amp
measurement = 'meanbl';
[junk1 junk2 junk3 codes] = pop_geterpvalues( ALLERP, twin, binis, 1:nch, 'Append', 'off', 'Baseline', 'pre', 'Binlabel', 'on', 'Erpsets', [1:length(ALLERP)], 'FileFormat',...
'long', 'Filename', [outputpath filename], 'Fracreplace','NaN', 'InterpFactor',  1, 'Measure', measurement, 'Neighborhood',  8, 'Peakpolarity', polarity, 'Peakreplace', 'absolute','Resolution',  3 );
fid = fopen([outputpath filename]);
[junk]=textscan(fid,'%f %d %s %d %s %*s %*d %*s %d%*[^\n]','HeaderLines',1);
fclose(fid);
P400Meanamp = junk{1}; 
% 2. peak lat
measurement = 'peaklatbl';
[junk1 junk2 junk3 codes] = pop_geterpvalues( ALLERP, twin, binis, 1:nch, 'Append', 'off', 'Baseline', 'pre', 'Binlabel', 'on', 'Erpsets', [1:length(ALLERP)], 'FileFormat',...
'long', 'Filename', [outputpath filename], 'Fracreplace','NaN', 'InterpFactor',  1, 'Measure', measurement, 'Neighborhood',  8, 'Peakpolarity', polarity, 'Peakreplace', 'absolute','Resolution',  3 );
fid = fopen([outputpath filename]);
[junk]=textscan(fid,'%f %d %s %d %s %*s %*d %*s %d%*[^\n]','HeaderLines',1);
fclose(fid);
P400Peaklat = junk{1};

% Nc component
polarity='negative';
% 1. Mean amp
measurement = 'meanbl';
[junk1 junk2 junk3 codes] = pop_geterpvalues( ALLERP, twin, binis, 1:nch, 'Append', 'off', 'Baseline', 'pre', 'Binlabel', 'on', 'Erpsets', [1:length(ALLERP)], 'FileFormat',...
'long', 'Filename', [outputpath filename], 'Fracreplace','NaN', 'InterpFactor',  1, 'Measure', measurement, 'Neighborhood',  8, 'Peakpolarity', polarity, 'Peakreplace', 'absolute','Resolution',  3 );
fid = fopen([outputpath filename]);
[junk]=textscan(fid,'%f %d %s %d %s %*s %*d %*s %d%*[^\n]','HeaderLines',1);
fclose(fid);
NcMeanamp = junk{1};

% Make a table with all variables and export the file;
% Calculate the peak to trough N290 peak
N290PeakampC = N290Peakamp - PreN290Peakamp;

% Calculate the length of the ages column;
nrows  = length(subjects);
nsubjs = length(ages);
nmulti = nrows/nsubjs;
ages   = repmat(ages,[1 nmulti]);
ages   = ages';
ages   = ages(:);

T=table(subjects,ages,chnum,chname,bin,binlabel,P1Peakamp,PreN290Peaklat,N290Peakamp,N290PeakampC,N290Peaklat,N290Meanamp,P400Meanamp,P400Peaklat,NcMeanamp,'VariableNames',{'participantnumbers','age','chnum','chname','bin','label','P1Preakamp','PreN290Lat','N290Peakamp','N290PeakampC','N290Peaklat','N290Meanamp','P400Meanamp','P400Peaklat','NcMeanamp'});
%disp(T);
writetable(T,[outputpath filename],'Delimiter','\t');
                                      