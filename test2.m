qmatlab = 'C:\Users\ccollins\Documents\GitHub\Qmatlab\';
cd([qmatlab, 'G09']);
path = 'C:\Users\ccollins\Desktop\start\ordered\';

mols = {'1A', '1B', '1C', '2A', '2B', '2C'};
frags = cell(6);

for i = 1:length(mols)
    disp(mols{i});
    f1 = gaussian(mols{i}(1), path);
    f1.parseg09();
    m = gaussian(mols{i}, path);
    m.parseg09();
    f2 = gaussian(mols{i}(2), path);
    f2.parseg09();

    disp([all(f1.Z(1:end-1)==m.Z(1:length(f1.Z)-1)), ...
          all(m.Z(length(f1.Z):end)==f2.Z(1:end-1))]);
      
    r1 = find(f1.atom ~= f1.atom(end));
    r2 = find(f2.atom ~= f2.atom(end));
    % for i = (length(f2.Z)-1):-1:1
    %     r2 = [r2 find(f2.atom == i)'];
    % end

    natomicMol = size(m.orb,1);
    % f1.orb(atomic, mo), and we want only the r1 range of atomic
    orb1 = zeros(natomicMol, size(f1.orb,2));
    orb1(r1,:) = f1.orb(r1,:);

    orb2 = zeros(natomicMol, size(f2.orb,2));
    start = length(r1);
    orb2(r2 + start,:) = f2.orb(r2,:);

    % temp1(fragMO,fullMO)
    temp1 = orb1' * m.overlap * m.orb;
    temp2 = orb2' * m.overlap * m.orb;

    frags{i}{1} = f1;
    frags{i}{2} = m;
    frags{i}{3} = f2;
    frags{i,2} = temp1.^2;
    frags{i,3} = temp2.^2;
end


cd(qmatlab);