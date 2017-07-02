function examplemddir
% tests mddir with the example folder structure
%%
mddirpath = which('mddir');
curdir = pwd;
dname = fileparts(mddirpath);
cd(dname);
mddir
cd(curdir)

end