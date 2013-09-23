
 function chk2indo(obj)

 
fid1 = fopen([obj.fileprefix,'.fch'],'r');
if (fid1 == -1)
% make the fchk file
system(['C:\G09W\formchk.exe ',obj.fileprefix,'.chk']);
fid1 = fopen([obj.fileprefix,'.fch'],'r');
end
%read the fchk file and find cartesian coordinates
t1 = textscan(fid1,'%s');
text = t1{1};
fclose(fid1);

% the atomic numbers (Z) are after 'Atomic numbers'
phrase = {'Atomic','numbers'};
loc = obj.findText(text,phrase);
natom = str2num(text{loc+4});
Z = zeros(1,natom);
for iatom=1:natom
   Z(1,iatom) = str2num(text{loc+4+iatom});
end

% Cartesian coordinates
phrase = {'Current','cartesian','coordinates'};
loc = obj.findText(text,phrase);
rcart = zeros(natom,3);
icurr = loc + 6;
for iatom=1:natom
   for ix= 1:3
   rcart(iatom,ix) = str2double(text{icurr});
   icurr = icurr+1;
   end
end
% Convert from Bohr radii to Angstroms
rcart = rcart / 1.889726124565062;

Atoms = {'H','He','Li','Be','B','C','N','O','F','Ne','Na','Mg','Al','Si','P','S','Cl','Ar'};


%  make a out file that is compatable with INDO

mopacText(1) = {['          CARTESIAN COORDINATES\n']};
mopacText(2) = {['    NO.       ATOM               X         Y         Z\n']};

for iatom = 1:natom
    xcoord = rcart(iatom,1);
    ycoord = rcart(iatom,2); 
    zcoord = rcart(iatom,3);
    xc = sprintf('%0.8f', xcoord);
    yc = sprintf('%0.8f', ycoord);
    zc = sprintf('%0.8f', zcoord);
mopacText(end+1)= {['       ',num2str(iatom),' ',Atoms{Z(iatom)},'        ',num2str(xc),...
    '      ',num2str(yc),'      ',num2str(zc),'\n']};
end
mopacText(end+1) = {'  \n'}; % needed for indo to be able to read properly
mopacText1 = strcat(mopacText{:});

mopacText2 = ([mopacText1,'\n',mopacText1]);

fid2 = fopen([obj.fileprefix,'_g.out'],'wt');
fprintf(fid2,mopacText2, 'char');
fclose(fid2);
 end