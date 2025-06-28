import os

def print_md_file_paths(start_path='.'):
    """
    遍历当前文件夹及其子文件夹，打印所有.md文件的相对路径
    
    :param start_path: 起始路径，默认为当前目录
    """
    for root, dirs, files in os.walk(start_path):
        # 获取当前目录相对于起始目录的相对路径
        rel_path = os.path.relpath(root, start=start_path)
        
        for file in files:
            # 检查文件是否以.md结尾
            if file.lower().endswith('.md'):
                # 如果是当前目录下的文件，直接打印文件名
                if rel_path == '.':
                    print(file)
                else:
                    # 否则打印相对路径 + 文件名
                    print(os.path.join(rel_path, file))

if __name__ == "__main__":
    print("当前文件夹及其子文件夹下的所有.md文件路径：")
    print_md_file_paths()