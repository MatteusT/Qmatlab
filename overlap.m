qmatlab = pwd;

path = 'C:\Users\ccollins\Desktop\start\ordered\';

mols = {'1A'};%S, '1B', '1C', '2A', '2B', '2C'};
frags = cell(length(mols), 3);

for i = 1:length(mols)
    disp(mols{i});
%%  Parse
    f1 = Gaussian(path, mols{i}(1),{});
    f1.parse();
    m = Gaussian(path, mols{i},{});
    m.parse();
    f2 = Gaussian(path, mols{i}(2),{});
    f2.parse();

    disp([all(f1.Z(1:end-1)==m.Z(1:length(f1.Z)-1)), ...
          all(m.Z(length(f1.Z):end)==f2.Z(1:end-1))]);

%%  Calculate
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
    temp1 = (orb1' * m.overlap * m.orb).^2;
    temp2 = (orb2' * m.overlap * m.orb).^2;

    frags{i}{1} = f1;
    frags{i}{2} = m;
    frags{i}{3} = f2;
    frags{i,2} = temp1;
    frags{i,3} = temp2;

%%  Draw
    figure;
    points = [0    0.5;
              2.25 2.75;
              4.5 5];
    t1 = f1.Eorb(r1);
    t2 = m.Eorb;
    t3 = f2.Eorb(r2);
    %Eorbs = {t1(t1>-7), t2(t2>-7), t3(t3>-7)};
    Eorbs = {t1, t2, t3};

    % write homo/lumo
    for j=1:length(frags{i,1})
        x = mean(points(j,:));
        homo = frags{i,1}{j}.Nelectrons/2;
        text(x, Eorbs{j}(homo), 'HOMO', 'horizontalalignment', 'center');
        text(x, Eorbs{j}(homo+1), 'LUMO', 'horizontalalignment', 'center');
    end

    %Eorbs = {t1(t1>-4), t2(t2>-4), t3(t3>-4)};

    % draw levels
    for j=1:length(Eorbs)
        p = points(j,:);
        eo = Eorbs{j};
        for e=eo
             line(p, [e e], 'color', [0 0 0]);
        end
    end

    % draw dotted lines
    dx = 0.0;
    dottedpoints = [points(1,2)+dx points(2,1)-dx;
                    points(2,2)+dx points(3,1)-dx];
    threshold = .25;
    
    for j = 1:length(Eorbs{1})
        for k = 1:length(Eorbs{2})
            if temp1(j,k)>threshold
                e1 = Eorbs{1}(j);
                e2 = Eorbs{2}(k);
                line(dottedpoints(1,:), [e1 e2], 'LineStyle', ':', 'color', [0 0 0]);
            end
        end
    end

    for j = 1:length(Eorbs{3})
        for k = 1:length(Eorbs{2})
            if temp2(j,k)>threshold
                e1 = Eorbs{2}(k);
                e2 = Eorbs{3}(j);
                line(dottedpoints(2,:), [e1 e2], 'LineStyle', ':', 'color', [0 0 0]);
            end
        end
    end
    
    scale = .075;
    xoffset = [-.75 .5 -.5 .75];
    center = mean(points(2,:));
    homo = m.Nelectrons/2;
    
    for loop = -1:2
        offset = center+xoffset(loop+2);
        drawStructureOrb(m, homo+loop, offset, scale);
    end
    
    homo = f1.Nelectrons/2;
    center = mean(points(1,:));
    for loop = 0:1
       offset = center+.5;
       drawStructureOrb(f1, homo+loop, offset, scale);
    end

    homo = f2.Nelectrons/2;
    center = mean(points(3,:));
    for loop = 0:1
       offset = center-.5;
       drawStructureOrb(f2, homo+loop, offset, scale);
    end
end