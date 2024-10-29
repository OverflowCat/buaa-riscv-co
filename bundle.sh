# 每5秒打包 **/*.v（但排除 **/tb_*.*v） 到 bundle.zip，不保留目录结构
while true; do
    find . -type f -name "*.v" ! -name "*tb*.v" -exec zip -j -r bundle.zip {} +;
    sleep 5;
done
