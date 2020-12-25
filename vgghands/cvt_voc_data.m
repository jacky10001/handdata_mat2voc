function cvt_voc_data(export_path,name_id,get_folder,get_name,get_size,get_bboxs,get_image)
%----- init -----%
name_id = sprintf('%05d', name_id);
%------------------------------------------------------------------
dataset_annotations = fullfile(export_path,'Annotations');
[~,~,~] = mkdir(dataset_annotations);
xml_filename = fullfile(dataset_annotations,[name_id,'.xml']);
%------------------------------------------------------------------
dataset_jpegimages = fullfile(export_path,'JPEGImages');
[~,~,~] = mkdir(dataset_jpegimages);
jpg_filename = fullfile(dataset_jpegimages,[name_id,'.jpg']);
%------------------------------------------------------------------
get_size = [get_size(2),get_size(1),get_size(3)];

%----- main -----%
docNode = com.mathworks.xml.XMLUtils.createDocument('annotation');
annotation = docNode.getDocumentElement;

    folderNode = docNode.createElement('folder');
    folderNode.appendChild(docNode.createTextNode('vgg_hand_dataset'));
    annotation.appendChild(folderNode);

    filenameNode = docNode.createElement('filename');
    filenameNode.appendChild(docNode.createTextNode(name_id));
    annotation.appendChild(filenameNode);

    sourceNode = docNode.createElement('source');
        src_meta_node = docNode.createElement('meta_folder');
        src_meta_node.appendChild(docNode.createTextNode(get_folder));
        sourceNode.appendChild(src_meta_node);
        src_name_node = docNode.createElement('frame_name');
        src_name_node.appendChild(docNode.createTextNode(get_name));
        sourceNode.appendChild(src_name_node);
    annotation.appendChild(sourceNode);

    sizeNode = docNode.createElement('size');
    annotation.appendChild(sizeNode);
        size_node = {'width','height','depth'};
        for idx = 1:length(size_node)
            curr_node = docNode.createElement(size_node{idx});
            data = string(get_size(idx));
            curr_node.appendChild(docNode.createTextNode(data));
            sizeNode.appendChild(curr_node);
        end

    segmentedNode = docNode.createElement('segmented');
    segmentedNode.appendChild(docNode.createTextNode('0'));
    annotation.appendChild(segmentedNode);
        
    [total_box,~] = size(get_bboxs);
    for idx = 1:total_box(1)
    objectNode = docNode.createElement('object');
    annotation.appendChild(objectNode);
        
         name = docNode.createElement('name');
         name.appendChild(docNode.createTextNode('hand'));
         objectNode.appendChild(name);
        
         name = docNode.createElement('pose');
         name.appendChild(docNode.createTextNode('Unspecified'));
         objectNode.appendChild(name);
        
         name = docNode.createElement('truncated');
         name.appendChild(docNode.createTextNode('0'));
         objectNode.appendChild(name);
        
         name = docNode.createElement('difficult');
         name.appendChild(docNode.createTextNode('0'));
         objectNode.appendChild(name);
        
         bndbox = docNode.createElement('bndbox');
         bndbox_node = {'xmin','ymin','xmax','ymax'};
         for idx2 = 1:length(bndbox_node)
             curr_node = docNode.createElement(bndbox_node{idx2});
             data = string(get_bboxs(idx,idx2));
             curr_node.appendChild(docNode.createTextNode(data));
             bndbox.appendChild(curr_node);
         end
         objectNode.appendChild(bndbox);
    end

xmlwrite(xml_filename,docNode);
imwrite(get_image,jpg_filename)
end



