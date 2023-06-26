require 'concurrent'
require 'json'
require 'terminal-table'
require 'colorize'

TIMES = {seconds: 1000.0, minutes: 60.0, hours: 60.0, days: 24.0, months: (365.25 / 12), years: 12.0}
MASTERY = {gold: 100, plat: 200, poly: 300, orion: 400}
THREADS = 16
JSON_PATH = 'weapons.json'
# JSON_PATH = 'weapons_small.json'
TESSDATA_PATH = './tessdata/'

def run_ahk
  `/mnt/c/Program\\ Files/AutoHotkey/v2/AutoHotkey.exe gather_screenshots.ahk`
end

def main
  gun_map = Hash.new { |hsh, key| hsh[key] = Hash.new {|h, k| h[k] = {}}}

  pool = Concurrent::FixedThreadPool.new(THREADS)

  gun_images = Dir.glob('./runs/**/*.png', File::FNM_DOTMATCH).reject do |img|
    img.end_with?('full.png') || img.end_with?('_processed.png') || img.end_with?('test.png') || img.include?('/flat/')
  end
  done_count = 0
  gun_images.each do |img|
    pool.post do
      gun_class_name = File.basename(File.dirname(File.dirname(img)))
      gun_name = File.basename(File.dirname(img))
      mastery = File.basename(img, ".png").to_sym
      processed_img = File.dirname(img) + "/" + File.basename(img, File.extname(img)) + "_processed" + File.extname(img)

      progress = ''
      number_colors = `convert '#{img}' -fuzz 5% -fill black -draw 'color 0,0 floodfill' -unique-colors -depth 8 txt:-`.split("\n").size - 1
      if number_colors != 1
        `convert '#{img}' -monochrome -channel RGB -negate '#{processed_img}'` unless File.exist?(processed_img)
        progress = normalize_progress(`TESSDATA_PREFIX=#{TESSDATA_PATH} tesseract --psm 6 -c load_number_dawg=1 -c tessedit_char_whitelist=0123456789/ '#{processed_img}' stdout`, gun_class_name, gun_name, mastery)
      end
      gun_map[gun_class_name][gun_name][mastery] = calc_progress(progress)

      done_count += 1
      print("\rAnalysing gun #{done_count / 4} / #{gun_images.size / 4}")
    end
  end

  pool.shutdown
  pool.wait_for_termination
  puts ""

  print_gun_map(gun_map)
end

def normalize_progress(progress, gun_class_name, gun_name, mastery)
  progress = progress.strip
  progress = progress.chomp("/#{MASTERY[mastery]}")
  if progress.end_with?("7#{MASTERY[mastery]}")
    old_progress = progress
    progress = progress.chomp("7#{MASTERY[mastery]}") # sometimes / is misread as 7
    puts "\r#{gun_class_name}/#{gun_name}: '/' misread as '7' '#{old_progress}' -> '#{progress}'".light_yellow
  end
  progress
end

def calc_progress(str)
  str.empty? ? :complete : str.to_i
end

def load_json(path)
  JSON.load_file(path).map do |klass, guns|
    [klass, WeaponClass.new(klass, guns)]
  end.to_h
end

def print_gun_map(gun_map)
  json = JSON.load_file(JSON_PATH)
  rows = []
  totals = {gold: 0, plat: 0, poly: 0, orion: 0}
  total_guns = 0
  total_kills = 0
  max_kills = 0

  json.each do |weapon_class, guns|
    weapon_class_totals = {gold: 0, plat: 0, poly: 0, orion: 0}
    weapon_class_total_guns = 0
    guns.each do |gun_name|
      masteries = gun_map[weapon_class][gun_name]
      weapon_class_total_guns += 1

      row = ["  " + gun_name, print_row(masteries, :gold, weapon_class_totals), print_row(masteries, :plat, weapon_class_totals), print_row(masteries, :poly, weapon_class_totals), print_row(masteries, :orion, weapon_class_totals)]
      rows << row
      max_kills += 1_000
      total_kills += sum_kills(masteries)
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

  puts "total kill progress: #{human_number(total_kills)} / #{human_number(max_kills)} (#{(total_kills * 100.0 / max_kills).round(3)}%)"
  puts
end

def sum_kills(masteries)
  masteries.map do |camo, kills|
    kills == :complete ? MASTERY[camo] : kills
  end.sum
end

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

def human_number(number)
  number.to_s.chars.to_a.reverse.each_slice(3).map(&:join).join(",").reverse
end

start = Time.now
run_ahk
middle = Time.now
puts "took #{human_duration (middle - start) * 1000, 1} to gather screenshots"
main
finish = Time.now
puts "took #{human_duration (finish - middle) * 1000, 1} to aggregate"
puts "took #{human_duration (finish - start) * 1000, 1} in total"
