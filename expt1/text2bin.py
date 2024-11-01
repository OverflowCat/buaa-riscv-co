def text_to_binary_file(input_text_file, output_binary_file):
    with open(input_text_file, 'r', encoding="ascii") as txt_file, open(output_binary_file, 'wb') as bin_file:
        for line in txt_file:
            # 移除换行符并检查是否是32位
            binary_str = line.strip()
            if len(binary_str) == 32 and all(c in '01' for c in binary_str):
                # 将文本二进制字符串转换为整数，再转换为4字节（32位）二进制
                binary_data = int(binary_str, 2).to_bytes(4, byteorder='big')
                # 写入到二进制文件
                bin_file.write(binary_data)
            else:
                print(f"Skipping invalid line: {line}")

import os
curr_pth = os.getcwd()
dat = os.path.join(curr_pth, "cpu_core_test/code_b.dat")
text_to_binary_file(dat, "output.bin")
