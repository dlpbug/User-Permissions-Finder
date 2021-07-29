# User-Permissions-Finder
Gets and stores user permission data for a selected directory and all subdirectories

free for anyone to add, change, or remove

Protocode:
change directory to located files
	test for valid directory
display massage for acquiring files
get all sub directories set into an array
sets a directory to where filed information will be placed
while statement to find what location in the array program is at{
	get current file location from array
	find who has access to it
	white statement to go through what user permission in the directory program is at{
		get username
		If statement to see if user has already been documented
			create directory for user
			create cvs file for user in user's folder
		import content from users cvs file
		add current location in array
		add content to file
		increase count for user array
increase count for location array
Update Display for Current percent of program completion