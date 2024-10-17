import os

def count_lines_in_file(file_path):
    """计算单个文件中的行数"""
    with open(file_path, 'r', encoding='utf-8') as file:
        return sum(1 for line in file)

def count_cs_code_lines(directory):
    """计算指定目录及其子目录下所有.cs文件的代码总行数"""
    total_lines = 0
    # 遍历目录及其子目录
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.cs'):
                file_path = os.path.join(root, file)
                total_lines += count_lines_in_file(file_path)
                print(f"File: {file_path}, Lines: {count_lines_in_file(file_path)}")
    return total_lines

# 使用示例
directory_path = ".\Remnant Afterglow"

total_lines = count_cs_code_lines(directory_path)
print(f"总的代码行数: {total_lines}")
input("暂停！ ")