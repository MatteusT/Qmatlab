classdef Decompose < handle

   properties
      fullIn % Gaussian object of full molecule (calculation already run)
      full % full calc 
      frags % cell array of the fragments
      fragList % cell array, with lists of atoms in each fragment
      links % link atoms (currently only 2 supported)
      rlinks % array with bond lengths for the link atoms
      keywords % string: should eventually pull from full, but user for now
      
      maps % full.orbs(maps{ifrag),:) = full MOs in the AO basis of 
           % ifrag (but without the link atom present)
      nonLink % nonLink{ifrag} = all AO's on ifrag except those on link atom
      overlap % overlap{ifrag}(fragMO,fullMO)
   end
   
   methods
      function obj = Decompose(fullIn,fragList,links,rlinks,keywords)
         obj.fullIn = fullIn;
         obj.fragList = fragList;
         obj.links = links;
         obj.rlinks = rlinks;
         obj.keywords = keywords;
      end
   end
end
