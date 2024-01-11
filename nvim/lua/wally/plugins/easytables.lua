return {
	"Myzel394/easytables.nvim",
	config = function ()
		require("easytables").setup{}
	end
}


-- Tutorial
-- Inserting a new table

-- Go to the place where you want to insert your table and either call:

--     :EasyTablesCreateNew <width>x<height> - Creates a new table with <width> columns and <height> rows
--     :EasyTablesCreateNew <width> - Creates a square table with the size of <width> (eg. :EasyTablesCreateNew 5 -> Creates a 5x5 table)
--     :EasyTablesCreateNew <width>x - Creates a table with <width> columns and one row
--     :EasyTablesCreateNew x<height> - Creates a table with one column and <height> rows

-- Editing an existing table

-- Go to your table (doesn't matter where, can be at a border or inside a cell) and type:

-- :EasyTablesImportThisTable
