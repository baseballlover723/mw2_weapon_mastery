require 'concurrent'
require 'json'
require 'terminal-table'
require 'colorize'

TIMES = {seconds: 1000.0, minutes: 60.0, hours: 60.0, days: 24.0, months: (365.25 / 12), years: 12.0}
# JSON_PATH = 'weapons.json'
JSON_PATH = 'weapons_small.json'

class WeaponClass
  def initialize(name, gun_names)
    @name = name
    @guns = {}
    gun_names.each do |gun_name|
      @guns[gun_name] = Gun.new(gun_name)
    end
  end

  def [](name)
    @guns[name]
  end
end

class Gun
  def initialize(name)
    @name = name
    @masteries = {}
  end

  def [](name)
    @masteries[name]
  end

  def []=(name, value)
    if value.empty?
      @masteries[name] = :complete
    else
      @masteries[name] = value.to_i
    end
  end
end

def run_ahk
  `/mnt/c/Program\\ Files/AutoHotkey/v2/AutoHotkey.exe gather_screenshots.ahk`
end

def load_json(path)
  JSON.load_file(path).map do |klass, guns|
    [klass, WeaponClass.new(klass, guns)]
  end.to_h
end

def main
  # gun_map = load_json(JSON_PATH)
  gun_map = Hash.new { |hsh, key| hsh[key] = Hash.new {|h, k| h[k] = {}}}

  pool = Concurrent::FixedThreadPool.new(16)
  # pool = Concurrent::FixedThreadPool.new(1)
  # Dir.glob('./runs/flat/*.png', File::FNM_DOTMATCH).each do |img|
  #   pool.post do
  #     # `convert '#{img}' -monochrome -channel RGB -negate '#{img}'`
  #
  #     # puts "tesseract --psm 6 -c load_number_dawg=1 -c tessedit_char_whitelist=0123456789/\\|\\\\ '#{img}' stdout"
  #     progress = `tesseract --psm 6 -c load_number_dawg=1 -c tessedit_char_whitelist=0123456789/\\|\\\\ '#{img}' stdout`.strip
  #     # puts "#{File.basename(img)}: #{progress} (#{progress.empty?})"# if img.include?('flat')
  #
  #     gun_class_name = File.basename(File.dirname(File.dirname(img)))
  #     gun_name = File.basename(File.dirname(img))
  #     mastery = File.basename(img, ".png").to_sym
  #     puts "#{gun_class_name}: #{gun_name}: #{mastery}: #{progress}"
  #     # gun_map[gun_class_name][gun_name][mastery] = calc_progress(progress)
  #   end
  # end

  Dir.glob('./runs/**/*.png', File::FNM_DOTMATCH).reject do |img|
  # Dir["./runs/**/*.png"].reject do |img|
    img.end_with?('full.png') || img.end_with?('test.png') || img.include?('/flat/')
  end.to_a.each do |img|
    pool.post do
      # puts "img: #{img}"
      # width = `identify -format "%w" '#{img}'`.to_i
      # puts "width: #{width}"
      # new_img = img[0..-5] + "_test.png"
      # puts "cmd: #{"convert '#{img}' -resize #{width * 5} '#{new_img}'"}"
      # `convert '#{img}' -resize #{width * 5} '#{img}'`
      # `convert '#{img}' -resize #{width * 5} -bordercolor White -border 10x10 '#{img}'`
      # `convert '#{img}' -scale 500% -bordercolor White -border 10x10 '#{img}'`
      # `convert '#{img}' -magnify -magnify -magnify -bordercolor White -border 10x10 '#{img}'`
      # `convert '#{img}' -adaptive-resize 500% -bordercolor White -border 10x10 '#{img}'`
      # `convert '#{img}' -scale 500% -resample 600 -bordercolor White -border 10x10 '#{img}'`
      # `convert '#{img}' -density 600 -bordercolor White -border 10x10 '#{img}'`
      # `convert '#{img}' -threshold 75% '#{img}'`
      # `convert '#{img}' -monochrome '#{img}'`

      # puts "convert '#{img}' -monochrome -channel RGB -negate '#{img}'" if img.include? "Handgun"
      `convert '#{img}' -monochrome -channel RGB -negate '#{img}'`
      # `convert '#{img}' -scale 500% -monochrome -channel RGB -negate '#{img}'`
      # `convert '#{img}' -magnify -magnify -magnify -monochrome -channel RGB -negate '#{img}'`
      # `convert '#{img}' -magnify -magnify -magnify -channel RGB -negate -monochrome '#{img}'`
      # `convert '#{img}' -monochrome -magnify -magnify -magnify -channel RGB -negate '#{img}'`

      # `convert '#{img}' -monochrome -channel RGB -negate -bordercolor White -border 10x10 '#{img}'`
      # `convert '#{img}' -monochrome -channel RGB -negate -gaussian-blur 1x1 '#{img}'`
      # `convert '#{img}' -monochrome -channel RGB -negate -gaussian-blur 0x1 '#{img}'`
      # `convert '#{img}' -monochrome -channel RGB -negate -gaussian-blur 0x2 '#{img}'`

      # `convert '#{img}' -monochrome -channel RGB -negate -morphology Smooth Octagon:1 '#{img}'`


      # progress = `tesseract '#{img}' stdout`.strip
      # progress = `tesseract -c tessedit_char_whitelist=0123456789/ '#{img}' stdout`.strip
      # progress = `tesseract -c load_number_dawg=1 '#{img}' stdout`.strip
      # progress = `tesseract --psm 13 -c load_number_dawg=1 -c tessedit_char_whitelist=0123456789/ '#{img}' stdout`.strip
      # progress = `tesseract --psm 6 -c load_number_dawg=1 -c tessedit_char_whitelist=0123456789/ '#{img}' stdout`.strip
      # progress = `tesseract --psm 6 -c load_number_dawg=1 -c tessedit_char_whitelist=0123456789/\\|\\\\l '#{img}' stdout`.strip
      # progress = `tesseract --psm 6 -c load_number_dawg=1 -c tessedit_char_whitelist=0123456789/\\|\\\\l -c hocr_char_boxes=1 '#{img}' stdout tsv`.strip
      # progress = `tesseract --psm 6 -c load_number_dawg=1 -c tessedit_char_whitelist=0123456789/\\|\\\\lI -c hocr_char_boxes=1 '#{img}' stdout hcr`.strip
      # puts progress

      # progress = `tesseract --psm 6 -c load_number_dawg=1 -c tessedit_char_whitelist=0123456789/ '#{img}' stdout`.strip
      # progress = `tesseract --psm 6 -c load_number_dawg=1 -c tessedit_char_whitelist=0123456789/\\|\\\\ '#{img}' stdout`.strip
      # progress = `tesseract --psm 6 -c load_system_dawg=0 -c tessedit_char_whitelist=0123456789/ '#{img}' stdout`
      # progress = `tesseract -c load_system_dawg=0 -c load_freq_dawg=0 -c load_unambig_dawg=0 -c load_bigram_dawg=0 -c tessedit_char_whitelist=0123456789/ '#{img}' stdout`
      # puts "#{File.basename(img)}: #{progress} (#{progress.empty?})"# if img.include?('flat')

      progress = `TESSDATA_PREFIX=~/tessdata/ tesseract --psm 6 -c load_number_dawg=1 -c tessedit_char_whitelist=0123456789/ '#{img}' stdout`.strip
      # progress = `TESSDATA_PREFIX=~/tessdata/ tesseract --oem 0 --psm 6 -c load_number_dawg=1 -c tessedit_char_whitelist=0123456789/ '#{img}' stdout`.strip

      gun_class_name = File.basename(File.dirname(File.dirname(img)))
      gun_name = File.basename(File.dirname(img))
      mastery = File.basename(img, ".png").to_sym
      # puts "#{gun_class_name}: #{gun_name}: #{mastery}: #{progress}"
      gun_map[gun_class_name][gun_name][mastery] = calc_progress(progress)
    end
  end

  pool.shutdown
  pool.wait_for_termination

  print_gun_map(gun_map)
