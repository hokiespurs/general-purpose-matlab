function fgroup = mddirgroupf(f,d)
nd = numel(d);
%get directory of each file
fd = cellfun(@(x) fileparts(x),f,'UniformOutput',false);
fgroup = cell(0);
for i=1:nd
   D = d{i};
   filesInD = f(strcmp(D,fd));
   fext = cellfun(@(x) x(find(x=='.',1,'last')+1:end),filesInD,'UniformOutput',false);
   [uniqueExt,~,ind] = unique(fext);
   for j=1:numel(uniqueExt)
       nUniqueExt = sum(ind==j);
       fgroup{end+1,1} = sprintf('%s\\*.%s (%i)',D,uniqueExt{j},nUniqueExt);
   end
end

end

