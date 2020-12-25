% EgoHands: A Dataset for Hands in Complex Egocentric Interactions 
% URL http://vision.soic.indiana.edu/projects/egohands/
% bounding_boxes is (xmin,ymin,width,height)
% get_bboxs (xmin,ymin,xmax,ymax)
clear,clc
handdata_path = 'D:\YJ\MyDatasets\Hand\egohands_data';
cd(handdata_path)

export_path = 'D:\YJ\MyDatasets\VOC\egohands_data';
jpegimages_path = fullfile(export_path,'JPEGImages');
annotations_path = fullfile(export_path,'Annotations');
ImageSets_Main_path = fullfile(export_path,'ImageSets','Main');
[~,~,~] = mkdir(jpegimages_path);
[~,~,~] = mkdir(annotations_path);
[~,~,~] = mkdir(ImageSets_Main_path);

name_id = 1;
MainSplit = {'TRAIN','VALID','TEST'};
for ll = 1:length(MainSplit)
    vid = getMetaBy('MainSplit', MainSplit{ll});
    
    set_cnt = 1;
    name_ids = {};
    for ii = 1:length(vid)
    for jj = 1:100
        get_target = vid(ii);

        get_folder = get_target.video_id;
        get_name = sprintf('frame_%04d.jpg', get_target.labelled_frames(jj).frame_num);
        get_fullpath = fullfile('_LABELLED_SAMPLES',get_folder,get_name);

        get_image = imread(get_fullpath);
        get_size = size(get_image);

        bounding_boxes = getBoundingBoxes(get_target, jj);
        get_bboxs = bounding_boxes;
        if ~isempty(find(get_bboxs==0, 1))
            get_bboxs(get_bboxs==0) = [];
            get_bboxs = reshape(get_bboxs, [length(get_bboxs)/4,4]);
        end
        cvt_voc_data(annotations_path,jpegimages_path,name_id,...
                     get_folder,get_name,get_size,get_bboxs,get_image)
        fprintf([num2str(name_id,'%05d') ' \n'])
        name_ids{set_cnt} = num2str(name_id,'%05d');
        set_cnt = set_cnt + 1;
        name_id = name_id + 1;
        
        %%% inspect data is correct or not %%%
%         figure(1)
%         imshow(insertShape(get_image, ...
%             'Rectangle', bounding_boxes, ...
%             'Color', {'blue', 'yellow', 'red', 'green'}, ...
%             'LineWidth', 10));
%             disp('Press any key to move onto the next image');pause;
    end
    end
    
    writetable(table( name_ids' ), ...
        fullfile(ImageSets_Main_path,[lower(MainSplit{ll}),'.txt']) , ...
        'WriteVariableNames',0)
end
