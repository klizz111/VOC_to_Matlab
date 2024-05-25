%图片路径
img_dir = "D:\Downloads\VOCtrainval_06-Nov-2007\VOCdevkit\VOC2007\Person";
xml_dir = "D:\Downloads\VOCtrainval_06-Nov-2007\VOCdevkit\VOC2007\xmls";

%读取图片
imds = imageDatastore(img_dir);
img_data = readall(imds);

%初始化数据
ann_data = struct('imageFilename',{},'person',[]);

%读取xml
for i = 1:numel(img_data)
    %读取xml
    filePath = fullfile(xml_dir,imds.Files{i}(end-9:end-3)+"xml");
    xmls = xmlread(filePath);
    %获取xml中的所有object
    objects = xmls.getElementsByTagName('object');
    %初始化person_data
    person_data = struct('bndbox', {});
    %遍历所有object
    for k = 0:objects.getLength-1
        object = objects.item(k);
        %检查object的name是否为person
        name = object.getElementsByTagName('name').item(0).getFirstChild.getData;
        if strcmp(name, 'person')
            %获取bndbox
            bndbox = object.getElementsByTagName('bndbox');
            %获取xmin
            xmin = str2double(bndbox.item(0).getElementsByTagName('xmin').item(0).getFirstChild.getData);
            %获取ymin
            ymin = str2double(bndbox.item(0).getElementsByTagName('ymin').item(0).getFirstChild.getData);
            %获取xmax
            xmax = str2double(bndbox.item(0).getElementsByTagName('xmax').item(0).getFirstChild.getData);
            %获取width
            width = xmax - xmin;
            %获取ymax
            ymax = str2double(bndbox.item(0).getElementsByTagName('ymax').item(0).getFirstChild.getData);
            %获取height
            height = ymax - ymin;
            %添加到person_data
            person_data(k+1).bndbox = [xmin, ymin, width, height];
        end
    end
    %添加到ann_data
    ann_data(i).imageFilename = imds.Files{i};
    ann_data(i).person = {person_data.bndbox};
end

%创建table
ann_table = struct2table(ann_data);

%将ann_table.person从1*n cell转换为1*n矩阵
ann_table.person = cellfun(@(x) cell2mat(x), ann_table.person, 'UniformOutput', false);

%将ann_table.person从1*n cell转换为 n * 4矩阵
for i = 1:numel(ann_table.person)
    ann_table.person{i} = reshape(ann_table.person{i}, [4, numel(ann_table.person{i})/4])';
end