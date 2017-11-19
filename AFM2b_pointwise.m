% this algorithm fits the pointwise approach [O'Callaghan 2011] for increasing indentation depths
% it takes the files saved with AFM1_contactpoint.m as input and 
% give as output the pointwise Young's modulus for each indentation depth for each
% file (saved as .xslx file)

% 0_ INPUT
% here information about the data/experiment need to be entered
input_folder = 'D:\SHEFFIELD\WORK\AFM\output'; % where are the data files with CP fitted
indenter_radius = 3000; % spherical indenter used for experiments: radius in [nm]
k = 0.2;    % spring constant of cantilever used in [nN/nm]
% where are the files going to be saved?
output_folder = 'D:\SHEFFIELD\WORK\AFM\output\young'; % name folder
mkdir(output_folder);   % create folder
% what is the working folder for Matlab?
working_folder = 'D:\SHEFFIELD\WORK\Matlab';

% 1_ open folder and list files
data_folder = cd (input_folder);
D = dir('*.txt');	% make a file list (D) of the (.txt) data in data_folder
[~,index] = sortrows({D.date}.'); D = D(index); clear index     % order data by acquisition time
D_cell = struct2cell(D); D_cell_filename = D_cell(1,:)';	% create cell array of strings with file-names

% 2_ output arrays initialisation
save_h = [50, 100:100:500];	% height at which saving E values
E_save = zeros(size(D_cell_filename,1),length(save_h));

% 3_ FOR cycle which opens one file at the time and perform post-processing steps
for i = 1:size(D_cell_filename,1) 
    
    % 3a_ open file
    cd (input_folder);
    myfilename = D_cell_filename{i};
    fileID = fopen(myfilename);
    C = textscan(fileID, '%f%f%f%f', 'CommentStyle', '#');	% raw files contain 4 columns
    mydata = cell2mat(C);	% save data of file(i) into matrix mydata
    fclose(fileID);
    cd (working_folder)
    
    % 3b_ save data from file into arrays
    height = mydata(:,1);	% cantilever height [nm]
    force = mydata(:,2);	% vertical deflection [nN]
    series = mydata(:,3);       % time [s]
    segment = mydata(:,4);      % time for extend/retract [s]
    
    segment_start = zeros(4,1);
    jj = 1;
    for ii = 1:length(segment)-1
        if segment(ii)-segment(ii+1) > 0.1
            segment_start(jj,1) = (ii+1);	% index of [segment] change from extend to retract
            jj = jj+1;
        end
    end
    
    % extend (E) data
    force_E = force(1:segment_start(1)-1);
    height_E = height(1:segment_start(1)-1);
    series_E = series(1:segment_start(1)-1);
    segment_E = segment(1:segment_start(1)-1);
    % retract (R) data
    force_R = force(segment_start(1):end);
    height_R = height(segment_start(1):end);
    series_R = series(segment_start(1):end);
    segment_R = segment(segment_start(1):end);
    
    % 3c_ find pointwise Young's modulus for increasing indentation dephts
    
    % consider indentation region only 
    index_neg = find(height_E<0);
    force_neg = force_E(index_neg); % [nN]
    height_neg = height_E(index_neg); % [nm]
    
    % find height difference between cell and substrate
    height_substrate = force_neg/(-k); % [nm]
    height_diff = (height_substrate-height_neg); % [nm]
           
    % find pointwise Young's modulus
    phi = (4/(3*pi))*sqrt(indenter_radius*height_diff.^3); % [nm2]
    E = force_neg./(2*pi.*phi); % [Gpa]
    E_kPa = E*10^6; %[kPa]
    
    % 3d_ save in output arrays [E_save]
    for kk = 1:length(save_h)
        vector_search = abs(save_h(kk)-height_diff);
        index_search = find(vector_search == min(vector_search));
        E_save(i,kk) = E_kPa(index_search);
    end
       
end

% SAVE
cd(output_folder);
filename1 = 'pointwise_young_indentation.xlsx';
xlswrite(filename1,E_save)
