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
    push!(diaryEntries, diaryEntry(title, date, content))
end
@qmlfunction newEntry

function editEntry(index, title, date, content)
    println("=============edit==============")
    println(index + 1, "\t", title, "\t", date, "\t", content)
    println("===============================")
    global diaryEntries
    setindex!(diaryEntries, 
        diaryEntry(title, date, content), 
        index + 1
    )
end
@qmlfunction editEntry

function deleteEntry(index)
    global diaryEntries
    println("Delete entry at index $index")
    delete!(diaryEntries, index + 1)
end
@qmlfunction deleteEntry

function getEntry(index)
    global diaryEntries
    return [diaryEntries[index+1].entryTitle, diaryEntries[index+1].entryDate, diaryEntries[index+1].entryContent]
end
@qmlfunction getEntry

function save_to_json()
    global diaryEntries
    global diary_file_path
    open(diary_file_path, "w") do io
        JSON3.write(io, values(diaryEntries)[])
    end
end
@qmlfunction save_to_json

function load_from_json()
    global diary_file_path
    open(diary_file_path, "r") do io
        JSON3.read(io, Vector{diaryEntry})
    end
end

# StructTypes.StructType(::Type{diaryEntry}) = StructTypes.Struct()
# default path for diary data
diary_file_path = homedir() * "/.diary_app_data.json"
# check if file exists
if !isfile(diary_file_path)
    open(diary_file_path, "w") do io
        JSON3.write(io, [])
    end
end

diaryEntries = JuliaItemModel(
    load_from_json()
)

qml_file_path = joinpath(@__DIR__, "main.qml")

loadqml(qml_file_path; diaryEntries = diaryEntries)

exec()
