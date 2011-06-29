describe 'Paint.color' do
  it 'only returns a the color escape sequnce and is directly used by Paint.[] with all paramenters except the first; see there fore specs' do end
end

describe 'Paint.simple' do
  it 'returns ansi code number for one of the eight ansi base colors' do
    Paint.simple(:red).should == 31
  end

  it 'returns background ansi code number for one of the eight ansi base colors if second parameter is true' do
    Paint.simple(:red, true).should == 41
  end
end

describe 'Paint.rgb' do
  it 'returns ansi code sequence for one of 256 colors' do
    Paint.rgb(1,2,3).should == '38;5;16'
  end

  it 'returns background ansi code sequence for one of 256 colors if last parameter is true' do
    Paint.rgb(1, 2, 3, true).should == '48;5;16'
  end
end

describe 'Paint.hex' do
  it 'returns ansi code sequence for one of 256 colors' do
    Paint.hex("#fff").should == "38;5;231"
  end

  it 'returns background ansi code sequence for one of 256 colors if second parameter is true' do
    Paint.hex("123456", true).should == "48;5;24"
  end
end

describe 'Paint.name' do
  it 'returns ansi code sequence for one of 256 colors' do
    Paint.name("gold").should == "38;5;226"
  end

  it 'returns background ansi code sequence for one of 256 colors if second parameter is true' do
    Paint.name("gold", true).should == "48;5;226"
  end
end

describe 'Paint.random' do
  it 'returns ansi code for one of the eight ansi base colors' do
    (30...38) === Paint.random.should
  end
end

describe 'Paint.effect' do
  it 'returns ansi code for effect using EFFECTS hash' do
    Paint.effect(:bright).should == 1
  end
end

describe 'Paint.wrap' do
  it 'wraps an ansi color code (array of integers) into an ansi escape sequence' do
    Paint.wrap(31, 1).should == "\e[31;1m"
  end
end

# util.rb

describe 'Paint.unpaint' do
  it 'removes any ansi color escape sequences in the string' do
    Paint.unpaint( Paint['J-_-L', :red, :bright] ).should == 'J-_-L'
  end
end

describe 'Paint.rainbow' do
  it 'prints all available 256 colors' do end
end

describe 'Paint.update_rgb_colors' do
  it 'updates the Paint::RGB_COLORS hash using rgb.txt (takes path to it as argument' do end
end
