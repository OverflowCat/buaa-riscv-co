// merge.js
const fs = require('fs');
const path = require('path');

// 输出文件
const outputFile = 'build.v';

// 要合并的文件列表
const files = [
  './data_path.v',
  './control.v',
  './instr_rom.v',
  './alu.v',
  '../../expt1/regfile_test/regfile.v',
  './data_ram.v',
  '../../expt1/imm_gen_test/imm_gen.v',
  './core_top.v'  // core_top.v 放在最后，因为它依赖其他模块
];

// 存储已处理的include语句，避免重复
const processedIncludes = new Set();

// 处理文件内容，移除include语句
function processContent(content) {
  const lines = content.split('\n');
  return lines
    .filter(line => !line.trim().startsWith('`include'))
    .join('\n');
}

try {
  let mergedContent = '// Auto-generated file - DO NOT EDIT\n\n';

  // 读取并合并所有文件
  for (const file of files) {
    const filePath = path.resolve(__dirname, file);
    console.log(`Processing ${filePath}`);
    
    try {
      const content = fs.readFileSync(filePath, 'utf8');
      mergedContent += `// File: ${path.basename(file)}\n`;
      mergedContent += processContent(content);
      mergedContent += '\n\n';
    } catch (err) {
      console.error(`Error reading file ${file}:`, err);
    }
  }

  // 写入合并后的文件
  fs.writeFileSync(outputFile, mergedContent);
  console.log(`Successfully merged files into ${outputFile}`);

} catch (err) {
  console.error('Error:', err);
}