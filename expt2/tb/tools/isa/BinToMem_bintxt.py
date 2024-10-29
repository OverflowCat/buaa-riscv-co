import sys
import os

infile_path  = "./rv32ui-p-add.bin"
outfile_path = "./rv32ui-p-add.txt"

def bin_to_mem(infile, outfile):
    binfile = open(infile, 'rb')
    binfile_content = binfile.read(os.path.getsize(infile))
    datafile = open(outfile, 'w')

    index = 0
    b0 = 0
    b1 = 0
    b2 = 0
    b3 = 0

    for b in  binfile_content:
        if index == 0:
            b0 = b
            index = index + 1
        elif index == 1:
            b1 = b
            index = index + 1
        elif index == 2:
            b2 = b
            index = index + 1
        elif index == 3:
            b3 = b
            index = 0
            array = []
            array.append(b3)
            array.append(b2)
            array.append(b1)
            array.append(b0)
            datafile.write(bytearray(array).hex() + '\n')

    binfile.close()
    datafile.close()

def bin_to_txt(infile, outfile):
    binfile = open(infile, 'rb')
    binfile_content = binfile.read(os.path.getsize(infile))
    datafile = open(outfile, 'w')

    index = 0
    b0 = 0
    b1 = 0
    b2 = 0
    b3 = 0
    bin_str = ''
    for b in  binfile_content:
        if index == 0:
            b0 = b
            index = index + 1
        elif index == 1:
            b1 = b
            index = index + 1
        elif index == 2:
            b2 = b
            index = index + 1
        elif index == 3:
            b3 = b
            index = 0
            bin_str = bin(b3)[2:].zfill(8) + bin(b2)[2:].zfill(8) + bin(b1)[2:].zfill(8) + bin(b0)[2:].zfill(8)
            datafile.write(bin_str + "\n")

    binfile.close()
    datafile.close()

# bin_to_mem(infile_path, outfile_path)
# bin_to_txt(infile_path, outfile_path)

if __name__ == '__main__':
    if len(sys.argv) == 3:
        # bin_to_mem(sys.argv[1], sys.argv[2])
        bin_to_txt(sys.argv[1], sys.argv[2])
    else:
        print('Usage: %s binfile datafile' % sys.argv[0], sys.argv[1], sys.argv[2])
