import json
import shutil
import os


def load_data():
    with open('config.json', 'r', encoding='utf-8') as file:
        data = json.load(file)
    return data


##读取日志数据
def read_log():
    with open('log.txt', 'r', encoding='utf-8') as file:
        return file.read()


def add_log(str):
    with open(r'log.txt', 'a', encoding='utf-8') as test:
        test.write(str + "\n")


##清除文件数据
def close_log():
    with open('log.txt', 'a+', encoding='utf-8') as test:
        test.truncate(0)


##删除文件夹
def delete_folder(path):
    if os.path.exists(path) and os.path.isdir(path):
        shutil.rmtree(path)


##删除文件夹2
def delete_folder2(path, ignore_list):
    for ignore in ignore_list:
        if path.find(ignore) != -1:
            return
        else:
            continue
    if os.path.exists(path) and os.path.isdir(path):
        shutil.rmtree(path)


##删除文件夹下数据
def del_file(path):
    if not os.listdir(path):
        add_log('目录已为空！')
    else:
        for i in os.listdir(path):  ## and not path_file.endswith(".png.import")
            path_file = os.path.join(path, i)  # 取文件绝对路径
            if os.path.isfile(path_file):
                os.remove(path_file)
            else:
                del_file(path_file)
                shutil.rmtree(path_file)


##删除文件夹下文件2
def del_file2(path, ignore_list):
    for i in os.listdir(path):  ## and not path_file.endswith(".png.import")
        path_file = os.path.join(path, i)  # 取文件绝对路径
        for ignore in ignore_list:
            if path_file.find(ignore) != -1:
                return
            else:
                continue
        os.remove(path_file)


##删除一个文件
def del_file_one(path):
    shutil.rmtree(path)


def copy_dir(src_path, target_path):
    if os.path.isdir(src_path) and os.path.isdir(target_path):
        filelist_src = os.listdir(src_path)
        for file in filelist_src:
            path = os.path.join(os.path.abspath(src_path), file)
            if os.path.isdir(path):
                path1 = os.path.join(os.path.abspath(target_path), file)
                if not os.path.exists(path1):
                    os.mkdir(path1)
                copy_dir(path, path1)
            else:
                with open(path, 'rb') as read_stream:
                    contents = read_stream.read()
                    path1 = os.path.join(target_path, file)
                    with open(path1, 'wb') as write_stream:
                        write_stream.write(contents)
        return True

    else:
        return False


def copy_dir2(class_export_path, project_path, ignore_list):
    IsCopyList = []
    pathList = os.listdir(class_export_path)

    for path in pathList:
        p = 0
        for ignore in ignore_list:
            if path.find(ignore) != -1:
                p = 1
                break
            else:
                continue
        if p == 0:
            IsCopyList.append(path)
    for copy_path in IsCopyList:
        shutil.copy2(os.path.join(class_export_path, copy_path), project_path)


##复制数据到对应路径
def copy_config_develop(NowProjectConfig, path_name):
    path_list = NowProjectConfig["复制用路径列表"][path_name]
    root_path = path_list[0]
    # 定义源文件夹和目标文件夹的路径
    src_dir_config = NowProjectConfig["导出配置的存放路径"]
    src_dir_images = NowProjectConfig["导出配置图片的存放路径"]
    src_file = NowProjectConfig["导出配置的索引文件路径"]

    dst_dir_config = root_path + path_list[2]
    dst_dir_images = root_path + path_list[3]
    dst_folder = root_path + path_list[4]
    del_file(root_path + path_list[1])

    # 使用shutil模块中的copytree()方法复制文件夹
    shutil.copytree(src_dir_config, dst_dir_config)
    shutil.copytree(src_dir_images, dst_dir_images)
    shutil.copy2(src_file, dst_folder)
    if(len(path_list)>5):# 说明有多出的需要复制的路径
        otherList = path_list[5:]
        for other_str in otherList:
            config_path = NowProjectConfig["导出的配置基础路径"] + other_str
            other_path = root_path + other_str
            shutil.copytree(config_path,other_path)
        
    

