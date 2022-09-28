            global IO pathname filename;
            
            [filename, pathname] = uigetfile('*.*','Pick the image file to be processed',cd);

            app.EnterImageFileNameEditField.Value = filename; 

            C1 = exist([pathname filename]); 
            if  (C1 == 0)  
                app.StatusTextArea.Value = {'File does not exist'}; 
                app.Lamp.Color = 'r';
                return;
            else 
                app.StatusTextArea.Value = {'Please Press the Process 1 Button to Colour Normalize the Image'};      
            end
            IO = imread([pathname filename]);
            cd(pathname)
            imshow(IO,'parent',app.Image_4);