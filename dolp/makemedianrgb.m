%%
DNAME = 'C:\tmp\pt3\organized';

for iP = 8:9
    for iT = 1:4
        imstrlook = sprintf('P%02.0f_T%02.0f*.jpg',iP,iT);
        fnames = dirname(imstrlook,1,DNAME);
        fnames = fnames(1:3:end);
        Itemp = [];
        for i=1:numel(fnames)
           Itemp(:,:,:,i)=imread(fnames{i});
           i
        end
        if ~isempty(fnames)
            Imedian = uint8(median(Itemp,4));
            imwrite(Imedian,[DNAME '/' sprintf('RGB_P%02.0f_T%02.0f.png',iP,iT)]);
        end
    end
end