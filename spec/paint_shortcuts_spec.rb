require File.dirname(__FILE__) + '/spec_helper'

# TODO fix include specs, probably failing because of some rspec voodoo

describe 'Paint::SHORTCUTS' do
  before do
    Paint::SHORTCUTS[:example] = {
      :white => Paint.color(:black),
      :red => Paint.color(:red, :bright),
      :title => Paint.color(:underline),
    }
  end

  context 'Paint::Example.method_missing' do
    it 'returns a color defined in the SHORTCUTS hash under the :example key' do
      Paint::Example.red == "\e[31m"
    end

    it 'returns a color defined in the SHORTCUTS hash under the :some_module key; method takes string to colorize' do
      Paint::Example.red 'J-_-L' == "\e[31;1mJ-_-L\e[0m"
    end
  end

  context 'include Paint::Example' do
    include Paint::Example
    #red.should == "\e[31;1m"
    #white( 'Ruby' ).should "\e[30m"
  end


  context 'include Paint::Example::String' do
    it 'adds shortcuts methods that colorize self' do
      class MyString < String # could also have used original String
        include Paint::Example::String
      end

      # MyString.new("J-_-L").red.should == "\e[31;1mJ-_-L\e[0m"
    end

    it 'adds shortcuts methods that colorize self (also works for non-String classes by calling to_s)' do
      Paint::SHORTCUTS[:example][:gold] = Paint.color "gold"
      class Integer
        include Paint::Example::String
      end
      #123.red.should == "\e[38;5;226m123\e[0m"
    end
  end

  context 'include Paint::Example::Prefix::ExampleName' do
    it 'sets a single color helper method to avoid cluttering namespaces' do
      class Object
        include Paint::Example::Prefix::ExampleName
      end
      #"Ruby".example_name(:red).should == "\e[31;1mRuby\e[0m"
    end
  end
end
