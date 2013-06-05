function parameters(obj, fileprefix)

fields = obj.config.field;
charge = obj.config.charge;
nstates= obj.config.nstates;
norbs = obj.config.norbs;

% if (nargin < 5)
%     obj.field = [0.000 0.000 0.000];
% else
%     obj.field = field;
% end
% if (nargin < 4)
%     obj.charge = 0;
% else
%     obj.charge = charge;
% end
% if (nargin < 3)
%     obj.nstates = 25 ;
% else
%     obj.nstates = nstates;
% end
% if (nargin < 2)
%     obj.norbs = 100;
% else
%     obj.norbs = norbs;
% end

%create the file
fid0 = fopen([obj.dataPath,'parameters.txt'],'wt');
fprintf(fid0, 'jobname = aaaaaaa\ncharge = bbbbbb\nnorbs = cccccc\nnstates = ddddddd\nefieldx = eeeeeee\nefieldy = fffffff\nefieldz = ggggggg');
fclose(fid0);

%if there is a potiential
if (~isempty(obj.config.potfile))
    fid8 = fopen('parameters.txt','at');
    fprintf(fid8,'\npot_file = xxxxxxxxx');
    fclose(fid8);
end

% replacing the parameters
fid1 = fopen([obj.dataPath,'parameters.txt'],'r');
scan = textscan(fid1,'%s');
fclose(fid1);
scan = scan{1};
file = fileread([obj.dataPath,'parameters.txt']);

%jobname
job = find(ismember(scan,'jobname')==1);
scan(job+2);
t1 = strrep(file,scan{job+2},fileprefix);

%charge
chrg = find(ismember(scan,'charge')==1);
t2 = strrep(t1,scan{chrg+2},num2str(charge,'%i'));


%number of orbitals
norb = find(ismember(scan,'norbs')==1);
t3 = strrep(t2,scan{norb+2},num2str(norbs));

%number of states
nst = find(ismember(scan,'nstates')==1);
t4 = strrep(t3,scan{nst+2},num2str(nstates));

%xfield
xf = find(ismember(scan,'efieldx')==1);
t5 = strrep(t4,scan{xf+2},num2str(fields(1),'%8.3f'));
%yfield
yf = find(ismember(scan,'efieldy')==1);
t6 = strrep(t5,scan{yf+2},num2str(fields(2),'%8.3f'));
%zfield
zf = find(ismember(scan,'efieldz')==1);
t7 = strrep(t6,scan{zf+2},num2str(fields(3),'%8.3f'));

%pot file
    potf = find(ismember(scan,'pot_file')==1);
    potsize = size(potf,1);
if potsize == 1
    t7 = strrep(t7,scan{potf+2},potfile);
end

%write in the file
fid2 = fopen([obj.dataPath,'parameters.txt'],'w');
fwrite(fid2, t7, 'char');
fclose('all');

end


