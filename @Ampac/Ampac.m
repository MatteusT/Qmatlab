classdef Ampac < Base
    %AMPAC Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Hf          % Total Energy (same as Hf if method = HF)
        rho         % Atom number
        natom       % number of atoms
        r           % cartesian coordinates
        element     % element
        esp         % electostatic potential
    end
    
    methods
        function obj = Ampac(dataPath, template, params)
            obj = obj@Base(dataPath, template, params);
        end
        function run(obj)
            ampacexe ='"C:\Program Files (x86)\Semichem, Inc\Ampac-9.2\ampac.exe"';
            
            tpl_file = [obj.dataPath, obj.template,'.tpl'];
            filetext = fileread(tpl_file);

            arc_file = [obj.dataPath, obj.filename, '.arc'];
            dat_file = [obj.dataPath, obj.filename, '.dat'];

            fid2 = fopen(arc_file,'r');
            if (fid2 == -1)
                for i=1:size(obj.params,1)
                    filetext = strrep(filetext, obj.params{i,1}, obj.params{i,2});
                end
                
                fid1 = fopen(dat_file,'w');
                fwrite(fid1, filetext, 'char');
                fclose(fid1);
                
                disp(['about to do: ',ampacexe,' ',dat_file]);
                [status, result] = system([ampacexe,' ',dat_file]);
            end
            parse(obj);
            fclose('all');
        end
    end
    
end

