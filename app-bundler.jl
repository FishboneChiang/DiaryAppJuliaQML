import AppBundler
import Pkg.BinaryPlatforms: Linux, MacOS, Windows
AppBundler.bundle_app(MacOS(:aarch64), @__DIR__, joinpath(@__DIR__,"build/DiaryApp.app"))