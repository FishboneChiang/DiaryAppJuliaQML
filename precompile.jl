using PackageCompiler
using Pkg

Pkg.activate("MyApp")

create_sysimage(["MyApp"], sysimage_path="packages.so")