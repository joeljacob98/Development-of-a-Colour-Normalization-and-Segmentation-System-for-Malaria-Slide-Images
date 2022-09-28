function pxds = convertPixelLabels(pxds, labelDir)
            % Convert pixel label data to uint8.
            
            classes = pxds.ClassNames;
            labelIDs = 1:numel(classes);
            if ~exist(labelDir,'dir')
                mkdir(labelDir)
            else
                pxds = pixelLabelDatastore(labelDir,classes,labelIDs);
                checkSize = imread(pxds.Files{1});
                if (size(checkSize,1) == 224) && (size(checkSize,2) == 224)
                    disp('Label data already resized')
                    return; % Skip if images already resized
                end
            end
            
            reset(pxds)
            while hasdata(pxds)
                % Read the pixel data.
                [C,info] = read(pxds);
                
                % Convert from categorical to uint8.
                L = uint8(C);
                
                % Convert the data. 
                C = im2uint8(C);
                
                % Write the data to disk.
                [~, filename, ext] = fileparts(info.Filename);
                imwrite(C,fullfile(labelDir, [filename ext]))
            end
            
            labelIDs = 1:numel(classes);
            pxds = pixelLabelDatastore(labelDir,classes,labelIDs);
        end