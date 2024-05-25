import os
import xml.etree.ElementTree as ET
import shutil

# VOC2007数据集的路径
voc_dir = 'D:\\Downloads\\VOCtrainval_06-Nov-2007\\VOCdevkit\\VOC2007'
# 新文件夹的路径
new_dir = 'D:\\Downloads\\VOCtrainval_06-Nov-2007\\VOCdevkit\\VOC2007\\Person'
xml_dir = 'D:\\Downloads\\VOCtrainval_06-Nov-2007\\VOCdevkit\\VOC2007\\xmls'
# 创建新文件夹
os.makedirs(new_dir, exist_ok=True)
os.makedirs(xml_dir, exist_ok=True)

# 遍历VOC2007中的所有XML文件
for xml_file in os.listdir(os.path.join(voc_dir, 'Annotations')):
    tree = ET.parse(os.path.join(voc_dir, 'Annotations', xml_file))
    root = tree.getroot()

    # 检查是否存在'person'标签
    for obj in root.iter('object'):
        if obj.find('name').text == 'person':
            # 如果存在，则复制对应的图像文件到新文件夹
            img_file = xml_file.replace('.xml', '.jpg')
            shutil.copy(os.path.join(voc_dir, 'JPEGImages', img_file), os.path.join(new_dir, img_file))
            shutil.copy(os.path.join(voc_dir, 'Annotations', xml_file), os.path.join(xml_dir, xml_file))
            break