
ROBOT_OS = "ubuntu"

local crosscompiler = _OPTIONS["crosscompiler"]
if crosscompiler == nil then
  crosscompiler = "gcc"
end

local crossSystemDir = path.getabsolute(".") .. "/sysroot-ubuntu20.04"
local cpu_flags = "-march=silvermont -mtune=silvermont -mrdrnd"

if(_OPTIONS["platform"] == "Nao") then
  
  if crosscompiler == "clang" then
    print("INFO: Crosscompile with CLANG")
    
    toolset "clang"
    architecture "x86_64"
    
    buildoptions {
      --"-v", -- enable for debugging
      "--target=x86_64-linux-gnu",
      "--sysroot=" .. crossSystemDir,
      --"--gcc-toolchain=" .. crossSystemDir .. "/usr/lib/gcc/",
      cpu_flags
    }

    linkoptions {
        --"-v", -- enable for debugging
        "--target=x86_64-linux-gnu",  
        "--sysroot=" .. crossSystemDir,
        --"--gcc-toolchain=" .. crossSystemDir .. "/usr/lib/gcc/",
        "-fuse-ld=lld", -- use the native linker of clang
        "-Wl,-rpath=/home/nao/lib"
    }
    
    premake.tools.clang.tools.ar = "llvm-ar"
    
  elseif crosscompiler == "gcc" then
    print("INFO: Crosscompile with GCC ")
    
  else
    print("ERROR: unknown crosscompiler: " .. tostring(crosscompiler))
  end
end


-- this seems to be necessary in order to have the compiler paths set in the generated Makefile
function premake.tools.gcc.gettoolname(cfg, tool)
  return premake.tools.gcc.tools[tool]
end

-- BUGFIX: 
-- /usr/lib64 is allways added to the list of paths 
-- and there is no way to prevent it.
-- This can make problems on some systems.
-- So we redefine libraryDirectories without it.
-- https://github.com/premake/premake-core/blob/ea2971dd50d048582d646d12d9e50253f6f6731c/src/tools/gcc.lua#L473
premake.tools.gcc.libraryDirectories = {
		architecture = {
			x86 = function (cfg)
				return {}
			end,
			x86_64 = function (cfg)
				return {}
			end,
		},
		system = {
			wii = "-L$(LIBOGC_LIB)",
		}
}

newoption {
  trigger     = "crosscompiler",
  value       = "COMPILER",
  description = "Set the cross compiler to be used to compile for NAO.",
  default     = "gcc",
  allowed     = {
    { "gcc",   "GCC 9"},
    { "clang", "Native CLANG version."}
  }
}