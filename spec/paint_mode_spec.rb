# frozen_string_literal: true

require File.dirname(__FILE__) + '/spec_helper'

describe 'Paint.mode' do
  it "works with full color set if mode is 0xFFFFFF (16777215)" do
    Paint.mode = 0xFFFFFF
    Paint['J-_-L', 'gold'].should == "\e[38;2;255;215;0mJ-_-L\e[0m"
  end

  it "converts to a close color from the 256 colors palette if mode is 256" do
    Paint.mode = 256
    Paint['J-_-L', 'gold'].should == "\e[38;5;226mJ-_-L\e[0m"
  end

  it "only uses the 8 ansi colors with bright effect if mode is 16" do
    Paint.mode = 16
    Paint['J-_-L', 'gold'].should == "\e[33;1mJ-_-L\e[0m"
  end

  it "only uses the 8 ansi colors if mode is 8" do
    Paint.mode = 8
    Paint['J-_-L', 'gold'].should == "\e[33mJ-_-L\e[0m"
  end

  it "doesn't colorize anything if mode is 0" do
    Paint.mode = 0
    Paint['J-_-L', 'gold'].should == "J-_-L"
  end
end

describe 'Paint.detect_mode' do
  it 'does not colorize when NO_COLOR environment variable is set' do
    ENV['NO_COLOR'] = ''
    Paint.detect_mode.should == 0
  end
end
