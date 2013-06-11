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
    temp1 = orb1' * m.overlap * m.orb;
    temp2 = orb2' * m.overlap * m.orb;

    frags{i}{1} = f1;
    frags{i}{2} = m;
    frags{i}{3} = f2;
    frags{i,2} = temp1.^2;
    frags{i,3} = temp2.^2;

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

    Eorbs = {t1(t1>-7), t2(t2>-7), t3(t3>-7)};

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

    for j=1:2
        for k=1:length(Eorbs{3})
            e1 = Eorbs{j}(k);
            e2 = Eorbs{j+1}(k);
            line(dottedpoints(j,:), [e1 e2], 'LineStyle', ':', 'color', [0 0 0]);
        end
    end

    figure;
    for j=1:size(m.rcart,2)
        for k=1:size(m.rcart,2)
            xs = m.rcart(1,[j k]);
            ys = m.rcart(2,[j k]);
            dist = norm([xs(1)-xs(2), ys(1)-ys(2)]);
            if (dist - 2) < 0
                plot(xs, ys, 'Color', [0, 0, 0]);
                hold on;
            end
        end
    end

    mo = m.Nelectrons/2;

    for j=1:size(m.rcart,2)
        a1 = m.orb((m.atom == j) & (m.type == 1) & (m.subtype == 3) , mo);
        if length(a1) == 0
            continue
        end
        if ~all(sign(a1)==sign(a1(1)))
            disp(a1);
            disp(j);
        end
        r = sign(sum(a1)) * norm(a1);
        drawCircle(m.rcart(1,j), m.rcart(2,j), r);
        hold on;
    end
end