#!/usr/bin/luajit
directories = {}

function init_dir(path)
   directories[path] = {}
   directories[path].directories = {}
   directories[path].files = {}
   directories[path].size = nil
end
function get_sub_path(current_path, word)
   local localdir = ""
   if current_path == "/" then
      localdir = current_path .. word
   else
      localdir = current_path .. "/" .. word
   end
   return localdir
end
function parse_commands(path)
   local current_dir = nil
   directories = {}
   for line in io.lines(path) do
      words = {}
      for w in string.gmatch(line, "%S+") do
	 words[#words+1] = w
      end
      if words[1] == "$" then
	 if words[2] == "cd" then
	    if words[3] == "/" then
	       current_dir = "/"
	       if #directories == 0 then
		  init_dir(current_dir)
	       end
	    elseif words[3] == ".." then
	       current_dir = current_dir:gsub("/%w+$", "")
	    else
	       current_dir = get_sub_path(current_dir, words[3])
	       if directories[current_dir] == nil then
		  init_dir(current_dir)
	       end
	    end
	 end
      else
	 local localdir = get_sub_path(current_dir, words[2])
	 if words[1] == "dir" then
	    if directories[current_dir].directories[localdir] == nil then
	       init_dir(localdir)
	       directories[current_dir].directories[localdir] = true
	    end
	 else
	    directories[current_dir].files[localdir] = words[1]
	 end
      end
   end
   return directories
end

function calculate_content_size(tab)
   if tab.size ~= nil then
      return tab.size
   end
   local sum = 0
   for file, size in pairs(tab.files) do
      sum = sum + size
   end
   for dir, exist in pairs(tab.directories) do
      if directories[dir].size ~= nil then
	 sum = sum + directories[dir].size
      else
	 sum = sum + calculate_content_size(directories[dir])
      end
   end
   tab.size = sum
   return sum
end

-- Part1
function part1(tab, threshold)
   local valid_directories = {}
   for dir, content in pairs(tab) do
      local size = calculate_content_size(directories[dir])
      if size <= threshold then
      	 valid_directories[#valid_directories+1] = size
      end
   end
   local sum = 0
   for k,s in pairs(valid_directories) do
      sum = sum + s
   end
   return sum
end

function part2(tab)
   local available = 70000000 - tab["/"].size
   local min_delete = 30000000 - available
   local min_legal = tab["/"].size
   for k,v in pairs(tab) do
      if v.size < min_legal and v.size > min_delete then
	 min_legal = v.size
      end
   end
   return min_legal
end

directories_read = parse_commands("./resources/input")
print(part1(directories, 100000))
print(part2(directories))
