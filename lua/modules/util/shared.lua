module( "util", package.seeall )

--[[---------------------------------------------------------
Name: ValidVariable( meta (table), var (variable) )
Desc: Checks if the variable is a valid one.
Returns: validVar (variable)
-----------------------------------------------------------]]
function ValidVariable( meta, var )
	if meta and meta[ var ] then
		return meta[ var ]
	end

	return nil
end

--[[---------------------------------------------------------
Name: ValidFunction( meta (table function), funcname (function name string), ... (arguments) )
Desc: Checks if the function is a valid one.
Returns: validFunc (function)
-----------------------------------------------------------]]
function ValidFunction( meta, funcname, ... )
	if meta and meta[ funcname ] then
		return meta[ funcname ]( meta, ... )
	end

	return nil
end

--[[---------------------------------------------------------
Name: BitCounter( bitSize (int), bitFloat (float) )
Desc: Counts the bit based on the bitFloat with the bitSize.
Returns: bitCount
-----------------------------------------------------------]]
function BitCounter( bitSize, bitFloat )
	return math.max( 2, math.min( 32, math.ceil( math.log( bitFloat + 0.5 ) / math.log( bitSize ) ) ) )
end