%% CNN Model
net = resnet50;

%% Load the Full Path of the Folder
imgDir = fullfile('Original Malaria Slide Images 2');
imds = imageDatastore(imgDir);
%imageLabeler(imds)
pic_num = 150;
H = readimage(imds, pic_num);
figure(1);
imshow(H);

%% Load Pixel Label Images
classes = [
    "Infected_RBC"
    "Background"
    ];
% Load the full path for ground truth images to create Data Store
labelIDs = [1,2];
labelDir = fullfile('PixelLabelData_4');
pxds = pixelLabelDatastore(labelDir,classes,labelIDs);
cmap = ColorMap;

C = readimage(pxds, pic_num);
B = labeloverlay(H,C,'ColorMap',cmap);
figure(2);
imshow(B);
pixelLabelColorbar(cmap,classes);

% Dataset Statistics in Table and Graph Form
tbl = countEachLabel(pxds)

frequency = tbl.PixelCount/sum(tbl.PixelCount)

bar(1:numel(classes),frequency);
xticks(1:numel(classes));
xticklabels(tbl.Name);
xtickangle(45);
ylabel('Frequency');

%% Resize Images and Pixel Labels
imds = resizeImages(imds, imgDir);
pxds = resizePixelLabels(pxds, labelDir);

%% Preparation & Training of Neural Network
[imdsTrain, imdsTest, pxdsTrain, pxdsTest] = partitionData(imds,pxds,labelIDs);

% An 90/10 split will be applied.
numTrainingImages = numel(imdsTrain.Files);
numTestingImages = numel(imdsTest.Files);

%% Create SegNet
% Specify the network image size. This is typically the same as the training image sizes.
imageSize = [224 224 3];

% Specify the number of classes.
numClasses = numel(classes);

% The use of DeepLab v3+ network layers
lgraph = deeplabv3plusLayers(imageSize,numClasses,'resnet50');

%lgraph initially has 206 layers
lgraph.Layers

%Plot the 206-layer lgraph
fig4 = figure('Position', [100, 100, 1000, 1100]);
plot(lgraph);
axis off
axis tight
title('Complete Layer Graph')

%% Balance Classes using Class Weighting
imageFreq = tbl.PixelCount ./ tbl.ImagePixelCount
classWeights = median(imageFreq) ./ imageFreq

pxLayer = pixelClassificationLayer('Name','labels','Classes',tbl.Name,'ClassWeights',classWeights);

%Plot new 206-layer lgraph
lgraph = removeLayers(lgraph, {'classification'});
lgraph = addLayers(lgraph, pxLayer);
lgraph = connectLayers(lgraph, 'softmax-out','labels');
lgraph.Layers

fig5 = figure('Position', [100, 100, 1000, 1100]);
plot(lgraph);
axis off
axis tight
title('Complete Layer Graph')

%% Data Augmentation
augmenter = imageDataAugmenter('RandXReflection',true,'RandXTranslation',[-10 10],'RandYTranslation',[-10 10]);
datasource = pixelLabelImageSource(imdsTrain, pxdsTrain, 'DataAugmentation', augmenter);

%% Select Training Options
% Define training options. 
options = trainingOptions('sgdm', ...
    'Momentum',0.9, ...
    'InitialLearnRate',1e-2, ...
    'L2Regularization',0.0005, ...
    'MaxEpochs',70, ...  
    'MiniBatchSize',3, ...
    'Shuffle','every-epoch', ...
    'CheckpointPath', tempdir, ...
    'VerboseFrequency',2,...
    'Plots','training-progress');

%% Start Training
doTraining = false;
if doTraining
    % Trains a network for image classification problems
    tic
    [net, info] = trainNetwork(datasource,lgraph,options);
    toc
    save('PreTrainedCnn.mat','net','info','options');
    disp('NN trained');
else
    % Load the pre-trained network.  
    data = load('PreTrainedCnn.mat');
    net = data.net;
end

%% Test Network on Image
pic_num = 1;
I = readimage(imds, pic_num);
PL = readimage(pxds, pic_num);
GT = labeloverlay(I, PL, 'Colormap', cmap, 'Transparency', 0.5);

% Show the results of the semantic segmentation
S = semanticseg(I, net);
B = labeloverlay(I, S, 'Colormap', cmap, 'Transparency', 0.5);
figure(4)
imshowpair(GT,B,'montage')
pixelLabelColorbar(cmap,classes);
title('GT vs P')

%% Test on Test Image
expectedResult = readimage(pxds, pic_num);
predicted = uint8(S);
groundtruth = uint8(expectedResult);
figure(6)
imshowpair(groundtruth, predicted, 'montage')
title('GT vs P')

%% Convert to B&W
expectedResult = readimage(pxds, pic_num);
predicted = uint8(S);
groundtruth = uint8(expectedResult);
predicted_2 = imcomplement(predicted);
groundtruth_2 = imcomplement(groundtruth);
figure(7);
imshowpair(groundtruth_2, predicted_2, 'montage');
title('GT vs P');

%% Cropping the B&W Image
PP = imread("B&W Image");
T1 = imcrop(PP,[958.5 89.5 613 614]);
figure(8)
imshow(T1)
imwrite(T1,"B&W Image")

%% Creating Datastore for Segmented Images 
imgDir_2 = fullfile('Segmented Malaria Slide Images 4');
imds_2 = imageDatastore(imgDir_2);
pic_num = 80;
I = readimage(imds_2, pic_num);
figure(9);
imshow(I);

%% Resizing Segmented Images
imds_2 = resizeImages(imds_2, imgDir_2);

%% Post-Processing
se = strel('line',5,90);
eroded = imerode(I, se);
A = imfill(eroded,'holes');
C = bwareaopen(A, 150);
figure(10)
imshow(B)
figure(11);
imshowpair(I, C, 'montage');

%% Creating Mask over Segmented CN Images
pic_num = 1;
Y = readimage(imds, pic_num);
figure(12);
imshow(I);
Z = I;
figure(13);
imshow(Z);

temp_img = Y;

for i = 1:224
    for j = 1:224
        if Z(i,j) == 0
            for k = 1:3
                temp_img(i,j,k) = 255;
            end
        end
    end
end

figure(14);
imshow(temp_img);

%% The Use of Intersection-over-Union Metric
IoU = jaccard(S, expectedResult);
table(classes, IoU)

%% Evaluate Trained Network
pxdsResults = semanticseg(imdsTrain,net, ...
    'MiniBatchSize',3, ...
    'WriteLocation',tempdir, ...
    'Verbose',false);
metrics = evaluateSemanticSegmentation(pxdsResults,pxdsTrain,'Verbose',false);
metrics.DataSetMetrics
metrics.ClassMetrics
metrics.ConfusionMatrix