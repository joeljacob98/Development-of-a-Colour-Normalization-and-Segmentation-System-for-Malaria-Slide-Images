I = imread('Reference Image to be used for Colour Normalization');
LAB = rgb2lab(I);
L = LAB(:,:,1)/100;
L = adapthisteq(L,'NumTiles',[25 25],'ClipLimit',0.003);
LAB(:,:,1) = L*100;
J = lab2rgb(LAB);

figure(1);
subplot (2,2,1), imshow(I), title('Original');
subplot (2,2,2), imhist(I), title('Original Histogram');
subplot (2,2,3), imshow(J), title('Enhanced Image');
subplot (2,2,4), imhist(J), title('Enhanced Histogram');

figure(2);
imshow(J);

figure(3);
imhist(I);

figure(4);
imhist(J);