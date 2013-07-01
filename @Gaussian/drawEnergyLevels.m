function drawEnergyLevels(obj, figNum, xs, piOnly)
    figure(figNum);
    hold on;
    for iorb = 1:size(obj.orb,1)
      e = obj.Eorb(iorb);
      if (iorb <= obj.Nelectrons/2)
         format = 'b'; % filled orbs are blue
      else
         format = 'g'; % empty orbs are green
      end
      if (piOnly && (obj.piCharacter(iorb) < 0.1))
         format = 'y'; % non-pi will be yellow
      end
      plot(xs, [e e], format);
    end
end

