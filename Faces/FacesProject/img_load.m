function imgs = img_load(path)
    image_paths = dir(strcat(path, "/*.jpg"));
    
    imgs = zeros(length(image_paths), 45 * 45);
    
    for i=1:length(image_paths)
        img_path = image_paths(i);
        path = strcat(strcat(img_path.folder, "/"), img_path.name);
        
        img = imread(path);
        
        if size(img, 3) == 3
            img = rgb2gray(img);
        end
        
        img = reshape(img, [1 size(img, 1) * size(img, 2)]);
        
        imgs(i, :) = img;
    end
    
end