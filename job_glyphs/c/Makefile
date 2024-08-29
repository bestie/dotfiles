job_glyphs: job_glyphs.c
	gcc -Ofast job_glyphs.c -o job_glyphs

test_bash_jobs.txt:
	echo "[1]+  Running                 sleep 10 &" > test.txt
	echo "[2]+  Running                 sleep 10 &\n" >> test.txt

.PHONY: test
test: job_glyphs test_bash_jobs.txt
	cat test_bash_jobs.txt | ./job_glyphs

.PHONY: clean
clean:
	rm ./job_glyphs
