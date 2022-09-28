I = imread('Malaria Slide Image');
R = imread('Enhanced Reference Malaria Slide Image');

figure
imhist(I)

Ir = I(:,:,1);
Ig = I(:,:,2);
Ib = I(:,:,3);

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

figure(1);
subplot(221);imshow(R);title('Reference Image');
subplot(222);imshow(I);title('Input Image');
subplot(224);imshow(histsp);title('Result Image');

figure(2);
subplot(221);imhist(R);title('Reference Image');
subplot(222);imhist(I);title('Input Image');
subplot(224);imhist(histsp);title('Result Image');