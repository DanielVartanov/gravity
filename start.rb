#!/usr/bin/env ruby

require "bundler"
Bundler.require(:default)

require_relative 'logic'
require_relative 'graphics'

Rubygame.init

event_queue = Rubygame::EventQueue.new
event_queue.enable_new_style_events

clock = Rubygame::Clock.new
clock.target_framerate = 10
clock.calibrate
clock.enable_tick_events

maximum_resolution = Rubygame::Screen.get_resolution

screen = Rubygame::Screen.new [1280, 800], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
screen.title = "Gravity"

world = Gravity::World.new
graphics = Gravity::Graphics.new screen, world

TIME_QUANTUM_LENGTH = 1e-4

def split_into_time_quantums(seconds_passed)
  time_quantums = [TIME_QUANTUM_LENGTH] * (seconds_passed.to_f / TIME_QUANTUM_LENGTH).to_i
  time_quantums << seconds_passed.to_f % TIME_QUANTUM_LENGTH
  time_quantums
end

loop do
  event_queue.each do |event|
    case event
    when Rubygame::Events::QuitRequested
      Rubygame.quit
      exit
    end
  end

  seconds_passed = clock.tick.seconds
  time_quantums = split_into_time_quantums(seconds_passed)
  time_quantums.each do |time_quantum|
    world.update! time_quantum
  end

  screen.fill(:black)
  graphics.draw!
  screen.flip
end
