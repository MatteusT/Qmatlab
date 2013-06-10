classdef Ampac < handle
    %AMPAC Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        method      % Method which you want to use
        dataPath    % Datapath where the input and the output files go
        jobName     % Name of Job you want to run
        npar        % number of additional parameters (max 4)
        par         % value of each parameter
        Hf          % Total Energy (same as Hf if method = HF)
        rho         % Atom number
        natom       % number of atoms
        r           % cartesian coordinates
        element     % element
        esp         % electostatic potential
    end
    
    methods
        function runAmpac(obj)
            setPars(obj);
            template = [obj.dataPath,obj.jobName,'.dat'];
            filetext = fileread(template);
            fileprefix = [obj.dataPath,obj.jobName,'_',obj.method];
            disp(fileprefix);
            arcfile = [fileprefix,'.arc'];
            fid2 = fopen(arcfile,'r');
            if (fid2 == -1)
                t1 = strrep(filetext,'METHOD', obj.method);
                if obj.npar ~= 0
                    tpar= t1;
                    for ipar = 1:obj.npar
                        tpar = strrep(tpar, ['PAR',num2str(ipar)], num2str(obj.par(ipar)));
                    end
                    tf = tpar;
                else
                    tf= t1;
                end
                datFile = [fileprefix,'.dat'];
                fid1 = fopen(datFile,'w');
                fwrite(fid1, tf, 'char');
                fclose(fid1);
                ampacexe ='"C:\Program Files (x86)\Semichem, Inc\Ampac-9.2\ampac.exe"';
                disp(['about to do: ',ampacexe,' ',datFile]);
                [status, result] = system([ampacexe,' ',datFile]);
                disp('ok');
            end
            parseAmpac(obj,fileprefix);
            fclose('all')
        end
        function setPars(obj)
            text = fileread([obj.dataPath,obj.jobName,'.dat']);
            parmnr = strfind(text,'PAR');
            obj.npar = length(parmnr);  
            if obj.npar ~= length(obj.par)
                error('The amount of parameteres are not matching')
            end
            
        end
    end
    
end

