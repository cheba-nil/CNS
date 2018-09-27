function oldPath = CNSP_resetLib

% clears LD_LIBRARY_PATH and ensures
% the FSL envrionment variables have been
% set up
%
% Usage: oldPath = CNSP_resetLib


fsldir=getenv('FSLDIR');

% if contains (system_dependent('getos'), 'Ubuntu')
if strfind (system_dependent('getos'), 'Ubuntu') % use strfind, instead of contains, to be compatible with older version of MATLAB
    fsllibdir=sprintf('%s/%s', fsldir, 'bin');
end

if ismac
  dylibpath=getenv('DYLD_LIBRARY_PATH');
  oldPath = dylibpath;
  setenv('DYLD_LIBRARY_PATH');  
else
  ldlibpath=getenv('LD_LIBRARY_PATH');
  oldPath = ldlibpath;
  setenv('LD_LIBRARY_PATH');
  % if contains (system_dependent('getos'), 'Ubuntu')
  if strfind (system_dependent('getos'), 'Ubuntu') % use strfind, instead of contains, to be compatible with older version of MATLAB
    setenv('LD_LIBRARY_PATH',fsllibdir);
  end
end

