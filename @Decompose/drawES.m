function drawES(obj,figNum)
    if (nargin < 2)
       figNum = 1;
    end
    figure(figNum); %should match figure number from draw.m
    hold on;
    m = obj.full;
    nlevels = length(m.Ees);
    userIn = -1;
    while (userIn ~= 0)
        for i=1:nlevels
            disp([num2str(i),' ',num2str(m.Ees(i)),' f= ',num2str(m.Ef(i))]);
        end
        userIn = input('Pick a level (0 to exit) ');
        % plot from x= [2.25 2.75]
        if (i>0 && i<=nlevels && userIn~=0)
            ncomp = length(m.Ecomp{userIn});
            x = 2.25;
            xstep = (2.75-2.25)/ncomp;
            for ic = 1:ncomp
                t1 = m.Ecomp{userIn}{ic};
                if (t1.amp.^2 > 0.2)     
                    hold on;
                    plot([x x],[m.Eorb(t1.filled) m.Eorb(t1.empty)],'r-');
                    x = x + xstep;
                    %display transitions and amplitudes
                    disp([num2str(t1.filled), '->',...
                        num2str(t1.empty),' Amplitude: ', num2str(t1.amp)])
                end
            end
        end
    end
end



