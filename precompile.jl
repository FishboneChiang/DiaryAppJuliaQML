using PackageCompiler
using Pkg

Pkg.activate("DiaryApp")

create_sysimage(["DiaryApp"], sysimage_path="packages.so")