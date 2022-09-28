function pxds = resizeImageLabels(pxds, labelDir)
            % Resize pixel label data to [224 224].
            
            if ~exist(labelDir,'dir')
                mkdir(labelDir)
            else
                pxds = imageDatastore(labelDir);
                checkSize = read(pxds);
                if (size(checkSize,1) == 224) && (size(checkSize,2) == 224)
                    disp('Label data already resized')
                    return; % Skip if images already resized
                end
            end
            
            reset(pxds)
            while hasdata(pxds)
                % Read the pixel data.
                [C,info] = read(pxds);
                
                % Resize the data. Use 'nearest' interpolation to
                % preserver label IDs.
                C = imresize(C,[224 224],'nearest');
                
                % Write the data to disk.
                [~, filename, ext] = fileparts(info.Filename);
                imwrite(C,fullfile(labelDir, [filename ext]))
            end
        end