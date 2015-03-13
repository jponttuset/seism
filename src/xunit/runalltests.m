function did_pass = runalltests( test_dir )
% did_pass = runalltests( test_dir )
%
% Runs all tests placed in:
% - The folder "tests" of the working directory
% - The folders "tests" in each subfolder

if nargin==0
   test_dir = pwd;
end

file_list = dir(test_dir);
dir_list = file_list([file_list.isdir]);

did_pass = 1;
for ii=1:numel(dir_list)
    if(dir_list(ii).name(1)~='.')
        did_pass_this = runtests(fullfile(test_dir, dir_list(ii).name, 'tests'));
        did_pass = did_pass*did_pass_this;
    end
end

if ~isempty(dir('tests'))
    did_pas = did_pass*runtests('tests'); %#ok<NASGU,*NASGU>
else
    did_pas = did_pass*runtests(); %#ok<NASGU,*NASGU>
end

if nargout==0
    disp('***************************************')
    if did_pass
        disp('           Tests PASSED')
    else
        disp('           Tests NOT PASSED')
    end
    disp('***************************************')
    clear did_pass
end



