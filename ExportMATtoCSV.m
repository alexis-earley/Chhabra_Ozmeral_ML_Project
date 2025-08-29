function ExportMATtoCSV(inputDir, outputDir)

if nargin < 2
    error('Must specify input and output directories.')
end

% Get list of all MAT files
files = dir(fullfile(inputDir, '*.mat'));

for k = 1:length(files)
    % Load file
    filename = fullfile(inputDir, files(k).name);
    dataStruct = load(filename);
    
    % Strip extension from name for folder
    [~, baseName, ~] = fileparts(files(k).name);
    baseName = lower(regexprep(baseName, '[^a-zA-Z0-9]', '_')); % Make python import friendly
    fileOutDir = fullfile(outputDir, baseName);
    if ~exist(fileOutDir, 'dir')
        mkdir(fileOutDir);
    end
    
    % Save theselabels (cell) as csv
    writeCellOrDouble(dataStruct.theselabels, fullfile(fileOutDir, 'theselabels.csv'));
    
    % Save feature_list (cell) as csv
    writeCellOrDouble(dataStruct.feature_list, fullfile(fileOutDir, 'feature_list.csv'));
    
    % Process svm_train
    processSVMstruct(dataStruct.svm_train, fullfile(fileOutDir, 'svm_train'));
    
    % Process svm_class
    processSVMstruct(dataStruct.svm_class, fullfile(fileOutDir, 'svm_class'));
end

end

function processSVMstruct(svmStruct, outDir)
    if ~exist(outDir, 'dir')
        mkdir(outDir);
    end
    
    % Data is numeric
    dlmwrite(fullfile(outDir, 'data.csv'), svmStruct.data, 'delimiter', ',', 'precision', '%.15f');
    
    % Labels are cell arrays of strings
    writeCellOrDouble(svmStruct.labels, fullfile(outDir, 'labels.csv'));
end

function writeCellOrDouble(var, filename)
    if iscell(var)

        writecell(var(:), filename);
    else
        error('Unsupported type for export: %s', class(var));
    end
end
