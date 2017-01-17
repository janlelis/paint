require File.dirname(__FILE__) + '/spec_helper'

describe 'Paint.color' do
  it 'only returns a the color escape sequence and is directly used by Paint.[] with all paramenters except the first; see there for specs' do end
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
  context '(256 colors)' do
    before do
      Paint.mode = 256
    end

    it 'returns ANSI code sequence for one of 256 colors' do
      Paint.rgb(1, 2, 3).should == '38;5;232'
    end

    it 'returns background ANSI code sequence for one of 256 colors if last parameter is true' do
      Paint.rgb(1, 2, 3, true).should == '48;5;232'
    end
  end

  context '(true colors)' do
    before do
      Paint.mode = 0xFFFFFF
    end

    it 'returns truecolor ANSI code sequence' do
      Paint.rgb(1, 2, 3).should == '38;2;1;2;3'
    end

    it 'returns truecolor background ANSI code sequence if last parameter is true' do
      Paint.rgb(1, 2, 3, true).should == '48;2;1;2;3'
    end
  end
end

describe 'Paint.rgb_hex' do
  before do
    Paint.mode = 256
  end

  it 'returns ansi code sequence for one of 256 colors' do
    Paint.rgb_hex("fff").should == "38;5;255"
  end

  it 'returns background ansi code sequence for one of 256 colors if second parameter is true' do
    Paint.rgb_hex("123456", true).should == "48;5;24"
  end
end

describe 'Paint.rgb_name' do
  before do
    Paint.mode = 256
  end

  it 'returns ansi code sequence for one of 256 colors' do
    Paint.rgb_name("gold").should == "38;5;226"
  end

  it 'returns background ansi code sequence for one of 256 colors if second parameter is true' do
    Paint.rgb_name("gold", true).should == "48;5;226"
  end

  it 'returns ansi code sequence for the names color colour220' do
    Paint.rgb_name("colour220").should == "38;5;226"
  end

  it 'returns background ansi code sequence for named color colour232 if second parameter is true' do
    Paint.rgb_name("colour232", true).should == "48;5;233"
  end

  it 'handled zero padded colour-names correctly' do
    Paint.rgb_name("colour16").should == Paint.rgb_name("colour016")
    Paint.rgb_name("colour2").should == Paint.rgb_name("colour002")
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
  it 'updates the Paint::RGB_COLORS hash using rgb.txt (takes path to it as argument)' do end
end
