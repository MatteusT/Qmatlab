function values = decompose(obj, atomLists, orbital)
    values = zeros(length(atomLists),1);
    for i = 1:length(atomLists)
        atoms = ismember(obj.atom,atomLists{i});
        values(i) = sum(obj.orb(atoms,orbital).^2);
    end
end