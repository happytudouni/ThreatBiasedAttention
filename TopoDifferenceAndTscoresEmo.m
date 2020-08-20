% put this program in the same folder with the ERP data;
clear;
cfg = []; % define cfg here; 
if ~isfield(cfg, 'age'),            cfg.age          = 36;              end
if ~isfield(cfg, 'hz'),             cfg.hz           = 0.3;             end
if ~isfield(cfg, 'icaornot'),       cfg.icaornot     = 1;               end
if ~isfield(cfg, 'replacearg'),     cfg.replacearg   = 0;               end
age = cfg.age; hz = cfg.hz; icaornot = cfg.icaornot; replacearg = cfg.replacearg;
eeglab;close;

load('subjectsmatrix_emotion.mat');

if age == 99 % plot all the infants
    participantnumbers = subjectsmatrix_emotion.participantnumbers_ierp;
    ages = subjectsmatrix_emotion.ages_ierp;
elseif age == 36
    participantnumbers = subjectsmatrix_emotion.participantnumbers_36mos;
    ages = ones(length(participantnumbers),1)*36;  
else
    participantnumbers = subjectsmatrix_emotion.participantnumbers_ierp;
    ages = subjectsmatrix_emotion.ages_ierp;
    participantnumbers = participantnumbers(ages == age);
    ages(ages~=age) = [];
end


% Check the existence of the output file
SegmentAverageFiles = '';

disp(['ERP measurements will be conducted for ' num2str(length(participantnumbers)) ' subjects.']);

% Load the ERPLAB sets;
for i=1:length(participantnumbers)
    participantnumber = participantnumbers(i);
    age = ages(i);
    disp([num2str(i) ' Participantnumber ' num2str(participantnumber)]);    
    if icaornot
        erpname=['Experiment 1 Subject ' num2str(participantnumber) ' Age ' num2str(age) ' ' num2str(hz) 'Hz ERPLAB Averaged ERPs.erp'];
    else
        erpname=['Experiment 1 Subject ' num2str(participantnumber) ' Age ' num2str(age) ' ' num2str(hz) 'Hz ERPLAB NoICA Averaged ERPs.erp'];
    end
    if ~exist([erpname])
        continue
    end
    disp(['load ' erpname]);
    ERP=pop_loaderp('filename',erpname,'filepath',SegmentAverageFiles);
    allerp(i)=ERP;
end                 

% Do the measurements
%% N290 component
if age == 36
    binis = 1:6; %anger100, anger40, fear100, fear40, happy, neutral;
    twin = [190 350];polarity='negative';
else
    twin = [190 290];polarity='negative';
    binis = 1:3;
end
nch = size(ERP.bindata,1);
%  mean amp
measurement = 'meanbl';
[junk1 N290Meanamp junk3 codes] = pop_geterpvalues( allerp, twin, binis, 1:nch, 'Append', 'off', 'Baseline', 'pre', 'Binlabel', 'on', 'Erpsets', [1:length(allerp)], 'Fracreplace','NaN', 'InterpFactor',  1, 'Measure', measurement, 'Neighborhood',  8, 'Peakpolarity', polarity, 'Peakreplace', 'absolute','Resolution',  3 );
% N290 amp for threatening faces, i.e., angry and fear
N290threat = N290Meanamp([1 3],:,:);
N290threat = squeeze(mean(N290threat,1))';
if age == 36
    N290hn     = N290Meanamp([5 6],:,:); % happy and neutral;
    N290hn     = squeeze(mean(N290hn,1))';
else
    N290hn     = squeeze(N290Meanamp([3],:,:))'; % happy;
end

N290mdiff  = mean(N290threat - N290hn);
% topoplot;
N290diff   = (N290threat - N290hn);
mu = 0; % test if the difference is greater than 0;
[h1,ptest1,ci1,stats1] = ttest(N290diff,mu,0.05,'right');
[h2,ptest2,ci2,stats2] = ttest(N290diff,mu,0.05,'left');
% chans2mark = union(find(ptest1<0.001),find(ptest2<0.005));
% FDR adjustment for all p-values;
[h1, crit_p1, adj_ci_cvrg1, adj_p1]=fdr_bh(ptest1);
[h2, crit_p2, adj_ci_cvrg2, adj_p2]=fdr_bh(ptest2);
chans2mark = union(find(h1),find(h2));
% topoplot;
figure;
topoplotMK(N290mdiff,ERP.chanlocs,'maplimits',[-1.3 1.3],'plotrad',0.7,'emarker2',{chans2mark,'*','k',12,1});
c = colorbar;
c.Label.String = 'µV';
c.Label.FontSize = 16;
c.Label.FontName = 'Arial';
c.Label.Position = [2 0 0];
c.FontSize = 16

%% P400 and Nc;
if age == 36
    twin = [350 650];
    binis = 6;
else
    twin = [300 650];
    binis = 3;
end
% 1. Mean amp
measurement = 'meanbl';
[junk1 P4NcMeanamp junk3 codes] = pop_geterpvalues( allerp, twin, 1:binis, 1:nch, 'Append', 'off', 'Baseline', 'pre', 'Binlabel', 'on', 'Erpsets', [1:length(allerp)], 'FileFormat',...
'long', 'Fracreplace','NaN', 'InterpFactor',  1, 'Measure', measurement, 'Neighborhood',  8, 'Peakreplace', 'absolute','Resolution',  3 );

% P400/Nc amp for threatening faces, i.e., angry and fear
P4Ncthreat = P4NcMeanamp([1 3],:,:);
P4Ncthreat = squeeze(mean(P4Ncthreat,1))';
if age == 36
    P4Nchn     = P4NcMeanamp([5 6],:,:); % happy and neutral;
    P4Nchn     = squeeze(mean(P4Nchn,1))';
else
    P4Nchn     = squeeze(P4NcMeanamp(3,:,:))'; % happy;
end
P4Ncmdiff  = mean(P4Ncthreat - P4Nchn);

% calculate the t-values and do the t-test;
P4Ncdiff   = (P4Ncthreat - P4Nchn);
mu = 0; % test if the difference is greater than 0;
[h1,ptest1,ci1,stats1] = ttest(P4Ncdiff,mu,0.05,'right');
[h2,ptest2,ci2,stats2] = ttest(P4Ncdiff,mu,0.05,'left');
 chans2mark = union(find(ptest1<0.001),find(ptest2<0.005));
 
[h1, crit_p1, adj_ci_cvrg1, adj_p1]=fdr_bh(ptest1);
[h2, crit_p2, adj_ci_cvrg2, adj_p2]=fdr_bh(ptest2);
chans2mark = union(find(h1),find(h2));
% topoplot;
figure;
topoplotMK(P4Ncmdiff,ERP.chanlocs,'maplimits',[-1.3 1.3],'plotrad',0.7,'emarker2',{chans2mark,'*','k',12,1});
c = colorbar;
c.Label.String = 'µV';
c.Label.FontSize = 16;
c.Label.FontName = 'Arial';
c.Label.Position = [2 0 0];
c.FontSize = 16

    
disp(['**************** Done *****************']);


        

                                      