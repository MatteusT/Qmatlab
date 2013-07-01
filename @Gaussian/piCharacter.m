function res = piCharacter(obj, iorb)
  % m is a guassian calc for a molecule lying in x,y plane
  a1 = obj.orb((obj.type == 1) & (obj.subtype == 3) , iorb);
  res = sum(a1.^2);
end