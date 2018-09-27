%------------
% CNSP_imgCal
%------------
%
% INPUT:
%   calType = 'sum', 'avg',
%   outputDir = output directory
%   outputFilename = output filename without .nii suffix
%   N = number of images that will be calculated
%   inputCellArr_col = a column cell array containing paths to each image
%
% OUTPUT:
%   outputImg = path to output image
%
% NOTE:
% 	Do not include extension in outputFilename
%

function outputImg = CNSP_imgCal (calType, outputDir, outputFilename, N, inputCellArr_col)

spm('defaults', 'fmri');
spm_jobman('initcfg');

[row,col] = size (inputCellArr_col);

if (row ~= N) || (col ~= 1)
	error ('Incorrect cell array size.');
end

switch calType
    case 'avg'  % average input images
        for i = 1:N
            if i == 1
                expr = 'i1';
            else
                expr = strcat(expr,['+i' num2str(i)]);
            end
        end

        expr = ['(' expr ')/' num2str(N)];
        
    case 'sum'  % sum input images
        for i = 1:N
            if i == 1
                expr = 'i1';
            else
                expr = strcat(expr,['+i' num2str(i)]);
            end
        end
        
    otherwise
        error (['No calculation type ' calType 'defined in CNSP_imgCal.']);
end

matlabbatch{1}.spm.util.imcalc.input = inputCellArr_col;
matlabbatch{1}.spm.util.imcalc.output = outputFilename;
matlabbatch{1}.spm.util.imcalc.outdir = {outputDir};
matlabbatch{1}.spm.util.imcalc.expression = expr;
matlabbatch{1}.spm.util.imcalc.var = struct('name', {}, 'value', {});
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

output = spm_jobman ('run',matlabbatch);

outputImg = [outputDir '/' outputFilename '.nii'];
