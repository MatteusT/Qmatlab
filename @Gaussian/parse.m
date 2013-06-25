function parse(obj)

% Will have utils.findText() issue errors for us as appropriate
issueErrors = true;
fch_file = [obj.dataPath, obj.filename, '.fch'];
fid1 = fopen(fch_file,'r');
if fid1 == -1
   fch_file = [obj.dataPath, obj.filename, '.fchk'];
   fid1 = fopen(fch_file,'r');
   if fid1 == -1
      disp( '  Missing formated checkpoint file' );
      fclose('all');
   end
end

t1 = textscan(fid1,'%s');
fclose(fid1);
text = t1{1};


% Orbital energies
phrase = {'Alpha','Orbital','Energies'};
loc = utils.findText(text,phrase, issueErrors);
% The fifth word after alpha is the number of energies
Nenergies = str2double( text{loc+5} );
obj.Eorb = zeros(Nenergies,1);

for i=1:Nenergies
   obj.Eorb(i) = str2double(text{loc + 5 + i});
end

% Number of electrons
phrase = {'Number','of','electrons'};
loc = utils.findText(text,phrase);
%The fourth word after number is the number of electrons
obj.Nelectrons = str2double(text{loc + 4});

% Orbital coefficients
phrase = {'Alpha','MO','coefficients'};
loc = utils.findText(text,phrase);
% The fifth word after alpha is the number of energies
Nvalues = str2double(text{loc+5});
temp = zeros(Nvalues,1);

for i=1:Nvalues
   temp(i) = str2double(text{loc + 5 + i});
end

obj.orb = reshape(temp,Nenergies,Nenergies);

% The hartree fock energy is after SCF Energy R
phrase = {'SCF','Energy','R'};
loc = utils.findText(text,phrase);

obj.Ehf = str2double(text{loc+3});

% MP2 Energy
phrase = {'MP2','Energy','R'};
loc = utils.findText(text,phrase);
if loc == 0
    obj.MP2 = obj.Ehf;
else
  obj.MP2 = str2double(text{loc+3});
end

% the atomic numbers (Z) are after 'Atomic numbers'
phrase = {'Atomic','numbers'};
loc = utils.findText(text,phrase);
natom = str2double(text{loc+4});
obj.Z = zeros(1,natom);
for iatom=1:natom
   obj.Z(1,iatom) = str2double(text{loc+4+iatom});
end

% Cartesian coordinates
phrase = {'Current','cartesian','coordinates'};
loc = utils.findText(text,phrase);
obj.rcart = zeros(3,natom);
icurr = loc + 6;
for iatom=1:natom
   for ix= 1:3
     obj.rcart(ix,iatom) = str2double(text{icurr});
     icurr = icurr+1;
   end
end
% Convert from Bohr radii to Angstroms
obj.rcart = obj.rcart / 1.889726124565062;

try
    % Dipole moment
    phrase = {'Dipole','Moment'};
    loc = utils.findText(text,phrase);
    n1 = str2double(text{loc+4});
    obj.dipole = zeros(n1,1);
    for i=1:n1
       obj.dipole(i,1) = str2double(text{loc+4+i});
    end
end

% Mulliken charges
phrase = {'Mulliken','Charges'};
loc = utils.findText(text,phrase);
n1 = str2double(text{loc+4});
obj.mulliken = zeros(1,n1);
for i=1:n1
   obj.mulliken(1,i) = str2double(text{loc+4+i});
end


% Basis set information
% First, read in the data as it is defined in the fchk file
phrase = {'Shell','types'};
loc = utils.findText(text,phrase);
nshells = str2num(text{loc+4});
obj.shellTypes = zeros(nshells,1);
for i=1:nshells
   obj.shellTypes(i,1) = str2num(text{loc+4+i});
end

phrase = {'Number','of','primitives','per','shell'};
loc = utils.findText(text,phrase);
nshells = str2num(text{loc+7});
primsPerShell = zeros(nshells,1);
for i=1:nshells
   primsPerShell(i,1) = str2num(text{loc+7+i});
end

phrase = {'Shell','to','atom','map'};
loc = utils.findText(text,phrase);
nshells = str2num(text{loc+6});
shellToAtom = zeros(nshells,1);
for i=1:nshells
   shellToAtom(i,1) = str2num(text{loc+6+i});
end

phrase = {'Primitive','exponents'};
loc = utils.findText(text,phrase);
n1 = str2num(text{loc+4});
primExp = zeros(n1,1);
for i=1:n1
   primExp(i,1) = str2num(text{loc+4+i});
end

phrase = {'Contraction','coefficients'};
loc = utils.findText(text,phrase);
if (size(loc,1) > 0)
   n1 = str2num(text{loc(1)+4});
   contCoef = zeros(n1,1);
   for i=1:n1
      contCoef(i,1) = str2num(text{loc(1)+4+i});
   end
end
if (size(loc,1) == 2)
   if (strcmp(text{loc(2)-1},'P(S=P)')~=1)
      error('readfchk.m: unsupported contraction in fchk file');
   end
   n1 = str2num(text{loc(2)+4});
   contCoef2 = zeros(n1,1);
   for i=1:n1
      contCoef2(i,1) = str2num(text{loc(2)+4+i});
   end
