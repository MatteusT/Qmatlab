classdef gaussian < handle
    %GAUSSIAN Summary of this class goes here
    %   Detailed explanation goes here

    properties
        controller
        params
        
        method      % Method which you want to use
        basisSet    % Basis that you want to use
        Ehf         % Hartree Fock Energy
        Etot        % Total Energy (same as Hf if method = HF)
        mulliken    % Mulliken charges for atoms
        MP2         % MP2 Energy
        Z           % Atom number
        Eorb        % Orbital Energies
        rcart       % cartesian coordinates
        dipole      % Dipole
        filename    % Name of the file without the extension
        densities   % SCF densities
        Nelectrons
        orb
        overlap
        shellTypes
        atom
        type
        subtype
    end
    methods
        function obj = gaussian(controller, params)
           obj.controller = controller;
           obj.params = params;
           obj.filename = obj.controller.template;
           for i=1:length(params)
               if obj.controller.inname(i)
                   obj.filename = [obj.filename, '_', obj.params{i}];
               end 
           end
        end
        function runGaussian(obj)
            g09exe = 'C:\G09W\g09.exe';
            gaussianPath = 'C:\G09W';

            template = [obj.controller.dataPath,obj.controller.template,'.tpl'];
            filetext = fileread(template);

            log_file = [obj.controller.dataPath,obj.filename,'.log'];
            gjf_file = [obj.controller.dataPath,obj.filename,'.gjf'];
            fch_file = [obj.controller.dataPath,obj.filename,'.fch'];
            
            fid2 = fopen(log_file,'r');
            if (fid2 == -1)
                for i=1:length(obj.params)
                    filetext = strrep(filetext, obj.controller.paramNames{i}, obj.params{i});
                end 

                fid1 = fopen(gjf_file,'w');
                fwrite(fid1, filetext, 'char');
                fclose(fid1);

                disp(['about to do: ',g09exe,' ',gjf_file]);
                setenv('GAUSS_EXEDIR',gaussianPath);

                resp1 = 1; resp2 = 1;
                while ( resp1 ~= 0 || resp2 ~= 0 )
                    try
                        resp1 = system([g09exe,' ',gjf_file,' ',log_file]);
                        % convert checkpoint file to a formatted checkpoint file
                        resp2 = system([gaussianPath,'\formchk.exe ','temp.chk ', fch_file]);
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
            delete('temp.chk', 'fort.*');
            fclose('all');
        end
    end
end

