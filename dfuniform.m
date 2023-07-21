function [newcfs, newf] = dfuniform(cfs,f,t)
[nf, nc] = size(cfs);


% capturamos entre los 1.5 - 5 Ghz
idxmin = nf - find(fliplr(f') >= 1.5e9,1) + 1;
idxmax = find(f <= 5e9, 1) - 1;
cfs2 = cfs(idxmax:idxmin, :);
f2 = f(idxmax:idxmin);


difmin = f(end) - f(end - 1);
f3 = f2(1):difmin:f2(end);
nf3 = length(f3);
cfs3 = zeros(nf3, nc);
cfs3(1,:) = cfs2(1,:);

for i = 2:length(f3)
    idxref = find(f2 <= f3(i) ,1);
    ratio = (f2(idxref-1) - f3(i))/(f2(idxref-1) - f2(idxref));
    cfs3(i,:) = cfs2(idxref,:) + (cfs2(idxref - 1,:) - cfs2(idxref,:))*ratio;
end

newcfs = cfs3;
newf = f3;
end