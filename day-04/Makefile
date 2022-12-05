SE := ~/programming-projects/eiffel/liberty-eiffel/target/bin/se
.PHONY: clean
run: day4
	./day4
day4: day4.e
	$(SE) compile day4.e -o day4 --boost
clean:
	rm *.c *.h *.o *.out day4
