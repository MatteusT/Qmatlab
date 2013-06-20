classdef Indo < handle
   properties (SetAccess = private)
      % Input parameters
      config     % see defaultConfig() for contents
      dataPath   % directory for the data (do not end with \)
      jobName    % will read structure from ampac out file  jobname.out
      parameterFile
      % and store indo results in jobname.ido
      % Atomic basis set:
      norb       % number of atomic basis functions, and hf orbitals
      aorbAtom   % (1,i) atom on which the ith atomic orbital resides
      aorbType   % (1,i) type of ith atomic orbital
      %  {s1=0,s2=1,p2x=2,p2y=3,p2z=4,s3=5,p3x=6,p3y=7,p3z=8}
      % Hartree Fock Results:
      nfilled    % number of filled molecular orbitals
      hfE        % HF ground state energy
      orbE       % (1,i) energy of ith orbital
      orb        % (i,j) ith component of jth orbital
      indoOutput % output from indo
      % SCI results
      nsci        % number of sci states, with first being ground state
      nscibasis   % number of basis functions (first being ground state)
      esci        % (1,i) energies of ith sci state
      r           %( i,j, icomp) transition (position) operator icomp = x,y,z
      wfsci       % (i,j)  ith component of jth state
      ehsci       % (i,1) hole of the ith SCI basis function (0 if GS)
      % (i,2) = elec of the ith SCI basis function (0 if GS)
      
      indoExe = '"c:\mscpp\demo-dci\Release\demo-dci.exe"';
   end % properties
   properties (Transient)
      osc         % (1,i) oscillator strength from gs to state i
      rx          % r(:,:,1) for backwards compatibility, don't use now
      ry          % r(:,:,2)
      rz          % r(:,:,3)
   end 
   methods (Access = private)
      readIndo(obj);
   end
   methods (Static)
      function res = defaultConfig()
         res.charge = 1;
         res.norbs = 100;
         res.nstates = 25;
         res.field = [0,0,0];
         res.potfile = '';
      end
   end
   methods
      function res = Indo(ConfigIn, dataPathIn, jobNameIn, parameterFileIn)
         if (nargin < 1)
            res.config = Indo.defaultConfig();
         else
            res.config = ConfigIn;
         end
         if (nargin < 2)
            res.dataPath = 'data';
         else
            res.dataPath = dataPathIn;
         end
         if (nargin < 3)
            res.jobName = 'jobname';
         else
            res.jobName = jobNameIn;
         end
         if (nargin < 4)
             res.parameterFile = 'parafile';
         else
             res.parameterFile = parameterFileIn;
         end
             fileprefix= [res.dataPath,res.jobName];
         if (nargin > 0)
            parameters(res, fileprefix); % generates parameterfile (will need to add potfile)
            jobstring = [res.indoExe,' ',res.parameterFile];
         
            disp(['about to do: ',jobstring]);
            [status, result] = system(jobstring);
            res.indoOutput = result;
            res.readIndo();
         end
      end % INDO constructor
      
      function res = get.osc(obj)
         res = zeros(1,obj.nsci);
         for i=1:obj.nsci
            res(1,i) = (obj.esci(1,i)-obj.esci(1,1)) * ...
               ( obj.r(1,i,1)^2 + obj.r(1,i,2)^2 + obj.r(1,i,3)^2 );
         end
      end
      function res = get.rx(obj)
         res = obj.r(:,:,1);
      end
      function res = get.ry(obj)
         res = obj.r(:,:,2);
      end
      function res = get.rz(obj)
         res = obj.r(:,:,3);
      end
      function res = dipole(obj,istate,jstate)
         % returns a vector that is the dipole(istate=jstate)
         % or transition moment (istate ~= jstate)
         res = reshape(obj.r(istate,jstate,:),[3,1]);
      end
   end % methods
end % class