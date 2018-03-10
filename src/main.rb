require 'dxruby'
require_relative 'config'
require_relative 'scene_mgr'
require_relative 'scenes/title/director'
require_relative 'scenes/game/director'
require_relative 'scenes/result/director'
require_relative 'scenes/credit/director'

$DEBUG = false

Window.width = 800
Window.height = 600

SceneMgr.add(Title::Director.new(), :title)
SceneMgr.add(Game::Director.new(), :game)
SceneMgr.add(Result::Director.new(), :result)
SceneMgr.add(Credit::Director.new(), :credit)

SceneMgr.move_to(:title)

Window.loop do
    break if Input.key_push?(K_ESCAPE)
    SceneMgr.play
end
