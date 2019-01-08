%%
DNAME = 'C:\tmp\pt3';

%%
f = dir([DNAME '/*.jpg']);
ft = [f.datenum];
ft = (ft-min(ft))*60*60*24;
fnames = {f.name};

[t,ind]=sort(ft);
imnames = fnames(ind);

tsubsecond = getImageTime(imnames,DNAME);
tsubsecondrel = (tsubsecond-tsubsecond(1))*24*60*60;
%%
plot(diff(tsubsecondrel),'.-')

%% organize
jumpind = [0 find(diff(tsubsecondrel)>4) numel(imnames)];

nimages = numel(imnames);
groupnum = nan(nimages,1);
imN = nan(nimages,1);
imL = nan(nimages,1);
groupnum = nan(nimages,1);

L2 = [zeros(1,6) kron(30:30:180,ones(1,3))];
L1 = [180*ones(1,6) kron(150:-30:0,ones(1,3))];
N = [1:6 repmat([1 2 3],1,6)];

for i=1:numel(jumpind)-1
    groupind = jumpind(i)+1:jumpind(i+1);
    if i>=28
        groupnum(groupind)=i+1;
    else
        groupnum(groupind)=i;
    end
    mt(i) = mean(tsubsecondrel(groupind));
    nimingroup(i) = numel(groupind);
    
    if mod(i,2)==1
        if i>=28
            L = L2;
        else
            L = L1;
        end
    else
        if i>=28
            L = L1;
        else
            L = L2;
        end
    end

    if i==28
        imN(groupind) = N(3:end);
        imL(groupind) = L(3:end);
    else
        imN(groupind) = N;
        imL(groupind) = L;
    end
    
end

P = kron(1:9,ones(1,4));
T = repmat([1:4]',1,9);
T(:,2:2:end)=flipud(T(:,2:2:end));
T = T(:);
imPan = P(groupnum);
imTilt = T(groupnum);

PTLN = [imPan(:) imTilt(:) imL(:) imN(:)];

for i=1:numel(imnames)
    newname = sprintf('P%02.0f_T%02.0f_L%03.0f_N%02.0f.jpg',PTLN(i,:));
    copyfile([DNAME '/' imnames{i}],[DNAME '/organized/' newname]);
    fprintf('%s\n',newname);
end


