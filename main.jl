using QML, JSON3, Dates, JLD2

mutable struct diaryEntry
	entryTitle::String
	entryDate::String
	entryContent::String
end

function complete_datetime(date_string)
	# Define a list of possible formats in order of complexity
	formats = [
		"yyyy-mm-dd HH:MM:SS", "yyyy-mm-dd HH:MM",
		"yyyy-mm-dd", "yyyy-mm", "yyyy",
	]
	# Try parsing with each format
	if date_string == ""
		date_string = Dates.format(Dates.now(), "yyyy-mm-dd HH:MM:SS")
	end
	for fmt in formats
		try
			dt = DateTime(date_string, fmt)
			return Dates.format(dt, "yyyy-mm-dd HH:MM:SS")
		catch
			# Ignore parsing errors and try the next format
		end
	end
	throw(ArgumentError("Invalid date string format: $date_string"))
end

function newEntry(title, date, content)
	global diaryEntries
	# complete date & time
	date = complete_datetime(date)
	# append new entry to the list and sort entries by time (can be optimized)
	pushfirst!(diaryEntries, diaryEntry(title, date, content))
	sort_entries_by_time()
	# save entries to json file
	save_to_json()
end
@qmlfunction newEntry

function editEntry(index, title, date, content)
	global diaryEntries
	# complete date & time
	date = complete_datetime(date)
	# append entry to the list and sort entries by time (can be optimized)
	diaryEntries[index+1] = diaryEntry(title, date, content)
	sort_entries_by_time()
	# save entries to json file
	save_to_json()
end
@qmlfunction editEntry

function deleteEntry(index)
	global diaryEntries
	deleteat!(diaryEntries, index + 1)
	save_to_json()
end
@qmlfunction deleteEntry

function getEntry(index)
	global diaryEntries
	return [diaryEntries[index+1].entryTitle, diaryEntries[index+1].entryDate, diaryEntries[index+1].entryContent]
end
@qmlfunction getEntry

function getNumEntries()
	global diaryEntries
	return length(diaryEntries)
end
@qmlfunction getNumEntries

function sort_entries_by_time()
	global diaryEntries
	sort!(diaryEntries, by = x -> x.entryDate, rev = true)
end

function save_to_json()
	global diaryEntries, diary_file_path
	open(diary_file_path, "w") do io
		JSON3.write(io, diaryEntries)
	end
end

function load_from_json()
	global diary_file_path
	open(diary_file_path, "r") do io
		JSON3.read(io, Vector{diaryEntry})
	end
end

function setDarkMode(dark_mode)
	global settings, diary_settings_path
	settings["dark_mode"] = dark_mode
	save(diary_settings_path, settings)
end
@qmlfunction setDarkMode

function getDarkMode()
	global settings
	return settings["dark_mode"]
end
@qmlfunction getDarkMode

function getDiaryFileDir()
	global settings
	return settings["diary_file_dir"]
end
@qmlfunction getDiaryFileDir

function setDiaryFileDir(path)
	global settings, diary_settings_path
	# convert path to Julia string
	save_path::String = string(path)
	println("New diary save location: ", save_path)
	# update settings and save to file
	settings["diary_file_dir"] = save_path
	save(diary_settings_path, settings)
	# initialize diary entries
	initializeDiary()
end
@qmlfunction setDiaryFileDir

function initializeDiary()
	global diaryEntries, diary_file_path
	# initialize file to save diary app data
	diary_file_path = joinpath(settings["diary_file_dir"], "diary_app_data.json")
	# check if the file exists or is empty
	if !isfile(diary_file_path) || filesize(diary_file_path) == 0
		open(diary_file_path, "w") do io
			JSON3.write(io, [])
		end
	end
	# read diary entries from json file
	diaryEntries = load_from_json()
end

# diary app settings save location
diary_settings_path = joinpath(homedir(), "diary_app_settings.jld2")

# default settings
default_settings = Dict(
	"dark_mode" => true,
	"diary_file_dir" => homedir(),
)
settings = default_settings

# check if settings file exists
if !isfile(diary_settings_path)
	save(diary_settings_path, default_settings)
else
	settings = load(diary_settings_path)
end

# initialize file to save diary app data
diary_file_path = joinpath(settings["diary_file_dir"], "diary_app_data.json")
initializeDiary()

# display diary app information
println()
println("==============Diary App==============")
println("* Settings: ")
println("\t", settings)
println("* Status: ")
println("\tNumber of Entries: ", getNumEntries())
println("=====================================")
println()

# load QML file
qml_file_path = joinpath(@__DIR__, "main.qml")
loadqml(qml_file_path)
exec()
