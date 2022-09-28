function imds = resizeImages(imds, imgDir)
            % Resize images to [224 224].
            
            if ~exist(imgDir,'dir')
                mkdir(imgDir)
            else
                imds = imageDatastore(imgDir);
                checkSize = read(imds);
                if size(checkSize) == [224 224 3]
                    disp('Image data already resized')
                    return; % Skip if images already resized
                end
            end
            
            reset(imds)
            while hasdata(imds)
                % Read an image.
                [I,info] = read(imds);
                
                % Resize image.
                I = imresize(I,[224 224]);
                % Write to disk.
                [~, filename, ext] = fileparts(info.Filename);
                imwrite(I, fullfile(imgDir, [filename  ext]))
            end
            
            imds = imageDatastore(imgDir);
end