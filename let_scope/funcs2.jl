# function to be executed on process 2

let
	b = 2

	global testFunc		# declare testFunc as global so it is visible 
	function testFunc(a)
		b = b+a
		return b
	end

	

end
