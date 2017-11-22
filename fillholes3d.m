function resimg=fillholes3d(img,maxgap)
%
% resimg=fillholes3d(img,maxgap)
%
% close a 3D image with the speicified gap size and then fill the holes
%
% author: Qianqian Fang, <q.fang at neu.edu>
% 
% input:
%    img: a 3D binary image
%    maxgap: maximum gap size for image closing
%
% output:
%    resimg: the image free of holes
%
% this function requires the image processing toolbox for matlab/octave
%
% -- this function is part of iso2mesh toolbox (http://iso2mesh.sf.net)
% Modified for gpu usage

if(maxgap)
  if(HaveGpu)
       gpu_img = gpuArray(uint8(img));
       for i = 1:size(img, 3)
        resimg(:,:,i) = imclose(gpu_img(:,:,i),strel(ones(maxgap,maxgap)));
       end
       clear gpu_img
  else
       resimg = imclose(img,strel(ones(maxgap,maxgap,maxgap)));
  end
else
  resimg=img;
end

if(isoctavemesh)
  if(~exist('bwfill'))
    error('you need to install octave-image toolbox first');
  end
  for i=1:size(resimg,3)
    resimg(:,:,i)=bwfill(resimg(:,:,i),'holes');
  end
else
  if(HaveGpu)
      for i = 1:size(resimg, 3)
        resimg(:, :, i) = imfill(resimg(:, :, i),'holes');
      end
      resimg = gather(resimg);
  end
      resimg = imfill(resimg, 'holes');
end
