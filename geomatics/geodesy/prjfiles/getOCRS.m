function [Projdef,Ellipdef,type] = getOCRS(ocrsname)
% return OCRS parameters using the PRJ files in the ocrs_meters folder

dname = fileparts(which('getOCRS.m'));
prjname = dirname(['*' ocrsname '*.prj'],inf,[dname '../ocrs_meters']);

if numel(prjname)==1
    [Projdef,Ellipdef,type] = readPRJfile(prjname{1});
elseif numel(prjname)>1
    % use the shorter of the names
    [~,ind] = min(cellfun(@numel,prjname));
    [Projdef,Ellipdef,type] = readPRJfile(prjname{ind});
elseif numel(prjname)==0
   error('cant find matching prj file'); 
end

end