end
if ((size(loc,2) > 2) || (size(loc,2) < 1))
  error('readfchk.m: unsupported contraction in fchk file');
end

% Information on the basis set. See top of file for definition of these
% arrays
atom = zeros(Nenergies, 1);
type = zeros(Nenergies, 1);
subtype = zeros(Nenergies, 1);
nprims = zeros(Nenergies, 1);
% prims{ibasis) = (2,nprims) matrix
% (1,:) = cont coefficients; (2,:) = prim exponents
prims = cell(Nenergies,1);

nsubtypes = [1 3 6]; %  cartesian basis sets for s,p,d
ibasis = 0;
iprim = 0;
for ishell = 1:nshells
   % stype = 0(s) 1(p) 2(d) etc.
   % if stype < 0, then it means we have shells up to that stype here
   % i.e. stype = -1, means we have both an s and p shell with identical
   % contractions
   stypeFile = obj.shellTypes(ishell);
   if (stypeFile >= 0)
      stype = stypeFile;
      primTemp = zeros(2, primsPerShell(ishell));
      for ip = 1:primsPerShell(ishell)
         iprim = iprim+1;
         primTemp(1,ip) = contCoef(iprim);
         primTemp(2,ip) = primExp(iprim);
      end
      for itemp = 1:nsubtypes(stype+1)
         ibasis = ibasis + 1;
         atom(ibasis) = shellToAtom(ishell);
         type(ibasis) = stype;
         subtype(ibasis) = itemp;
         nprims(ibasis) = primsPerShell(ishell);
         prims{ibasis} = primTemp;
      end
   else
      for stype = 0:abs(stypeFile)
         primTemp = zeros(2, primsPerShell(ishell));
         for ip = 1:primsPerShell(ishell)
            iprim = iprim+1;
            if (stype == 0)
               primTemp(1,ip) = contCoef(iprim);
            else
               primTemp(1,ip) = contCoef2(iprim);
            end
            primTemp(2,ip) = primExp(iprim);
         end
         % reset iprim, to keep count ok
         if (stype < abs(stypeFile))
            iprim = iprim - primsPerShell(ishell);
         end
         for itemp = 1:nsubtypes(stype+1)
            ibasis = ibasis + 1;
            atom(ibasis) = shellToAtom(ishell);
            type(ibasis) = stype;
            subtype(ibasis) = itemp;
            nprims(ibasis) = primsPerShell(ishell);
            prims{ibasis} = primTemp;
         end
      end
   end
end
if (ibasis ~= Nenergies)
   error('readchk.m: bookkeeping error in creation of atom()');
end

obj.atom = atom;
obj.type = type;
obj.subtype = subtype;

phrase = {'Total','SCF','Density'};
loc = utils.findText(text, phrase, issueErrors);
ndensities = str2double(text{loc + 5});
obj.densities = zeros(Nenergies,Nenergies);

r = 0;
c = 1;
for i=1:ndensities
   r = r + 1;
   obj.densities(c, r) = str2double(text{loc + 5 + i});
   r = mod(r, c);
   if r == 0
      c = c + 1;
   end
end



try
    log_file = [obj.dataPath, obj.filename, '.log'];
    fid1 = fopen(log_file,'r');

    t1 = textscan(fid1,'%s');
    fclose(fid1);
    text = t1{1};

    try:
        phrase = {'***','Overlap','***'};
        loc = utils.findText(text, phrase, issueErrors);
        obj.overlap= zeros(Nenergies,Nenergies);
        n = ceil(Nenergies/5);

        loc = loc + 3;                 % Overlap, ***
        for i = 1:n
           r = (i - 1) * 5;            % remove 5 rows/columns for each iteration
           if i == n                  % special case when rows left < 5
              Nleft = mod(Nenergies, 5);
              if Nleft == 0
                  Nleft = 5;
              end
              loc = loc + Nleft;
           else
              loc = loc + 5;           % 5 nums at top
           end
           for j = 1+r:Nenergies
              for k = 1:5
                 temp = str2num(text{loc + k});
                 obj.overlap(j, r+k) = temp;
                 obj.overlap(r+k, j) = temp;
                 if j-r == k           % first 5 rows in a set form a diag
                    break
                 end
              end
              loc = loc + k + 1;
           end
        end
    end

    try
        % EXCITED STATES
        phrase = {'Excited', 'State'};
        loc = utils.findText(text,phrase);
        i = 1;

        % Iterates through every instance of phrase Excited State
        ilevel = 0;
        for i = 1:size(loc)
            % Make sure this the correct location of file, should ave #: here
            if (strcmp(text{loc(i)+2}(2),':'))
                ilevel = ilevel + 1;
                obj.Ees(ilevel) = str2num( text{loc(i)+4} );
                % oscillator strength f=#
                obj.Ef(ilevel)  = str2num( text{loc(i)+8}(3:end) );
                icurr = loc(i) + 11;
                icomp = 0;
                t2 = {};
                while (strcmp(text{icurr},'->'))
                    icomp = icomp + 1;
                    t3.filled = str2num(text{icurr -1});
                    t3.empty  = str2num(text{icurr +1});
                    t3.amp    = str2num(text{icurr +2});
                    t2{icomp} = t3;
                    icurr = icurr + 4;
                end
                obj.Ecomp{ilevel} = t2;
            end
        end
    end

end
end