function imds = convertImages(imds, imgDir)
            % Convert images to uint8.
            
            if ~exist(imgDir,'dir')
                mkdir(imgDir)
            else
                imds = imageDatastore(imgDir);
                checkFormat = read(imds);
                if format(checkFormat) == uint8(I)
                    disp('Image data already converted')
                    return; % Skip if images already converted
                end
            end
            
            reset(imds)
            while hasdata(imds)
                % Read an image.
                [I,info] = read(imds);
                
                % Resize image.
                I = im2uint8(I);
                % Write to disk.
                [~, filename, ext] = fileparts(info.Filename);
                imwrite(I, fullfile(imgDir, [filename  ext]))
            end
            
            imds = imageDatastore(imgDir);
end