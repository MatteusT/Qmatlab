function parseAmpac(obj,fileprefix)

arcfile = ([fileprefix,'.arc']);
fid1 = fopen(arcfile,'r');
t1 = textscan(fid1,'%s');
fclose(fid1);
text = t1{1};

Hf = find(ismember(text,'FORMATION')==1);
[nfound,junk] = size(Hf);
if (nfound ~= 1)
   display(['error: found FORMATION ',num2str(nfound),' times']);
end
obj.Hf = str2num(text{Hf+2});

% Parse the out file
outfile = ([fileprefix,'.out']);
fid1 = fopen(outfile,'r');
t1 = textscan(fid1,'%s');
fclose(fid1);
text = t1{1};
% Read in cartesian coordinates
t1 = find(ismember(text,'CARTESIAN')==1);
% take last occurence of the word cartesian
t1 = t1(size(t1,1),1);
t1 = t1 + 7;
done = 0;
iatom = 1;
while (~done)
   if (str2num(text{t1}) == iatom)
      element{iatom} = {text{t1+1}};
      r(1,iatom) = str2double( text{t1+2} );
      r(2,iatom) = str2double( text{t1+3} );
      r(3,iatom) = str2double( text{t1+4} );
      t1 = t1 + 5;
      iatom = iatom + 1;
   else
      done = 1;
      iatom = iatom -1;
   end
end
obj.natom = iatom;
obj.r = r;
obj.element = element;

%%
t1 = find(ismember(text,'NET')==1);
if (size(t1,1) > 0)
   % take last occurence of the word 'NET'
   t1 = t1(size(t1,1),1);
   t1 = t1 + 13;
   done = 0;
   iatom = 1;
   while (~done)
      if (str2num(text{t1}) == iatom)
         c_element{iatom} = text{t1+1};
         charge(iatom) = str2double( text{t1+2} );
         t1 = t1 + 4;
         iatom = iatom + 1;
      else
         done = 1;
         iatom = iatom -1;
      end
   end
   obj.rho = charge;
end

%% Read in charges
t1 = find(ismember(text,'ELECTROSTATIC')==1);
if (size(t1,1) > 1)
   % take last occurence of the word cartesian
   t1 = t1(size(t1,1),1);
   t1 = t1 + 7;
   totalCharge = str2double( text{t1} );
   t1 = t1 + 7;
   done = 0;
   iatom = 1;
   while (~done)
      if (str2num(text{t1}) == iatom)
         c_element(iatom) = text{t1+1};
         charge(iatom) = str2double( text{t1+2} );
         t1 = t1 + 3;
         iatom = iatom + 1;
      else
         done = 1;
         iatom = iatom -1;
      end
   end
   obj.esp = charge;
end
%% Old stuff, when trying to get geometry from arcfile
%t1 = find(ismember(text,'CARTESIAN')==1);
%for i=1:size(t1,1)
%   if ( strcmp(text{t1(i)-1},'FINAL') && strcmp(text{t1(i)+1},'OBTAINED'))
%      t2 = t1(i);
%   end
%end
% move to first 0.000000 after t2
%i1 = t2;
%t2 = 0;
%while (i1 < size(text,1) && ~strcmp(text{i1}, '0.000000') )
%   i1 = i1 + 1;
%end
%i1 = i1-1;

      