% VGG Hand Dataset
% URL https://www.robots.ox.ac.uk/~vgg/data/hands/
% (box.a  box.b  box.c  box.d) four point is (Y,X) 
clear,clc
% yours matlab code need put on here
handdata_path = 'D:\YJ\MyDatasets\Hand\hand_dataset';
cd(handdata_path)
% yours export path
export_path = 'D:\YJ\MyDatasets\VOC\vgg_hands_data';
jpegimages_path = fullfile(export_path,'JPEGImages');
annotations_path = fullfile(export_path,'Annotations');
ImageSets_Main_path = fullfile(export_path,'ImageSets','Main');
[~,~,~] = mkdir(jpegimages_path);
[~,~,~] = mkdir(annotations_path);
[~,~,~] = mkdir(ImageSets_Main_path);
% Only allow to export area of hand bigger than the threshold
area_threshold = 1500 ;
% Only allow to export area of hand bigger than the threshold
show_debug_image = false ;
% move to 'your path + \hand_dataset' for **dir() function**
% we can use '*' to get all dataset image filepath
% e.g. '*/*/images/*.jpg'
%    first '*'  : can find {training_dataset,validation_dataset,test_dataset}
%    second '*' : can find {training_data,validation_data,test_data}
%    third '*'  : can find all JPEG file
uf = dir('*/*/images/*.jpg');
% initial counter
name_id = 1;
countBig = 0;
countImg = 0;
countErr = 0;
% for record the list of set
train_set = {};  train_cnt = 1;
valid_set = {};  valid_cnt = 1;
test_set = {};  test_cnt = 1;
% begin create voc dataset
for i = 1:length(uf)
    flag = 0;
    % get target file folder and name
    get_target = uf(i);
    % only use the root of set for get data property
    get_folder = get_target.folder;
    sep_idx = strfind(get_folder,'\');
    get_folder = get_folder(1:sep_idx(end)-1);
    % only get filename, remove file extension
    get_name = uf(i).name;
    [~,name,~] = fileparts(get_name);
    % get image data property
    get_image = imread( fullfile(get_folder,'images',[name,'.jpg']) );
    load( fullfile(get_folder,'annotations',[name,'.mat']) );
    get_size = size(get_image);
    
    get_bboxs = [];
    bounding_boxes = [];
    for j = 1:length(boxes)
        box = boxes{j};
        box_x = [box.a(2) box.b(2) box.c(2) box.d(2)];
        box_y = [box.a(1) box.b(1) box.c(1) box.d(1)];
        xmin = floor(min(box_x)); xmin = floor(max([xmin,1]));
        ymin = floor(min(box_y)); ymin = floor(max([ymin,1]));
        xmax = floor(max(box_x)); xmax = floor(min([xmax,get_size(2)]));
        ymax = floor(max(box_y)); ymax = floor(min([ymax,get_size(1)]));
        
        area = (xmax-xmin+1)*(ymax-ymin+1);
        if(area > area_threshold)
            flag = 1;
            get_bboxs(j,:) = [xmin ymin xmax ymax];
            bounding_boxes(j,:) = [xmin ymin xmax-xmin ymax-ymin];
            countBig = countBig + 1;
        end
    end
    
    if(flag == 1)
        cvt_voc_data(annotations_path,jpegimages_path,name_id,...
                     get_folder,get_name,get_size,get_bboxs,get_image)
        fprintf([num2str(name_id,'%05d') ' \n'])
        % get image set property
        set_type = '';
        if contains(get_folder,'train')
            train_set{train_cnt} = num2str(name_id,'%05d');
            train_cnt = train_cnt + 1;
        elseif contains(get_folder,'validation')
            valid_set{valid_cnt} = num2str(name_id,'%05d');
            valid_cnt = valid_cnt + 1;
        elseif contains(get_folder,'test')
            test_set{test_cnt} = num2str(name_id,'%05d');
            test_cnt = test_cnt + 1;
        end
        name_id = name_id + 1;
        
        %%% inspect data is correct or not %%%
        if show_debug_image
            figure(1),imshow(get_image);
            imshow(insertShape(get_image, ...
                'Rectangle', bounding_boxes, ...
                'Color', 'red', ...
                'LineWidth', 5));
            disp('Press any key to move onto the next image');pause;
        end
    
        countImg = countImg + 1;
    else
        disp('No big hand, skip the data');
        countErr = countErr + 1;
    end
end

% save ImageSets
writetable(table( train_set' ), ...
	fullfile(ImageSets_Main_path,'train.txt') , ...
	'WriteVariableNames',0)
writetable(table( valid_set' ), ...
	fullfile(ImageSets_Main_path,'val.txt') , ...
	'WriteVariableNames',0)
writetable(table( test_set' ), ...
	fullfile(ImageSets_Main_path,'test.txt') , ...
	'WriteVariableNames',0)
% show counter
fprintf('\n\n   count Big: %d\n   count Img: %d\n   count Err: %d\n', ...
                countBig,          countImg,          countErr);