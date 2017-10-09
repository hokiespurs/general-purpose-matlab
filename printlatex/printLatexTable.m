function texstr = printLatexTable(X)

[m,n]=size(X);

texstr = '\\begin{table}[H]\n';
texstr = [texstr '\\centering\n'];
texstr = [texstr sprintf('\\\\begin{tabular}{|%s}\\n',repmat(char('c|'),1,n))];
texstr = [texstr '\\toprule\n'];
for i=1:m
    for j=1:n
        texstr = [texstr X{i,j}];
        if j~=n
            texstr = [texstr '& %%NEWCOLUMN\n'];
        else
            texstr = [texstr '\\\\ %%NEWROW\n'];
        end
    end
    if i~=m
        texstr = [texstr '\\midrule\n'];
    else
        texstr = [texstr '\\bottomrule\n'];
    end
end
texstr = [texstr '\\end{tabular}\n'];
texstr = [texstr '\\end{table}\n'];

end