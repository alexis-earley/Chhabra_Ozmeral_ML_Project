% Set directory ('.' means current folder)
folder = '.';  

% Get list of all MAT files
files = dir(fullfile(folder, '*.mat'));

% Loop through and load each file
for k = 1:length(files)
    filename = fullfile(folder, files(k).name);
    data = load(filename);
    
    % Option 1: store each file in a struct array
    allData(k).name = files(k).name;
    allData(k).data = data;
    
    % Option 2: load into workspace directly
    % (not recommended if variable names overlap)
    % load(filename);
end
