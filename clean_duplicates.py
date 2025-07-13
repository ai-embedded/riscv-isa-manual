#!/usr/bin/env python3
import re

def clean_duplicates(input_file, output_file):
    with open(input_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 找到所有的指令节（以==== 开头的）
    sections = []
    current_section = []
    seen_instructions = set()
    
    lines = content.split('\n')
    i = 0
    while i < len(lines):
        line = lines[i]
        
        # 检查是否是新的指令节
        if line.startswith('==== ') and not line.startswith('==== `'):
            # 保存之前的节
            if current_section:
                sections.append('\n'.join(current_section))
            
            # 检查是否是重复的指令
            instruction_match = re.match(r'^==== (\w+)', line)
            if instruction_match:
                instruction_name = instruction_match.group(1)
                if instruction_name in seen_instructions:
                    # 跳过重复的指令节，找到下一个指令节或文件结束
                    i += 1
                    while i < len(lines) and not (lines[i].startswith('==== ') or lines[i].startswith('[[crypto_scalar_')):
                        i += 1
                    continue
                else:
                    seen_instructions.add(instruction_name)
            
            current_section = [line]
        else:
            current_section.append(line)
        
        i += 1
    
    # 保存最后一个节
    if current_section:
        sections.append('\n'.join(current_section))
    
    # 写入清理后的内容
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write('\n'.join(sections))

# 清理文件
clean_duplicates('src_zh/scalar-crypto.adoc', 'src_zh/scalar-crypto-clean.adoc')
print("清理完成")