end

def calc_progress(str)
  str.empty? ? :complete : str.to_i
end

def print_gun_map(gun_map)
  json = JSON.load_file(JSON_PATH)
  rows = []
  totals = {gold: 0, plat: 0, poly: 0, orion: 0}
  total_guns = 0

  json.each do |weapon_class, guns|
    weapon_class_totals = {gold: 0, plat: 0, poly: 0, orion: 0}
    weapon_class_total_guns = 0
    guns.each do |gun_name|
      masteries = gun_map[weapon_class][gun_name]
      weapon_class_total_guns += 1

      row = ["  " + gun_name, print_row(masteries, :gold, weapon_class_totals), print_row(masteries, :plat, weapon_class_totals), print_row(masteries, :poly, weapon_class_totals), print_row(masteries, :orion, weapon_class_totals)]
      rows << row
    end
    rows.insert(-weapon_class_total_guns - 1, print_weapon_class(weapon_class, weapon_class_totals, weapon_class_total_guns))

    totals[:gold] += weapon_class_totals[:gold]
    totals[:plat] += weapon_class_totals[:plat]
    totals[:poly] += weapon_class_totals[:poly]
    totals[:orion] += weapon_class_totals[:orion]
    total_guns += weapon_class_total_guns
    rows << :separator
  end
  rows.pop
  rows.unshift(:separator)
  rows.unshift(print_weapon_class("Total", totals, total_guns))

  table = Terminal::Table.new(rows: rows, headings: ['Name', 'Gold', 'Platinum', 'Polyatomic', 'Orion'])
  puts table
end

MASTERY = {gold: 100, plat: 200, poly: 300, orion: 400}

def print_row(masteries, mastery, weapon_class_totals)
  if masteries[mastery] == :complete
    weapon_class_totals[mastery] += 1
    print_fraction(MASTERY[mastery], MASTERY[mastery])
  else
    print_fraction(masteries[mastery], MASTERY[mastery])
  end
end

def print_weapon_class(weapon_class, weapon_class_totals, weapon_class_total_guns)
  [weapon_class, print_fraction(weapon_class_totals[:gold], weapon_class_total_guns), print_fraction(weapon_class_totals[:plat], weapon_class_total_guns), print_fraction(weapon_class_totals[:poly], weapon_class_total_guns), print_fraction(weapon_class_totals[:orion], weapon_class_total_guns)]
end

def print_fraction(complete, total)
  color = complete == total ? :light_green : complete != 0 ? :light_yellow : :light_red
  "#{complete}/#{total}".send(color)
end

def human_duration(ms, threshhold)
  prev_string = "#{ms} milliseconds"
  prev_value = ms
  TIMES.each do |unit, multi|
    return prev_string if prev_value.abs / multi < threshhold
    prev_value /= multi
    prev_string = "#{prev_value.round 2} #{unit}"
  end
  prev_string
end

start = Time.now
run_ahk
middle = Time.now
puts "took #{human_duration (middle - start) * 1000, 1} to gather screenshots"
main
finish = Time.now
puts "took #{human_duration (finish - middle) * 1000, 1} to aggregate"
puts "took #{human_duration (finish - start) * 1000, 1} in total"
