function cmap = ColorMap()
% Define the colormap used by CamVid dataset.

cmap = [
    0 0 128     % Infected_RBC
    128 0 0     % Background
    ];

% Normalize between [0 1].
cmap = cmap ./ 255;
end 