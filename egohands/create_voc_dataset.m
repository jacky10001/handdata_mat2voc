clear,clc
%%
export_path = 'D:\YJ\MyDatasets\VOC\egohands_data';

name_id = 1;
locations = {'OFFICE','COURTYARD','LIVINGROOM'};
activities = {'CHESS','JENGA','PUZZLE','CARDS'};
for ll = 1:length(locations)
for aa = 1:length(activities)
for ii = 1:4
for jj = 1:100
    vid = getMetaBy('Location', locations{ll}, 'Activity', activities{aa});
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

    cvt_voc_data(export_path,name_id,get_folder,get_name,get_size,get_bboxs,get_image)
    fprintf([num2str(name_id,'%05d') ' \n'])
    name_id = name_id + 1;

    %%% inspect data is correct or not %%%
    % figure(1)
    % imshow(insertShape(get_image, ...
    %     'Rectangle', bounding_boxes, ...
    %     'Color', {'blue', 'yellow', 'red', 'green'}, ...
    %     'LineWidth', 10));
    %     disp('Press any key to move onto the next image');pause;
end
end
end
end