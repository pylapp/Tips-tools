# CHANGELOG

## v14.3.0

Data generation time may be faster:

	* HTML and JSON files are updated if and only if their original content has been changed
	* to do so, checksums are registered in a metadata file to check if produced data (in CSV) have been updated or not

The data generation time is computed and displayed.