<?php
function getFiles($path)
{
	// Gets all files names from the path. Removes the '.' and '..'. Resets the array.
	$array = array_values(array_diff(scandir($path), array('..', '.')));
	for ($i = 0; $i < count($array); $i++) {
			$array[$i] = $path . $array[$i];
	}
	return $array;
}

$files = [
	getFiles("sql/Procedures/Select/"),
	getFiles("sql/Procedures/Insert/"),
	getFiles("sql/Procedures/Update/"),
	getFiles("sql/Procedures/Delete/"),
	getFiles("sql/Procedures/")
];
$data = file_get_contents("sql/Tables/tables.sql");
foreach ($files as $file) {
	foreach ($file as $path) {
		$data .= file_get_contents($path);
	}

}
$data .= file_get_contents("sql/Tables/triggers.sql");
$data .= file_get_contents("sql/Tables/content.sql");
file_put_contents("sql/compiled.sql",$data);