% Test pre-post image alignment.

clc

input_dir = 'C:\Users\Derin\Desktop\2015-3-18 kras rods redo\dehyb\pos0';

post_name = 'post24green';
pre_name = 'pre24green';

rx = '^img_.*$';
fList = regexpdir(input_dir, rx);
progressbar;
for i = framelist
    fpre = [input_dir pre_name ' (' num2str(i) ').mat'];
    p = load(fpre);
    pre = double(p.data);%*mean(mirror(:))./(double(mirror));
    fpost = [input_dir post_name ' (' num2str(i) ').mat'];
    f = load(fpost);
    post = double(f.data);%*mean(mirror(:))./(double(mirror));

    I1 = pre;
    I2 = post;
    medi = median(I2(:));
    
    theta = -4:.2:4;
    quality = zeros(length(theta),1);
    [a,b] = size(I1);
    
    best = 0;
    best_idx = 1;
    for t = 1:length(theta)
        
    %     a = c*sin(theta(i)*pi/180) + r*cos(theta(i)*pi/180);
    %     b = c*cos(theta(i)*pi/180) + r*sin(theta(i)*pi/180);
        I2r = imrotate(I2,theta(t),'crop');
        I2r(I2r==0) = medi;
        
        [delta,q] = alignImages(I1,I2r);
        I2_aligned = imtranslate(I2r,delta);
        quality(t) = q;
        composite = (double(I1) + double(I2_aligned)) /2;
%         imwrite(uint8(255*(composite-min(composite(:)))./range(composite(:))), ['spot ' num2str(i) ' image number ' num2str(t) '.jpeg'],'jpeg');
        if q > best
            imwrite(uint8(255*(composite-min(composite(:)))./range(composite(:))), ['aligned composite' num2str(i) '.jpeg'],'jpeg');
            best = q;
            best_idx = t;
        end
        progressbar(t/length(theta),[]);
    end
    plot(theta,quality);
    progressbar([],i/length(framelist));
end
progressbar(1)
