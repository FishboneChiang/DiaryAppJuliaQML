using QML
using JSON3, StructTypes

mutable struct diaryEntry
	entryTitle::String
	entryDate::String
	entryContent::String
end

function newEntry(title, date, content)
    println("===========new entry===========")
    println(title, "\t", date, "\t", content)
    println("===============================")
    global diaryEntries
    pushfirst!(diaryEntries, diaryEntry(title, date, content))
end
@qmlfunction newEntry

function editEntry(index, title, date, content)
    println("=============edit==============")
    println(index + 1, "\t", title, "\t", date, "\t", content)
    println("===============================")
    global diaryEntries
    diaryEntries[index+1] = diaryEntry(title, date, content)
end
@qmlfunction editEntry

function deleteEntry(index)
    global diaryEntries
    println("Delete entry at index $index")
    deleteat!(diaryEntries, index + 1)
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

function save_to_json()
    global diaryEntries
    global diary_file_path
    open(diary_file_path, "w") do io
        JSON3.write(io, diaryEntries)
    end
end
@qmlfunction save_to_json

function load_from_json()
    global diary_file_path
    open(diary_file_path, "r") do io
        JSON3.read(io, Vector{diaryEntry})
    end
end


# default path for diary data
# diary_file_path = homedir() * "/.diary_app_data.json"
diary_file_path = joinpath(@__DIR__, "diary_app_data.json")
# check if file exists
if !isfile(diary_file_path)
    open(diary_file_path, "w") do io
        JSON3.write(io, [])
    end
end
diaryEntries = load_from_json()
diaryEntries = [
    diaryEntry("title"*string(i), "date", "content1...")
    for i in 1:5
]
# println(diaryEntries)

qml_file_path = joinpath(@__DIR__, "main.qml")

loadqml(qml_file_path)

exec()
