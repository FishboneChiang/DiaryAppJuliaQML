using PackageCompiler
create_sysimage(["QML", "JSON3", "Dates"], sysimage_path="packages.so", precompile_execution_file="precompile_packages.jl")