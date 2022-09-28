            global IO pathname filename;
            
            Logo = imread('Logo.jpg');

            imshow(imresize(Logo,[240 480]),'parent',app.UIAxes);
            
            filename = app.EnterImageFileNameEditField.Value;
            C1 = exist(filename); 
            if  (C1 == 0)  
                app.StatusTextArea.Value = {'Choose a File'}; 
                app.Lamp.Color = 'r';
                return;
            else 
                app.StatusTextArea.Value = {'Please press processing button'};      
            end            
            IO = imread(filename);