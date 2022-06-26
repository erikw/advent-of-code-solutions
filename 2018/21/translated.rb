reg1 = 123
while reg1 & 456 != 72
end

reg2 = 65_536
reg1 = 7_470_384

while X
  reg5 = reg2 | 255
  reg1 = ((reg1 + reg5) & 16_777_215) * 65_899 & 16_777_215
  reg5 = 0 if 256 > reg2 # 1: false, 2: true

  loop do
    reg4 = (reg5 + 1) * 256
    break if reg4 > reg2

    reg5 += 1
  end
  reg2 = reg5 = 255
end
