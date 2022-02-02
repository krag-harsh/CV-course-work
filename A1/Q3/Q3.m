function []=Q3(path)

vid=VideoReader(strcat(path,'shahar_walk.avi'));  % reading the video
% code to create frames from the video
n = vid.NumFrames; % store the number of frame in the video
for ifr = 1:n
  frames = read(vid, ifr);
  imwrite(frames, fullfile(path, sprintf('%05d.jpg', ifr)));  % saving the frames
end 

files=dir([path '*.jpg']);  % store the file names
% code to create the video file(data is added at the end to this file)
outputVideo = VideoWriter(fullfile(path,'outputQ3.avi'));
outputVideo.FrameRate = vid.FrameRate; % setting the frame rate of the video file created
open(outputVideo)

nl=numel(files);
base=zeros(vid.height,vid.width,3,nl);  % creating variable which will store the frames in its 4th dimension

for i=1:nl
    base(:,:,:,i)= double(imread(strcat(path,files(i).name))); %storing the frames 
end

base=median(base,4);  % taking the mean of the frames(pixel wise, therefore at dimention 4(where frames are stored)

for i=1:nl
    I_tosave=imread(strcat(path,'/',files(i).name));  % reading the frame
    fmed=mean(abs(double(I_tosave)-base),3);  % subtracting the median frame with this frame
    
    fm=fmed>49;  % tried different values, finally selected 49 as threashold

    Stats = regionprops([fm],'Boundingbox');  % getting the position of the boundingbox from the frame
    St=Stats(1).BoundingBox;
    
    % taking the image and adding shape to it
    fh=figure('visible','off');
    imshow( I_tosave, 'border', 'tight' );
    hold on;
    rectangle('Position', [St(1) St(2) St(3) St(4)],'EdgeColor','r','Curvature',[1 1]); %// draw rectangle on image
    frm = getframe(fh);
    writeVideo(outputVideo,uint8(frm.cdata))  % finally saving the image data to the video

end

end





