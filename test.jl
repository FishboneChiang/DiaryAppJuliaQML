using JSON3
using StructTypes

mutable struct diaryEntry
	entryTitle::String
	entryDate::String
	entryContent::String
end

# 寫入 JSON 檔案
function save_to_json(entries, filepath)
    open(filepath, "w") do io
        JSON3.write(io, entries)
    end
end

# 從 JSON 檔案讀取
function load_from_json(filepath)
    open(filepath, "r") do io
        JSON3.read(io, Vector{diaryEntry})
    end
end

# 定義 `diaryEntry` 的 JSON 表示
StructTypes.StructType(::Type{diaryEntry}) = StructTypes.Struct()

# 測試
diaryEntries = [
    diaryEntry("Test", "today!!", "今天是風和日麗的一天"),
    diaryEntry("2nd test", "tomorrow!!", "")
]

save_to_json(diaryEntries, "diary.json")
loaded_entries = load_from_json("diary.json")
println(loaded_entries)