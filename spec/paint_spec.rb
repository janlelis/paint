require File.dirname(__FILE__) + '/spec_helper'

describe 'Paint.[]' do
  before do
    Paint.mode = 256
  end

  context '(with no options)' do
    it "doesn't colorize at all" do
      Paint['J-_-L'].should == "J-_-L"
    end
  end

  context '(with one color)' do
    it 'understands a simple symbol color and use it as foreground color' do
      Paint['J-_-L', :yellow].should == "\e[33mJ-_-L\e[0m"
    end

    it 'understands an array as rgb color definition and use it as foreground color' do
      Paint['J-_-L', [255, 200, 0]].should == "\e[38;5;220mJ-_-L\e[0m"
    end

    it 'understands a hex string (with #, 6 digits) as rgb color definition and use it as foreground color' do
      Paint['J-_-L', "#123456"].should == "\e[38;5;24mJ-_-L\e[0m"
    end

    it 'understands a hex string (no #, 6 digits) as rgb color definition and use it as foreground color' do
      Paint['J-_-L', "123456"].should == "\e[38;5;24mJ-_-L\e[0m"
    end

    it 'understands a hex string (with #, 3 digits) as rgb color definition and use it as foreground color' do
      Paint['J-_-L', "#fff"].should == "\e[38;5;255mJ-_-L\e[0m"
    end

    it 'understands a hex string (no #, 3 digits) as rgb color definition and use it as foreground color' do
      Paint['J-_-L', "fff"].should == "\e[38;5;255mJ-_-L\e[0m"
    end

    it 'understands a hex string (with uppercased letters) as rgb color definition and use it as foreground color' do
      Paint['J-_-L', "#4183C4"].should == "\e[38;5;74mJ-_-L\e[0m"
    end

    it 'understands a non-hex string as rgb color name (rgb.txt) and use it as foreground color' do
      Paint['J-_-L', "medium purple"].should == "\e[38;5;141mJ-_-L\e[0m"
    end

    it 'colorizes using a random ansi foreground color' do
      Paint['J-_-L', :random].should =~ /\e\[3\dmJ-_-L\e\[0m/
    end

    it 'does not cache randomness' do
      (0..99).map{ Paint['J-_-L', :random] }.uniq.size.should > 1
    end
  end

  context '(with two colors)' do
    it 'interprets the first color as foreground color and the second one as background color' do
      Paint['J-_-L', :yellow, :red].should == "\e[33;41mJ-_-L\e[0m"
    end

    it 'interprets the first color as foreground color and the second one as background color (rgb)' do
      Paint['J-_-L', '#424242', [42, 142, 242]].should == "\e[38;5;238;48;5;39mJ-_-L\e[0m"
    end

    it 'sets only a background color, if first color is nil' do
      Paint['J-_-L', nil, [42, 142, 242]].should == "\e[48;5;39mJ-_-L\e[0m"
    end
  end

  context '(with effects)' do
    it 'passes effects' do
      Paint['J-_-L', :bright].should == "\e[1mJ-_-L\e[0m"
    end

    it 'passes effects, mixed with colors' do
      Paint['J-_-L', :yellow, :bright].should == "\e[33;1mJ-_-L\e[0m"
    end

    it 'passes effects, mixed with colors, order does not matter' do
      Paint['J-_-L', :bright, :yellow].should == "\e[1;33mJ-_-L\e[0m"
    end

    it 'passes multiple effects' do
      Paint['J-_-L', :yellow, :red, :bright, :underline, :inverse].should == "\e[33;41;1;4;7mJ-_-L\e[0m"
    end
  end

  context '(with plain integers)' do
    it 'passes integers to final escape sequence' do
      Paint['J-_-L', 31, 1, 42].should == "\e[31;1;42mJ-_-L\e[0m"
    end

    it 'passes integers to final escape sequence (mixed with normal arguments)' do
      Paint['J-_-L', :red, :bright, 42, :underline].should == "\e[31;1;42;4mJ-_-L\e[0m"
    end
  end
end
