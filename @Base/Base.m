classdef Base < handle
    %BASE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dataPath
        template
        params
        filename
    end
    
    methods
        function obj = Base(dataPath, template, params)
           obj.dataPath = dataPath;
           obj.template = template;
           obj.params = params;

           obj.filename = obj.template;
           for i=1:size(obj.params,1)
               obj.params{i,2} = num2str(obj.params{i,2}, '%.1f');
               if obj.params{i,3}
                   obj.filename = [obj.filename, '_', obj.params{i,2}];
               end
           end 
        end
        function run(obj)
        end
        function parse(obj)
        end
    end
    
end

