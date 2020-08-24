function MgOnoise = addnoise(MgO, sig)

MgOnoise = zeros(length(MgO), 2);
MgOnoise(:,1) = MgO(:,1);

for i = 1:length(MgO)
      
    MgOnoise(i, 2) = MgO(i, 2) + normrnd(0, sig);

end

dlmwrite('MgOnoise.txt', MgOnoise)

end