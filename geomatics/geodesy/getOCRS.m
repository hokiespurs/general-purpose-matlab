function [Projdef,Ellipdef,type] = getOCRS(ocrsname)
% return OCRS parameters

prjname = dirname(['*' ocrsname '*.prj'],inf,'prjfiles');

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