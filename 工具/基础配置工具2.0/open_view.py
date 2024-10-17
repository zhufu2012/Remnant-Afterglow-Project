import win32api
##打开xlsx表格
def openexcel(path):
    # 启动WPS应用程序
    win32api.ShellExecute(0, 'open', r"wps.exe", f"\""+path+"\"",'cfg_ConfigCall_配置调用关系表',1)


