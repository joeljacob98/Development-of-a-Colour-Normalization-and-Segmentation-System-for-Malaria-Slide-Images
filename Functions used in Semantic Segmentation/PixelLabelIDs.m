function labelIDs = PixelLabelIDs()
% Return the label IDs corresponding to each class.
%
% The 2 classes are:
%   "Infected_RBC" and "Background" 
labelIDs = { ...
    
    % "Infected_RBC"
    [
        000 000 128; ... % "Infected_RBC"
    ]
    
    % "Background" 
    [
        128 000 000; ... % "Background"
    ]
   };
end