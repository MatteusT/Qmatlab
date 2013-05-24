classdef gaussian < handle
    %GAUSSIAN Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        method      % Method which you want to use
        basisSet    % Basis that you want to use
        dataPath    % Datapath where the input and the output files go
        jobName     % Name of Job you want to run
        Ehf         % Hartree Fock Energy
        Etot        % Total Energy (same as Hf if method = HF)
        mulliken    % Mulliken charges for atoms
        MP2         % MP2 Energy
        Z           % Atom number
        Eorb        % Orbital Energies
        rcart       % cartesian coordinates
        dipole      % Dipole
    end
    methods
        function runGaussian(obj)
            g09exe = 'C:\G09W\g09.exe';
            gaussianPath = 'C:\G09W';
            template = [obj.dataPath,obj.jobName,'.gjf'];
            filetext = fileread(template);
            
            fileprefix = [obj.dataPath,obj.jobName];
            logfile = [fileprefix,'_',obj.method,'_',obj.basisSet,'.log'];
            fid2 = fopen(logfile,'r');
            if (fid2 == -1)
                t1 = strrep(filetext, 'METHOD', obj.method);
                t2 = strrep(t1,'BASIS',obj.basisSet);
                gjf_file = [fileprefix,'_',obj.method,'_',obj.basisSet,'.gjf'];
                fid1 = fopen(gjf_file,'w');
                fwrite(fid1, t2, 'char');
                fclose(fid1);
                disp(['about to do: ',g09exe,' ',gjf_file]);
                setenv('GAUSS_EXEDIR',gaussianPath);
                resp1 = 1; resp2 = 1;
                while ( resp1 ~= 0 || resp2 ~= 0 )
                    try
                        resp1 = system([g09exe,' ',gjf_file,' ',logfile]);
                        % convert checkpoint file to a formatted checkpoint file
                        resp2 = system([gaussianPath,'\formchk.exe ','temp.chk ',obj.dataPath,'temp.fch']);
                        if ( resp1 == 2057 )
                            disp( '  removing temporary files' );
                            delete( 'fort.6', 'gxx.d2e', 'gxx.inp', 'gxx.int', 'gxx.scr', ...
                                'temp.chk', 'temp.fch', 'temp.rwf' )
                        end
                    catch
                        disp( 'Failed, retrying...' );
                        resp1 = 1; resp2 = 1;
                    end
                end
            end
            parseg09(obj);
            fclose('all');
        end
    end
end

