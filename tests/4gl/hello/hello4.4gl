main
	define l_ind smallint
	define ma_char array[5] of char(3)

--#	define ma_integer array[3] of integer

	define ma_array array [3] of record
	f2_check      char(1),
	f2_integer    integer,
	f2_smallint   smallint,
	f2_decimal    decimal(17,6),
	f2_decimal0   decimal(10,0),
	f2_char       char(10),
	f2_date       date,
	f2_dttime_y2s datetime year to second,
	f2_dttime_y2m datetime year to month,
	f2_dttime_y2f datetime year to fraction(3),
	f2_scroll     char(100),
	f2_varchar    varchar(20)

end record


initialize ma_array to null
initialize ma_integer to null


display "hello world"

call _arraydeleteitem(ma_array)
call _arrayadditem(ma_array,3)

call _arraydeleteitem(ma_integer)
call _arrayadditem(ma_integer,3)

for l_ind = 1 to 3
	let ma_integer[l_ind] = null

	let ma_array[l_ind].f2_check      = null
	let ma_array[l_ind].f2_integer    = null
	let ma_array[l_ind].f2_smallint   = null
	let ma_array[l_ind].f2_decimal    = null
	let ma_array[l_ind].f2_decimal0   = null
	let ma_array[l_ind].f2_char       = " "
	let ma_array[l_ind].f2_varchar    = " "
	let ma_array[l_ind].f2_date       = today + l_ind units day
	let ma_array[l_ind].f2_dttime_y2s = null
	let ma_array[l_ind].f2_dttime_y2m = null
	let ma_array[l_ind].f2_dttime_y2f = null
	let ma_array[l_ind].f2_scroll     = null

end for

for l_ind = 1 to 3
	let ma_integer[l_ind] = l_ind

	let ma_array[l_ind].f2_check      = "s"
	let ma_array[l_ind].f2_integer    = 339782827 + l_ind
	let ma_array[l_ind].f2_smallint   = 18721 + l_ind
	let ma_array[l_ind].f2_decimal    = -19838849.087712 + l_ind
	let ma_array[l_ind].f2_decimal0   = 9389007739 + l_ind
	let ma_array[l_ind].f2_char       = "texto"||l_ind
	let ma_array[l_ind].f2_varchar    = "textovarchar   "||l_ind
	let ma_array[l_ind].f2_date       = today + 3 units day
	let ma_array[l_ind].f2_dttime_y2s = current + l_ind units day
	let ma_array[l_ind].f2_dttime_y2m = current + l_ind + 1 units day
	let ma_array[l_ind].f2_dttime_y2f = current + l_ind + 2 units day
	let ma_array[l_ind].f2_scroll     = "texto scroll texto scroll texto scroll "
end for


end main
