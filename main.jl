using QML

qml_file_path = joinpath(@__DIR__, "main.qml")

loadqml(qml_file_path, obs = JuliaPropertyMap(

))

exec()