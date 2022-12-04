class DAY4
insert
ARGUMENTS
create {ANY}
	make
feature {ANY}
	make
		local
		path: STRING;
		do
		-- read the pairs from list
		--run the part1 and 2 methods on the result
		path := "./resources/input"
		io.put_string("Part 1: ")
		io.put_integer(part1(path))
		io.put_new_line
		io.put_string("Part 2: ")
		io.put_integer(part2(path))
		io.put_new_line
		end
	part1(path: STRING): INTEGER
		local
		text_file_read: TEXT_FILE_READ
			split1, split2: STRING
			index11, index12, index21, index22, i, j, counter: INTEGER
		do
		create text_file_read.connect_to(path)
			counter := 0
			if text_file_read.is_connected then
				from
					text_file_read.read_line
				until
				text_file_read.end_of_input
				loop
				i := text_file_read.last_string.index_of(',', 1)
				split1 := text_file_read.last_string.substring(1, i-1)
				split2 := text_file_read.last_string.substring(i+1, text_file_read.last_string.count)
				j := split1.index_of('-', 1)
				index11 := split1.substring(1, j-1).to_integer
				index12 := split1.substring(j+1, split1.count).to_integer

				j := split2.index_of('-', 1)
				index21 := split2.substring(1, j-1).to_integer
				index22 := split2.substring(j+1, split2.count).to_integer
					if (index11 >= index21 and index12 <= index22) or (index11 <= index21 and index12 >= index22) then
					counter := counter + 1
					end
				text_file_read.read_line
				end
				text_file_read.disconnect
				Result := counter 
			end
		end
	part2(path: STRING): INTEGER
		local
		text_file_read: TEXT_FILE_READ
			split1, split2: STRING
			index11, index12, index21, index22, i, j, counter: INTEGER
		do
		create text_file_read.connect_to(path)
			counter := 0
			if text_file_read.is_connected then
				from
					text_file_read.read_line
				until
				text_file_read.end_of_input
				loop
				i := text_file_read.last_string.index_of(',', 1)
				split1 := text_file_read.last_string.substring(1, i-1)
				split2 := text_file_read.last_string.substring(i+1, text_file_read.last_string.count)
				j := split1.index_of('-', 1)
				index11 := split1.substring(1, j-1).to_integer
				index12 := split1.substring(j+1, split1.count).to_integer

				j := split2.index_of('-', 1)
				index21 := split2.substring(1, j-1).to_integer
				index22 := split2.substring(j+1, split2.count).to_integer
					if (index11 >= index21 and index11 <= index22) or
					(index12 >= index21 and index12 <= index22) or
					(index11 <= index21 and index12 >= index21) or
					(index11 <= index22 and index12 >= index22) then
					counter := counter + 1
					end
				text_file_read.read_line
				end
				text_file_read.disconnect
				Result := counter 
			end
		end
end

