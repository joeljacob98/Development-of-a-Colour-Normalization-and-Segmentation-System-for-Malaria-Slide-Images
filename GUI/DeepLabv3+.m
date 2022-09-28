global IO I1 B predicted predicted_2 pathname filename;

        %% Load the pre-trained network.  
        data = load('PreTrainedCnn.mat');
        net = data.net;
        
        %% Test Network on Image
        cmap = ColorMap;
        S = semanticseg(I1, net);
        B = labeloverlay(I1, S, 'Colormap', cmap, 'Transparency', 0.5);

        %% Convert to B&W
        predicted = uint8(S);
        predicted_2 = imcomplement(predicted);
        
        
        C1 = exist([pathname filename]); 
            if  (C1 == 0)  
                app.StatusTextArea.Value = {'File does not exist'}; 
                app.Lamp.Color = 'r';
                return;
            else 
                app.StatusTextArea.Value = {'End of Process'}; 
                app.Lamp.Color = 'b';
            end
            imshowpair(B,predicted_2,'montage','parent',app.Image_5);