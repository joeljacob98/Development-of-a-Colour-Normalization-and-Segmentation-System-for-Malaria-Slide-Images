function pxds = resizePixelLabels(pxds, labelDir)
            % Resize pixel label data to [224 224].
            
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
                
                % Resize the data. Use 'nearest' interpolation to
                % preserve label IDs.
                L = imresize(L,[224 224],'nearest');
                
                % Write the data to disk.
                [~, filename, ext] = fileparts(info.Filename);
                imwrite(L,fullfile(labelDir, [filename ext]))
            end
            
            labelIDs = 1:numel(classes);
            pxds = pixelLabelDatastore(labelDir,classes,labelIDs);
        end