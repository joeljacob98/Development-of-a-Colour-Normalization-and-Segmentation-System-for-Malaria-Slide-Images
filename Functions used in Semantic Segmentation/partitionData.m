function [imdsTrain, imdsTest, pxdsTrain, pxdsTest] = partitionData(imds,pxds,labelIDs)
            % Partition data by randomly selecting 90% of the data for training. The
            % rest is used for testing.
            
            % Set initial random state for example reproducibility.
            rng(0);
            numFiles = numel(imds.Files);
            % Returns a row vector containing a random permutation of the integers from 1 to n inclusive.
            shuffledIndices = randperm(numFiles);
            
            % Use 90% of the images for training.
            N = round(0.90 * numFiles);
            trainingIdx = shuffledIndices(1:N);
            
            % Use the rest for testing.
            testIdx = shuffledIndices(N+1:end);
            
            % Create image datastores for training and test.
            trainingImages = imds.Files(trainingIdx);
            testImages = imds.Files(testIdx);
            imdsTrain = imageDatastore(trainingImages);
            imdsTest = imageDatastore(testImages);
            
            % Extract class and label IDs info
            classes = pxds.ClassNames;
            labelIDs = 1:numel(pxds.ClassNames);
            
            % Create pixel label datastores for training and test.
            trainingLabels = pxds.Files(trainingIdx);
            testLabels = pxds.Files(testIdx);
            pxdsTrain = pixelLabelDatastore(trainingLabels, classes, labelIDs);
            pxdsTest = pixelLabelDatastore(testLabels, classes, labelIDs);
        end