job_glyphs: job_glyphs.c
	gcc -O3 job_glyphs.c -o job_glyphs

.PHONY: install
install: job_glyphs
	cp ./job_glyphs $(HOME)/bin/job_glyphs

.PHONY: demo
test: job_glyphs test_bash_jobs.txt
	cat test_bash_jobs.txt | ./job_glyphs --separator=''

test_bash_jobs.txt:
	echo "[1]+  Running                 sleep 10 &" > test_bash_jobs.txt
	echo "[2]+  Running                 sleep 10 &\n" >> test_bash_jobs.txt

.PHONY: clean
clean:
	rm ./job_glyphs
	rm test_bash_jobs.txt
