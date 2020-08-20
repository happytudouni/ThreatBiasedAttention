function [] = Ploterps(participantnumber,age);
% put this program in the same folder with the ERP data;
% use is as Ploterps(36000,36); % This will plot the grand average for 36 mos;
% ****** or Ploterps(21,7); This will plot the individual ERPs for subj 21 at 7mos;
global ERP ERP1 ERP2;
hz = 0.3;
eeglab;close;
%Load the ERP set
% 5000 is the average ERP for 5 mos, 7000 is for 7 mos, 12000 is for 12mos,
% and 36000 is for 36 mos;
if find(ismember([5000 7000 12000 36000],participantnumber)) % group plots
    erpname=['Experiment 1 Subject ' num2str(participantnumber) ' ' num2str(hz) 'Hz ERPLAB Averaged ERPs.erp'];   
else % individual plots
    erpname=['Experiment 1 Subject ' num2str(participantnumber) ' Age ' num2str(age) ' ' num2str(hz) 'Hz ERPLAB Averaged ERPs.erp'];    
end

ERP = pop_loaderp('filename',erpname,'filepath','');

if age == 36 %there are 6 bins
    % channel operation: 9 clusters as in Xie et al. (2019)_Dev Sci
    ERP1 = pop_erpchanoperator(ERP, {'nch1 =(ch57+ch58+ch63+ch64+ch50+ch59+ch65+ch68)/8 label TO_L' 'nch2= (ch101+ch95+ch96+ch99+ch100+ch90+ch91+ch94)/8 label TO_R'  'nch3=(ch66+ch69+ch70+ch73+ch74)/5 label OI_L' 'nch4=(ch82+ch83+ch84+ch88+ch89)/5 label OI_R' 'nch5 =(ch71+ch72+ch75+ch76+ch81)/5 label OI_z' 'nch6=(ch7+ch31+ch55+ch80+ch106)/5 label Centralz' 'nch7 =(ch30+ch36+ch37+ch41+ch42)/5 label Central3'  'nch8=(ch87+ch93+ch103+ch104+ch105)/5 label Central4' 'nch9=(ch5+ch10+ch11+ch12+ch16+ch18)/6 label Frontalz'});
    nch = 9; % ch1-9: TO_L, TO_R, OI_L, OI_R, OI_Z, CentralZ, Central3, Central4, FrontalZ;
    %plot all 6 conditions
    %'Linespec',{'-k' '--r' '-.b' '-g' ':c' '--m' '-.y'}
    nbin = 6;
    pop_ploterps( ERP1,[1:6],1:nch, 'AutoYlim', 'off', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [3 3], 'ChLabel', 'on', 'FontSizeChan',15, 'FontSizeLeg',15, 'LegPos', 'bottom', 'Linespec', {'k-.' , 'k--', 'r-','r-.','b-','m-'}, 'LineWidth',3, 'Maximize', 'on', 'Position', [ 103.667 25.75 105.833 35.75], 'Style', 'Classic', 'xscale', [ -100.0 896.0 -100 0:400:800 ], 'YDir', 'normal', 'yscale', [ -25 35 -10:5:20 ] );                                                                                                                
    set (gcf,'Name','All 6 conditions');
    %plot for [angry100,fear100,happy,neutral] 4 conditions
    pop_ploterps( ERP1,[1 3 5 6],1:5, 'AutoYlim', 'off', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [2 3], 'ChLabel', 'on', 'FontSizeChan',15, 'FontSizeLeg',15,'FontSizeTicks',15, 'LegPos', 'bottom', 'Linespec', {'b-.' , 'k--', 'r-.','m-'}, 'LineWidth',3, 'Maximize', 'on', 'Position', [ 103.667 25.75 105.833 35.75], 'Style', 'Classic', 'xscale', [ -100.0 896.0 -100 0:400:800 ], 'YDir', 'normal', 'yscale', [ -5 19 0:10:15 ],'style','classic' );                                                                                                                
    set (gcf,'Name','The N2090 and P400 components'); 
    % change the netural condition to gray
    axhandle = gcf;
    lines = findobj(axhandle,'type','line');
    for k=1:4:length(lines)
    set(lines(k),'color',[0.4 0.4 0.4]);
    end   
    axhandle.CurrentAxes.FontSize = 20;
    
    pop_ploterps( ERP1,[1 3 5 6],6:9, 'AutoYlim', 'off', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [2 3], 'ChLabel', 'on', 'FontSizeChan',15, 'FontSizeLeg',15,'FontSizeTicks',15, 'LegPos', 'none', 'Linespec', {'b-.' , 'k--', 'r-.','m-'}, 'LineWidth',3, 'Maximize', 'on', 'Position', [ 103.667 25.75 105.833 35.75], 'Style', 'Classic', 'xscale', [ -100.0 896.0 -100 0:400:800 ], 'YDir', 'normal', 'yscale', [ -11 3 -10:10:0 ],'style','classic' );                                                                                                                
    set (gcf,'Name','The Nc component');
    % change the netural condition to gray
    axhandle = gcf;
    lines = findobj(axhandle,'type','line');
    for k=1:4:length(lines)
    set(lines(k),'color',[0.4 0.4 0.4]);
    end
    axhandle.CurrentAxes.FontSize = 20
    
    % plot averaged ERP plots, one plot for each component (N290, P400 and Nc);
    ERP2 = pop_erpchanoperator(ERP1, {'nch1 =(ch1+ch2+ch3+ch4)/4 label N290' 'nch2= (ch1+ch2+ch3+ch4+ch5)/5 label P400' 'nch3=(ch6+ch7+ch8+ch9)/4 label Nc'});
    pop_ploterps( ERP2,1:6, [1 2 3], 'AutoYlim', 'off', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [2 3], 'ChLabel', 'on', 'FontSizeChan',15, 'FontSizeLeg',15,'FontSizeTicks',15, 'LegPos', 'bottom', 'Linespec', {'b-.' ,'b-', 'k-.','k-', 'r-.','m-'}, 'LineWidth',3, 'Maximize', 'on', 'Position', [ 103.667 25.75 105.833 35.75], 'Style', 'Classic', 'xscale', [ -100.0 896.0 -100 0:400:800 ], 'YDir', 'normal', 'yscale', [ -15 20 -10:5:20 ],'style','classic' );                                                                                                                
    set (gcf,'Name','One plot for each component by averaging across the clusters used for them');
    % change the netural condition to gray
    axhandle = gcf;
    lines = findobj(axhandle,'type','line');
    for k=1:6:length(lines)
    set(lines(k),'color',[0.4 0.4 0.4]);
    end
    axhandle.CurrentAxes.FontSize = 20
