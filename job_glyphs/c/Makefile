.PHONY: demo
test: job_glyphs test_bash_jobs.txt
	cat test_bash_jobs.txt | ./job_glyphs --separator=''

job_glyphs: job_glyphs.c
	gcc -Ofast job_glyphs.c -o job_glyphs

test_bash_jobs.txt:
	echo "[1]+  Running                 sleep 10 &" > test_bash_jobs.txt
	echo "[2]+  Running                 sleep 10 &\n" >> test_bash_jobs.txt

.PHONY: clean
clean:
	rm ./job_glyphs
	rm test_bash_jobs.txt
