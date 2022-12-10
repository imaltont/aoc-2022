# I really want to find a way to not have to have all of these explicitly stated.
days = day1-run day2-run day3-run day4-run day5-run day6-run day7-run day8-run day9-run
run: $(days)
	echo "Done"
day1-run:
	echo ""
	echo "Day 1:"
	cd ./day-01/; make
	echo "_______________________________________"
day2-run:
	echo ""
	echo "Day 2:"
	cd ./day-02/; make
	echo "_______________________________________"
day3-run:
	echo ""
	echo "Day 3:"
	cd ./day-03/; make
	echo "_______________________________________"
day4-run:
	echo ""
	echo "Day 4:"
	cd ./day-04/; make
	echo "_______________________________________"
day5-run:
	echo ""
	echo "Day 5:"
	cd ./day-05/; make
	echo "_______________________________________"
day6-run:
	echo ""
	echo "Day 6:"
	cd ./day-06/; make
	echo "_______________________________________"
day7-run:
	echo ""
	echo "Day 7:"
	cd ./day-07/; make
	echo "_______________________________________"
day8-run:
	echo ""
	echo "Day 8:"
	cd ./day-08/; make
	echo "_______________________________________"
day9-run:
	echo ""
	echo "Day 9:"
	cd ./day-09/; make
	echo "_______________________________________"