else %infants have 3 bins
    %pop_scalplot(ERP,[5:8],200:50:400,'Maximize','on','Electrodes','off','Maptype','2D','Maplimit','minmax');
    % channel operation 
    nch = 9;
    ERP1 = pop_erpchanoperator(ERP, {'nch1 =(ch57+ch58+ch63+ch64+ch50+ch59+ch65+ch68)/8 label TO_L' 'nch2= (ch101+ch95+ch96+ch99+ch100+ch90+ch91+ch94)/8 label TO_R'  'nch3=(ch66+ch69+ch70+ch73+ch74)/5 label OI_L' 'nch4=(ch82+ch83+ch84+ch88+ch89)/5 label OI_R' 'nch5 =(ch71+ch72+ch75+ch76+ch81)/5 label OI_z' 'nch6=(ch7+ch31+ch55+ch80+ch106)/5 label Centralz' 'nch7 =(ch30+ch36+ch37+ch41+ch42)/5 label Central3'  'nch8=(ch87+ch93+ch103+ch104+ch105)/5 label Central4' 'nch9=(ch5+ch10+ch11+ch12+ch16+ch18)/6 label Frontalz'});
    % you may set up the ylimits differently for the infant plots;
    wrow = 3; wcol = 4;
    ymin = -20; ymax = 40;
    pop_ploterps( ERP1,[1 2 3],1:nch, 'AutoYlim', 'off', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [wrow wcol], 'ChLabel', 'on', 'FontSizeChan',15, 'FontSizeLeg',15, 'LegPos', 'bottom', 'Linespec', {'b-.' , 'k-', 'r:','r-.','b-','m-'}, 'LineWidth',4, 'Maximize', 'on', 'Position', [ 103.667 25.75 105.833 35.75], 'Style', 'Classic', 'xscale', [ -100.0 896.0 -100 0:50:800], 'YDir', 'normal', 'yscale', [ymin ymax ymin:20:ymax] );        
    set (gcf,'Name','angry100,fear100,happy100'); %'m:'
    
     %plot for [angry100,fear100,happy,neutral] 4 conditions
    pop_ploterps( ERP1,1:3,1:5, 'AutoYlim', 'off', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [2 3], 'ChLabel', 'on', 'FontSizeChan',15, 'FontSizeLeg',15,'FontSizeTicks',15, 'LegPos', 'bottom', 'Linespec', {'b-.' , 'k--', 'r-.','m-'}, 'LineWidth',3, 'Maximize', 'on', 'Position', [ 103.667 25.75 105.833 35.75], 'Style', 'Classic', 'xscale', [ -100.0 896.0 -100 0:400:800 ], 'YDir', 'normal', 'yscale',[ymin ymax ymin:20:ymax],'style','classic' );                                                                                                                
    set (gcf,'Name','The N2090 and P400 components'); 
    % change the netural condition to gray
    axhandle = gcf; 
    axhandle.CurrentAxes.FontSize = 20;
    
    pop_ploterps( ERP1,1:3,6:9, 'AutoYlim', 'off', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [2 3], 'ChLabel', 'on', 'FontSizeChan',15, 'FontSizeLeg',15,'FontSizeTicks',15, 'LegPos', 'none', 'Linespec', {'b-.' , 'k--', 'r-.','m-'}, 'LineWidth',3, 'Maximize', 'on', 'Position', [ 103.667 25.75 105.833 35.75], 'Style', 'Classic', 'xscale', [ -100.0 896.0 -100 0:400:800 ], 'YDir', 'normal', 'yscale', [ymin 10 ymin:20:10],'style','classic' );                                                                                                                
    set (gcf,'Name','The Nc component');
    % change the netural condition to gray
    axhandle = gcf;
    axhandle.CurrentAxes.FontSize = 20;   
end  

%% topo plots;
% examples:
% pop_scalplot(ERP,[1 2 3],100:20:280,'Blc','none','Value','insta','Maximize','on','Electrodes','off','Maptype','2D','Maplimit',[-20 10],'Animated','on','filename','TopoMaps.gif');
% pop_scalplot(ERP,[1 2 3],100:20:280,'Blc','none','Value','insta','Maximize','on','Electrodes','on','Maptype','2D','Maplimit',[-10 20],'Colorbar','on','fontsize',15,'plotrad',0.8);










