import os
import pandas as pd

def collect_xlsx_data():
    # 初始化一个空列表用于存储收集到的数据
    data_list = []

    # 获取当前目录
    current_dir = os.getcwd()

    # 遍历当前目录及其子目录下的所有文件
    for root, dirs, files in os.walk(current_dir):
        for file in files:
            # 检查文件是否为.xlsx格式且不是临时文件（以~$开头）
            if file.endswith('.xlsx') and not file.startswith('~$'):
                file_path = os.path.join(root, file)
                relative_path = os.path.relpath(file_path, current_dir)

                try:
                    # 使用pandas读取Excel文件的所有工作表名称
                    xls = pd.ExcelFile(file_path)
                    for sheet_name in xls.sheet_names:
                        if not sheet_name.startswith("cfg_"):  ##开头不是cfg_的表都不算
                            continue
                        # 读取特定工作表并获取A1单元格的值
                        df_sheet = pd.read_excel(xls, sheet_name=sheet_name,usecols="A", nrows=0)  # 只读取第一行
                        first_cell_value = df_sheet.columns[0]
                        
                        # 将数据添加到列表中
                        data_list.append(pd.DataFrame({
                            '表名': [sheet_name],
                            '表描述（每个表 A1 格）': [first_cell_value],
                            '超链接': [f'=HYPERLINK("{relative_path}", "{relative_path}")']
                        }))
                except Exception as e:
                    print(f"无法读取文件 {file_path}: {e}")

# 如果有收集到的数据，则合并所有数据框，并保存到新的Excel文件
    if data_list:
        # 合并所有数据框
        data = pd.concat(data_list, ignore_index=True)

        # 定义输出文件路径和名称
        output_file = os.path.join(current_dir, '汇总表.xlsx')
        
        # 如果输出文件已经存在，则先删除它
        if os.path.exists(output_file):
            os.remove(output_file)

        # 设置ExcelWriter并应用格式
        with pd.ExcelWriter(output_file, engine='xlsxwriter') as writer:
            data.to_excel(writer, index=False, sheet_name='汇总')

            # 获取xlsxwriter的工作簿和工作表对象
            workbook = writer.book
            worksheet = writer.sheets['汇总']

            # 定义自动换行的格式
            wrap_format = workbook.add_format({'text_wrap': True})
            worksheet.set_row(0, 40)
            # 应用格式到第二列（索引从0开始，所以是1）
            worksheet.set_column('A:A', None, wrap_format)  # 第二列
            worksheet.set_column('A:A', 50)  # 设置第二列宽度为50个字符
            worksheet.set_column('B:B', None, wrap_format)  # 第二列
            worksheet.set_column('B:B', 50)  # 设置第二列宽度为50个字符
            worksheet.set_column('C:C', None, wrap_format)  # 第二列
            worksheet.set_column('C:C', 50)  # 设置第二列宽度为50个字符
            # 关闭并保存Excel文件

        print(f"数据已成功保存到 {output_file}")
    else:
        print("没有找到任何符合条件的.xlsx文件")

# 调用函数执行任务
collect_xlsx_data()
input("按任意键退出...")