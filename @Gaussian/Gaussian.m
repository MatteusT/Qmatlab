classdef Gaussian < Base
    %GAUSSIAN Summary of this class goes here
    %   Detailed explanation goes here

    properties
        Ehf         % Hartree Fock Energy
        Etot        % Total Energy (same as Hf if method = HF)
        mulliken    % Mulliken charges for atoms
        MP2         % MP2 Energy
        Z           % Atom number
        Eorb        % Orbital Energies
        rcart       % cartesian coordinates
        dipole      % Dipole
        densities   % SCF densities
        Nelectrons
        orb
        overlap
        shellTypes
        atom
        type
        subtype
        Ees
        Ef
        Ecomp
    end
    methods
        function obj = Gaussian(dataPath, template, params)
           obj = obj@Base(dataPath, template, params);
        end
        function run(obj)
            g09exe = 'C:\G09W\g09.exe';
            gaussianPath = 'C:\G09W';

            tpl_file = [obj.dataPath, obj.template,'.tpl'];
            filetext = fileread(tpl_file);

            log_file = [obj.dataPath, obj.filename, '.log'];
            gjf_file = [obj.dataPath, obj.filename, '.gjf'];
            fch_file = [obj.dataPath, obj.filename, '.fch'];

            fid2 = fopen(log_file,'r');
            if (fid2 == -1)
                f = fieldnames(obj.params);
                for i=1:length(f)
                    x = f{i};
                    filetext = strrep(filetext, x, obj.params.(x){1});
                end

                fid1 = fopen(gjf_file,'w');
                fwrite(fid1, filetext, 'char');
                fclose(fid1);

                disp(['about to do: ',g09exe,' ',gjf_file,' ',log_file]);
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
            parse(obj);
            delete('temp.chk', 'fort.*');
            fclose('all');
        end
    end
end

