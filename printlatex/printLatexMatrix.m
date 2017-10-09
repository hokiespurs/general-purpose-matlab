function texstr = printLatexMatrix(X,strformat)
% get 
[m,n]=size(X);

texstr = '$\n \\begin{bmatrix}\n';
for i=1:m
    for j=1:n
        texstr = [texstr sprintf(strformat,X(i,j))];
        if j~=n
           texstr = [texstr sprintf('&')];            
        end
    end
    texstr = [texstr '\\\\\n'];
end
texstr = [texstr '\\end{bmatrix}\n'];
texstr = [texstr '$\n'];

end