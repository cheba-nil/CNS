function CNSP_restoreLib (oldPath)

if ismac
  setenv('DYLD_LIBRARY_PATH', oldPath);
else
    setenv('LD_LIBRARY_PATH', oldPath);
end