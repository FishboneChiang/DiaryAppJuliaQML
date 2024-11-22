using QML
using JSON3
using DataFrames
using Dates

function complete_datetime(date_string)
	# Define a list of possible formats in order of complexity
	formats = [
		"yyyy-mm-dd HH:MM:SS",
		"yyyy-mm-dd HH:MM",
		"yyyy-mm-dd",
		"yyyy-mm",
		"yyyy"
	]

	# Try parsing with each format
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

mutable struct diaryEntry
	entryTitle::String
	entryDate::String
	entryContent::String
end

function newEntry(title, date, content)
	global diaryEntries
    date = complete_datetime(date)
	pushfirst!(diaryEntries, diaryEntry(title, date, content))
	save_to_json()
end
@qmlfunction newEntry

function editEntry(index, title, date, content)
	global diaryEntries
    date = complete_datetime(date)
	diaryEntries[index+1] = diaryEntry(title, date, content)
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

function sort_entries_with_time()
	global diaryEntries
	sort!(diaryEntries, by = x -> x.entryDate, rev = true)
end

function save_to_json()
	global diaryEntries
	global diary_file_path
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

# default path for diary data
diary_settings_path = homedir() * "/.diary_app_settings.json"
diary_file_path = joinpath(@__DIR__, "diary_app_data.json")
# check if file exists
if !isfile(diary_file_path)
	open(diary_file_path, "w") do io
		JSON3.write(io, [])
	end
else
	# check if json file is empty
	if filesize(diary_file_path) == 0
		open(diary_file_path, "w") do io
			JSON3.write(io, [])
		end
	end
end
diaryEntries = load_from_json()
# diaryEntries = [
#     diaryEntry("title"*string(i), "date", "content1...")
#     for i in 1:5
# ]
# println(diaryEntries)

qml_file_path = joinpath(@__DIR__, "main.qml")

loadqml(qml_file_path)

exec()
