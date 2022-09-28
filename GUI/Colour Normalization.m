 global IO I1 pathname filename;                   
            
            IO = imread([pathname filename]);
            R = imread('Enhanced Reference 6.tif');
            
            Ir = IO(:,:,1);
            Ig = IO(:,:,2);
            Ib = IO(:,:,3);

            Ir2 = R(:,:,1);
            Ig2 = R(:,:,2);
            Ib2 = R(:,:,3);
            
            HIr2 = imhist(Ir2);
            HIg2 = imhist(Ig2);
            HIb2 = imhist(Ib2);
            
            Outr = histeq(Ir,HIr2);
            Outg = histeq(Ig,HIg2);
            Outb = histeq(Ib,HIb2);
            
            histsp(:,:,1) = Outr;
            histsp(:,:,2) = Outg;
            histsp(:,:,3) = Outb;
            
            I1 = imresize(histsp,[224 224]);

            app.EnterImageFileNameEditField.Value = filename; 

            C1 = exist([pathname filename]); 
            if  (C1 == 0)  
                app.StatusTextArea.Value = {'File does not exist'}; 
                app.Lamp.Color = 'r';
                return;
            else 
                app.StatusTextArea.Value = {'Please Press the Process 2 Button to Segment the Infected RBC'...
                    'Type of Semantic Segmentation Architecture can be Selected'}; 
                app.Lamp.Color = 'y';
            end
            imshow(histsp,'parent',app.Image_2);